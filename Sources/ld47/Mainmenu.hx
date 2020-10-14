package ld47;

import ld47.Game;
import ld47.UI.*;
import zui.*;
import zui.Themes;

class Mainmenu extends Trait {

	static var playerData : Array<PlayerData> = [for(i in 0...4) {
		name: 'P'+(i+1),
		enabled: i < 2,
		color: Player.COLORS[i]
	}];

	var ui : Zui;
	var sound : AudioChannel;

	public function new() {
		super();
		notifyOnInit( () -> {
			Log.info( 'Mainmenu' );
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
		var gp : Gamepad = null;
		for( i in 0...4 ) {
			gp = Input.getGamepad(i);
			if( gp.started( 'start' ) ) {
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
		final numPlayers = playerData.filter( p -> return p.enabled ).length;
		
		g.end();
		
		ui.begin( g );
		g.opacity = 1;
		if( ui.window( Id.handle(), 16, 16, sw, sh, false ) ) {
			
			ui.text('SUPERPOSITION');
			
			ui.row( [ 1/20, 1/20, 1/20, 1/20 ]);
			
			ui.ops.theme.BUTTON_TEXT_COL = playerData[0].enabled ? playerData[0].color : COLOR_DISABLED;
			if( ui.button( playerData[0].name, Left ) ) playerData[0].enabled = !playerData[0].enabled;
			
			ui.ops.theme.BUTTON_TEXT_COL = playerData[1].enabled ? playerData[1].color : COLOR_DISABLED;
			if( ui.button( playerData[1].name, Left ) ) playerData[1].enabled = !playerData[1].enabled;
			
			ui.ops.theme.BUTTON_TEXT_COL = playerData[2].enabled ? playerData[2].color : COLOR_DISABLED;
			if( ui.button( playerData[2].name, Left ) ) playerData[2].enabled = !playerData[2].enabled;
			
			ui.ops.theme.BUTTON_TEXT_COL = playerData[3].enabled ? playerData[3].color : COLOR_DISABLED;
			if( ui.button( playerData[3].name, Left ) ) playerData[3].enabled = !playerData[3].enabled;
			
			/*
			var maps = MapStore.MAPS.get( numPlayers );
			var part = 1 / maps.length;
			//ui.row( [for(i in 0...maps.length) part] );
			for( map in maps ) {
				//trace(map);
				ui.button( map.name.toUpperCase(), Left );
			}
			*/
			
			//ui.row( [ 1/10, 1/10 ]);
			ui.ops.theme.BUTTON_TEXT_COL = COLOR_ENABLED;
			final canPlay = playerData.filter( p -> return p.enabled ).length >= 2;
			if( !canPlay ) ui.ops.theme.BUTTON_TEXT_COL = COLOR_DISABLED;
			if( ui.button( 'PLAY', Left ) ) loadGame();
			ui.ops.theme.BUTTON_TEXT_COL = COLOR_ENABLED;
			//if( ui.button( 'SETTINGS', Left ) ) Scene.setActive( 'Settings' );
			//if( ui.button( 'HELP', Left ) ) Scene.setActive( 'Help' );
			if( ui.button( 'CREDITS', Left ) ) Scene.setActive( 'Credits' );
			if( ui.button( 'QUIT', Left ) ) Scene.setActive( 'Quit' );
		}
		ui.end();

		g.color = COLOR_ENABLED;
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
