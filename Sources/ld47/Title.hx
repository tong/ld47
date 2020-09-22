package ld47;

class Title extends Trait {

	//var sound : AudioChannel;

	public function new() {
		super();
		notifyOnInit( () -> {

			Log.info( 'Title' );

			Input.init();

			Data.getImage( 'title.png', img -> {

				notifyOnUpdate( update );

				notifyOnRender2D( g -> {
					final sw = System.windowWidth();
	            	final sh = System.windowHeight();
                    g.end();
                    g.color = 0xff000000;
                    g.fillRect( 0, 0, sw, sh );
                    g.color = 0xffffffff;
                    g.drawImage( img, sw/2 - img.width/2, sh/2 - img.height/2 );
                    g.begin( false );
				});
			});

			/* Tween.timer( 0.1, () -> {
                Data.getSound( 'title.wav', s -> {
                    var channel = Audio.play( s, false, true );
                });
            }); */
        });
	}

	function update() {

		var keyboard = Input.keyboard;
        var mouse = Input.mouse;
		var gamepad = Input.gamepads[0];

		if( keyboard.started( Escape ) ) {
			System.stop();
			return;
		}

		if( keyboard.started( Space ) || keyboard.started( Return )
			|| mouse.left.started
			|| gamepad.started("a") ) {
			//sound.stop();
			Scene.setActive( 'Game' );
		}
	}

}
