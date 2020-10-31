package superposition.ui;

import superposition.Game;
import zui.*;
import zui.Themes;

class PauseMenu extends Menu {

	public function new() {
		super();
		notifyOnUpdate( update );
	}

	function update() {
		var kb = Input.getKeyboard();
		if( kb.started("escape") ) {
			Game.active.paused ? Game.active.resume() : Game.active.pause();
		}
		for (i in 0...4) {
			var gp = Input.getGamepad(i);
			if (gp.started('start')) {
				Game.active.paused ? Game.active.resume() : Game.active.pause();
			}
		}
	}

	override function render( g : kha.graphics2.Graphics ) {
		if( !Game.active.paused )
			return;
		super.render( g );
	}

	override function renderUI( g : kha.graphics2.Graphics ) {
		if( ui.window( Id.handle(), 32, 32, 400, 400, false ) ) {
			if( ui.button( 'RESUME', Left ) ) Game.active.resume();
			/* if( ui.button( 'RESTART', Left ) ) {
				//Game.active.abort();
				//Game.active.create();
			} */
            if( ui.button( 'EXIT', Left ) ) Scene.setActive( 'Mainmenu' );
            if( ui.button( 'QUIT', Left ) ) Scene.setActive( 'Quit' );
		}
	}
}