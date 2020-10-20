package superposition;

import zui.Id;
import zui.Themes;
import zui.Zui;

class ResultMenu extends Trait {

	//var status : GameStatus;
	var winner : Player;
	var ui : Zui;

	//public function new( status: GameStatus ) {
	public function new( winner : Player ) {
		super();
		this.winner = winner;
	//	this.status = status;
		notifyOnInit( () -> {
			var theme:TTheme = Reflect.copy(UI.THEME_2);
			// theme.BUTTON_TEXT_COL = 0xff00ff00;
			// theme.FILL_WINDOW_BG = false;
			// theme.FILL_BUTTON_BG = true;
			//theme.FONT_SIZE = 24;
			//theme.ELEMENT_H = 26;
			ui = new Zui({font: UI.fontTitle, theme: theme});
			notifyOnUpdate( update );
			notifyOnRender2D( render );
		});
		/* notifyOnRemove( () -> {
			removeRender2D( render );
		}); */
	}

	function update() {
		final kb = Input.getKeyboard();
		if( kb.started("enter") || kb.started("escape") || kb.started("space") ) {
			Scene.setActive( 'Mainmenu' );
			return;
		}
		var gp : Gamepad = null;
		for( i in 0...4 ) {
			gp = Input.getGamepad(i);
			if( gp.started( 'cross' ) ) {
				Scene.setActive('Mainmenu');
				return;
			}
		}
	}

	function render(g:kha.graphics2.Graphics) {
		var sw = System.windowWidth(), sh = System.windowHeight();
		g.end();
		g.opacity = 1;
		ui.begin(g);
		if (ui.window(Id.handle(), 32, 32, sw-64, sh-64, false)) {

			if( winner != null ) {
				ui.ops.theme.TEXT_COL = winner.color;
				ui.text( 'WINNER: '+winner.index  );
			} else {
				ui.text( 'NO WINNER'  );
			}

			for( player in Game.active.players ) {
				ui.ops.theme.TEXT_COL = player.color;
				ui.text('P' + (player.index+1) );
			}

			/*
			function printPlayer( player : Player ) {
				ui.ops.theme.TEXT_COL = player.color;
				ui.text('P' + (player.index+1), Left);
				// ui.text('SPAWNED ELECTRONS ' + player.score.spawnedElectrons, Left);
				// ui.text('SHOTS FIRED ' + player.score.shotsFired, Left);
				// ui.text('SHOTS HIT ATOM ' + player.score.shotsHitAtom, Left);
				// ui.text('SHOTS DESTROYED ' + player.score.shotsDestroyedByEnemyElectron, Left);
				// ui.text('OWNERSHIP TAKEN ' + player.score.ownershipsTaken, Left);
				// ui.text('OWNERSHIP LOST ' + player.score.ownershipsLost, Left);
			}
			if( status.hasWinner ) {
				var player = status.winner;
				//ui.ops.theme.TEXT_COL = player.color;
				//ui.text('WINNER', Left );
				ui.ops.theme.TEXT_COL = player.color;
				ui.text('P' + (player.index+1)+' WINNER', Left);
				//printPlayer( player );
				for (p in status.others ) printPlayer(p);
			} else {
				for (p in status.others ) printPlayer(p);
			}
			*/
			/* if (ui.button('RESTART', Left)) {
				remove();
				Game.active.create();
				return;
			} */
			if (ui.button('PROCEED', Left)) {
				Scene.setActive('Mainmenu');
			}
		}
		ui.end();
		g.begin(false);
	}
}
