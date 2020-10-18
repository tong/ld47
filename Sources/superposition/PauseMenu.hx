package superposition;

import superposition.Game;
import zui.*;
import zui.Themes;

class PauseMenu extends Trait {

	var ui : Zui;

	public function new() {
		super();
		notifyOnInit( () -> {
			var theme : TTheme = Reflect.copy( UI.THEME );
			//theme.BUTTON_TEXT_COL = 0xff00ff00;
			//theme.FILL_WINDOW_BG = false;
			//theme.FILL_BUTTON_BG = false;
			ui = new Zui( { font : UI.fontTitle, theme: theme } );
			notifyOnUpdate( update );
			notifyOnRender2D( render );
		});
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

	function render( g : kha.graphics2.Graphics ) {
		if( !Game.active.paused )
			return;
        var sw = System.windowWidth(), sh = System.windowHeight();
        g.end();
		g.opacity = 1;
		ui.begin( g );
		if( ui.window( Id.handle(), 32, 32, 400, 400, false ) ) {
			if( ui.button( 'RESUME', Left ) ) Game.active.resume();
			/* if( ui.button( 'RESTART', Left ) ) {
				//Game.active.abort();
				//Game.active.create();
			} */
            if( ui.button( 'EXIT', Left ) ) Scene.setActive( 'Mainmenu' );
            if( ui.button( 'QUIT', Left ) ) Scene.setActive( 'Quit' );
		}
		ui.end();
        g.begin( false );
	}
}