package ld47;

class Player extends Trait {
	public static final COLORS : Array<Color> = [0xfff50057, 0xff00b0ff, 0xffFFEA00, 0xffFF3D00];

	public var index(default, null):Int;
	public var color(default, null):Color;
	public var materials(default, null):haxe.ds.Vector<MaterialData>;
	public var atom(default, null):Atom;

	public function new(index:Int) {
		super();
		this.index = index;
		this.color = COLORS[index];
		notifyOnInit(() -> {
			DataTools.loadMaterial('Game', 'Player$index', m -> {
				materials = m;
				var mesh : MeshObject = cast object;
                mesh.materials = m;
			});
			notifyOnUpdate(update);
		});
	}

	function update() {
		var gp = Input.getGamepad(index);
		var keyboard = Input.getKeyboard();
		if (gp.started('circle')) {
			// TODO select electron
		} else {
			var v = new Vec2();
			if (gp.started("left"))
				v.x = -1;
			else if (gp.started("right"))
				v.x = 1;
			if (gp.started("up"))
				v.y = 1;
			else if (gp.started("down"))
				v.y = -1;

			switch this.index {
				case 0:
					if (keyboard.started('left'))
						v.x = -1;
					else if (keyboard.started('right'))
						v.x = 1;
					if (keyboard.started('up'))
						v.y = 1;
					else if (keyboard.started('down'))
						v.y = -1;
					if (keyboard.started('m'))
						atom.fire();
				case 1:
					if (keyboard.started('a'))
						v.x = -1;
					else if (keyboard.started('d'))
						v.x = 1;
					if (keyboard.started('w'))
						v.y = 1;
					else if (keyboard.started('s'))
						v.y = -1;
					if (keyboard.started('f'))
						atom.fire();
			}

			navigateSelectionTowards(v);

			if (gp.started('cross')) {
				// TODO fire electron
				atom.fire();
			}
		}

		if (atom == null) {
			var atoms = Game.active.atoms.filter(a -> return a.player == this);
			if (atoms.length > 0) {
				selectAtom(atoms[0]);
			}
		}
		if (atom != null) {
			final t = atom.object.transform;
			final s = 1.3;
			final scaleFactor = atom.scale * s;
			object.transform.scale.x = object.transform.scale.y = object.transform.scale.z = scaleFactor;
			object.transform.buildMatrix();
		}
	}

	public function selectAtom(newAtom:Atom) {
		if (atom != null) {
			atom.deselect();
		}
		atom = newAtom;
		atom.select();

		final loc = atom.object.transform.world.getLoc(); 
		final s = 1.3;
		final scaleFactor = atom.scale * s;

		object.transform.scale.x = object.transform.scale.y = object.transform.scale.z = scaleFactor;
		object.transform.buildMatrix();
		
		Tween.to({
			props: {x: loc.x, y: loc.y, z: loc.z},
			duration: 0.5,
			target: object.transform.loc,
			ease: Ease.QuartOut,
			tick: () -> {
				object.transform.buildMatrix();
			},
			done: () -> {
			}
		});
		Tween.to({
			props: {x: scaleFactor, y: scaleFactor, z: scaleFactor},
			duration: 0.5,
			target: object.transform.scale,
			ease: Ease.QuartOut,
		});
	}

	public function navigateSelectionTowards(direction:Vec2) {
		if (atom == null || direction.x == 0 && direction.y == 0) {
			return;
		}

		if (atom != null) {
			var shootDirection = new Vec2(direction.x, direction.y).normalize();
			trace('navigate too ' + shootDirection);

			var atoms = Game.active.atoms.filter(a -> return a.player == this && a != atom);

			if (atoms.length > 0) {
				var bestAtom = null;
				var bestScore = 0.0;
				var bestDistance = 0.0;

				for (a in atoms) {
					var locA = a.object.transform.loc;
					var locAtom = atom.object.transform.loc;
					var distance = locAtom.distanceTo(locA);
					var direction = new Vec2(locA.x - locAtom.x, locA.y - locAtom.y).normalize();
					var score = Math.pow(direction.dot(shootDirection),1) / (distance+10);					

					if (score > bestScore) {						
						bestScore = score;
						bestAtom = a;
						bestDistance = distance;
					}
				}

				

				if (bestAtom != null) {
					trace('navigate from ' + atom.object.transform.loc + ' too best atom at ' + bestAtom.object.transform.loc + ' with a score of ' + bestScore + ' and a distance of ' + bestDistance);
					selectAtom(bestAtom);
				}
				else
				{
					trace('no good atom to navigate to');
				}
			}
		}
	}
}
