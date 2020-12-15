package superposition;

import zui.*;

class Credits extends Trait {

    var ui : Zui;
    var sound : AudioChannel;

	public function new() {
        super();
        Log.info( 'Credits' );
        SoundEffect.play( 'game_ambient_1', true, true, 0.0, s -> {
            sound = s;
            Tween.to( { target: sound, props: { volume: 0.9 }, delay: 0.1, duration: 1.0 } );
        } );
        ui = new Zui( { font : UI.fontTitle, theme: UI.THEME } );
        notifyOnRender2D( g -> {
            var sw = System.windowWidth(), sh = System.windowHeight();
            g.end();
            ui.begin( g );
            if( ui.window( Id.handle(), 32, 32, sw-64, sh-64, false ) ) {
                if( ui.button( 'Developed by shadow & tong at disktree.net'.toUpperCase(), Left ) ) {
                    System.loadUrl('https://disktree.net/');
                }
                if( ui.button( 'Sound by stritter.audio'.toUpperCase(), Left ) ) {
                    System.loadUrl('https://stritter.audio/');
                }
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
