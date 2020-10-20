package superposition;

class Score {
        
	public static var spawned = new Score(1, 0, 0, 0, 0, 0);
	public static var fired = new Score(0, 1, 0, 0, 0, 0);	
    public static var destroyed = new Score(0, 0, 0, 1, 0, 0);
	public static var taken = new Score(0, 0, 0, 0, 1, 0);
    public static var lost = new Score(0, 0, 0, 0, 0, 1);
    public static var hit = new Score(0, 0, 1, 0, 0, 0);
	public static var empty = new Score(0,0,0,0,0,0);
	
	public var spawnedElectrons(default,null) : Int;
	public var shotsFired(default,null) : Int;
	public var shotsHitAtom(default,null) : Int;
	public var shotsDestroyedByEnemyElectron(default,null) : Int;
	public var ownershipsTaken(default,null) : Int;
    public var ownershipsLost(default,null) : Int;
    
	function new( spawnedElectrons:Int, shotsFired:Int, shotsHitAtom:Int, shotsDestroyedByEnemyElectron:Int, ownershipsTaken:Int, ownershipsLost:Int) {
		this.spawnedElectrons = spawnedElectrons;
		this.shotsFired = shotsFired;
		this.shotsHitAtom = shotsHitAtom;
		this.shotsDestroyedByEnemyElectron = shotsDestroyedByEnemyElectron;
		this.ownershipsTaken = ownershipsTaken;
		this.ownershipsLost = ownershipsLost;
	}

	public function add( s : Score ) : Score {
		return new Score(
			spawnedElectrons + s.spawnedElectrons, 
			shotsFired + s.shotsFired, 
			shotsHitAtom + s.shotsHitAtom,
			shotsDestroyedByEnemyElectron + s.shotsDestroyedByEnemyElectron, 
			ownershipsTaken + s.ownershipsTaken,
			ownershipsLost + s.ownershipsLost
		);
	}
	
	public inline function reset() {
		spawnedElectrons = shotsFired = shotsHitAtom = shotsDestroyedByEnemyElectron = ownershipsTaken = ownershipsLost = 0;
	}
}

class Player extends Trait {

	public static final COLORS:Array<Color> = [0xff268BD2, 0xffDC322F, 0xff859900, 0xffD33682];

	public final index : Int;
	public final color : Color;
	
	public var atom(default,null) : Atom;
	public var mesh(default,null) : MeshObject;
	public var score(default,null) = Score.empty;
	public var moveSpeed : FastFloat = 1.0;
	//public var dead(default,null) = false;

	var moveTween : TAnim;
	var soundMove : AudioChannel;
	var soundFire : AudioChannel;

	public function new( index : Int ) {
		super();
		this.index = index;
		color = COLORS[index];
		notifyOnInit( () -> {

			mesh = cast object.getChild('PlayerMesh');
			mesh.visible = true;

			DataTools.loadMaterial('Game','Player'+(index+1), m -> {
				mesh.materials = m;
			});

			SoundEffect.load( 'player_move', s -> {
				soundMove = Audio.play( s, false, false );
				soundMove.pause();
			});
			SoundEffect.load( 'electron_fire_p'+(index+1), s-> {
				soundFire = Audio.play( s, false, false );
				soundFire.pause();
			});

			/* SoundEffect.play( 'atom_ambient_'+index, true, true, 1.0, s -> {
				soundAmbient = s;
			} ); */
		});
	}

