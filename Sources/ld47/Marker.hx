package ld47;

import iron.data.MaterialData;

class Marker extends Trait {
	public var color:Color = 0xffffffff;

	public function new() {
		super();
		notifyOnInit(() -> {
			Uniforms.externalVec3Links.push(vec3Link);
		});
	}

	public function show() {
		object.visible = true;
		/* object.transform.scale.x = object.transform.scale.y = object.transform.scale.z = 0.1;
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
		});*/

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
	}

	public function hide() {
		object.visible = false;
	}

	function vec3Link(object:Object, mat:MaterialData, link:String):Vec4 {
		if (link == "RGB" && object == this.object) {
			return new Vec4(color.R, color.G, color.B);
			/*
				if (player == null) {
					return defaultColor;
				} else {
					//var c:Color = player.color;
					//return new Vec4(c.R, c.G, c.B);
				}
			 */
		}
		return null;
	}
}
