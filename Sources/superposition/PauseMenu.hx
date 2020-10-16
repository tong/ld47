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
		final kb = Input.getKeyboard();
		if( kb.started("escape") ) {
			if( Game.active.paused ) {
				Game.active.resume();
			} else {
				Game.active.pause();
			}
		}
		for (i in 0...4) {
			final gp = Input.getGamepad(i);
			if (gp.started('start')) {
				if( Game.active.paused ) {
					Game.active.resume();
				} else {
					Game.active.pause();
				}
			}
		}
	}

	function render( g : kha.graphics2.Graphics ) {
		if( !Game.active.paused )
			return;
		final game = Game.active;
        final sw = System.windowWidth();
		final sh = System.windowHeight();
        g.end();
		g.opacity = 1;
		ui.begin( g );
		if( ui.window( Id.handle(), 32, 32, sw-64, sh-64, false ) ) {
			if( ui.button( 'RESUME', Left ) ) {
				game.resume();
            }
			/* if( ui.button( 'RESTART', Left ) ) {
				game.start();
			} */
            if( ui.button( 'EXIT', Left ) ) {
				Game.active.abort();
			}
		}
		ui.end();
        g.begin( false );
	}
}