package ld47;

import kha.graphics2.Graphics;

class Credits extends Trait {

	public function new() {
		super();
		notifyOnInit( () -> {
            final sw = System.windowWidth();
            final sh = System.windowHeight();
            final keyboard = Input.getKeyboard();
            var text = "Developed by shadow & tong @ disktree.net";
            notifyOnUpdate( () -> {
                if( keyboard.started('escape') ) {
                    Scene.setActive( 'Mainmenu' );
                }
            });
            notifyOnRender2D( g -> {
                g.end();
                g.color = 0xff000000;
                g.fillRect( 0, 0, sw, sh );
                g.font = UI.font;
                g.fontSize = UI.fontSize;
                g.color = 0xffffffff;
                g.drawString( text, UI.fontSize, UI.fontSize ); 
                g.begin( false );
            });
		});
    }
    
}
