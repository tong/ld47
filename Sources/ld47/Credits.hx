package ld47;

import zui.*;

class Credits extends Trait {

    var ui : Zui;

	public function new() {
        super();
        Log.info( 'Credits' );
        ui = new Zui( { font : UI.fontTitle, theme: UI.THEME } );
        var sw : Int = null;
        var sh : Int = null;
        notifyOnRender2D( g -> {
            sw = System.windowWidth();
		    sh = System.windowHeight();
            g.end();
            ui.begin( g );
            if( ui.window( Id.handle(), 16, 16, sw, sh, false ) ) {
                ui.text( 'Developed by shadow & tong at disktree.net'.toUpperCase() );
                ui.text( 'Sound by fred'.toUpperCase() );
            }
            ui.end();
            g.begin(false);
        });
        var kb = Input.getKeyboard();
        var gp : Gamepad = null;
        notifyOnUpdate( () -> {
            if( kb.started('escape') ) {
                Scene.setActive( 'Mainmenu' );
                return;
            }
            for( i in 0...4 ) {
                gp = Input.getGamepad(i);
                if( gp.started( 'cross' ) ) {
                    Scene.setActive( 'Quit' );
                    return;
                }
            }
        });
    }
}
