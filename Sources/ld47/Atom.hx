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
	public var mesh(default, null) : MeshObject;

	var lastSpawn:Float;
	var spawnTime:Float = 10.0;

	var isSelected:Bool;
	var soundFire : AudioChannel;
	var materials : haxe.ds.Vector<MaterialData>;
	var defaultMaterials : haxe.ds.Vector<MaterialData>;

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

			defaultMaterials = mesh.materials;

			if( materials != null ) mesh.materials = materials;
		//	if( player != null ) mesh.materials = player.materials;

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

			Data.getSound('electron_fire.ogg', s -> {
				soundFire = Audio.play(s, false, false);
				soundFire.pause();
			});

			notifyOnUpdate(update);
		});

		deselect();
	}

	public function setPlayer(p:Player) {
		player = p;
		//trace(player.materials);
		//if ( mesh != null  ) mesh.materials = player.materials;
	/* 	if( player != null )
			if ( mesh != null  ) mesh.materials = player.materials;
		*/
		if( player != null ) {
			trace("SET  MATTERIAL Player"+player.index);
			DataTools.loadMaterial('Game', 'Player'+player.index, m -> {
				materials = m;
				if( mesh != null ) mesh.materials = m;
			});
		} else {
			materials = null;
			mesh.materials = defaultMaterials;
			//mesh.materials = new haxe.ds.Vector(1);
		}
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

			if (electrons.length == 0){
				setPlayer(null);
			}

		}
	}

	public function fire() {
		var oldCount = electrons.length;
		if (oldCount > 0) {
			var index = 0; // hier sollte der index des selektierten elektrons stehen			
			var electron = electrons[index];						
			
			var wlocElectron = new Vec2(electron.object.transform.worldx(),
										 electron.object.transform.worldy());

			var wlocAtom = new Vec2(object.transform.worldx(),
									object.transform.worldy());
			
			object.removeChild(electron.object);
			Scene.active.root.addChild(electron.object);
			electron.setPostion(wlocElectron);
			electrons.splice(index,1);
			Game.active.flyingElectrons.push(electron);
			trace('shot electron from ' + wlocElectron );
			// move electron object in
			var locElectron = electron.object.transform.loc.clone();
			
			var direction = new Vec4(wlocElectron.x - wlocAtom.x,
								     wlocElectron.y - wlocAtom.y ).normalize();
			electron.setVelocity(direction);

			if (electrons.length == 0){
				player.navigateSelectionTowards(new Vec2(direction.x,direction.y));
				setPlayer(null);
			}


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

}
