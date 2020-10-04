package ld47;

import zui.*;
import zui.Themes;

class PauseMenu extends Trait {

	var ui : Zui;

	public function new() {
		super();
		notifyOnInit( () -> {
			var theme : TTheme = Reflect.copy( UI.THEME );
			//theme.BUTTON_TEXT_COL = 0xff00ff00;
			theme.FILL_WINDOW_BG = false;
			theme.FILL_BUTTON_BG = true;
			ui = new Zui( { font : UI.fontTitle, theme: theme } );
			Event.add( 'game_pause', handlePause );
			notifyOnRemove( () -> {
				Event.remove( 'game_pause' );
			});
		});
	}

	function handlePause() {
		if( Game.active.paused ) {
			notifyOnRender2D( render );
		} else {
			removeRender2D( render );
		}
	}

	function render( g : kha.graphics2.Graphics ) {
		final game = Game.active;
        final sw = System.windowWidth();
		final sh = System.windowHeight();
        g.end();
		g.opacity = 1;
		ui.begin( g );
		if( ui.window( Id.handle(), 0, 0, 400, 200, false ) ) {
			//ui.row( [ 1/2, 1/2 ]);
			if( ui.button( 'RESUME', Left ) ) {
				game.resume();
            }
			/* if( ui.button( 'RESTART', Left ) ) {
				game.start();
			} */
            if( ui.button( 'EXIT', Left ) ) {
				game.end();
			}
		}
		ui.end();
        g.begin( false );
	}
}
