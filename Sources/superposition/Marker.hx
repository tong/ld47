package superposition;

class Marker extends Trait {
	
	public var mesh(default,null) : MeshObject;
	public var light(default,null) : LightObject;
	
	public function new() {
		super();
		notifyOnInit(() -> {
			mesh = cast object.getChild('ElectronMarkerMesh');
			object.transform.loc.set(0,0,0);
			object.transform.buildMatrix();
			//light = cast object.getChild('ElectronMarkerLight');
			//trace(light);
		});
	}

	public function show() {
		//trace("SHOW MARKER");
		if( mesh != null ) mesh.visible = true;
		//object.visible = true;
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
		//trace("HIDE MARKER");
		if( mesh != null ) mesh.visible = false;
		//object.visible = false;
	}
}