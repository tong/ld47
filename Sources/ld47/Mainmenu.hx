package ld47;

import ld47.Game.MapData;
import ld47.Game.PlayerData;
import zui.*;
import zui.Themes;
class Mainmenu extends Trait {

	static var playerData : Array<PlayerData>;	

	var ui : Zui;
	var sound : AudioChannel;

	public function new() {
		super();
		notifyOnInit( () -> {

			Log.info( 'Mainmenu' );
			
			if( playerData == null ) playerData = [for(i in 0...4) {
					name: 'P'+(i+1),
					enabled: i < 2,
					color: Player.COLORS[i]
				}];

			ui = new Zui( { font : UI.fontTitle, theme: UI.THEME } );
			notifyOnUpdate( update );
			notifyOnRender2D( render2D );
			
			//#if ld47_release
			//SoundEffect.play( 'game_ambient_2', true, true, 0.9, s -> sound = s );
			//#end 
		});
	}

	function update() {
		final kb = Input.getKeyboard();
		if( kb.started( "escape" ) ) {
			Scene.setActive( 'Quit' );
			return;
		}
		if( kb.started( "c" ) ) {
			Scene.setActive( 'Credits' );
			return;
		}
		if( kb.started( "enter" ) ) {
			loadGame();
			return;
		}
		for( i in 0...4 ) {
			var gp = Input.getGamepad(i);
			if( gp.started( 'cross' ) ) {
				loadGame();
				return;
			}
			if( gp.started( 'share' ) ) {
				Scene.setActive( 'Quit' );
				return;
			}
		}
	}

	function render2D( g : kha.graphics2.Graphics ) {

		final sw = System.windowWidth();
		final sh = System.windowHeight();
		final colorEnabled = 0xffffffff;
		final colorDisabled = 0xff505050;
		
		g.end();
		
		ui.begin( g );
		g.opacity = 1;
		if( ui.window( Id.handle(), 16, 16, sw, sh, false ) ) {
			
			//ui.ops.theme.FONT_SIZE = 120;
			ui.text('SUPERPOSITION');
			
			ui.row( [ 1/20, 1/20, 1/20, 1/20 ]);
			
			ui.ops.theme.BUTTON_TEXT_COL = playerData[0].enabled ? playerData[0].color : colorDisabled;
			if( ui.button( playerData[0].name, Left ) ) playerData[0].enabled = !playerData[0].enabled;
			
			ui.ops.theme.BUTTON_TEXT_COL = playerData[1].enabled ? playerData[1].color : colorDisabled;
			//g.opacity = 1.0;
			if( ui.button( playerData[1].name, Left ) ) playerData[1].enabled = !playerData[1].enabled;
			
			ui.ops.theme.BUTTON_TEXT_COL = playerData[2].enabled ? playerData[2].color : colorDisabled;
			if( ui.button( playerData[2].name, Left ) ) playerData[2].enabled = !playerData[2].enabled;
			
			ui.ops.theme.BUTTON_TEXT_COL = playerData[3].enabled ? playerData[3].color : colorDisabled;
			if( ui.button( playerData[3].name, Left ) ) playerData[3].enabled = !playerData[3].enabled;
			
			ui.ops.theme.BUTTON_TEXT_COL = colorEnabled;
			
			final canPlay = playerData.filter( p -> return p.enabled ).length >= 2;
			if( !canPlay ) ui.ops.theme.BUTTON_TEXT_COL = colorDisabled;
			if( ui.button( 'PLAY', Left ) ) loadGame();
			ui.ops.theme.BUTTON_TEXT_COL = colorEnabled;
			if( ui.button( 'QUIT', Left ) ) Scene.setActive( 'Quit' );
		}
		ui.end();

		g.color = colorEnabled;
		g.font = UI.font;
		g.fontSize = Std.int(UI.fontSize*0.8);
		final text = 'v'+Main.projectVersion;
		final textWidth = UI.font.width( g.fontSize, text );
		g.drawString( text, sw-(textWidth + (g.fontSize*1.2)), sh-(g.fontSize*2) ); 
		
		g.begin( false );
	}

	function loadGame() {
		if( sound != null ) sound.stop();
		final numPlayers = playerData.filter( p -> return p.enabled ).length;
		if( numPlayers >= 2 ) {
			final maps = MapStore.MAPS[numPlayers];
			final mapData = maps[Std.int(maps.length*Math.random())];
			Scene.setActive( 'Game' );
			final game = new Game( playerData, mapData );
			Scene.active.root.addTrait( game );
		}
	}

}
