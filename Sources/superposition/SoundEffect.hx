package superposition;

class SoundEffect {

    public static inline function load( id : String, cb : kha.Sound->Void ) {
        Data.getSound( '$id.ogg', cb );
    }

    public static inline function loadSet( baseName : String, count : Int, cb : Array<kha.Sound>->Void ) {
        var loaded = new Array<kha.Sound>();
        function loadNext() {
            trace('$baseName${loaded.length+1}.ogg');
            load( '$baseName${loaded.length+1}', s -> {
                loaded.push(s);
                if( loaded.length == count ) cb( loaded ) else loadNext();
            } );
        }
        loadNext();
    }

    public static function play( id : String, ?loop : Bool, ?stream : Bool, volume = 0.8, ?cb : AudioChannel->Void ) {
        load( id, s -> {
            var c = Audio.play( s, loop, stream );
            c.volume = volume;
            if( cb != null ) cb(c);
        });
    }

    public static inline function fade( sound : AudioChannel, volume : Float, duration : Float, ?ease : iron.system.Ease, delay = 0.0 ) : AudioChannel {
        Tween.to( { target: sound, props: { volume: volume }, duration: duration , delay: delay, ease: ease } );
        return sound;
    }

    public static inline function fadeIn( sound : AudioChannel, volume : Float, duration : Float, ?ease : iron.system.Ease, delay = 0.0 ) : AudioChannel {
        sound.volume = 0;
        Tween.to( { target: sound, props: { volume: volume }, duration: duration , delay: delay, ease: ease } );
        return sound;
    }

}