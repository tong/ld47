package ld47;

import ld47.Electron.Feature;
import ld47.renderpath.Postprocess;

typedef MapData = {
	var atoms : Array<{ features: Array<Electron.Feature> }>;
}

typedef PlayerData = {
	var name : String;
	var enabled : Bool;
	var color : Color;
}

class Game extends Trait {
	public static var active(default, null):Game;

	public var time(default, null):Float;
	public var paused(default, null) = false;
	
	public var worldSizeX(default,null) : Float;
	public var worldSizeY(default,null) : Float;

	public var players(default, null):Array<Player>;
	public var atoms(default, null):Array<Atom>;
	public var flyingElectrons(default,null):Array<Electron>;

	var timeStart:Null<Float>;
	var timePauseStart:Null<Float>;

	var minAtomDistance = 3;
	var atomContainer:Object;

	public function new( playerData : Array<PlayerData>, mapData : MapData ) {
		super();
		Game.active = this;
		notifyOnInit(() -> {
			Log.info('Game');

			flyingElectrons = [];
			players = [];
			atomContainer = Scene.active.getEmpty('AtomContainer');

			var ground = Scene.active.getMesh('Ground');
			worldSizeX = Math.floor( ground.transform.dim.x*100 ) / 100;
			worldSizeY = Math.floor( ground.transform.dim.y*100 ) / 100;

			for( i in 0...playerData.length ) {
				var raw = playerData[i];
				if( raw.enabled ) {
					final player = new Player( i );
					Scene.active.spawnObject( 'Player', null, obj -> {
						obj.addTrait( player );
					});
					players.push( player );
				}
			}

			trace("Creating map "+mapData );
			//TODO

			spawnMap(10, true, () -> {
				
				atoms[0].setPlayer(players[0]);
				atoms[1].setPlayer(players[1]);
				atoms[2].setPlayer(players[1]);

				atoms[0].spawnElectrons( 1, [Feature.Spawner], () -> {
					atoms[1].spawnElectrons( 2, [Feature.None], () -> {
						atoms[2].spawnElectrons( 1, [Feature.None], () -> {
							notifyOnUpdate(update);
							start();
						} );
					} );
				} );
			});
		});
	}

	public function start() {

		trace('Starting game');
		
		time = 0;
		timeStart = Time.time();
		
		Postprocess.chromatic_aberration_uniforms[0] = 20.0;
		var values = { v : 20.0 };
		Tween.to({
			target: values,
			duration: 0.5,
			props: { v: 0.01 },
			ease: QuartOut,
			tick: () -> {
				Postprocess.chromatic_aberration_uniforms[0] = values.v;
			},
			done: () -> {
			}
		});

		SoundEffect.play( 'game_start' );

		Event.send('game_start');
	}

	public function pause() {
		if (!paused) {
			paused = true;
			timePauseStart = Time.time();
			Event.send('game_pause');
		}
	}

	public function resume() {
		if (paused) {
			paused = false;
			timeStart += Time.time() - timePauseStart;
			timePauseStart = null;
			Event.send('game_pause');
		}
	}

	public function end() {
		Event.send('game_end');
		Scene.setActive("Mainmenu");
	}

	public function clearMap() {
		if (atoms != null) {
			for (a in atoms) {
				a.destroy(); // TODO
				// a.object.remove();
			}
		}
		atoms = [];
	}

	public function spawnMap( numAtoms : Int, clear = true, cb:Void->Void) {
		if (clear)
			clearMap();
		atoms = [];
		var positions = getAtomPositions(numAtoms);
		function spawnNext() {
			spawnAtom(positions[atoms.length], 5 + Std.int(Math.random()*10), a -> {
				if (atoms.length == numAtoms)
					cb();
				else
					spawnNext();
			});
		}
		spawnNext();
	}

	public function spawnAtom( pos:Vec2, numSlots = 10, cb:Atom->Void) {
		Scene.active.spawnObject('Atom', atomContainer, obj -> {
			var atom = new Atom( numSlots );
			atom.notifyOnInit(()->{
				cb(atom);
			});
			obj.addTrait(atom);
			atom.setPostion(pos);
			atoms.push(atom);			
		});
	}

