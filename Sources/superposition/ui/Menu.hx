package superposition.ui;

import zui.*;
import zui.Themes;

class Menu extends Trait {

    var ui : Zui;

	function new() {
		super();
		notifyOnInit( () -> {
			var theme : TTheme = Reflect.copy( UI.THEME );
			ui = new Zui( { font : UI.fontTitle, theme: theme } );
			notifyOnRender2D( render );
		});
	}

	function render( g : kha.graphics2.Graphics ) {
        g.end();
		g.opacity = 1;
		ui.begin( g );
		renderUI( g );
		ui.end();
        g.begin( false );
    }

    function renderUI( g : kha.graphics2.Graphics ) {
    }
}