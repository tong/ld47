package superposition;

import superposition.Player.Score;

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

	public static inline var MIN_SLOTS = 3;
	public static inline var MAX_SLOTS = 32;

	public final index : Int;
	public final numSlots : Int;
	public final scale : FastFloat;
	public final electrons : Array<Electron> = [];

	public var player(default,null) : Player;
	public var mesh(default,null) : MeshObject;
	public var selectedElectron(default,null) : Electron;

	public var rotationSpeed(default,null) : FastFloat = 1.0;
	public var orbRadius(default,null) : FastFloat;

	var marker : Marker;
	var defaultMaterials : haxe.ds.Vector<MaterialData>;
	var materials : haxe.ds.Vector<MaterialData>;
	var lastSpawnTime : Float;
	//var soundAmbient : AudioChannel;

	public function new( index : Int, numSlots : Int ) {

		super();
		this.index = index;
		this.numSlots = numSlots;
		
		scale = numSlots / 10;
		rotationSpeed = 0.01; //numSlots * 0.001;
		
		notifyOnInit( () -> {

			lastSpawnTime = Game.active.time;
			
			mesh = cast object.getChild('AtomMesh');
			mesh.visible = true;
			mesh.transform.scale.x = mesh.transform.scale.y = mesh.transform.scale.z = scale;	
			mesh.transform.buildMatrix();

			defaultMaterials = mesh.materials;
			
			var markerObject = cast object.getChild('ElectronMarker');
			markerObject.visible = true;
			marker = new Marker();
			markerObject.addTrait( marker );

			/* var speaker = object.getChildOfType( SpeakerObject );
			trace(speaker); */
			
			/*
			SoundEffect.play( 'atom_ambient_'+(1+Std.int(Math.random()*8)), true, true, 0.9, a -> {
				soundAmbient = a;
				soundAmbient.pause();
				//Tween.to( { target: soundAmbient, props: { volume: 0.3 }, duration: 2.0 } );
			});
			*/
		});
	}

	public function setPostion( v : Vec2 ) {
		object.transform.loc.x = v.x;
		object.transform.loc.y = v.y;
		object.transform.buildMatrix();
	}

	public function fire() {
		var oldCount = electrons.length;
		if (oldCount > 0) {
			player.score.add( Score.fired );
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
			electron.player.score.add(Score.taken);
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
						if( marker.mesh != null )
							marker.mesh.materials = m;
					});
				}
				marker.show();
			});
			//soundAmbient.play();
		} else {
			mesh.materials = defaultMaterials;
			//marker.hide();
			//soundAmbient.stop();
		}
	}

	public function update() {

		if( player != null ) {

			var rotSpeed = ((player.index+1) % 2 == 0) ? -1.0 : 1.0;
			var spawnTimeFactor = 0.0;
			
			for( e in electrons ) {
				switch e.core {
				case Spawner(v): spawnTimeFactor += v;
				case Speeder(v): rotSpeed *= v;
				//case Speeder(v): rotSpeed += v;
				case _:
				}
			}
			
			var baseSpeed = 0.6; //TODO
			rotationSpeed = rotSpeed/ (100/baseSpeed);
			object.transform.rotate( Vec4.zAxis(), rotationSpeed );
	
			for(e in electrons) e.update();
			
			if( electrons.length < numSlots && spawnTimeFactor > 0 ) {
				var spawnTime = 10 / spawnTimeFactor;
				if( Game.active.time - lastSpawnTime >= spawnTime ) {
					lastSpawnTime = Game.active.time;
					//TODO core type spawn ratios
					var core : Electron.Core = None;
					/*
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
					*/
					if( core != null ) {
						spawnElectron(core);
					}
				}
			}
		}

		if( electrons.length == 0 ) {
			marker.hide();
		}
	}

	public function dispose() {
		//if( soundAmbient != null ) soundAmbient.stop();
		for( e in electrons ) e.dispose();
		object.remove();
	}

	public function spawnElectrons( cores:Array<Electron.Core>, ?cb:Array<Electron>->Void) {
		var spawned = new Array<Electron>();
		function spawnNext() {
			spawnElectron( cores[spawned.length], e -> {
				spawned.push(e);
				if (spawned.length == cores.length) {
					player.score.add( Score.spawned );
					if (cb != null) cb(spawned);
				} else spawnNext();
			});
		}
		spawnNext();
	}

	function spawnElectron( core : Electron.Core, ?cb : Electron->Void ) {
		Scene.active.spawnObject('Electron', object, obj -> {
			var e = new Electron( player, core );
			e.notifyOnInit(() -> {
				e.setAtom( this, getFirstFreeElectronIndex() );
				var pos = getElectronPosition(e);
				var dir = new Vec4( pos.x, pos.y ).normalize();
				e.setPostion( pos );
				e.setDirection( dir );
				if (electrons.length == 0) selectElectron(e);
				electrons.push(e);
				if (cb != null) cb(e);
			});
			obj.addTrait(e);
		});
	}

	public function selectPreviousElectron() {
		if (electrons.length > 0) {
			if (rotationSpeed < 0) {
				selectElectron(getNextElectron(selectedElectron));
			} else {
				selectElectron(getPrevElectron(selectedElectron));
			}
		} else selectElectron();
	}

	public function selectNextElectron() {
		if (electrons.length > 0) {
			if (rotationSpeed > 0) {
				selectElectron(getNextElectron(selectedElectron));
			} else {
				selectElectron(getPrevElectron(selectedElectron));
			}
		} else selectElectron();
	}

	function selectElectron( ?electron : Electron ) {
		if ( (selectedElectron = electron) != null) {
			var loc = electron.object.transform.loc;
			var rot = electron.object.transform.rot;
			trace('change selection to electron at $loc with rot: $rot');
			Tween.to({
				props: { x: loc.x, y: loc.y, z: loc.z },
				duration: 0.2,
				target: marker.object.transform.loc,
				ease: Ease.QuartInOut,
				tick: object.transform.buildMatrix
			});
		} else {
			trace('change electron selection to $electron');
		}
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
			player.score.add( Score.lost );
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

	function getPrevElectron(electron:Electron) : Electron {
		trace('getPrevElectron for index ${electron.position}');
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

	function getFirstFreeElectronIndex() : Null<Int> {
		for( i in 0...numSlots ) {
			var isFree = true;
			for (e in electrons) {
				if (e.position == i) {
					isFree = false;
					break;
				}
			}
			if( isFree ) return i;
		}
		return null;
	}

	function getElectronPosition( electron : Electron ) : Vec2 {
		var angle = 2 * PI * electron.position / numSlots;
		if( rotationSpeed < 0 ) angle = -angle;
		var orbRadius = (mesh.transform.dim.y / 2) + Electron.RADIUS* 3;
		return new Vec2( orbRadius * Math.sin(angle), orbRadius * Math.cos(angle) );
	}
}
