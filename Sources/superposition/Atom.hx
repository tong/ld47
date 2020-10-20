package superposition;

import superposition.Player.Score;

class Atom extends Trait {

	public static inline var MIN_SLOTS = 3;
	public static inline var MAX_SLOTS = 32;

	public final index : Int;
	public final numSlots : Int;
	public final scale : FastFloat;
	public final electrons : Array<Electron> = [];

	public var mesh(default,null) : MeshObject;
	public var body(default,null) : RigidBody;
	public var player(default,null) : Player;
	public var selectedElectron(default,null) : Electron;

	//public var rotation(default,null) : FastFloat = 0;
	//public var rotationOffset(default,null) : FastFloat = 90;
	public var rotationSpeed(default,null) : FastFloat = 1.0;
	public var orbRadius(default,null) : FastFloat;

	var defaultMaterials : haxe.ds.Vector<MaterialData>;
	var materials : haxe.ds.Vector<MaterialData>;
	var marker : Marker;
	var lastSpawnTime : Float;
	//var soundAmbient : AudioChannel;
	//var soundFire : AudioChannel;

	public function new( index : Int, numSlots : Int ) {

		super();
		this.index = index;
		this.numSlots = numSlots;
		scale = numSlots / 10;
		
		notifyOnInit( () -> {

			lastSpawnTime = Game.active.time;
			
			mesh = cast object.getChild('AtomMesh');
			mesh.visible = true;
			mesh.transform.scale.x = mesh.transform.scale.y = mesh.transform.scale.z = scale;	
			mesh.transform.buildMatrix();

			defaultMaterials = mesh.materials;
			
			body = mesh.getTrait(RigidBody);
			//body.notifyOnContact( a -> trace(a.name) );
			//PhysicsWorld.active.notifyOnPreUpdate( preUpdate );
			
			var markerObject = cast object.getChild('ElectronMarker');
			///marker = markerObject.getTrait(Marker);
			marker = markerObject.getTrait(Marker);

			/* SoundEffect.play( 'atom_ambient_'+(1+Std.int(Math.random()*8)), true, true, 0.9, a -> {
				soundAmbient = a;
				soundAmbient.pause();
			}); */
			/* SoundEffect.play( 'electron_fire', false, false, 0.1, a -> {
				soundFire = a;
				soundFire.pause();
			}); */

			/* mesh.transform.scale.x = mesh.transform.scale.y = mesh.transform.scale.z = 0.001;
			Tween.to({
				props: {x: scale, y: scale, z: scale},
				duration: 4.0,
				target: mesh.transform.scale,
				ease: Ease.ElasticOut,
				tick: mesh.transform.buildMatrix,
				//done: () -> { body = mesh.getTrait(RigidBody); }
			}); */
		});
		
		notifyOnRemove( () -> {
			body.removeFromWorld();
			//if( soundAmbient != null ) soundAmbient.stop();
			//PhysicsWorld.active.removePreUpdate( preUpdate );
		});
	}

	public inline function setPostion( v : Vec3 ) {
		object.transform.loc.x = v.x;
		object.transform.loc.y = v.y;
		object.transform.loc.z = v.z;
		object.transform.buildMatrix();
		if( body != null ) body.syncTransform();
	}

