package superposition;

import superposition.Game;
import superposition.UI.*;
import zui.*;
import zui.Themes;

class Mainmenu extends Trait {
	
	//static var playerData : Array<PlayerData> = [for(i in 0...4) { name: 'P'+(i+1), enabled: i < 2, color: Player.COLORS[i] }];
	static var playerData : Array<PlayerData> = [for(i in 0...4) { name: 'P'+(i+1), enabled: false, color: Player.COLORS[i] }];
	static var selectedMap = 0;
	//static var sound : AudioChannel;

	var ui : Zui;

	public function new() {
		super();
		Log.info( 'Mainmenu' );
		notifyOnInit( () -> {
			var theme : TTheme = Reflect.copy( UI.THEME );
			ui = new Zui( { font : UI.fontTitle, theme: theme } );
			//ui.alwaysRedraw = true;
			notifyOnUpdate( update );
			notifyOnRender2D( render2D );
			notifyOnRemove( () -> {
				/* if( sound != null ) {
					sound.pause();
					sound.volume = 0;
				} */
			});
			/* if( sound == null ) {
				var ts = Time.realTime ();
				SoundEffect.play( 'game_ambient_1', true, false, 0.0, s -> {
					trace(Time.realTime ()-ts);
					sound = s;
					sound.fadeIn( 1.0, 0.5 );
				});
			} else {
				sound.fadeIn( 1.0, 0.5 ).play();
			} */
		});
	}

	function update() {
		var kb = Input.getKeyboard();
		if( kb.started( "escape" ) ) Scene.setActive('Quit');
		if( kb.started( "c" ) ) Scene.setActive('Credits');
		for( i in 0...4 ) {
			var gp = Input.getGamepad(i);
			if( gp.started( 'home' ) ) Scene.setActive('Quit');
			if( gp.started( 'start' ) ) loadGame();
			if( gp.started( 'a' ) ) playerData[i].enabled = !playerData[i].enabled;
		}
	}

	function render2D( g : kha.graphics2.Graphics ) {

		if( ui == null ) return;

		var sw = System.windowWidth(), sh = System.windowHeight();
		var numPlayers = playerData.filter( p -> return p.enabled ).length;
		
		g.end();
		ui.begin( g );
		//ui.beginRegion( g );
		g.opacity = 1;

		var hwin = Id.handle();
		hwin.redraws = 1;

		if( ui.window( hwin, 32, 32, sw-64, sh-64, false ) ) {

			ui.ops.theme.TEXT_COL = COLOR_ENABLED;
			ui.text('SUPERPOSITION');
			
			ui.row( [ -90, -90, -90, -90 ]);
			
			ui.ops.theme.BUTTON_TEXT_COL = playerData[0].enabled ? playerData[0].color : COLOR_DISABLED;
			if( ui.button( playerData[0].name, Left ) ) playerData[0].enabled = !playerData[0].enabled;
			
			ui.ops.theme.BUTTON_TEXT_COL = playerData[1].enabled ? playerData[1].color : COLOR_DISABLED;
			if( ui.button( playerData[1].name, Left ) ) playerData[1].enabled = !playerData[1].enabled;
			
			ui.ops.theme.BUTTON_TEXT_COL = playerData[2].enabled ? playerData[2].color : COLOR_DISABLED;
			if( ui.button( playerData[2].name, Left ) ) playerData[2].enabled = !playerData[2].enabled;
			
			ui.ops.theme.BUTTON_TEXT_COL = playerData[3].enabled ? playerData[3].color : COLOR_DISABLED;
			if( ui.button( playerData[3].name, Left ) ) playerData[3].enabled = !playerData[3].enabled;
			
			switch numPlayers {
			case 0: ui.text( 'NO ACTIVE PLAYERS' );
			case 1: ui.text( 'REQUIRES 2 PLAYERS' );
			default:
				var maps = MapStore.MAPS.get( numPlayers );
				for( i in 0...maps.length ) {
					ui.ops.theme.BUTTON_TEXT_COL = ( i == selectedMap ) ? COLOR_ENABLED : COLOR_DISABLED;
					if( ui.button( 'M$i', Left ) ) selectedMap = i;
				}
			}
			
			/*
			var hcombo = Id.handle();
			selectedMap = ui.combo( hcombo, [for(i in 0...maps.length) '$i'], 'MAP' );
			if (hcombo.changed) {
				//trace('CHANGED');
			}
			*/
			
			ui.row( [-180,-180,-180]);

			var canPlay = playerData.filter( p -> return p.enabled ).length >= 2;
			ui.ops.theme.BUTTON_TEXT_COL = canPlay ? COLOR_ENABLED : COLOR_DISABLED;
			if( ui.button( 'PLAY', Left ) ) loadGame();

			ui.ops.theme.BUTTON_TEXT_COL = COLOR_ENABLED;
			//if( ui.button( 'SETTINGS', Left ) ) Scene.setActive( 'Settings' );
			if( ui.button( 'HELP', Left ) ) Scene.setActive( 'Help' );
			//if( ui.button( 'CREDITS', Left ) ) Scene.setActive( 'Credits' );
			if( ui.button( 'QUIT', Left ) ) Scene.setActive( 'Quit' );
		}
		ui.end();

		g.color = COLOR_ENABLED;
		g.font = UI.font;
		g.fontSize = Std.int(UI.fontSize*0.8);
		var text = 'v'+Main.projectVersion;
		var textWidth = UI.font.width( g.fontSize, text );
		g.drawString( text, sw-(textWidth + (g.fontSize*1.2)), sh-(g.fontSize*2) ); 
		
		g.begin( false );
	}

	function loadGame() {
		var playerData = Mainmenu.playerData.filter( p -> return p.enabled );
		if( playerData.length >= 2 ) {
			var availableMaps = MapStore.MAPS[playerData.length];
			var mapData = availableMaps[selectedMap];
			/* Scene.active.notifyOnInit( () -> {
				trace("Scene init");
			} ); */
			Scene.setActive( 'Game', obj -> {
				var game = obj.getTrait( superposition.Game );
				game.notifyOnInit( () -> {
					game.create( { players : playerData, map : mapData }, () -> {
						game.start();
					}); 
				});
			} );
		}
	}
	
}
