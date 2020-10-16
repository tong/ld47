package superposition;

import zui.Id;
import zui.Zui;

typedef TConfig = {
    > armory.data.Config.TConfig,
	audio_ambient: Float,
	audio_effects: Float,
}

class Settings extends Trait {

	public static inline var FILE = "config.json";

    public static var defaultConfig : TConfig = {

		rp_bloom : true, 
		rp_motionblur: true,
		rp_dynres : false, 
		rp_gi : false, 
		rp_shadowmap_cascade : 1024, 
		rp_shadowmap_cube : 512, 
		rp_ssgi : true, 
		rp_ssr : true, 
		rp_supersample : 1,

		window_w : 1920,
		window_h : 1080, 
		window_maximizable : false, 
		window_minimizable : true, 
		window_mode : 1, 
		window_msaa : 1, 
		window_resizable : false, 
		window_scale : 1, 
		window_vsync : true, 

		audio_ambient: 1.0,
		audio_effects: 1.0,
    }

    public static var raw : TConfig;
    
    var ui : Zui;

	public function new() {
        super();
		Log.info( 'Settings' );
		notifyOnInit( () -> {
			load( cfg -> {
				trace(cfg);
				ui = new Zui( { font : UI.font, theme: UI.THEME_1 } );
				ui.alwaysRedraw = true;
				notifyOnRender2D( render );
			} );
			var kb = Input.getKeyboard();
			notifyOnUpdate( () -> {
				if( kb.started('escape') ) Scene.setActive( 'Mainmenu' );
				for( i in 0...4 ) if( Input.getGamepad(i).started( 'cross' ) ) Scene.setActive( 'Quit' );
			});
		});
    }
    
    function render( g : kha.graphics2.Graphics ) {
		
		var ocfg : TConfig= raw;
		var ncfg : TConfig = cast {};
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
			
			var hcombo = Id.handle();
			ui.combo( hcombo, [for(r in ['3840x210','1920x1080','1280x1080']) r], 'RESOLUTION' );

			ui.text('SOUND',Left);
			ncfg.audio_ambient = ui.slider( Id.handle( { value: ocfg.audio_ambient } ), "AMBIENT", 0, 1.0, true );
			ncfg.audio_effects = ui.slider( Id.handle( { value: ocfg.audio_effects } ), "EFFECTS", 0, 1.0, true );

			ui.text('KEYBOARD P1',Left);
			ui.textInput( Id.handle( { text: 'W' } ), 'MOVE UP' );
			ui.textInput( Id.handle( { text: 'A' } ), 'MOVE LEFT' );
			ui.textInput( Id.handle( { text: 'S' } ), 'MOVE DOWN' );
			ui.textInput( Id.handle( { text: 'D' } ), 'MOVE RIGHT' );
			ui.textInput( Id.handle( { text: 'E' } ), 'SELECT NEXT ATOM' );
			ui.textInput( Id.handle( { text: 'Q' } ), 'SELECT PREV ATOM' );
			ui.textInput( Id.handle( { text: 'F' } ), 'FIRE ATOM' );
		
			ui.row( [ 1/3,1/3,1/3 ]);
			ui.ops.theme = UI.THEME_2;
			if( ui.button( "APPLY", Left ) ) {
				applyConfig( ncfg );
				Scene.setActive( 'Mainmenu' );
			}
			if( ui.button( "CANCEL", Left ) ) {
				Scene.setActive( 'Mainmenu' );
			}
			if( ui.button( "RESET", Left ) ) {
				applyConfig( defaultConfig );
			}
		}
		ui.end();
		g.begin( false );
	}
	
	function applyConfig( cfg : TConfig ) {
		save( cfg );
		///armory.data.Config.raw = cfg;
		armory.data.Config.raw.rp_bloom = cfg.rp_bloom;
		armory.data.Config.raw.rp_motionblur = cfg.rp_motionblur;
		armory.data.Config.raw.window_w = cfg.window_w;
		armory.data.Config.raw.window_h = cfg.window_h;
		armory.data.Config.raw.window_vsync = cfg.window_vsync;
		armory.renderpath.RenderPathCreator.applyConfig();
	}

	static function load(done:TConfig->Void) {
		#if kha_krom
		var path = tron.sys.Path.data() + '$FILE';
		trace('Loading config $path');
		try {
			Data.getBlob(path, blob -> {
				raw = Json.parse(blob.toString());
				done(raw);
			});
		} catch (e:Dynamic) {
			trace('No config found, using default');
			save(defaultConfig);
			done(raw);
		}
		#else
		Log.warn("not implemented");
		#end
	}

	static function save(?cfg:TConfig) {
        if( cfg != null ) raw = cfg;
        #if kha_krom
		// Use system application data folder when running from protected path like "Program Files"
		//var path = (Path.isProtected() ? Krom.savePath() : Path.data() + Path.SEP) + FILE;
		//var path = (Path.isProtected() ? Krom.savePath() : "") + FILE;
		var path = Path.data()+'$FILE';
		var bytes = Bytes.ofString( Json.stringify( raw ) );
		try {
			Krom.fileSaveBytes( path, bytes.getData() );
		} catch(e:Dynamic) {
			Log.warn(e);
		}
		#else
		Log.warn("not implemented");
		#end
    }
}
