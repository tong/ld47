package ld47;

import ld47.Electron.Core;

typedef MapData = {
	var name: String;
	var atoms : Array<{
		slots: Int,
		position: Vec2,		
		?player: Null<Int>,
		?electrons: Array<Core>,
		//?rotationSpeed : Float //TODO
	}>;
}

typedef PlayerData = {
	var name : String;
	var enabled : Bool;
	var color : Color;
}

/*
@:enum abstract GameEvent(String) to String {
	var Start;
	var Pause;
	var Resume;
	var End;
}
*/

class Game extends Trait {

	public static var active(default, null):Game;

	public var time(default,null):Float;
	public var paused(default, null) = false;
	public var finished(default, null) = false;
	public var worldSize(default,null) : Vec2;
	public var players(default, null):Array<Player> = [];
	public var atoms(default, null):Array<Atom> = [];
	public var flyingElectrons(default,null):Array<Electron> = [];

	var timeStart:Null<Float>;
	var timePauseStart:Null<Float>;
	var minAtomDistance = 3;
	var atomContainer:Object;
	var ground : MeshObject;
	var soundAmbient : AudioChannel;

	public function new( playerData : Array<PlayerData>, mapData : MapData ) {
		super();
		Game.active = this;
		Log.info('Game');
		notifyOnInit(() -> {
			SoundEffect.play( 'game_ambient_'+1, true, true, 0.0, s -> {
				soundAmbient = s;
				Tween.to( { target: soundAmbient, props: { volume: 0.9 }, delay: 0.1, duration: 0.8 } );
			});
			atomContainer = Scene.active.getEmpty('AtomContainer');
			ground = Scene.active.getMesh('Ground');
			worldSize = new Vec2( Math.floor( ground.transform.dim.x*100 ) / 100, Math.floor( ground.transform.dim.y*100 ) / 100 );
			for( i in 0...playerData.length ) {
				var raw = playerData[i];
				if( raw.enabled ) {
					final p = new Player( i );
					Scene.active.spawnObject( 'Player', null, obj -> {
						obj.addTrait( p );
					});
					players.push( p );
				}
			}
			trace( 'Spawning map ${mapData.name}' );
			spawnMap( mapData, () -> {
				start();
			});

		});
		notifyOnUpdate(update);
	}

	public function start() {
		
		trace('Start game ${players.length}' );
		
		paused = finished = false;
		time = 0;
		timeStart = Time.time();

		var cam = Scene.active.camera;
		cam.transform.loc.z = 0;
		cam.transform.buildMatrix();

		Tween.timer( 0.2, () -> SoundEffect.play( 'game_start', false, true, 0.05 ) );
		
		//Postprocess.colorgrading_shadow_uniforms[0] = [1.0, 1.0, 1.0];
		//Postprocess.colorgrading_shadow_uniforms[1] = [1.0, 1.0, 1.0];
		Postprocess.chromatic_aberration_uniforms[0] = 20.0;
		var values = { chromatic : Postprocess.chromatic_aberration_uniforms[0] };
		Tween.to({
			target: values,
			delay: 0.2,
			duration: 1.0,
			props: { chromatic: 0.05 },
			ease: QuartOut,
			tick: () -> {
				cam.transform.loc.z = 105;
				cam.transform.buildMatrix();
				Postprocess.chromatic_aberration_uniforms[0] = values.chromatic;
				/* if( fadeInStarted ) {
					//Postprocess.chromatic_aberration_uniforms[0] = values.chromatic;
				} else {
					//Postprocess.chromatic_aberration_uniforms[0] = 20.0;
					fadeInStarted = true;
				} */
				//cam.transform.loc.z = values.z;
				//cam.transform.buildMatrix();
			},
			done: () -> {
				Postprocess.chromatic_aberration_uniforms[0] = 0.05;
			}
		});
//		Event.send( GameEvent.Start );
	}

	public function pause() {
		if (!finished && !paused) {
			trace('Pause game');
			paused = true;
			timePauseStart = Time.time();
			//Postprocess.colorgrading_shadow_uniforms[0] = [0.0, 0.0, 0.0];
			//Postprocess.colorgrading_shadow_uniforms[1] = [0.3, 0.3, 0.3];
//			Event.send(GameEvent.Pause);
		}
	}
	
	public function resume() {
		if (!finished && paused) {
			trace('Resume game');
			paused = false;
			timeStart += Time.time() - timePauseStart;
			timePauseStart = null;
			//Postprocess.colorgrading_shadow_uniforms[0] = [1.0, 1.0, 1.0];
			//Postprocess.colorgrading_shadow_uniforms[1] = [1.0, 1.0, 1.0];
//			Event.send(GameEvent.Resume);
		}
	}
	
	public function abort() {
		Postprocess.colorgrading_shadow_uniforms[0] = [1.0, 1.0, 1.0];
		if( soundAmbient != null ) soundAmbient.stop();
		for( a in atoms ) a.destroy();
//		Event.send( GameEvent.End );
		Scene.setActive( 'Mainmenu' );
	}
	
