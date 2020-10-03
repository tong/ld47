package ld47;

import ld47.Electron.Feature;

class Game extends Trait {

	public static var active(default, null):Game;

	public var time:Float;
	public var paused(default, null) = false;

	public var players(default, null):Array<Player>;
	public var atoms(default, null):Array<Atom>;

	var timeStart:Null<Float>;
	var timePauseStart:Null<Float>;

	var worldSizeX = 20;
	var worldSizeY = 12;
	var minAtomDistance = 8;

	var atomContainer:Object;

	public function new() {
		super();
		Game.active = this;
		notifyOnInit(() -> {

			Log.info('Game');

			atomContainer = Scene.active.getEmpty('AtomContainer');

			players = [
				new Player(0, 'tong', 0xffff0000),
				new Player(1, 'shadow', 0xff0000ff)
			];
			for (p in players) {
				p.onNavigate = (direction) -> {
					trace("Player wants to navigate " + direction);
				}
			}

			atoms = [];
			for (i in 0...10) {
				spawnAtom();
			}
			/*

			atoms[0].setPlayer(players[0]);
			atoms[1].setPlayer(players[1]);
			atoms[0].addElectron( new Electron(players[0], [Feature.Spawner], atoms[0] ) );
			atoms[0].addElectron( new Electron(players[1], [Feature.Spawner], atoms[1] ) ); // Input.init();
			*/

			notifyOnUpdate(update);
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
		for( atom in atoms ) {
			atom.spawnElectrons();
		}
		// var atom = new Atom();
		// atoms.push( atom );
		// return atom;
	}

	public function spawnAtom() {
		Scene.active.spawnObject('Atom', atomContainer, obj -> {
			var atom = new Atom();
			obj.addTrait(atom);
			trace("#################################");
			var pos = getNextAtomPosition();
			trace(pos);
			//atom.setPostion( new Vec2(0,6) );
			atom.setPostion( pos );
			atoms.push(atom);
		});
	}

	public function destroyAtom() {
		// TODO
	}

	function update() {
		var keyboard = Input.getKeyboard();
		if (paused) {
			if( keyboard.started("escape") ) {
				resume();
				return;
			}
			for( i in 0...4 ) {
				var gp = Input.getGamepad( i );
				if( gp.started('start') ) {
					resume();
					return;
				}
			}
		} else {

			var now = Time.time();
			time = now - timeStart;

			if(keyboard.started("escape") ) {
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

			for (player in players) {
				player.update();
			}
			
			for (atom in atoms) {
				atom.update();
			} 
		}
	}

	private function getNextAtomPosition() : Vec2 {
		
		while( true ) {
			var vector = new Vec4( (0.5 - Math.random()) * worldSizeX, (0.5 - Math.random() ) * worldSizeY );
			var hasTooCloseAtom = false;
			for( atom in atoms ) {
				var v = atom.object.transform.loc.sub(vector).length();
				if( v <= minAtomDistance ) {
					//trace("TOCLOSE");
					hasTooCloseAtom = true;
					break;
				} 
				
			}
			if( !hasTooCloseAtom ) {
				trace("VALID "+vector  );
				return new Vec2( vector.x, vector.y );
			}
		}
		return null;

		/*
		var vector : Vec4 = null; //= new Vec4(0, 0, 0, 0);
		var tooCloseAtoms : Int = el;
		do {
			//vector = new Vec4( Math.random() * worldSizeX, Math.random() * worldSizeY, 0 );
			vector = new Vec4( (0.5 - Math.random()) * worldSizeX, (0.5 - Math.random() ) * worldSizeY );
			for( atom in atoms ) {
				var v = atom.object.transform.loc.sub(vector).length();
				if( v <= minAtomDistance ) [
					break;
				]
			}
			/*
			tooCloseAtoms = atoms.filter( (f:Atom) -> {
				var v = f.object.transform.loc.sub(vector).length();
				trace(v);
				return v <= minAtomDistance;
			}).length;
			* /
			
		} while (true);
		return new Vec2( vector.x, vector.y );
		*/
	}
}
