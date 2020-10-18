package superposition;

//import superposition.Config;
import zui.Id;
import zui.Zui;

class SettingsMenu extends Trait {

    var ui : Zui;

	public function new() {
        super();
		Log.info( 'Settings' );
		notifyOnInit( () -> {
			//if( Config.raw == null )

			//trace( Config.raw  );
			ui = new Zui( { font : UI.font, theme: UI.THEME_1 } );
			ui.alwaysRedraw = true;
			notifyOnRender2D( render );
			/*

			load( cfg -> {
				trace(cfg);
				ui = new Zui( { font : UI.font, theme: UI.THEME_1 } );
				ui.alwaysRedraw = true;
				notifyOnRender2D( render );
			} );
			*/
			var kb = Input.getKeyboard();
			notifyOnUpdate( () -> {
				if( kb.started('escape') ) Scene.setActive( 'Mainmenu' );
				for( i in 0...4 ) if( Input.getGamepad(i).started( 'cross' ) ) Scene.setActive( 'Quit' );
			});
		});
    }
    
    function render( g : kha.graphics2.Graphics ) {
		
		//var ocfg : TConfig = Config.raw;
		var ocfg : armory.data.Config.TConfig = armory.data.Config.raw;
		var ncfg : armory.data.Config.TConfig = cast {};
		for( f in Reflect.fields( ocfg ) ) Reflect.setField( ncfg, f, Reflect.field( ocfg, f ) );

		final sw = System.windowWidth(), sh = System.windowHeight();
		final w = 320, h = System.windowHeight();

		g.end();
		ui.begin( g );
		if( ui.window( Id.handle(), 32, 32, w, h, false ) ) {

			ui.text('GRAPHICS',Left);
			ncfg.rp_bloom = ui.check( Id.handle( { selected: ocfg.rp_bloom } ), "BLOOM" );
			ncfg.rp_motionblur = ui.check( Id.handle( { selected: ocfg.rp_motionblur } ), "MOTION BLUR" );
			ncfg.window_vsync = ui.check( Id.handle({ selected: ocfg.window_vsync }), "VSYNC" );
			
			if( ui.button( "1280x720", Left ) ) {
				ncfg.window_w = 1280;
				ncfg.window_h = 720;
				trace("CHANGED RESOLUTION");
			}
			if( ui.button( "1920x1080", Left ) ) {
				ncfg.window_w = 1920;
				ncfg.window_h = 1080;
				trace("CHANGED RESOLUTION");
			}

			ui.text('CurrentW: '+ocfg.window_w );
			ui.text('CurrentH: '+ocfg.window_h );
			/* var hcombo = Id.handle();
			ui.combo( hcombo, [for(r in ['3840x210','1920x1080','1280x1080']) r], 'RESOLUTION' );
			if(hcombo.changed) {
				trace("Combo value changed this frame");
				trace(hcombo);
			} */

			// ui.text('SOUND',Left);
			// ncfg.audio_ambient = ui.slider( Id.handle( { value: ocfg.audio_ambient } ), "AMBIENT", 0, 1.0, true );
			// ncfg.audio_effects = ui.slider( Id.handle( { value: ocfg.audio_effects } ), "EFFECTS", 0, 1.0, true );

			// ui.text('KEYBOARD P1',Left);
			// ui.textInput( Id.handle( { text: 'W' } ), 'MOVE UP' );
			// ui.textInput( Id.handle( { text: 'A' } ), 'MOVE LEFT' );
			// ui.textInput( Id.handle( { text: 'S' } ), 'MOVE DOWN' );
			// ui.textInput( Id.handle( { text: 'D' } ), 'MOVE RIGHT' );
			// ui.textInput( Id.handle( { text: 'E' } ), 'SELECT NEXT ATOM' );
			// ui.textInput( Id.handle( { text: 'Q' } ), 'SELECT PREV ATOM' );
			// ui.textInput( Id.handle( { text: 'F' } ), 'FIRE ATOM' );
		
			ui.row( [ 1/3,1/3,1/3 ]);
			ui.ops.theme = UI.THEME_2;
			if( ui.button( "APPLY", Left ) ) {
				apply( ncfg );
				//Scene.setActive( 'Mainmenu' );
			}
			if( ui.button( "CANCEL", Left ) ) {
				Scene.setActive( 'Mainmenu' );
			}
			if( ui.button( "RESET", Left ) ) {
				apply( Config.defaultConfig );
			}
		}
		ui.end();
		g.begin( false );
	}
	
	function apply( cfg : armory.data.Config.TConfig ) {
		//cfg.window_w = 1280;
		//cfg.window_h = 720;
		trace("apply "+cfg);
		//Config.save( cfg, () -> {} );
		//Config.raw = cfg;
		armory.data.Config.raw = cfg;
		//armory.data.Config.raw.window_w = 1280;
		//armory.data.Config.raw.window_h = 720;
		armory.renderpath.RenderPathCreator.applyConfig();
		armory.data.Config.save();
		///superposition.renderpath.RenderPathCreator.applyConfig();
		trace("CONFIG APPLIED");
	}
}
