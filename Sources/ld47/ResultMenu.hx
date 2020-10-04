package ld47;

import zui.*;
import zui.Themes;

class ResultMenu extends Trait {

	var ui : Zui;

	public function new() {
		super();
		notifyOnInit(() -> {
			var theme:TTheme = Reflect.copy(UI.THEME);
			// theme.BUTTON_TEXT_COL = 0xff00ff00;
			// theme.FILL_WINDOW_BG = false;
			// theme.FILL_BUTTON_BG = true;
			ui = new Zui({font: UI.fontTitle, theme: theme});
			Event.add('game_end', handleGameEnd);
			/*
				notifyOnRemove( () -> {
					Event.remove( 'game_end' );
				});
			 */
		});
	}

	function handleGameEnd() {
		notifyOnRender2D(render);
	}

	function render(g:kha.graphics2.Graphics) {
		final game = Game.active;
		final sw = System.windowWidth();
		final sh = System.windowHeight();
		g.end();
		g.opacity = 1;
		ui.begin(g);
		if (ui.window(Id.handle(), 0, 0, sw, sh, false)) {
			ui.text('RESULT ', Left);
			//ui.text('DURATION '+, Left);
			/* for (i in 0...game.players.length) {
				var player = game.players[i];
				ui.text('P' + (i + 1), Left);
				ui.text('SPAWNED ELECTRONS ' + player.score.spawnedElectrons, Left);
				ui.text('SHOTS FIRED ' + player.score.shotsFired, Left);
			} */

			/*   if( ui.button( 'RESTART', Left ) ) {
				//game.restart();
			}*/
			if (ui.button('MAINMENU', Left)) {
				Scene.setActive('Mainmenu');
			}
		}
		ui.end();
		g.begin(false);
	}
}
