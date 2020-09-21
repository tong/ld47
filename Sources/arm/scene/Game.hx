package arm.scene;

class Game extends Trait {

	public function new() {
		super();
		notifyOnInit( () -> {
            trace("Game");
			tron.Log.info( 'Game' );
        });
	}

}
