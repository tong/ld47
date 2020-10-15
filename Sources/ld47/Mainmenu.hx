package ld47;

import ld47.Game;
import ld47.UI.*;
import zui.*;
import zui.Themes;

class Mainmenu extends Trait {
	
	static var selectedMap = 0;
	static var playerData : Array<PlayerData> = [for(i in 0...4) {
		name: 'P'+(i+1),
		enabled: i < 2,
		color: Player.COLORS[i]
	}];

	static var sound : AudioChannel;

	var ui : Zui;

	public function new() {
		super();
		Log.info( 'Mainmenu' );
		notifyOnInit( () -> {
			//Music.play('game_ambient_3');
			if( sound == null ) {
				SoundEffect.play( 'game_ambient_3', true, true, 0.0, s -> {
					sound = s;
					Tween.to( { target: sound, props: { volume: 0.9 }, delay: 0.2, duration: 2.0 } );
				});
			} else {
				Tween.to( { target: sound, props: { volume: 0.9 }, delay: 0.2, duration: 1.0 } );
			}
			var theme : TTheme = Reflect.copy( UI.THEME );
			ui = new Zui( { font : UI.fontTitle, theme: theme } );
			//ui.alwaysRedraw = true;
			notifyOnUpdate( update );
			notifyOnRender2D( render2D );
		});
	}

	function update() {
		final kb = Input.getKeyboard();
		if( kb.started( "escape" ) ) {
			//Scene.setActive( 'Quit' );
			loadScene('Quit');
			return;
		}
		if( kb.started( "c" ) ) {
			//Scene.setActive( 'Credits' );
			loadScene('Credits');
			return;
		}
		/* if( kb.started( "enter" ) ) {
			loadGame();
			return;
		} */
		var gp : Gamepad = null;
		for( i in 0...4 ) {
			gp = Input.getGamepad(i);
			/* if( gp.started( 'start' ) ) {
				loadGame();
				return;
			} */
			if( gp.started( 'share' ) ) {
				loadScene('Quit');
				return;
			}
		}
		notifyOnRemove( () -> {
			//if( sound != null ) sound.stop();
        });
	}

	function render2D( g : kha.graphics2.Graphics ) {

		if( ui == null ) return;

		final sw = System.windowWidth();
		final sh = System.windowHeight();
		final numPlayers = playerData.filter( p -> return p.enabled ).length;
		
		g.end();
		
		ui.begin( g );
		g.opacity = 1;

		var hwin = Id.handle();
		hwin.redraws = 1;
		if( ui.window( hwin, 32, 32, sw-64, sh-64, false ) ) {

			ui.ops.theme.TEXT_COL = COLOR_ENABLED;
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
			
			var maps = MapStore.MAPS.get( numPlayers );
			ui.row( [for(i in 0...maps.length) 1/18] );
			for( i in 0...maps.length ) {
				ui.ops.theme.BUTTON_TEXT_COL = ( i == selectedMap ) ? COLOR_ENABLED : COLOR_DISABLED;
				if( ui.button( 'M$i', Left ) ) {
					selectedMap = i;
				}
			}
			/*
			var hcombo = Id.handle();
			selectedMap = ui.combo( hcombo, [for(i in 0...maps.length) '$i'], 'MAP' );
			if (hcombo.changed) {
				//trace('CHANGED');
			}
			*/
			
			ui.ops.theme.BUTTON_TEXT_COL = COLOR_ENABLED;
			final canPlay = playerData.filter( p -> return p.enabled ).length >= 2;
			if( !canPlay ) ui.ops.theme.BUTTON_TEXT_COL = COLOR_DISABLED;
			if( ui.button( 'PLAY', Left ) ) loadGame();
			ui.ops.theme.BUTTON_TEXT_COL = COLOR_ENABLED;
			if( ui.button( 'SETTINGS', Left ) ) loadScene( 'Settings' );
			if( ui.button( 'HELP', Left ) ) loadScene( 'Help' );
			if( ui.button( 'CREDITS', Left ) ) loadScene( 'Credits' );
			if( ui.button( 'QUIT', Left ) ) loadScene( 'Quit' );
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

	function loadScene( name : String ) {
		Scene.setActive( name );
		Tween.to( { target: sound, props: { volume: 0.0 }, duration: 2.0,
			/* tick: () -> {
				//	ui.g.opacity = sound.b
			},
			done: () -> {
				//sound.stop();
			} */
		} );
	}

	function loadGame() {
		final numPlayers = playerData.filter( p -> return p.enabled ).length;
		if( numPlayers >= 2 ) {

			final maps = MapStore.MAPS[numPlayers];
			final mapData = maps[selectedMap];
			//final maps = MapStore.MAPS[numPlayers];
			//final mapData = maps[Std.int(maps.length*Math.random())];

			Scene.setActive( 'Game' );
			final game = new Game( playerData, mapData );
			Scene.active.root.addTrait( game );

			Tween.to( { target: sound, props: { volume: 0.0 }, duration: 0.4,
				tick: () -> {
				//	ui.g.opacity = sound.b
				},
				done: () -> {
					//sound.stop();
				}
			} );
		}
	}

}
