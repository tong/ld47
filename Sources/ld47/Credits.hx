package ld47;

import zui.*;

class Credits extends Trait {

    var ui : Zui;
    var sound : AudioChannel;

	public function new() {
        super();
        Log.info( 'Credits' );
        SoundEffect.play( 'game_ambient_1', true, true, 1.0, s -> sound = s );
        ui = new Zui( { font : UI.fontTitle, theme: UI.THEME } );
        var sw : Int = null, sh : Int = null;
        notifyOnRender2D( g -> {
            sw = System.windowWidth();
		    sh = System.windowHeight();
            g.end();
            ui.begin( g );
            if( ui.window( Id.handle(), 32, 32, sw-64, sh-64, false ) ) {
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
        notifyOnRemove( () -> {
            if( sound != null ) sound.stop();
        });
    }
}
