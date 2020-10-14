package ld47;

import iron.data.MaterialData;

class Atom extends Trait {

	public final index : Int;
	public final numSlots : Int;

	public var rotationSpeed:Float;
	public var electrons:Array<Electron> = [];
	public var player(default, null):Player;
	public var scale(default, null):Float;
	public var mesh(default, null):MeshObject;
	public var spawnTime : Float;

	var marker:Marker;
	var lastIntervalledSpawn:Float;
	var materials:haxe.ds.Vector<MaterialData>;
	var defaultMaterials:haxe.ds.Vector<MaterialData>;
	var selectedElectron:Electron;
	var sound : AudioChannel;

	public function new( index : Int, numSlots : Int, spawnTime = 10.0 ) {
		super();
		this.index = index;
		this.numSlots = numSlots;
		this.spawnTime = spawnTime;
		//var random = Math.random();
		//this.rotationSpeed = Math.pow(-1, Math.floor(10 * random)) * (1 + random) / numSlots / 20; // * size;
		this.rotationSpeed = 0.01; //numSlots * 0.001;
		this.scale = numSlots / 20;
		lastIntervalledSpawn = Game.active.time;

		notifyOnInit(() -> {

			mesh = cast object.getChild('AtomMesh');
			mesh.transform.scale.x = mesh.transform.scale.y = mesh.transform.scale.z = scale;
			mesh.transform.buildMatrix();
			mesh.visible = true;

			var markerObject = cast object.getChild('ElectronMarker');
			marker = new Marker();
			markerObject.addTrait(marker);
			marker.hide();

			defaultMaterials = mesh.materials;

			if (materials != null)
				mesh.materials = materials;
			
			
			/*
			var soundName = 'atom_'+(index+1);
			//trace('Loading sound $soundName');
			SoundEffect.play( soundName, true, true, 0.6, a -> {
				sound = a;
			} );
			 */

			notifyOnUpdate(update);
		});

		deselect();
	}

	public function setPlayer(p:Player) {
		player = p;
		if (player != null) {
			marker.show();
			var markerObject = cast object.getChild('ElectronMarker');
			DataTools.loadMaterial('Game', 'Player' + player.index, m -> {
				materials = m;
				markerObject.materials = m;
				if (mesh != null)
					mesh.materials = m;
			});
		} else {
			marker.hide();
			materials = null;
			mesh.materials = defaultMaterials;
		}
	}

	public function setPostion(v:Vec2) {
		object.transform.loc.x = v.x;
		object.transform.loc.y = v.y;
		object.transform.buildMatrix();
	}

	public function hit(electron:Electron) {
		if (player == null) {
			trace('hit on neutral atom');
			electron.player.addToScore(Score.taken);
			setPlayer(electron.player);
			spawnElectron(electron.feature);
		} else if (player == electron.player) {
			trace('hit on own atom');
			spawnElectron(electron.feature);
		} else {
			trace('hit on enemy atom');
			if (electron.feature == Electron.Feature.Bomber){
				hitByFeatureBomber();
			}
			if (electron.feature == Electron.Feature.UpSpeeder){
				hitByFeatureUpSpeeder();
			}
			if (electron.feature == Electron.Feature.DownSpeeder){
				hitByFeatureDownSpeeder();
			}
			else {				
				hitByFeatureNone();				
			}
			
		}
	}

