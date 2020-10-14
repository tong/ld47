package ld47;

import zui.Id;
import zui.Zui;

typedef TConfig = {
    // > armory.data.Config.TConfig,
	// ?audio_ambient: Float,
	// ?audio_effects: Float,
	// ?audio_music: Float,
    // ?version : String,
    anything: String
}

// TODO

class Settings extends Trait {

	public static inline var FILE = "config.json";

    public static var defaultConfig : TConfig = {
        anything: "TestTest"
    }

    public static var raw:TConfig;
    
    var ui : Zui;

	public function new() {
        super();
        Log.info( 'Settings' );
        load( cfg -> {
            trace(cfg);
            ui = new Zui( { font : UI.fontTitle, theme: UI.THEME } );
            notifyOnRender2D( render );
		} );
		var kb = Input.getKeyboard();
        var gp : Gamepad = null;
        notifyOnUpdate( () -> {
            if( kb.started('escape') ) Scene.setActive( 'Mainmenu' );
            for( i in 0...4 ) if( Input.getGamepad(i).started( 'cross' ) ) Scene.setActive( 'Quit' );
        });
    }
    
    function render( g : kha.graphics2.Graphics ) {
		g.end();
		ui.begin( g );
		if( ui.window( Id.handle(), 0, 0, 600, 600, true ) ) {
			//if( ui.panel( Id.handle( { selected: true } ), "Settings", true ) ) {
			ui.text( raw.anything, Left );
		}
		ui.end();
		g.begin( false );
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
		trace("not implemented");
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
			trace(e);
		}
		#else
		trace("not implemented");
		#end
    }
}
