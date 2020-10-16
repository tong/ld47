package superposition;

import kha.graphics2.Graphics;
import zui.*;
import zui.Themes;
using zui.Ext;

class Help extends Trait {

	var ui:Zui;

	public function new() {
		super();
		Log.info( 'Help' );
		

		notifyOnInit(() -> {
			var theme : TTheme = Reflect.copy( UI.THEME_1 );
			//theme.BUTTON_TEXT_COL = 0xff00ff00;
			theme.FILL_WINDOW_BG = false;
			theme.FILL_BUTTON_BG = false;
			theme.FONT_SIZE = 13;
			ui = new Zui({font: UI.font, theme: theme});

			final sw = System.windowWidth();
			final sh = System.windowHeight();
			final keyboard = Input.getKeyboard();

			var text = "
## Controls

### Gamepad
* DPad: select atom
* L1: select next electron
* R1: select prev electron
* A: fire electron

### Keyboard
#### P1
* WASD: select atom
* Q: select prev electron
* E: select next electron
* F: fire electron
#### P2
* Arrows: select atom
* B: select prev electron
* N: select next electron
* M: fire electron";
			notifyOnUpdate(() -> {
				if (keyboard.started('escape')) {
					Scene.setActive('Mainmenu');
				}
			});
			notifyOnRender2D(g -> {
				g.end();
				/* ui.begin(g);
				if (ui.window(Id.handle(), 16, 16, sw, sh, false)) {
					ui.textArea( Id.handle( { text: text } ), Left );
				}
				/*  g.color = 0xff000000;
					g.fillRect( 0, 0, sw, sh );
					g.font = UI.font;
					g.fontSize = UI.fontSize;
					g.color = 0xffffffff;
					g.drawString( text, UI.fontSize, UI.fontSize ); * /

				ui.end(); */
				g.begin(false);
			});
		});
	}
}
