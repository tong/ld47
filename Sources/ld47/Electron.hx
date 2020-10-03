package ld47;

enum Feature
{
    None;
    Spawner;
}

class Electron extends Trait {

    public var player(default,null) : Player;
    public var atom(default,null) : Atom;
    public var velocity : Vec4;    
    public var features : Array<Feature>;
  

    public function new( player : Player, features : Array<Feature>)  {
        super();
        this.player = player;
        this.features = features;
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
  
}
