package ld47;

enum Feature
{
    None;
    Spawner;
}

class Electron extends Trait {

    public var player(default,null) : Player;
    public var atom(default,null) : Atom;
    public var velocity : Vector3D;    
    public var features : Array<Feature>;
  

    public function new( player : Player, features : Array<Features>, atom : Atom)  {
        super();
        this.player = player;
        this.features = features;
        setAtom(a);
    }

    public function update() {
    } 

    public function setAtom(a:Atom) {
        atom = a;
        velocity = null;
    } 

    public function setVelocity(v:Vector3D)
        {
            atom = null;
            velocity=v;
        }
  
}