	public function fire() {
		var oldCount = electrons.length;
		if (oldCount > 0) {
			player.addToScore(Score.fired);
			var electron = selectedElectron;
			var wlocElectron = new Vec2(electron.object.transform.worldx(), electron.object.transform.worldy());

			var wlocAtom = new Vec2(object.transform.worldx(), object.transform.worldy());

			object.removeChild(electron.object);
			Scene.active.root.addChild(electron.object);
			electron.setPostion(wlocElectron);
			electrons.splice(electrons.indexOf(electron), 1);
			Game.active.flyingElectrons.push(electron);
			trace('shot electron from ' + wlocElectron + ' now only ' + electrons.length + ' electrons left');
			// move electron object in
			var locElectron = electron.object.transform.loc.clone();

			var direction = new Vec4(wlocElectron.x - wlocAtom.x, wlocElectron.y - wlocAtom.y).normalize();
			electron.setVelocity(direction);

			if (electrons.length == 0) {
				player.navigateSelectionTowards(new Vec2(direction.x, direction.y));
				setPlayer(null);
				if( sound != null ) sound.stop();
			}

			selectElectron(getNextElectron(electron));
			SoundEffect.play('electron_fire_p'+(index+1), 0.2 );

		} else {
			SoundEffect.play('electron_fire_deny', 0.2 );
		}
	}

	function update() {
		if (Game.active.paused)
			return;

		var upSpeeders = electrons.filter((e:Electron)-> return e.feature == Electron.Feature.UpSpeeder).length;
		var downSpeeders = electrons.filter((e:Electron)-> return e.feature == Electron.Feature.DownSpeeder).length;
		var modifiedRotationSpeed = rotationSpeed*Math.pow(1.1,upSpeeders)*Math.pow(0.8,downSpeeders);


		object.transform.rotate(new Vec4(0, 0, 1), modifiedRotationSpeed);

		for (electron in electrons) {
			electron.update();
		}

		if (Game.active.time - lastIntervalledSpawn >= spawnTime) {
			lastIntervalledSpawn = Game.active.time;

			var spawnerCount = electrons.filter((e:Electron) -> return e.feature == Electron.Feature.Spawner).length;
			var num = Std.int(Math.min(numSlots - electrons.length, spawnerCount));
			// trace('we have ' + electrons.length + ' electrons, but only ' + spawnerCount + ' are spanners');

			if (num > 0) {
				var features = new Array<Electron.Feature>();
				for (i in 0...num){
					switch Math.floor(Math.random()*3){
						case 0: features.push(Electron.Feature.Bomber);
						case 1: features.push(Electron.Feature.UpSpeeder);
						case 2: features.push(Electron.Feature.DownSpeeder);
						default: features.push(Electron.Feature.None);
					}
				}
				
				spawnElectrons(features);
			}
		}
	}

	public function select() {
		/* if (marker != null) {
			// marker.object.visible = true;

			marker.show();
			// Twwen.to;
			// trace(marker.materials.length);
		}*/
	}

	public function deselect() {
		/* if (marker != null) {
			marker.object.visible = false;
		}*/
	}

