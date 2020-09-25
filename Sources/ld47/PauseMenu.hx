package ld47;

import zui.*;
import zui.Themes;

class PauseMenu extends Trait {

	var ui : Zui;

	public function new() {
		super();
		notifyOnInit( () -> {
			ui = new Zui( { font : UI.font, theme: UI.THEME } );
			Event.add( 'game_pause', handlePause );
			notifyOnRemove( () -> {
				Event.remove( 'game_pause' );
			});
		});
	}

	function handlePause() {
		//trace(Game.active.paused );
		if( Game.active.paused ) {
			notifyOnRender2D( render );
		} else {
			removeRender2D( render );
		}
	}

	function render( g : kha.graphics2.Graphics ) {

        final w = 400;
        final h = System.windowHeight();
        
        g.end();
		g.opacity = 1;
		ui.begin( g );
		if( ui.window( Id.handle(), 0, 0, w, h, false ) ) {
            ui.text( "LD47" );
			ui.row( [ 1/2, 1/2 ]);
			if( ui.button( 'RESUME' ) ) {
				Game.active.resume();
            }
            if( ui.button( 'EXIT' ) ) {
				Game.active.end();
			}
		}
		ui.end();
        g.begin( false );

        /*
		final game = Game.active;
		if( ui == null )
			return;
		if( !game.paused ) {
			//settings.visible = false;
			return;
		}
		var w = 400;
		var h = System.windowHeight();
		g.end();
		g.opacity = 1;
		ui.begin( g );
		if( ui.window( Id.handle(), 0, 0, w, h, false ) ) {
			ui.text( game.level.toUpperCase() );
			ui.row( [ 1/2, 1/2 ]);
			if( ui.button( 'RESUME' ) ) {
				//settings.visible = false;
				removeRender2D( render );
				game.resume();
			}
			if( ui.button( 'SETTINGS' ) ) {
				//settings.visible = !settings.visible;
			}
			ui.row( [ 1/2, 1/2 ]);
			if( ui.button( 'EXIT' ) ) {
				Scene.active.remove();
				Scene.setActive( "scene_Menu" );
			}
			if( ui.button( 'QUIT' ) ) {
				Scene.setActive( 'scene_Quit' );
			}
			ui.row( [ 1/2, 1/2 ]);
			if( ui.button( 'SAVE' ) ) {
				//Game.saveState();
			}
			if( ui.button( 'LOAD' ) ) {
				//Game.loadState();
			}
		}
		ui.end();
        g.begin( false );
        */
        
	}
}
