package ld47;

class Player extends Trait {

	public static final COLORS:Array<Color> = [0xff268BD2, 0xffDC322F, 0xff859900, 0xffD33682];

	public final index : Int;
	public final color : Color;
	
	//public var atoms(default, null):Array<Atom> = [];
	public var atom(default, null):Atom;
	public var score(default, null):Score;
	public var mesh(default,null) : MeshObject;
	public var dead(default,null) = false;

	var soundMove : AudioChannel; 

	public function new(index:Int) {
		super();
		this.index = index;
		this.score = Score.empty;
		this.color = COLORS[index];
		notifyOnInit(() -> {
			mesh = cast object.getChild('PlayerMesh');
			mesh.visible = true;

			//Scene.active.spawnObject('PlayerLight', mesh, obj -> {});
			
			//var light : LightObject = cast object.getChild('PlayerLight');
			//trace(light.data);

		 	/* var d = new iron.data.LightData(cast {
				name : "PlayerLight"+index, 
				type : 'point', 
				cast_shadow : true, 
				near_plane : 0.10000000149011612, 
				far_plane : 5, 
				fov : 1.5707999467849731, 
				color : [0.0193822979927063,0.25818297266960144,0.6444798111915588], 
				strength : 56, 
				shadows_bias : 0.00009999999747378752, 
				shadowmap_size : 1024, 
				shadowmap_cube : true, 
				light_size : 2.5
			}, (dat) -> {
				var l = new LightObject(dat);
				l.transform.loc.z = 5;
				l.transform.buildMatrix();
				object.addChild( l );
			});  */

			//var speaker = new SpeakerObject();

			DataTools.loadMaterial('Game', 'Player'+(index+1), m -> {
				mesh.materials = m;
			});
			SoundEffect.load( 'player_move', s -> {
				soundMove = Audio.play( s, false, false );
				soundMove.pause();
				soundMove.volume = 0.2;
			} );
		});
	}

	public function addToScore(s:Score) {
		score = score.add(s);
		// trace('new score is ' + score);
		return;
	}

	public function update() {

		//atoms = Game.active.atoms.filter(a -> return a.player == this );

		if (atom == null) {
			final atoms = Game.active.atoms.filter(a -> return a.player == this);
			if( atoms.length > 0 ) {
				selectAtom( atoms[0] );
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
		else if (gp.started("up")) dir.y = -1;
		else if (gp.started("down")) dir.y = 1;

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
	}

	public function selectAtom(newAtom:Atom) {
		if (atom != null) {
			atom.deselect();
		} else {
			
		}
		atom = newAtom;
		atom.select();

		final loc = atom.object.transform.world.getLoc();
		final s = 1.3;
		final scaleFactor = atom.scale * s;
		final duration = object.transform.world.getLoc().distanceTo( loc ) / 20;

		if( soundMove != null ) soundMove.play();
				
		Tween.to({
			props: {x: loc.x, y: loc.y, z: loc.z},
			duration: duration,
			target: object.transform.loc,
			ease: Ease.QuartOut,
			tick: () -> {
				object.transform.buildMatrix();
			},
			done: () -> {
				//if( soundMove != null ) soundMove.play();
			}
		});
		Tween.to({
			props: {x: scaleFactor, y: scaleFactor, z: scaleFactor},
			duration: duration,
			target: mesh.transform.scale,
			tick: mesh.transform.buildMatrix,
			ease: Ease.QuartOut
		});
	}

	public function navigateSelectionTowards(dir:Vec2) {
		if (atom == null || dir.x == 0 && dir.y == 0) {
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

	function fire() {
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
}
