package ld47;

import ld47.Game.MapData;
import ld47.Game.PlayerData;
import zui.*;
import zui.Themes;
class Mainmenu extends Trait {

	var sound : AudioChannel;
	var ui : Zui;
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
			
			/*
			#if ld47_release
			Data.getSound( 'mainmenu_ambient.ogg', s -> {
				sound = Audio.play( s, true, true );
			});
			#end
			*/
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
		
		g.end();
		
		//g.color = 0xff000000;
		//g.fillRect( 0, 0, sw, sh );
		
		ui.begin( g );
		g.opacity = 1;
		if( ui.window( Id.handle(), 16, 16, sw, sh, false ) ) {
			
			//ui.ops.theme.FONT_SIZE = 120;
			ui.text('SUPERPOSITION');
			
			ui.row( [ 1/20, 1/20, 1/20, 1/20 ]);
			
			//ui.ops.theme.TEXT_COL = playerData[0].color;
			//playerData[0].enabled = ui.check(Id.handle( { selected: playerData[0].enabled } ), playerData[0].name );
			ui.ops.theme.BUTTON_TEXT_COL = playerData[0].enabled ? playerData[0].color : 0xff505050;
			//ui.ops.theme.BUTTON_TEXT_COL =  playerData[0].color;
			//g.opacity = playerData[0].enabled ? 1.0 : 0.5;
			//g.opacity = 0.5;
			if( ui.button( playerData[0].name, Left ) ) playerData[0].enabled = !playerData[0].enabled;
			
			ui.ops.theme.BUTTON_TEXT_COL = playerData[1].enabled ? playerData[1].color : 0xff505050;
			//g.opacity = 1.0;
			if( ui.button( playerData[1].name, Left ) ) playerData[1].enabled = !playerData[1].enabled;
			
			ui.ops.theme.BUTTON_TEXT_COL = playerData[2].enabled ? playerData[2].color : 0xff505050;
			if( ui.button( playerData[2].name, Left ) ) playerData[2].enabled = !playerData[2].enabled;
			
			ui.ops.theme.BUTTON_TEXT_COL = playerData[3].enabled ? playerData[3].color : 0xff505050;
			if( ui.button( playerData[3].name, Left ) ) playerData[3].enabled = !playerData[3].enabled;
			
			ui.ops.theme.BUTTON_TEXT_COL = 0xffffffff;
			
			final canPlay = getNumEnabledPlayers() >= 2;
			if( !canPlay ) ui.ops.theme.BUTTON_TEXT_COL = 0xff999999;
			if( ui.button( 'PLAY', Left ) ) loadGame();
			ui.ops.theme.BUTTON_TEXT_COL = 0xffffffff;
			if( ui.button( 'QUIT', Left ) ) Scene.setActive( 'Quit' );
		}
		ui.end();

		g.color = 0xffffffff;
		g.font = UI.font;
		g.fontSize = Std.int(UI.fontSize*0.8);
		var text = 'v'+Main.projectVersion;
		var textWidth = UI.font.width( g.fontSize, text );
		g.drawString( text, sw - (textWidth + g.fontSize/2), sh-(g.fontSize*1.5) ); 
		
		g.begin( false );
	}

	function getNumEnabledPlayers() : Int {
		var n = 0;
		for( p in playerData ) if( p.enabled ) n++;
		return n;
	}

	function loadGame() {

		if( sound != null ) sound.stop();
		
		final numEnabledPlayers = getNumEnabledPlayers();
		if( numEnabledPlayers >= 2 ) {

			//TODO
			var mapData : MapData = {
				atoms: [
					{ slots: 16 },
					{ slots: 16 },
					{ slots: 16 },
					{ slots: 16 },
					{ slots: 8, player: 0, electrons: 2  },
					{ slots: 10, player: 0, electrons: 6, spawner: 1 },
					{ slots: 8, player: 1, electrons: 2  },
					{ slots: 10, player: 1, electrons: 6, spawner: 1 },
					// { slots: 8, player: 1, electrons: 2, spawner: 2 },
					// { slots: 16, player: 1, electrons: 6 },
					// { slots: 16 },
					// { slots: 16 },
					// { slots: 16 },
					// { slots: 16 },
				]
			}

			Scene.setActive( 'Game' );
			var game = new Game( playerData, mapData );
			Scene.active.root.addTrait( game );
		}
	}

}