	public function finish(gameStatus: GameStatus){
		if( finished ) return;
		//Postprocess.colorgrading_shadow_uniforms[0] = [1.0, 1.0, 1.0];
		//Postprocess.colorgrading_shadow_uniforms[1] = [1.0, 1.0, 1.0];
		//trace('status others:' + gameStatus.others.length );
		SoundEffect.play( 'game_finish', false, true, 0.1, s -> {
			//Tween.to( { target: s, props: { volume: 0.5 }, delay: 0.1, duration: 0.8 } );
		});
		finished = true;
		var winner = gameStatus.winner;
		var others = gameStatus.others;
		if (gameStatus.hasWinner){
			var score = winner.score;
			trace('the game is finished, winner is player ${winner.index} with a score of $score' );						
		} else {
			trace('the game ended in a draw');
		}
		if( soundAmbient != null ) soundAmbient.stop();
		for( a in atoms ) a.destroy();
//		Event.send( GameEvent.End );
		Scene.setActive( 'Result' );
		var menu = new ResultMenu( gameStatus );
		Scene.active.root.addTrait( menu );
	}

	public function clearMap() {
		if (atoms != null) {
			for (a in atoms) a.destroy();
		}
		atoms = [];
	}

	function spawnMap( data : MapData, clear = true, cb:Void->Void) {
		if (clear)
			clearMap();
		atoms = [];		
		function spawnNext() {
			var dat = data.atoms[atoms.length];
			spawnAtom( dat.position, dat.slots, a -> {
				if( dat.player != null ) {
					/* a.notifyOnInit( () -> {
						a.setPlayer(players[dat.player]);

					}); */
					a.setPlayer(players[dat.player]);
				}
				if( dat.electrons != null ) {
					a.spawnElectrons( dat.electrons , spawned -> {						
						if (atoms.length == data.atoms.length ) cb() else spawnNext();
					});
				} else {
					if (atoms.length == data.atoms.length ) cb() else spawnNext();
				}
			});
		}
		spawnNext();
	}

	function spawnAtom( pos:Vec2, numSlots : Int, cb:Atom->Void) {
		Scene.active.spawnObject('Atom', atomContainer, obj -> {
			obj.visible = true;
			var atom = new Atom( atoms.length, numSlots );
			atom.notifyOnInit(()->{
				cb(atom);
			});
			obj.addTrait(atom);
			atom.setPostion(pos);
			atoms.push(atom);			
		});
	}

	function update() {
		if (paused) {
			//...
		} else {

			var kb = Input.getKeyboard();

			final now = Time.time();
			time = now - timeStart;
			
			for( p in players ) p.update();

			var gameStatus = getGameStatus();
			if (gameStatus.isFinished){
				finish(gameStatus);
				return;
			}

			var newFlyingElectrons = new Array<Electron>();

			for (electron in flyingElectrons){	
				//trace('check flying electron from player ' + electron.player.index);
				var locElectron = new Vec4(electron.object.transform.worldx(), electron.object.transform.worldy());
				var radiusElectron = electron.mesh.transform.dim.x/2;							
				var electronOK = true;
				
				electron.update();

				for (atom in atoms){
					var distance = atom.object.transform.loc.distanceTo(locElectron);
					var radiusAtom = atom.mesh.transform.dim.x/2;
					//trace('test atom in a distance of '+ distance + ' with radius of ' + radiusAtom + ' and in e-radius of ' + radiusElectron );
					if (distance < radiusAtom+radiusElectron) {		
						//the electron hits an atom				
						trace('electron from player ${electron.player.index} hit an atom');
						electronOK = false;						
						object.removeChild(electron.object);
						electron.object.remove();
						electron.player.addToScore(Score.hit);
						atom.hit(electron);	
					} else if (distance < radiusAtom*4 && 
							  atom.player != electron.player &&
							  atom.electrons.length>0){
						trace('electron from player ${electron.player.index} is in outer area of an atom, lets check electrons');

						for (targetElectron in atom.electrons){
							var locTarget = new Vec4(targetElectron.object.transform.worldx(), targetElectron.object.transform.worldy());
							var distElectron = locTarget.distanceTo(locElectron);
							if (distElectron < radiusElectron*2){
								//the electron hits an enemy electron attached to an atom
								trace('electron from player ${electron.player.index} hit an enemy electron orbiting an atom' );
								electron.player.addToScore(Score.destroyed);
								electronOK = false;								
								object.removeChild(electron.object);
								electron.object.remove();
								break;
							}								
						}						
					}
					if(!electronOK) break;
				}
				if (worldSize.x/2 < Math.abs(locElectron.x) || 
					worldSize.y/2 < Math.abs(locElectron.y)){
						//the electron leaves the game area
						electronOK=false;
						//object.removeChild(electron.object);
						//electron.object.remove();
						electron.destroy();	
						//SoundEffect.play( 'electron_death', 0.1 );
				}
				if (electronOK) {
					newFlyingElectrons.push(electron);
				}
			}
			flyingElectrons = newFlyingElectrons;
		}
	}

	function getGameStatus():GameStatus{
		//trace('getGameStatus of ' + players.length + ' players');
		if (atoms.filter(atom -> atom.electrons.length > 0).length == 0 && 
			flyingElectrons.length == 0){
			//no electrons left -> everybody looses
			return GameStatus.draw(players);
		}
		else{
			var winners = players.slice(0);
			var loosers = new Array<Player>();
			for (player in players){
				if (atoms.filter(atom -> atom.player != null && 
										 atom.player == player &&
										 atom.electrons.length > 0).length == 0 &&
					flyingElectrons.filter(electron -> electron.player == player).length ==0){
					//player has no electrons left -> he looses					
					winners.splice(winners.indexOf(player),1);
					loosers.push(player);
				}					
			}
			//trace('sorted into ' + winners.length + ' and ' + loosers.length);
			if(winners.length == 1){
				return GameStatus.finished(winners[0],loosers);
			} else {
				return GameStatus.running(winners);
			}
		}
	}
}