	public function fire() {
		if( electrons.length > 0 ) {

			var el = selectedElectron;
			var wlocElectron = new Vec2( el.object.transform.worldx(), el.object.transform.worldy() );
			var wlocAtom = new Vec4(object.transform.worldx(), object.transform.worldy());
			var dir = new Vec4( wlocElectron.x - wlocAtom.x, wlocElectron.y - wlocAtom.y ).normalize();
			
			//el.object.remove();
			object.removeChild(el.object);
        	Scene.active.root.addChild( el.object );
			el.setPostion( wlocElectron );
			el.fire( dir );

			electrons.remove( el );
			Game.active.flyingElectrons.push( el );

			trace('shot electron from $wlocElectron now only ${electrons.length} electrons left');
			
			SoundEffect.play( 'electron_fire_p'+(player.index+1), 0.1 );
			
			if (electrons.length == 0) {
				player.navigateSelectionTowards(new Vec2(dir.x, dir.y));
				setPlayer(null);
				//marker.hide();
			} else {
			}

			selectElectron( getNextElectron( el ) );

			/*
			player.score.add( Score.fired );
			var electron = selectedElectron;
			var wlocElectron = new Vec2(electron.object.transform.worldx(), electron.object.transform.worldy());
			var wlocAtom = new Vec2(object.transform.worldx(), object.transform.worldy());
			object.removeChild(electron.object);
			Scene.active.root.addChild(electron.object);
			electron.setPostion(wlocElectron);
			electrons.splice( electrons.indexOf(electron), 1 );
			Game.active.flyingElectrons.push( electron );
			trace('shot electron from $wlocElectron now only ${electrons.length} electrons left');
			var locElectron = electron.object.transform.loc.clone();
			var dir = new Vec4(wlocElectron.x - wlocAtom.x, wlocElectron.y - wlocAtom.y).normalize();
			electron.fire(dir);
			//soundFire.play();
			//SoundEffect.play('electron_fire_p'+(player.index+1), 0.05 );
			if (electrons.length == 0) {
				player.navigateSelectionTowards(new Vec2(dir.x, dir.y));
				setPlayer(null);
				//if( sound != null ) sound.stop();
				marker.hide();
			}
			selectElectron(getNextElectron(electron));
			*/

		} else {
			SoundEffect.play('electron_fire_deny', 0.2 );
		}
	}
	
	public function hit( electron : Electron ) {
		trace('Atom$index got hit by electron '+electron.index);
		Game.active.flyingElectrons.remove( electron );
		if (player == null) {
			trace('hit on neutral atom');
			setPlayer( electron.player );
			spawnElectron( electron.core );
		} else if (player == electron.player) {
			trace('hit on own atom');
			spawnElectron( electron.core );
		} else {

			trace('hit on enemy atom');

			/* switch electron.core {
			case Bomber: while( electrons.length > 0 ) hitByElectron();
			default: hitByElectron();	
			} */

			/* var scale1 = scale - 0.2;
			Tween.to({
				props: {x: scale1, y: scale1, z: scale1},
				duration: 0.2,
				target: mesh.transform.scale,
				ease: Ease.BackOut,
				tick: mesh.transform.buildMatrix,
				done: () -> {
					Tween.to({
						props: {x: scale, y: scale, z: scale},
						duration: 0.2,
						target: mesh.transform.scale,
						ease: Ease.BackOut,
						tick: mesh.transform.buildMatrix,
					});
				}
			}); */
		}
	}

