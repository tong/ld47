package ld47;

class Game extends Trait {

	public static var active(default,null) : Game;

	public var time : Float;
	public var paused(default,null) = false;

	var timeStart : Null<Float>;
	var timePauseStart : Float;

	public function new() {
		super();
		Game.active = this;
		notifyOnInit( () -> {
			Log.info( 'Game' );
			//Input.init();
			notifyOnUpdate( update );
        });
	}

	public function start() {
		time = 0;
		timeStart = Time.time();
		Event.send( 'game_start' );
	}

	public function pause() {
		if( !paused ) {
			paused = true;
			timePauseStart = Time.time();
			Event.send( 'game_pause' );
		}
	}
	
	public function resume() {
		if( paused ) {
			paused = false;
			timeStart += time - timePauseStart;
			timePauseStart = null;
			Event.send( 'game_pause' );
		}
	}

	public function end() {
		Event.send( 'game_end' );
		Scene.setActive( "Title" );
	}

	function update() {
		if( paused ) {

		} else {
			var now = Time.time();
			time = now - timeStart;
			if( Input.keyboard.started( Escape ) ) {
				pause();
			}
		}
	}
}
