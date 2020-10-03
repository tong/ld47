package ld47;

class Player {
	public static final COLORS = [0xF50057, 0x00B0FF, 0xFFEA00, 0xFF3D00];

	// public dynamic function onNavigate( direction : Float ) {}
	public var index(default, null):Int;
	public var name(default, null):String;
	public var color(default, null):Int;
	public var atom(default, null):Atom;

	public function new(index:Int, name:String) {
		this.index = index;
		this.name = name;
		this.color = COLORS[index];
	}

	public function update() {
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

			switch index {
				case 0:
					if (keyboard.started('left'))
						v.x = -1;
					else if (keyboard.started('right'))
						v.x = 1;
					if (keyboard.started('up'))
						v.y = 1;
					else if (keyboard.started('down'))
						v.y = -1;
				case 1:
					if (keyboard.started('a'))
						v.x = -1;
					else if (keyboard.started('d'))
						v.x = 1;
					if (keyboard.started('w'))
						v.y = 1;
					else if (keyboard.started('s'))
						v.y = -1;
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
	}

	public function selectAtom(newAtom:Atom) {
		if (atom != null) {
			atom.deselect();
		}
		atom = newAtom;
		atom.select();
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
					var distance = atom.object.transform.loc.distanceTo(a.object.transform.loc);
					var direction = new Vec2(a.object.transform.loc.x - atom.object.transform.loc.x, a.object.transform.loc.y - atom.object.transform.loc.y);
					var score = direction.dot(shootDirection) / distance;

					if (score > bestScore) {
						bestScore = score;
						bestAtom = a;
						bestDistance = distance;
					}
				}

				if (bestAtom != null) {
					selectAtom(bestAtom);
				}
			}
		}
	}
}
