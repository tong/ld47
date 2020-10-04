package ld47;

import ld47.Electron.Feature;

typedef PlayerData = {
	var name : String;
	var enabled : Bool;
	var color : Color;
}

class Game extends Trait {
	public static var active(default, null):Game;

	public var time(default, null):Float;
	public var paused(default, null) = false;

	public var players(default, null):Array<Player>;
	public var atoms(default, null):Array<Atom>;
	public var flyingElectrons(default,null):Array<Electron>;

	var timeStart:Null<Float>;
	var timePauseStart:Null<Float>;

	var worldSizeX = 20;
	var worldSizeY = 12;
	var minAtomDistance = 4;

	var atomContainer:Object;

	public function new( playerData : Array<PlayerData> ) {
		super();
		Game.active = this;
		notifyOnInit(() -> {
			Log.info('Game');

			flyingElectrons = [];
			players = [];
			atomContainer = Scene.active.getEmpty('AtomContainer');

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

			spawnMap(10, true, () -> {
				
				atoms[0].setPlayer(players[0]);
				atoms[1].setPlayer(players[0]);
				atoms[2].setPlayer(players[1]);
				atoms[3].setPlayer(players[1]);
				
				atoms[0].addElectron(new Electron(players[0], [Feature.Spawner]));
				atoms[1].addElectron(new Electron(players[0], [Feature.None]));				
				atoms[1].addElectron(new Electron(players[0], [Feature.None]));		
				atoms[2].addElectron(new Electron(players[1], [Feature.None]));		
				
				notifyOnUpdate(update);
			});
		});
	}

	public function start() {
		time = 0;
		timeStart = Time.time();
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

	public function spawnElectron() {
		for (atom in atoms) {
			atom.spawnElectrons();
		}
		// var atom = new Atom();
		// atoms.push( atom );
		// return atom;
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
			obj.addTrait(atom);
			atom.setPostion(pos);
			atoms.push(atom);
			cb(atom);
		});
	}

	public function destroyAtom() {
		// TODO
	}

	function update() {
		var keyboard = Input.getKeyboard();
		if (paused) {
			if (keyboard.started("escape")) {
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

			if (keyboard.started("escape")) {
				pause();
				return;
			}
			/*
				for( gp in Input.gamepads ) {
					if( gp.started('start') ) {
						pause();
						return;
					}
				}
			 */

			/* for (player in players) {
				player.update();
			}
			
			for (atom in atoms) {
				atom.update();
			}
			*/
			var newFlyingElectrons = new Array<Electron>();
			for (electron in flyingElectrons){				
				electron.update();
				var electronOK = true;
				for (atom in atoms){
					var distance = atom.object.transform.loc.distanceTo(electron.object.transform.loc);
					if (distance < atom.orbitRadius)
					{
						
						electronOK = false;
						electron.object.remove();						
						atom.hit(electron);						
					}
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

			do {
				vector = new Vec2((0.5 - Math.random()) * worldSizeX, (0.5 - Math.random()) * worldSizeY);
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
			} while (hasTooCloseExistingVector);

			vectors.push(vector);
			trace('added vector ' + vector + ' now we have' + vectors.length);
		}

		return vectors;
	}
}
