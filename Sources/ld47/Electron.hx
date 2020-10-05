package ld47;

import iron.data.MaterialData;

enum Feature {
    None;
    Spawner;
}

class Electron extends Trait {

    public static var defaultColor = new Vec4( 0, 1, 0 );

    public var player(default,null) : Player;
    public var atom(default,null) : Atom;
    public var atomIndex(default,null): Int;
    public var mesh(default, null) : MeshObject;
    
    public var velocity : Vec4;    
    public var features : Array<Feature>;

    public function new( player : Player, features : Array<Feature>)  {
        super();
        this.player = player;
        this.features = features;
        notifyOnInit( () -> {
            mesh = cast object.getChild('ElectronMesh');                 

            DataTools.loadMaterial('Game', 'Player'+(player.index), m -> {                
                mesh.materials = m;                
            }); 
        });
    }

    public function update() {
        if (velocity != null)
            {
                object.transform.translate(velocity.x/100, velocity.y/100,0);
            }
    } 

    public function setPostion( v : Vec2 ) {
        object.transform.loc.x = v.x;
		object.transform.loc.y = v.y;
		//object.transform.loc.z = 0;
		object.transform.buildMatrix();
    }


    public function setAtom(a:Atom, index:Int) {
        trace('attach electron to atom of player ' + a.player.index + ' at index ' + index);
        atom = a;
        atomIndex=index;
        velocity = null;
    } 

    public function setVelocity(v:Vec4)
    {
        trace('fire electron of in direction ' + v);
        setDirection(v);
        atom = null;
        velocity=v;
    }

    public function setDirection(dir:Vec4){
        var angleX = Math.atan( dir.z / dir.y );

        if( dir.y < 0 ) angleX = -angleX;
        
        var angleZ = Math.atan( dir.y / dir.x ) - HALF_PI;
        if( dir.x < 0 ) angleZ += Math.PI;
        

        object.transform.setRotation( angleX, 0, angleZ );
        object.transform.buildMatrix();
    }
}
