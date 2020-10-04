package ld47;

import zui.*;
import zui.Themes;

class Mainmenu extends Trait {

	static var THEME : TTheme = cast {
		NAME: "LevelSelectMenu",
		ACCENT_COL: 0xff444444,
		ACCENT_HOVER_COL: 0xff494949,
		ACCENT_SELECT_COL: 0xff606060,
		ARROW_SIZE: 5,
		BUTTON_H: 40,
		BUTTON_COL: 0xff000000,
		BUTTON_HOVER_COL: 0xff000000,
		BUTTON_PRESSED_COL: 0xff000000,
		BUTTON_TEXT_COL: 0xffffffff,
		CHECK_SELECT_SIZE: 8,
		CHECK_SIZE: 15,
		CONTEXT_COL: 0xff222222,
		ELEMENT_H: 68,
		ELEMENT_OFFSET: 0,
		ELEMENT_W: 100,
		FILL_ACCENT_BG: false,
		FILL_BUTTON_BG: false,
		FILL_WINDOW_BG: false,
		FONT_SIZE: 60,
		HIGHLIGHT_COL: 0xff205d9c,
		LABEL_COL: 0xffc8c8c8,
		LINK_STYLE: Line,
		PANEL_BG_COL: 0xff3b3b3b,
		SCROLL_W: 6,
		SEPARATOR_COL: 0xff272727,
		TAB_W: 6,
		TEXT_COL: 0xffe8e7e5,
		TEXT_OFFSET: 8,
		WINDOW_BG_COL: 0xff000000,
		WINDOW_TINT_COL: 0xffffffff,
	};

	var sound : AudioChannel;
	var ui : Zui;
	var players : Array<Bool>;

	public function new() {
		super();
		notifyOnInit( () -> {

			Log.info( 'Title' );
			
			players = [for(i in 0...4)false];
			
			final sw = System.windowWidth();
			final sh = System.windowHeight();
			final uw = 600;
			final uh = 600;
			final fontSize = 32;

			Data.getImage( 'title.png', img -> {
				Data.getFont( "helvetica_neue_85.ttf", font -> {
					ui = new Zui( { font : font, theme: THEME } );
					notifyOnRender2D( g -> {

						g.end();

						//g.color = 0xff000000;
						//g.fillRect( 0, 0, sw, sh );
						//g.color = 0xffffffff;
						//g.drawImage( img, sw/2 - img.width/2, sh/2 - img.height/2 );
						
						/*
						final textWidth = font.width( fontSize, 'PLAY' ) ;
						ui.begin( g );
						if( ui.window( Id.handle(), Std.int(sw/2-uw/2), Std.int(sh/2-uh/2), uw, uh, false ) ) {
							if( ui.button( 'PLAY', Left ) ) {
								Scene.setActive( 'Game' );
							}
						}
						ui.end();
						*/

						//g.color = 0xff000000;
						//g.fillRect( 0, 0, sw, sh );

						//final textWidth = font.width( fontSize, 'PLAY' ) ;
						//trace(textWidth);

						ui.begin( g );
						g.opacity = 1;
						if( ui.window( Id.handle(), 32, 32, uw, uh, false ) ) {
							
							ui.row( [ 1/4, 1/4, 1/4, 1/4 ]);
							players[0] = ui.check(Id.handle( { selected: true } ), "P1");
							players[1] = ui.check(Id.handle( { selected: true } ), "P2");
							players[2] = ui.check(Id.handle( { selected: false } ), "P3");
							players[3] = ui.check(Id.handle( { selected: false } ), "P4");
							
							if( ui.button( 'PLAY', Left ) ) {
								loadGame();
							}
							if( ui.button( 'QUIT', Left ) ) {
								Scene.setActive( 'Quit' );
							}
						}
						ui.end();
						//g.color = 0xffffffff;
						//g.drawImage( img, sw/2 - img.width/2, 140 );
						g.begin( false );
					});
				});
			});

			notifyOnUpdate( update );

			/*
			#if ld47_release
			Data.getSound( 'mainmenu_ambient.ogg', s -> {
				sound = Audio.play( s );
			});
			#end
			*/
		});
	}

	function update() {
		var keyboard = Input.getKeyboard();
		if( keyboard.started( "escape" ) ) {
			Scene.setActive( 'Quit' );
			return;
		}
		for( i in 0...4 ) {
			var gp = Input.getGamepad(i);
			if( gp.started( 'cross' ) ) {
				
			}
			if( gp.started( 'options' ) ) {
				loadGame();
				return;
			}
		}
	}

	function loadGame() {
		if( sound != null ) sound.stop();
		
		var numPlayers = 0;
		for( p in players ) if(p) numPlayers++;

		Scene.setActive( 'Game' );
		var game = new Game( numPlayers );
		Scene.active.root.addTrait( game );
	}

}
