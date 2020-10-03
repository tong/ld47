package ld47;

class Game extends Trait {

	public static var active(default, null):Game;

	public var time:Float;
	public var paused(default, null) = false;

	public var players(default, null):Array<Player>;
	public var atoms(default, null):Array<Atom>;

	var timeStart:Null<Float>;
	var timePauseStart:Null<Float>;

	var worldSizeX = 160;
	var worldSizeY = 90;
	var minAtomDistance = 20;

	var atomContainer:Object;

	public function new() {
		super();
		Game.active = this;
		notifyOnInit(() -> {
			Log.info('Game');

			atomContainer = Scene.active.getEmpty('AtomContainer');

			players = [new Player(0, 'tong', 0xffff0000); new Player(1, 'shadow', 0xff0000ff);];
			for (p in players) {
				p.onNavigate = (direction) -> {
					trace("Player wants to navigate " + direction);
				}
			}

			atoms = [];
			for (i in 0...10)
				spawnAtom();

			atoms[0].setPlayer(players[0]);
			atoms[1].setPlayer(players[1]);
			atoms[0].addElectron(new Electron(players[0], [Feature.Spawner], atoms[0]));
			atoms[0].addElectron(new Electron(players[1], [Feature.Spawner], atoms[1])) // Input.init();

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
		foreach(var atom in atoms) {
			atom.spawnElectrons();
		}

		// var atom = new Atom();
		// atoms.push( atom );
		// return atom;
	}

	public function spawnAtom() {
		Scene.active.spawnObject('Atom', atomContainer, obj -> {
			var atom = new Atom();
			var pos = getNextAtomPosition();
			atom.setPostion( pos.x, pos.y );
			obj.addTrait(atom);
			atoms.push(atom);
		});
	}

	public function destroyAtom() {
		// TODO
	}

	function update() {
		if (paused) {
			if( Input.keyboard.started("escape") ) {
				resume();
				return;
			}
			for( gp in Input.gamepads ) {
				if( gp.started('start') ) {
					resume();
					return;
				}
			}
		} else {

			var now = Time.time();
			time = now - timeStart;

			if(Input.keyboard.started("escape") {
				pause();
				return;
			}
			for( gp in Input.gamepads ) ) {
				if(  gp.started('start') ) {
					pause();
					return;
				}
			}

			for (player in players) {
				player.update();
			}
			for (atom in atoms) {
				atom.update();
			}
		}
	}

	private function getNextAtomPosition() : Vec2 {
		var vector : Vec2 = nul; //= new Vec4(0, 0, 0, 0);
		do {
			//vector = new Vec4( Math.random() * worldSizeX, Math.random() * worldSizeY, 0 );
			vector = new Vec2( Math.random() * worldSizeX, Math.random() * worldSizeY );
			var tooCloseAtoms = atoms.filter(f:Atom -> f.object.transform.loc.sub(vector).length() <= minAtomDistance );

			
		} while (tooCloseAtoms.length > 0)
		return vector;
	}
}
