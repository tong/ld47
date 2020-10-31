package superposition.ui;

import superposition.Game;
import zui.*;
import zui.Themes;

class Menu extends Trait {

    var ui : Zui;

	public function new() {
		super();
		notifyOnInit( () -> {
			var theme : TTheme = Reflect.copy( UI.THEME );
			//theme.BUTTON_TEXT_COL = 0xff00ff00;
			//theme.FILL_WINDOW_BG = false;
			//theme.FILL_BUTTON_BG = false;
			ui = new Zui( { font : UI.fontTitle, theme: theme } );
			//notifyOnUpdate( update );
			notifyOnRender2D( render );
		});
	}

	/*
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
	*/

	function render( g : kha.graphics2.Graphics ) {
        g.end();
		g.opacity = 1;
		ui.begin( g );
		renderUI( g );
		ui.end();
        g.begin( false );
    }

    function renderUI( g : kha.graphics2.Graphics ) {
        /* if( ui.window( Id.handle(), sw-200, 32, 200, 400, false ) ) {
			if( ui.button( 'SEND', Left ) ) {
                trace('Submit user feedback');
                System.loadUrl( 'http://disktree.net' );
            }
		} */
    }
}