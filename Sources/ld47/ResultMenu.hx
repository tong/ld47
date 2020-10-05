package ld47;

import zui.*;
import zui.Themes;

class ResultMenu extends Trait {

	var ui : Zui;

	public function new() {
		super();
		notifyOnInit(() -> {
			var theme:TTheme = Reflect.copy(UI.THEME_2);
			// theme.BUTTON_TEXT_COL = 0xff00ff00;
			// theme.FILL_WINDOW_BG = false;
			// theme.FILL_BUTTON_BG = true;
			theme.FONT_SIZE = 24;
			theme.ELEMENT_H = 26;
			ui = new Zui({font: UI.fontTitle, theme: theme});
			Event.add('game_end', handleGameEnd);
			/*
				notifyOnRemove( () -> {
					Event.remove( 'game_end' );
				});
			 */
			 //notifyOnRender2D(render);
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
		// g.color = 0xff000000;
		// g.fillRect( 0, 0, sw, sh );
		if (ui.window(Id.handle(), 0, 0, sw, sh, false)) {
			//ui.text('DURATION '+, Left);
			for (i in 0...game.players.length) {
				var player = game.players[i];
				ui.ops.theme.TEXT_COL = player.color;
				ui.text('P' + (i + 1), Left);
				//ui.ops.font = UI.font;
				ui.text('SPAWNED ELECTRONS ' + player.score.spawnedElectrons, Left);
				ui.text('SHOTS FIRED ' + player.score.shotsFired, Left);
				ui.text('SHOTS HIT ATOM ' + player.score.shotsHitAtom, Left);
				ui.text('SHOTS DESTROYED ' + player.score.shotsDestroyedByEnemyElectron, Left);
				ui.text('OWNERSHIP TAKEN ' + player.score.ownershipsTaken, Left);
				ui.text('OWNERSHIP LOST ' + player.score.ownershipsLost, Left);
			}
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
