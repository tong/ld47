package ld47;

import iron.data.MaterialData;

class Atom extends Trait {
	static var defaultColor = new Vec4(1, 1, 1);

	public var rotationSpeed:Float;
	public var numSlots:Int;
	public var electrons:Array<Electron> = [];	
	public var player(default, null):Player;
	public var scale(default, null):Float;
	public var mesh(default, null) : MeshObject;
	var marker:Marker;

	var lastIntervalledSpawn:Float;
	var spawnTime:Float = 10.0;	
	var materials : haxe.ds.Vector<MaterialData>;
	var defaultMaterials : haxe.ds.Vector<MaterialData>;
	var selectedElectron : Electron;

	public function new(numSlots:Int) {
		super();
		this.numSlots = numSlots;
		var random = Math.random();
		this.rotationSpeed = Math.pow(-1,Math.floor(10*random))*(1 + random) / numSlots / 20; // * size;
		this.scale = (numSlots/20);				
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
			

			if( materials != null ) mesh.materials = materials;

			notifyOnUpdate(update);
		});

		deselect();
	}

	public function setPlayer(p:Player) {
		player = p;
		if( player != null ) {
			trace("SET  MATTERIAL Player"+player.index);
			marker.show();
			var markerObject = cast object.getChild('ElectronMarker');
			
			DataTools.loadMaterial('Game', 'Player'+player.index, m -> {
				materials = m;
				markerObject.materials = m;
				if( mesh != null ) mesh.materials = m;
			});
		} else {
			marker.hide();
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
			electron.player.addToScore(Score.taken);
			setPlayer(electron.player);
			spawnElectron(electron.feature);
		} else if (player == electron.player) {
			trace('we got a hit on a own atom');
			spawnElectron(electron.feature);
		} else {
			trace('we got a hit on a enemy atom');
			var e = electrons.pop();
			Tween.to({
                props: {x: 0.01, y: 0.01, z: 0.01},
                duration: 1.0,
                target: e.mesh.transform.scale,
                ease: Ease.ElasticOut,
				tick: e.mesh.transform.buildMatrix,
				done: () -> e.object.remove()
            });
			if (electrons.length == 0){
				player.addToScore(Score.lost);
				setPlayer(null);
			}
		}
	}

	public function fire() {
		var oldCount = electrons.length;
		if (oldCount > 0) {
			player.addToScore(Score.fired);			
			var electron = selectedElectron;				
			var wlocElectron = new Vec2(electron.object.transform.worldx(),
										 electron.object.transform.worldy());

			var wlocAtom = new Vec2(object.transform.worldx(),
									object.transform.worldy());
			
			object.removeChild(electron.object);
			Scene.active.root.addChild(electron.object);
			electron.setPostion(wlocElectron);
			electrons.splice(electrons.indexOf(electron),1);
			Game.active.flyingElectrons.push(electron);
			trace('shot electron from ' + wlocElectron + ' now only ' + electrons.length + ' electrons left');
			// move electron object in
			var locElectron = electron.object.transform.loc.clone();
			
			var direction = new Vec4(wlocElectron.x - wlocAtom.x,
								     wlocElectron.y - wlocAtom.y ).normalize();
			electron.setVelocity(direction);

			if (electrons.length == 0){
				player.navigateSelectionTowards(new Vec2(direction.x,direction.y));
				setPlayer(null);				
			}
			
			selectElectron(getNextElectron(electron));
			SoundEffect.play( 'electron_fire' );
		}
		else
		{
			SoundEffect.play( 'electron_fire_deny' );
		}
	}

	function update() {
		
		if( Game.active.paused ) return;

		object.transform.rotate(new Vec4(0, 0, 1), rotationSpeed);

		for (electron in electrons) {
			electron.update();
		}

		if (Game.active.time - lastIntervalledSpawn >= spawnTime) {			
			lastIntervalledSpawn = Game.active.time;
			
			var spawnerCount = electrons.filter((e:Electron) -> return e.feature == Electron.Feature.Spawner).length;
			var num = Std.int(Math.min(numSlots - electrons.length, spawnerCount));				
			//trace('we have ' + electrons.length + ' electrons, but only ' + spawnerCount + ' are spanners');

			if (num > 0){
				//trace('time for auto spawn of ' + num + ' electrons');
				spawnElectrons([Electron.Feature.None]);
			}
		}
	}

	public function select() {		
		/* if (marker != null) {
			// marker.object.visible = true;

			marker.show();
			// Twwen.to;
			// trace(marker.materials.length);
		} */
	}

	public function deselect() {		
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

	public function spawnElectrons(  features : Array<Electron.Feature>, ?cb: Array<Electron> -> Void) {		
		//var numSpawned = 0;
		var spawned = new Array<Electron>();
		function spawnNext() {			
			spawnElectron( features[spawned.length], e -> {
				spawned.push( e );
				if (spawned.length == features.length )	{
					player.addToScore(Score.spawned);
					if (cb != null) { cb( spawned ); }
				} else{
					spawnNext();
				}
			});
		}
		spawnNext();
	}

	public function spawnElectron(feature : Electron.Feature, ?cb:Electron->Void) {
		Scene.active.spawnObject('Electron', object, obj -> {	
			var electron = new Electron(player, feature);
			electron.notifyOnInit(()-> {
				electron.setAtom(this, getFirstFreeElectronIndex());		
				var pos = getElectronPosition(electron);
				var direction = new Vec4(pos.x,pos.y,0,1).normalize();
				electron.setPostion(pos);
				electron.setDirection(direction);
				if (electrons.length == 0) {selectElectron(electron);}
				electrons.push(electron);
				if (cb != null) cb( electron );
			});
			obj.addTrait(electron);
		});			
		// trace('added elektron at position' + pos);
	}

	public function selectPreviousElectron(){
		if (electrons.length>0){
			if (rotationSpeed<0){
				selectElectron(getNextElectron(selectedElectron));
			}
			else{
				selectElectron(getPreviousElectron(selectedElectron));
			}
		}
		else{
			selectElectron(null);
		}
	}

	public function selectNextElectron(){
		if (electrons.length>0){
			if (rotationSpeed>0){
				selectElectron(getNextElectron(selectedElectron));
			}
			else{
				selectElectron(getPreviousElectron(selectedElectron));
			}			
		}
		else{
			selectElectron(null);
		}
	}


	private function getNextElectron(electron:Electron) : Electron{				
		trace('getNextElectron for index ' + electron.position);
		if (electrons.length == 0){			
			return null;
		}
		else if (electrons.length == 1){			
			return electrons[0];
		}
		else {
			var index = electron.position;			
			do{
				index++;
				if (index>numSlots) {index=0;}
				for (e in electrons) {if (e.position == index) return e;}
			}
			while(true);
		}		
	}

	private function getPreviousElectron(electron:Electron) : Electron{		
		trace('getPreviousElectron for index ' + electron.position);
		if (electrons.length == 0){
			return null;
		}
		else if (electrons.length == 1){
			return electrons[0];
		}
		else {
			var index = electron.position;
			do{
				index--;
				if (index<0) {index=numSlots;}
				for (e in electrons) {if (e.position == index) return e;}
			}
			while(true);
		}		
	}

	private function selectElectron(electron:Electron){
		
		var loc = new Vec4();
		var rot = new Quat();
		selectedElectron = electron;		

		if (electron != null){
			loc = electron.object.transform.loc;			
			rot = electron.object.transform.rot;
			trace('change selection to electron at ' + loc + ' with rot=' + rot);
		}
		else{
			trace('change selection to null ' + electron);
		}
			

		Tween.to({			
			props: {x: loc.x, y: loc.y, z: loc.z},
			duration: 0.5,
			target: marker.object.transform.loc,
			ease: Ease.QuartOut,
			tick: () -> {
				object.transform.buildMatrix();
			},
			done: () -> {
			}
		});

		Tween.to({			
			props: {x: rot.x, y: rot.y, z: rot.z, w: rot.w},
			duration: 0.5,
			target: marker.object.transform.rot,
			ease: Ease.QuartOut,
			tick: () -> {
				object.transform.buildMatrix();
			},
			done: () -> {
			}
		});
	}

	private function getFirstFreeElectronIndex(): Null<Int> {			
		for (i in 0...numSlots ){
			var isFree=true;
			for (electron in electrons){
				if (electron.position == i){
					isFree=false;
					break;
				}
			}
			if (isFree){
				return i;
			}
		}
		return null;	 
	}

	private function getElectronPosition(electron:Electron) :Vec2{
		var angle = 2 * Math.PI * electron.position / numSlots;
		if (rotationSpeed < 0) { angle=-angle; }
		var orbitRadius = mesh.transform.dim.x/2 + electron.mesh.transform.dim.x*2;
		return new Vec2(orbitRadius * Math.sin(angle), orbitRadius * Math.cos(angle));
	}

}
