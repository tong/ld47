package superposition;

private class Marker extends Trait {
	
	public var mesh(default,null) : MeshObject;
	public var light(default,null) : LightObject;
	
	public function new() {
		super();
		notifyOnInit(() -> {
			object.transform.loc.set(0,0,0);
			object.transform.buildMatrix();
			mesh = cast object.getChild('ElectronMarkerMesh');
			//light = cast object.getChild('ElectronMarkerLight');
			//trace(light);
		});
	}

	public function show() {
		if( mesh != null ) mesh.visible = true;
		/*
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
		*/
	}
	
	public function hide() {
		if( mesh != null ) mesh.visible = false;
	}
}

class Atom extends Trait {

	public final index : Int;
	public final numSlots : Int;
	public final scale : Float;

	public var rotationSpeed(default,null) = 1.0; // base speed
	public var electrons(default,null):Array<Electron> = [];
	public var player(default, null):Player;
	public var mesh(default, null):MeshObject;

	var defaultMaterials : haxe.ds.Vector<MaterialData>;
	var materials : haxe.ds.Vector<MaterialData>;
	var marker:Marker;
	var lastSpawnTime:Float;
	var selectedElectron:Electron;
	var soundAmbient : AudioChannel;

	public function new( index : Int, numSlots : Int ) {
		super();
		this.index = index;
		this.numSlots = numSlots;
		//var random = Math.random();
		//this.rotationSpeed = Math.pow(-1, Math.floor(10 * random)) * (1 + random) / numSlots / 20; // * size;
		this.rotationSpeed = 0.01; //numSlots * 0.001;
		this.scale = numSlots / 20;
		
		lastSpawnTime = Game.active.time;

		notifyOnInit(() -> {
			
			
			mesh = cast object.getChild('AtomMesh');
			mesh.transform.scale.x = mesh.transform.scale.y = mesh.transform.scale.z = scale;	
			mesh.transform.buildMatrix();
			mesh.visible = true;

			defaultMaterials = mesh.materials;

			var markerObject = cast object.getChild('ElectronMarker');
			markerObject.visible = true;
			markerObject.addTrait( marker = new Marker() );

			//if (materials != null) mesh.materials = materials;
			
			SoundEffect.play( 'atom_ambient_'+(1+Std.int(Math.random()*8)), true, false, 0.0, a -> {
				soundAmbient = a;
				Tween.to( { target: soundAmbient, props: { volume: 0.3 }, duration: 2.0 } );
			});

			notifyOnUpdate(update);
		});
		
		deselect();
	}

