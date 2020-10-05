package ld47;

class SoundEffect {

    public static inline function load( id : String, cb : kha.Sound->Void ) {
        Data.getSound( '$id.ogg', cb );
    }

    public static function play( id : String, ?loop : Bool, ?stream : Bool, volume = 1.0 ) {
        load( id, s -> {
            var c = Audio.play( s, loop, stream );
            c.volume = volume;
        });
    }

}