	public function setPlayer( p : Player ) {
		//player = p;
		player = p;
		if (p != null) {
			marker.show();
			DataTools.loadMaterial('Game', 'Player'+(player.index+1), m -> {
				materials = m;
				mesh.materials = m;
				for( e in electrons ) e.mesh.materials = m;
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
			//marker.show();
		} else {
			marker.hide();
			mesh.materials = defaultMaterials;
		}
	}

	public function update() {

		if( body == null || !body.ready ) return;
		body.syncTransform();
		
		/* var contacts = PhysicsWorld.active.getContactPairs( body );
		if( contacts != null ) {
			// var b = PhysicsWorld.active.get
			if( contacts[0] != null ) {
				var rb = PhysicsWorld.active.rbMap.get( contacts[0].a );
				// trace(rb.object.name);
				trace(rb.object.parent.name);
				// var e = rb.object.getTrait( Electron );
				// if( e != null ) trace(e.atom);
			}
		} */

		if( player != null ) {

			var spawnTimeFactor = 0.0;
			var rotAccelerate = ((player.index+1) % 2 == 0) ? -1.0 : 1.0;
			for( e in electrons ) {
				switch e.core {
				case Spawner(v): spawnTimeFactor += v;
				case Speeder(v): rotAccelerate *= v;
				case _:
				}
			}
			
			var rot = rotAccelerate * rotationSpeed;
			object.transform.rotate( Vec4.zAxis(), MathTools.degToRad( rot ) );
			
			/* var q = new Quat().fromAxisAngle( Vec4.zAxis(), MathTools.degToRad( rot ) );
			object.transform.rot.multquats( q, new Quat() );
			object.transform.buildMatrix(); */
		
			if( electrons.length < numSlots && spawnTimeFactor > 0 ) {
				var spawnTime = 10 / spawnTimeFactor;
				if( Game.active.time - lastSpawnTime >= spawnTime ) {
					lastSpawnTime = Game.active.time;
					//TODO core type spawn ratios
					//var core : Electron.Core = None;
					var type = Math.floor( Math.random() * (EnumTools.getConstructors(Electron.Core).length) );
					var core : Electron.Core = switch type {
					case 0: None;
					case 1: Spawner(Math.random()*1);
					case 2: Speeder(1+Math.random()*1);
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
		} else {
			//trace(rotationSpeed);
			//rotationSpeed = 1.0;
			//object.transform.rotate( Vec4.zAxis(), rotationSpeed );
			//marker.hide();
		}

		/* if( selectedElectron == null ) {
			marker.hide();
		} else {
			marker.show();
		} */
	}

	public function dispose() {
		//if( soundAmbient != null ) soundAmbient.stop();
		//for( e in electrons ) e.dispose();
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
			obj.name = 'Electron'+electrons.length + '_' + object.name;
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

	public function removeElectron( electron : Electron ) {
		if( electron != null && electrons.remove( electron ) ) {
			electron.object.remove();
		}
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
			trace('selectElectron '+electron );
			Tween.to({
				props: { x: loc.x, y: loc.y, z: loc.z },
				duration: 0.2,
				target: marker.object.transform.loc,
				ease: Ease.QuartInOut,
				tick: object.transform.buildMatrix
			});
		} else {
			//trace('change electron selection to $electron');
		}
	}

	function hitByElectron() {
		var e = electrons.pop();
		Tween.to({
			props: {x: 0.01, y: 0.01, z: 0.01},
			duration: 0.5,
			target: e.mesh.transform.scale,
			ease: Ease.BackInOut,
			tick: e.mesh.transform.buildMatrix,
			done: () -> e.object.remove()
		});
		if (electrons.length == 0) {
			player.score.add( Score.lost );
			setPlayer(null);
		}
	}

	/*
	function removeElectronAt( index : Int ) : Electron {
	}
	*/
	
	function getNextElectron( electron : Electron ) : Electron {
		//trace('getNextElectron for index ${electron.position}');
		switch electrons.length {
		case 0: return null;
		case 1: return electrons[0];
		default:
			var i = electron.index;
			do {
				if (++i > numSlots) i = 0;
				for (e in electrons) if (e.index == i) return e;
			} while (true);
		}
	}

	function getPrevElectron( electron : Electron ) : Electron {
		//trace('getPrevElectron for index ${electron.position}');
		switch electrons.length {
		case 0: return null;
		case 1: return electrons[0];
		default:
			var i = electron.index;
			do {
				if (--i < 0) i = numSlots;
				for (e in electrons) if (e.index == i) return e;
			} while (true);
		}
	}

	function getFirstFreeElectronIndex() : Null<Int> {
		for( i in 0...numSlots ) {
			var isFree = true;
			for (e in electrons) {
				if (e.index == i) {
					isFree = false;
					break;
				}
			}
			if( isFree ) return i;
		}
		return null;
	}

	function getElectronPosition( electron : Electron ) : Vec2 {
		var angle = 2 * PI * electron.index / numSlots;
		if( rotationSpeed < 0 ) angle = -angle;
		var orbRadius = (mesh.transform.dim.y / 2) + Electron.RADIUS* 3;
		return new Vec2( orbRadius * Math.sin(angle), orbRadius * Math.cos(angle) );
	}
}