	public function setPostion(v:Vec2) {
		object.transform.loc.x = v.x;
		object.transform.loc.y = v.y;
		object.transform.buildMatrix();
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
			trace('shot electron from $wlocElectron now only ${electrons.length} electrons left');
			var locElectron = electron.object.transform.loc.clone();
			var direction = new Vec4(wlocElectron.x - wlocAtom.x, wlocElectron.y - wlocAtom.y).normalize();
			electron.setVelocity(direction);
			SoundEffect.play('electron_fire_p'+(player.index+1), 0.05 );
			if (electrons.length == 0) {
				player.navigateSelectionTowards(new Vec2(direction.x, direction.y));
				setPlayer(null);
				//if( sound != null ) sound.stop();
				marker.hide();
			}
			selectElectron(getNextElectron(electron));
		} else {
			SoundEffect.play('electron_fire_deny', 0.2 );
		}
	}

	public function hit(electron:Electron) {
		if (player == null) {
			trace('hit on neutral atom');
			electron.player.addToScore(Score.taken);
			setPlayer(electron.player);
			spawnElectron(electron.core);
		} else if (player == electron.player) {
			trace('hit on own atom');
			spawnElectron(electron.core);
		} else {
			trace('hit on enemy atom');
			Scene.active.spawnObject('ElectronExplosion', null, obj -> {
				var mesh : MeshObject = cast obj;
				//var light : LightObject = cast mesh.getChild('ElectronExplosionLight');
				//light.visible = true;
				mesh.transform.loc.x = electron.object.transform.loc.x;
				mesh.transform.loc.y = electron.object.transform.loc.y;
				mesh.transform.loc.z = electron.object.transform.loc.z + 1;
				mesh.transform.rotate( Vec4.zAxis(), Math.random() * 100 );
				@:privateAccess mesh.tilesheet.onActionComplete = () -> {
					mesh.remove();
				}
				SoundEffect.play('electron_hit',false,true,0.5);
			});
			switch electron.core {
			case Bomber: while( electrons.length > 0 ) hitByElectron();
			default: hitByElectron();	
			}
		}
	}

	public function setPlayer(p:Player) {
		player = p;
		if (player != null) {
			DataTools.loadMaterial('Game', 'Player'+(player.index+1), m -> {
				materials = m;
				if (mesh != null) mesh.materials = m;
				if( marker.mesh != null ) {
					marker.mesh.materials = m;
				} else {
					marker.notifyOnInit( () -> {
						marker.mesh.materials = m;
					});
				}
				marker.show();
			});
		} else {
			mesh.materials = defaultMaterials;
			//marker.hide();
		}
	}

	function update() {

		if (Game.active.paused) return;

		var rotSpeed = 1.0;
		var spawnTimeFactor = 0.0;
		
		for( e in electrons ) {
			switch e.core {
			case Spawner(v): spawnTimeFactor += v;
			case Speeder(v): rotSpeed *= v;
			case _:
			}
		}
		
		object.transform.rotate( Vec4.zAxis(), rotSpeed/100 );

		for(e in electrons) e.update();
		
		if( electrons.length < numSlots && spawnTimeFactor > 0 ) {
			var spawnTime = 10 / spawnTimeFactor;
			if( Game.active.time - lastSpawnTime >= spawnTime ) {
				lastSpawnTime = Game.active.time;
				var type = Math.floor( Math.random() * (EnumTools.getConstructors(Electron.Core).length) );
				var core : Electron.Core = switch type {
				case 0: None;
				case 1: Spawner(1+Math.random()*2);
				case 2: Speeder(1+Math.random()*2);
				case 3: Bomber;
				case 4: Shield;
				case 5: Laser;
				case 6: Swastika;
				//case 7: Candyflip;
				//case 8: Occupier;
				case _: null;
				}
				if( core != null ) {
					spawnElectron(core);
				}
			}
		}

		if( electrons.length == 0 ) {
			marker.hide();
		}
	}

	public function select() {
		//marker.show();
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
		//marker.hide();
	}

	public function destroy() {
		if( soundAmbient != null ) soundAmbient.stop();
		for( e in electrons ) e.destroy();
		object.remove();
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
	}

	public function spawnElectrons( cores:Array<Electron.Core>, ?cb:Array<Electron>->Void) {
		var spawned = new Array<Electron>();
		function spawnNext() {
			spawnElectron(cores[spawned.length], e -> {
				spawned.push(e);
				if (spawned.length == cores.length) {
					player.addToScore(Score.spawned);
					if (cb != null) cb(spawned);
				} else spawnNext();
			});
		}
		spawnNext();
	}

	function spawnElectron(core:Electron.Core, ?cb:Electron->Void) {
		Scene.active.spawnObject('Electron', object, obj -> {
			var el = new Electron(player, core);
			el.notifyOnInit(() -> {
				el.setAtom(this, getFirstFreeElectronIndex());
				var pos = getElectronPosition(el);
				var direction = new Vec4(pos.x, pos.y, 0, 1).normalize();
				el.setPostion(pos);
				el.setDirection(direction);
				if (electrons.length == 0) selectElectron(el);
				electrons.push(el);
				if (cb != null) cb(el);
			});
			obj.addTrait(el);
		});
	}

	public function selectPreviousElectron() {
		if (electrons.length > 0) {
			if (rotationSpeed < 0) {
				selectElectron(getNextElectron(selectedElectron));
			} else {
				selectElectron(getPreviousElectron(selectedElectron));
			}
		} else selectElectron();
	}

	public function selectNextElectron() {
		if (electrons.length > 0) {
			if (rotationSpeed > 0) {
				selectElectron(getNextElectron(selectedElectron));
			} else {
				selectElectron(getPreviousElectron(selectedElectron));
			}
		} else selectElectron();
	}

	function hitByElectron(){
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
	
	function getNextElectron(electron:Electron):Electron {
		trace('getNextElectron for index ${electron.position}');
		switch electrons.length {
		case 0: return null;
		case 1: return electrons[0];
		default:
			var i = electron.position;
			do {
				if (++i > numSlots) i = 0;
				for (e in electrons) if (e.position == i) return e;
			} while (true);
		}
	}

	function getPreviousElectron(electron:Electron) : Electron {
		trace('getPreviousElectron for index ${electron.position}');
		switch electrons.length {
		case 0: return null;
		case 1: return electrons[0];
		default:
			var i = electron.position;
			do {
				if (--i < 0) i = numSlots;
				for (e in electrons) if (e.position == i) return e;
			} while (true);
		}
	}
 
	function selectElectron( ?electron : Electron ) {
		if ( (selectedElectron = electron) != null) {
			final loc = electron.object.transform.loc;
			final rot = electron.object.transform.rot;
			trace('change selection to electron at $loc with rot: $rot');
			Tween.to({
				props: {x: loc.x, y: loc.y, z: loc.z},
				duration: 0.2,
				target: marker.object.transform.loc,
				ease: Ease.QuartInOut,
				tick: object.transform.buildMatrix
			});
		} else {
			trace('change electron selection to $electron');
		}
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
			if (isFree) return i;
		}
		return null;
	}

	function getElectronPosition( electron : Electron ) : Vec2 {
		var angle = 2 * Math.PI * electron.position / numSlots;
		if( rotationSpeed < 0 ) angle = -angle;
		final orbRadius = mesh.transform.dim.x / 2 + electron.mesh.transform.dim.x * 2;
		return new Vec2(orbRadius * Math.sin(angle), orbRadius * Math.cos(angle));
	}
}
