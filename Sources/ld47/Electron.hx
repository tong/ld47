package ld47;

import iron.data.MaterialData;

enum Feature
{
    None;
    Spawner;
}

class Electron extends Trait {

    public static var defaultColor = new Vec4( 0, 1, 0 );

    public var player(default,null) : Player;
    public var atom(default,null) : Atom;
    
    public var velocity : Vec4;    
    public var features : Array<Feature>;
  

    public function new( player : Player, features : Array<Feature>)  {
        super();
        this.player = player;
        this.features = features;
        notifyOnInit( () -> {
            Uniforms.externalVec3Links.push( vec3Link );
        });
    }

    public function update() {
    } 

    public function setPostion( v : Vec2 ) {
        object.transform.loc.x = v.x;
		object.transform.loc.y = v.y;
		//object.transform.loc.z = 0;
		object.transform.buildMatrix();
    }

    public function setAtom(a:Atom) {
        atom = a;
        velocity = null;
    } 

    public function setVelocity(v:Vec4)
        {
            atom = null;
            velocity=v;
        }
    
    function vec3Link( object : Object, mat : MaterialData, link : String ) : Vec4 {
        if( link == "RGB" && object == this.object ) {
            if( player == null ) {
                return defaultColor;
            } else {
                var c : Color = player.color;
                return new Vec4( c.R, c.G, c.B );
            }
        }
        return null;
    }
  
}