	public function destroy() {
		if( sound != null ) sound.stop();
		for( e in electrons ) e.destroy();
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

	public function spawnElectrons(features:Array<Electron.Feature>, ?cb:Array<Electron>->Void) {
		// var numSpawned = 0;
		var spawned = new Array<Electron>();
		function spawnNext() {
			spawnElectron(features[spawned.length], e -> {
				spawned.push(e);
				if (spawned.length == features.length) {
					player.addToScore(Score.spawned);
					if (cb != null) {
						cb(spawned);
					}
				} else {
					spawnNext();
				}
			});
		}
		spawnNext();
	}

	public function spawnElectron(feature:Electron.Feature, ?cb:Electron->Void) {
		Scene.active.spawnObject('Electron', object, obj -> {
			var electron = new Electron(player, feature);
			electron.notifyOnInit(() -> {
				electron.setAtom(this, getFirstFreeElectronIndex());
				var pos = getElectronPosition(electron);
				var direction = new Vec4(pos.x, pos.y, 0, 1).normalize();
				electron.setPostion(pos);
				electron.setDirection(direction);
				if (electrons.length == 0) {
					selectElectron(electron);
				}
				electrons.push(electron);
				if (cb != null)
					cb(electron);
			});
			obj.addTrait(electron);
		});
	}

	public function selectPreviousElectron() {
		if (electrons.length > 0) {
			if (rotationSpeed < 0) {
				selectElectron(getNextElectron(selectedElectron));
			} else {
				selectElectron(getPreviousElectron(selectedElectron));
			}
		} else {
			selectElectron();
		}
	}

	public function selectNextElectron() {
		if (electrons.length > 0) {
			if (rotationSpeed > 0) {
				selectElectron(getNextElectron(selectedElectron));
			} else {
				selectElectron(getPreviousElectron(selectedElectron));
			}
		} else {
			selectElectron();
		}
	}

	function hitByFeatureNone(){
		var e = electrons.pop();
		Tween.to({
			props: {x: 0.01, y: 0.01, z: 0.01},
			duration: 1.0,
			target: e.mesh.transform.scale,
			ease: Ease.ElasticOut,
			tick: e.mesh.transform.buildMatrix,
			done: () -> e.object.remove()
		});

		if (electrons.length == 0) {
			player.addToScore(Score.lost);
			setPlayer(null);
		}
	}

	function hitByFeatureBomber(){
		while (electrons.length>0){
			hitByFeatureNone();
		}	
	}

	function hitByFeatureUpSpeeder(){		
		rotationSpeed = rotationSpeed*1.2;//the rotationspeed of this atom increases permanently
		hitByFeatureNone();
	}

	function hitByFeatureDownSpeeder(){		
		rotationSpeed = rotationSpeed*0.8;//the rotationspeed of this atom increases permanently
		hitByFeatureNone();
	}

	function getNextElectron(electron:Electron):Electron {
		trace('getNextElectron for index ' + electron.position);
		switch electrons.length {
		case 0: return null;
		case 1: return electrons[0];
		default:
			var index = electron.position;
			do {
				if (++index > numSlots) {
					index = 0;
				}
				for (e in electrons) {
					if (e.position == index)
						return e;
				}
			} while (true);
		}
	}

	function getPreviousElectron(electron:Electron):Electron {
		trace('getPreviousElectron for index ' + electron.position);
		if (electrons.length == 0) {
			return null;
		} else if (electrons.length == 1) {
			return electrons[0];
		} else {
			var index = electron.position;
			do {
				index--;
				if (index < 0) {
					index = numSlots;
				}
				for (e in electrons) {
					if (e.position == index)
						return e;
				}
			} while (true);
		}
	}
 
	function selectElectron( ?electron : Electron ) {
		var loc = new Vec4();
		var rot = new Quat();
		selectedElectron = electron;
		if (electron != null) {
			loc = electron.object.transform.loc;
			rot = electron.object.transform.rot;
			trace('change selection to electron at $loc with rot: $rot');
		} else {
			trace('change electron selection to ' + electron);
		}
		Tween.to({
			props: {x: loc.x, y: loc.y, z: loc.z},
			duration: 0.5,
			target: marker.object.transform.loc,
			ease: Ease.QuartOut,
			tick: object.transform.buildMatrix
		});
		Tween.to({
			props: { x: rot.x, y: rot.y, z: rot.z, w: rot.w },
			duration: 0.5,
			target: marker.object.transform.rot,
			ease: Ease.QuartOut,
			tick: object.transform.buildMatrix
		});
	}

	function getFirstFreeElectronIndex() : Null<Int> {
		for (i in 0...numSlots) {
			var isFree = true;
			for (e in electrons) {
				if (e.position == i) {
					isFree = false;
					break;
				}
			}
			if (isFree)
				return i;
		}
		return null;
	}

	function getElectronPosition( electron : Electron ) : Vec2 {
		var angle = 2 * Math.PI * electron.position / numSlots;
		if( rotationSpeed < 0 ) angle = -angle;
		var orbitRadius = mesh.transform.dim.x / 2 + electron.mesh.transform.dim.x * 2;
		return new Vec2(orbitRadius * Math.sin(angle), orbitRadius * Math.cos(angle));
	}
}
