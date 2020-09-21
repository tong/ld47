package arm.scene;

class Title extends Trait {

	var sound : AudioChannel;

	public function new() {
		super();
		notifyOnInit( () -> {

            trace("Title");
			tron.Log.info( 'Title' );

			Input.init();
            
            var keyboard = Input.keyboard;
            var mouse = Input.mouse;
            var gamepad = Input.gamepads[0];

			Data.getSound( 'title.ogg', s -> {
				var sound = Audio.play( s, false, true );
				notifyOnUpdate( () -> {
					if( keyboard.started( Space ) || keyboard.started( Return )
						|| mouse.left.started
						|| gamepad.started("a") ) {
						sound.stop();
						Scene.setActive( 'Game' );
					}
				});
			});
        });
	}

}
