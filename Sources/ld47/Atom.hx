package ld47;

import iron.data.MaterialData;

class Atom extends Trait {
	static var defaultColor = new Vec4(1, 1, 1);

	public var rotationSpeed:Float;
	public var numSlots:Int;
	public var electrons:Array<Electron> = [];
	public var orbitRadius:Float = 1.8;
	public var player(default, null):Player;
	public var scale(default, null):Float;

	var lastSpawn:Float;
	var spawnTime:Float = 10.0;

	var isSelected:Bool;
	var mesh : MeshObject;
	var soundFire : AudioChannel;

	public function new(numSlots:Int) {
		super();
		this.numSlots = numSlots;
		this.rotationSpeed = 1 / numSlots / 10; // * size;
		this.scale = (numSlots/20);
		
		lastSpawn = Game.active.time;
		
		notifyOnInit(() -> {

			mesh = cast object.getChild('AtomMesh');
			mesh.transform.scale.x = mesh.transform.scale.y = mesh.transform.scale.z = scale;
			mesh.transform.buildMatrix();
			
			/* Tween.to({
				props: {x: scale, y: scale, z: scale},
				duration: 0.5,
				target: atomMesh.transform.scale,
				//target: object.transform.scale,
				ease: Ease.QuartOut,
				tick: () -> {
					atomMesh.transform.buildMatrix();
				},
				done: () -> {
					// object.remove();
				}
			});
 			*/

			Data.getSound('fire_electron.ogg', s -> {
				soundFire = Audio.play(s, false, false);
				soundFire.pause();
			});

			Uniforms.externalVec3Links.push(vec3Link);

			notifyOnUpdate(update);
		});

		deselect();
	}

	public function setPlayer(p:Player) {
		if (player != null) {}
		player = p;
		/*
		if (marker != null) {
			marker.color = player.color;
		}
		*/
	}

	public function setPostion(v:Vec2) {
		object.transform.loc.x = v.x;
		object.transform.loc.y = v.y;
		object.transform.buildMatrix();
	}

	public function hit(electron:Electron) {		
		if (player == null) {
			trace('we got a hit on a neutral atom');
			setPlayer(electron.player);
			addElectron(electron);
		} else if (player == electron.player) {
			trace('we got a hit on a own atom');
			addElectron(electron);
		} else {
			trace('we got a hit on a enemy atom');
			var e = electrons.pop();
			e.object.remove();
			e.object.remove();
		}
	}

	public function fire() {
		var oldCount = electrons.length;
		if (oldCount > 0) {
			var index = oldCount-1; // hier sollte der index des selektierten elektrons stehen			
			var electron = electrons[index];			
			//electron.object.remove();
			var wlocElectron = new Vec2(electron.object.transform.worldx(),
										 electron.object.transform.worldy());

			var wlocAtom = new Vec2(object.transform.worldx(),
									object.transform.worldy());
			
			Scene.active.root.addChild(electron.object);
			electron.setPostion(wlocElectron);
			electrons.splice(index,1);
			Game.active.flyingElectrons.push(electron);
			trace('shot electron from ' + wlocElectron );
			// move electron object in
			var locElectron = electron.object.transform.loc.clone();
			//var locAtom = object.transform.loc.clone();
			var direction = new Vec4(wlocElectron.x - wlocAtom.x,
								     wlocElectron.y - wlocAtom.y );
			electron.setVelocity(direction);

			soundFire.play();
		}
		else
		{
			//play sound if no electron is there
		}



		
	}

	function update() {
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
		/* if (marker != null) {
			// marker.object.visible = true;

			marker.show();
			// Twwen.to;
			// trace(marker.materials.length);
		} */
	}

	public function deselect() {
		isSelected = false;
		/* if (marker != null) {
			marker.object.visible = false;
		} */
	}

	public function destroy() {
		/*
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
		*/
		object.remove();
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
		var direction = new Vec4(pos.x,pos.y,0,1).normalize();

		Scene.active.spawnObject('Electron', object, obj -> {
			// trace(obj);
			obj.addTrait(electron);
			// electron.setPostion( pos );
		});

		electron.setPostion(pos);
		electron.setDirection(direction);
		// trace('added elektron at position' + pos);
	}

	private function getElectronPosition(count:Int) {
		var angle = 2 * Math.PI * count / numSlots;
		return new Vec2(orbitRadius * Math.sin(angle), orbitRadius * Math.cos(angle));
	}

	function vec3Link(object:Object, mat:MaterialData, link:String):Vec4 {
		if (link == "RGB" && object == mesh) {
			if (player == null) {
				return defaultColor;
			} else {
				// TODO
				var c:Color = player.color;
				var c2 = Color.fromBytes( c.Rb, c.Gb, c.Bb );
				//var c2 = Color.fromBytes( c.Rb, c.Gb, c.Bb );
				return new Vec4( c2.R, c2.G, c2.B, 0.0 );
				//return new Vec4( Player._COLORS[0][0], Player._COLORS[0][1], Player._COLORS[0][2] );
			}
		}
		return null;
	}
}
