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
		var keyboard = Input.getKeyboard();
		notifyOnUpdate(() -> {
			if (keyboard.started('escape')) {
				Scene.setActive('Mainmenu');
			}
		});
	}
}
