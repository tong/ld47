package ld47;

class Player {
	// public dynamic function onNavigate( direction : Float ) {}
	public var index(default, null):Int;
	public var name(default, null):String;
	public var color(default, null):Int;
	public var atom(default, null):Atom;

	public function new(index:Int, name:String, color:Int) {
		this.index = index;
		this.name = name;
		this.color = color;
	}

	public function update() {
		var gp = iron.system.Input.getGamepad(index);
		if (gp.started('circle')) {
			// TODO select electron
		} else {
			if (gp.leftStick.moved) {
				var v = new Vec2();
				if (gp.started("left"))
					v.x = -1;
				else if (gp.started("right"))
					v.x = 1;
				if (gp.started("up"))
					v.y = -1;
				else if (gp.started("down"))
					v.y = 1;
				// onNavigate( v );
				navigateSelectionTowards(v);
			}
			if (gp.started('cross')) {
				// TODO fire electron
				atom.fire();
			}
        }
        
        if (atom == null)
            {
                var atoms = Game.active.atoms.filter(a -> return a.player == this);
                if (atoms.length >0)
                    {
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
        
        direction=new Vec2(0,0);

        if (atom == null)
        {
            return;
        }
        else if (direction.x == 0 && direction.y==0)
        {
            return;
        }

		if (atom != null ) {
            trace('navigate too ' + direction);
			var shootDirection = new Vec4(direction.x, direction.y).normalize();
			var atoms = Game.active.atoms.filter(a -> return a.player == this && a != atom);
			atoms.sort((a, b) -> {
				var locA = a.object.transform.loc;
				var locB = b.object.transform.loc;
				var locAtom = atom.object.transform.loc;
				var aDir = locA.normalize().dot(shootDirection) / locA.distanceTo(locAtom);
				var bDir = locB.normalize().dot(shootDirection) / locB.distanceTo(locAtom);
				return (aDir > bDir) ? 1 : (aDir == bDir) ? 0 : -1;
            });
            
            trace('found x atoms for player ' + atoms.length);

			if (atoms.length > 0) {
				selectAtom(atoms[0]);
			}
		}
	}
}
