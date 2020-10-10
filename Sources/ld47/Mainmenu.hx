package ld47;

import ld47.Game.MapData;
import ld47.Game.PlayerData;
import zui.*;
import zui.Themes;
class Mainmenu extends Trait {

	var ui : Zui;
	var sound : AudioChannel;
	var playerData : Array<PlayerData>;	

	public function new() {
		super();
		notifyOnInit( () -> {

			Log.info( 'Mainmenu' );
			
			playerData = [for(i in 0...4) {
				name: 'P'+(i+1),
				enabled: i < 2,
				color: Player.COLORS[i]
			}];

			ui = new Zui( { font : UI.fontTitle, theme: UI.THEME } );
			notifyOnUpdate( update );
			notifyOnRender2D( render2D );
			
			/* #if ld47_release
			Data.getSound( 'mainmenu_ambient.ogg', s -> {
				sound = Audio.play( s, true, true );
			});
			#end */
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
		var text = 'v'+Main.projectVersion;
		var textWidth = UI.font.width( g.fontSize, text );
		g.drawString( text, sw - (textWidth + g.fontSize/2), sh-(g.fontSize*1.5) ); 
		
		g.begin( false );
	}

	function loadGame() {
		if( sound != null ) sound.stop();
		final numEnabledPlayers = playerData.filter( p -> return p.enabled ).length;
		if( numEnabledPlayers >= 2 ) {
			var mapStore = new MapStore(numEnabledPlayers);
			var mapData = mapStore.getRandom();
			Scene.setActive( 'Game' );
			var game = new Game( playerData, mapData );
			Scene.active.root.addTrait( game );
		}
	}

}
