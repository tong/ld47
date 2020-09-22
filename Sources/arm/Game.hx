package arm;

class Game extends Trait {

	public static var active(default,null) : Game;

	public var time : Float;

	var timeStart : Float;

	public function new() {
		super();
		Game.active = this;
		notifyOnInit( () -> {

			Log.info( 'Game' );

			Input.init();

			time = 0;
			timeStart = Time.time();
			
			notifyOnUpdate( update );
        });
	}

	function update() {

		var now = Time.time();
		time = now - timeStart;

		var keyboard = Input.keyboard;
        var mouse = Input.mouse;
		var gamepad = Input.gamepads[0];

		if( keyboard.started( Escape ) ) {
			Scene.setActive( "Title" );
		}
	}
}
