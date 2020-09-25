package ld47;

class Boot extends Trait {

	@prop
	public var scene : String = "Mainmenu";

	public function new() {
		super();
		notifyOnInit( () -> {

            Log.info( Main.projectName+' '+Main.projectVersion );
            Log.info( 'Boot' );

            ld47.UI.init( () -> {
           
                Input.init();
                
                var keyboard = Input.keyboard;
                var mouse = Input.mouse;
                var gamepad = Input.gamepads[0];
    
                Data.getImage( 'boot.png', img -> {
    
                    notifyOnUpdate( () -> {
                        if( keyboard.started( Space ) || keyboard.started( Return )
                            || mouse.left.started
                        || gamepad.started("a") ) {
                            proceed();
                        }
                    });
    
                    notifyOnRender2D( (g) -> {
                        final sw = System.windowWidth();
                        final sh = System.windowHeight();
                        g.end();
                        g.color = 0xff000000;
                        g.fillRect( 0, 0, sw, sh );
                        g.color = 0xffffffff;
                        g.drawImage( img, sw/2 - img.width/2, sh/2 - img.height/2 );
                        g.begin( false );
                    });

                    Tween.timer( 0.5, () -> {
                        proceed();
                        /* Data.getSound( 'boot.wav', s -> {
                            var channel = Audio.play( s, false, true );
                        }); */
                    });
                });
            });
		});
	}

    function proceed() {
        Scene.setActive( scene );
    }
}