	public function update() {

		if (atom == null) {
			final atoms = Game.active.atoms.filter(a -> return a.player == this);
			if( atoms.length > 0 ) {
				selectAtom( atoms[0] );
				return;
			} else {
				object.visible = false;
				return;
			}
		}

		final gp = Input.getGamepad(index);
		final kb = Input.getKeyboard();
		final dir = new Vec2();

		if (gp.started('l1') ) {
			atom.selectPreviousElectron();
			return;
		}
		if (gp.started('r1') ) {
			atom.selectNextElectron();
			return;
		}
		if (gp.started('cross')) {
			fire();
			return;
		}

		if( gp.started("left") ) dir.x = -1;
		else if (gp.started("right")) dir.x = 1;
		else if (gp.started("up")) dir.y = 1;
		else if (gp.started("down")) dir.y = -1;

		switch index {
		case 0:
			if (kb.started('a')) dir.x = -1;
			else if (kb.started('d')) dir.x = 1;
			else if (kb.started('w')) dir.y = 1;
			else if (kb.started('s')) dir.y = -1;
			if (kb.started('q')) atom.selectPreviousElectron();
			else if (kb.started('e')) atom.selectNextElectron();
			else if (kb.started('f')) {
				fire();
				return;
			}
		case 1:
			if (kb.started('left')) dir.x = -1;
			else if (kb.started('right')) dir.x = 1;
			else if (kb.started('up')) dir.y = 1;
			else if (kb.started('down')) dir.y = -1;
			if (kb.started('n')) atom.selectPreviousElectron();
			else if (kb.started('b')) atom.selectNextElectron();
			else if (kb.started('m')) {
				fire();
				return;
			}
		}
		
		if( dir.x != 0 || dir.y != 0 ) navigateSelectionTowards(dir);
		//navigateSelectionTowards( dir );
	}

	public function selectAtom( newAtom : Atom ) {

		atom = newAtom;

		//if( soundMove != null ) soundMove.play();
		//soundAmbient.play();
		
		var destination = atom.object.transform.world.getLoc();
		var duration = (object.transform.world.getLoc().distanceTo(destination ) / 20) / moveSpeed;
		var values = {
			x : object.transform.loc.x, y : object.transform.loc.y, z : object.transform.loc.z,
			sx : object.transform.scale.x, sy : object.transform.scale.y, sz : object.transform.scale.z,
		}
		if( moveTween != null ) {
			Tween.stop( moveTween );
			moveTween = null;
		}
		moveTween = Tween.to({
			props: {
				x : destination.x, y : destination.y, z : destination.z,
				sx : atom.mesh.transform.scale.x, sy : atom.mesh.transform.scale.y, sz : atom.mesh.transform.scale.z
			},
			duration: duration,
			target: values,
			ease: Ease.QuartOut,
			tick: () -> {
				object.transform.loc.x = values.x;
				object.transform.loc.y = values.y;
				object.transform.loc.z = values.z;
				object.transform.buildMatrix();
				mesh.transform.scale.x = values.sx;
				mesh.transform.scale.y = values.sy;
				mesh.transform.scale.z = values.sz;
				mesh.transform.buildMatrix();
			},
			done: () -> {
				moveTween = null;
			}
		});
	}

	public function navigateSelectionTowards(dir:Vec2) {
		if (atom == null || (dir.x == 0 && dir.y == 0)) {
			return;
		}
		var shootDirection = new Vec2(dir.x, dir.y).normalize();
		var atoms = Game.active.atoms.filter(a -> return a.player == this && a != atom);
		if (atoms.length > 0) {
			//trace('navigate to $shootDirection');
			var bestAtom = null, bestScore = 0.0, bestDistance = 0.0;
			for (a in atoms) {
				var locA = a.object.transform.loc;
				var locAtom = atom.object.transform.loc;
				var distance = locAtom.distanceTo(locA);
				var direction = new Vec2(locA.x - locAtom.x, locA.y - locAtom.y).normalize();
				var score = Math.pow(direction.dot(shootDirection), 1) / (distance + 10);
				if (score > bestScore) {
					bestScore = score;
					bestAtom = a;
					bestDistance = distance;
				}
			}
			if (bestAtom != null) {
				trace('navigate from ${atom.object.transform.loc} to best atom at ${bestAtom.object.transform.loc} with a score of $bestScore and a distance of $bestDistance');
				selectAtom(bestAtom);
			} else {
				trace('no atom found to navigate to');
			}
		}
	}

	public function fire() {
		soundFire.play();
		atom.fire();
		if( atom.electrons.length == 0 ) {
			var atom : Atom = null;
			for( a in Game.active.atoms ) if( a.player == this ) {
				atom = a;
				break;
			}
			if( atom == null ) {
				mesh.visible = false;
			} else {
				mesh.visible = true;
				selectAtom( atom );
			}
		}
	}

	public function dispose() {
	}

	public function toString() : String {
		var s = 'P$index(';
		if( atom == null ) {
			s += 'dead)';
		} else {
			s += 'atom=${atom.index})';
		}
		return s;
	}
}
