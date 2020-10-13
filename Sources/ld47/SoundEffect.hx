package ld47;

class SoundEffect {

    public static inline function load( id : String, cb : kha.Sound->Void ) {
        Data.getSound( '$id.ogg', cb );
    }

    public static function play( id : String, ?loop : Bool, ?stream : Bool, volume = 0.8, ?cb : AudioChannel->Void ) {
        load( id, s -> {
            var c = Audio.play( s, loop, stream );
            c.volume = volume;
            if( cb != null ) cb(c);
        });
    }

}