package ld47;

import iron.data.MaterialData;

class Atom extends Trait {
	static var defaultColor = new Vec4(1, 1, 1);

	public var rotationSpeed = 0.01;
	public var numSlots:Int = 10;
	public var electrons:Array<Electron> = [];
	public var orbitRadius:Float = 2;
	public var player(default, null):Player;

	var lastSpawn:Float;
	var spawnTime:Float = 10.0;

	var isSelected:Bool;
	// var marker:MeshObject;
	var marker:Marker;

	public function new() {
		super();

		lastSpawn = Game.active.time;

		notifyOnInit(() -> {
			object.transform.scale.x = object.transform.scale.y = object.transform.scale.z = 0.1;
			object.transform.buildMatrix();

			Tween.to({
				props: {x: 1, y: 1, z: 1},
				duration: 0.5,
				target: object.transform.scale,
				ease: Ease.QuartOut,
				tick: () -> {
					object.transform.buildMatrix();
				},
				done: () -> {
					// object.remove();
				}
			});

			var markerObject = cast object.getChild('AtomMarker');
			marker = new Marker();
			markerObject.addTrait(marker);

			// marker.show();

			if (player != null)
				marker.color = player.color;

			Uniforms.externalVec3Links.push(vec3Link);
		});

		deselect();
	}

	public function setPlayer(p:Player) {
		if (player != null) {}
		player = p;
		if (marker != null) {
			marker.color = player.color;
		}
	}

	public function setPostion(v:Vec2) {
		object.transform.loc.x = v.x;
		object.transform.loc.y = v.y;
		object.transform.buildMatrix();
	}

	public function hit(electron:Electron) {
		if (player == null) {
			setPlayer(electron.player);
			addElectron(electron);
		} else if (player == electron.player) {
			addElectron(electron);
		} else {
			var e = electrons.pop();
			e.object.remove();
			e.object.remove();
		}
	}

	public function fire() {
		if (electrons.length > 0) {
			var electron = electrons[0];
			var index = 0; // hier sollte der index des selektierten elektrons stehen
			// move electron object in
		}

		Data.getSound('fire_electron.ogg', s -> {
			var channel = Audio.play(s);
		});
	}

	public function update() {
		object.transform.rotate(new Vec4(0, 0, 1), rotationSpeed);

		for (electron in electrons) {
			electron.update();
		}
		if (Game.active.time - lastSpawn >= spawnTime) {
			spawnElectrons();
		}
	}

	public function select() {
		isSelected = true;
		if (marker != null) {
			// marker.object.visible = true;

			marker.show();
			// Twwen.to;
			// trace(marker.materials.length);
		}
	}

	public function deselect() {
		isSelected = false;
		if (marker != null) {
			marker.object.visible = false;
		}
	}

	public function destroy() {
		var scale = 0.1;
		Tween.to({
			props: {x: scale, y: scale, z: scale},
			duration: 1.0,
			target: object.transform.scale,
			ease: Ease.QuartIn,
			tick: () -> {
				object.transform.buildMatrix();
			},
			done: () -> {
				object.remove();
			}
		});
	}

	public function spawnElectrons() {
		lastSpawn = Game.active.time;

		var spawnerCount = electrons.filter((e:Electron) -> return e.features.filter(f -> f == Electron.Feature.Spawner).length > 0).length;

		var spawnCount = Std.int(Math.min(numSlots - electrons.length, spawnerCount));
		// trace('spawn ' + spawnCount + ' new electrons');
		for (index in 0...spawnCount) {
			var newElectron = new Electron(player, new Array<ld47.Electron.Feature>());
			addElectron(newElectron);
		}
	}

	public function addElectron(electron:Electron) {
		electron.setAtom(this);
		electrons.push(electron);
		// move electron object into atom object
		//  electron.object.location = getElectronPosition(electrons.length);
		var pos = getElectronPosition(electrons.length);

		Scene.active.spawnObject('Electron', object, obj -> {
			// trace(obj);
			obj.addTrait(electron);
			// electron.setPostion( pos );
		});

		electron.setPostion(pos);
		// trace('added elektron at position' + pos);
	}

	private function getElectronPosition(count:Int) {
		var angle = 2 * Math.PI * count / numSlots;
		return new Vec2(orbitRadius * Math.sin(angle), orbitRadius * Math.cos(angle));
	}

	function vec3Link(object:Object, mat:MaterialData, link:String):Vec4 {
		if (link == "RGB" && object == this.object) {
			if (player == null) {
				return defaultColor;
			} else {
				var c:Color = player.color;
				return new Vec4(c.R, c.G, c.B);
			}
		}
		return null;
	}
}
