package superposition.trait;

class RotateObject extends Trait {
	
	@prop
	public var axis = new Vec4(0,0,0,1);

	@prop
	public var speed = 0.01;
	
	public function new() {
		super();
		notifyOnInit( () -> {
			notifyOnUpdate( update );
		});
	}
	
	function update() {
		object.transform.rotate( axis, speed );
	}
}
