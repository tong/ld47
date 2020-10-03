package ld47;

class Player {

    public dynamic function onNavigate( direction : Float ) {}

    public var index(default,null) : Int;
    public var name(default,null) : String;
    public var color(default,null) : Int;

    public function new( index : Int, name : String, color : Int ) {
        this.index = index;
        this.name = name;
        this.color = color;
    }
    
    public function update() {
        var gp = iron.system.Input.getGamepad( index );
        if( gp.leftStick.moved ) {
            onNavigate( 0 );
        }
        //trace( gp.down('x') );
    }
}