	public function destroyAtom() {
		// TODO
	}

	function update() {
		var kb = Input.getKeyboard();
		if (paused) {
			if (kb.started("escape")) {
				resume();
				return;
			}
			for (i in 0...4) {
				var gp = Input.getGamepad(i);
				if (gp.started('start')) {
					resume();
					return;
				}
			}
		} else {
			var now = Time.time();
			time = now - timeStart;

			if (kb.started("escape")) {
				pause();
				return;
			}
			for( i in 0...4 ) {
				var gp = Input.getGamepad(i);
				if( gp.started('share') ) {
					pause();
					return;
				}
			}

			var newFlyingElectrons = new Array<Electron>();

			for (electron in flyingElectrons){	
				//trace('check flying electron from player ' + electron.player.name);
				var locElectron = new Vec4(electron.object.transform.worldx(), electron.object.transform.worldy());
				var radiusElectron = electron.mesh.transform.dim.x/2;							
				
				electron.update();
				var electronOK = true;

				for (atom in atoms){
					var distance = atom.object.transform.loc.distanceTo(locElectron);
					var radiusAtom = atom.mesh.transform.dim.x/2;
					//trace('test atom in a distance of '+ distance + ' with radius of ' + radiusAtom + ' and in e-radius of ' + radiusElectron );

					if (distance < radiusAtom+radiusElectron)
					{		
						//the electron hits an atom				
						trace('elektron from player ' + electron.player.name + ' hit an atom');
						electronOK = false;						
						object.removeChild(electron.object);
						electron.object.remove();
						electron.player.addToScore(Score.hit);
						atom.hit(electron);	

					}else if (distance < radiusAtom*4 && 
							  atom.player != electron.player &&
							  atom.electrons.length>0){
						trace('elektron from player ' + electron.player.name + ' is in the outter area of an atom, lets check its electrons');

						for (targetElectron in atom.electrons){
							var locTarget = new Vec4(targetElectron.object.transform.worldx(),
													 targetElectron.object.transform.worldy());
							var distElectron = locTarget.distanceTo(locElectron);

							if (distElectron < radiusElectron*2){
								//the electron hits an enemy electron attached to an atom
								trace('elektron from player ' + electron.player.name + ' hit an enemy electron orbiting an atom');
								electron.player.addToScore(Score.destroyed);
								electronOK = false;								
								object.removeChild(electron.object);
								electron.object.remove();
								break;
							}								
						}						
					}
					if (!electronOK) {break;}
				}
				if (worldSizeX/2 < Math.abs(locElectron.x) || 
					worldSizeY/2 < Math.abs(locElectron.y)){
						//the electron leaves the game area
						electronOK=false;
						object.removeChild(electron.object);
						electron.object.remove();		
						SoundEffect.play( 'electron_death' );				
				}
				if (electronOK){
					newFlyingElectrons.push(electron);
				}
			}
			flyingElectrons=newFlyingElectrons;
		}
	}

	private function getAtomPositions(count:Int):Array<Vec2> {
		trace('###########');
		var vectors = new Array<Vec2>();
		for (index in 0...count) {
			var hasTooCloseExistingVector = false;
			var vector = new Vec2();
			var trys = 0;
			do {
				trys++;
				vector = new Vec2((0.5 - Math.random()) * (worldSizeX - minAtomDistance/1.5) , (0.5 - Math.random()) * (worldSizeY - minAtomDistance/1.5));
				hasTooCloseExistingVector = false;
				for (existingVector in vectors) {
					var distance = vector.distanceTo(existingVector);
					// trace('compare ' + vector + ' to vector' + existingVector + ' distance = ' + distance);

					if (distance <= minAtomDistance) {
						// trace('too near');
						hasTooCloseExistingVector = true;
						break;
					}
				}

				if (trys>50){
					vectors = new Array<Vec2>();
					hasTooCloseExistingVector=false;
				}

			} while (hasTooCloseExistingVector);

			vectors.push(vector);
			trace('added vector ' + vector + ' now we have' + vectors.length);
		}

		return vectors;
	}
}
