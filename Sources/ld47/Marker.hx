package ld47;

import iron.data.MaterialData;

class Marker extends Trait {
	public var color:Color = 0xffffffff;

	public function new(color = 0xffffffff) {
		super();
		this.color = color;
		notifyOnInit(() -> {
			object.transform.loc.set(0,0,0);
			object.transform.buildMatrix();
		});
	}

	public function show() {
		object.visible = true;
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
		object.visible = false;
	}
}
