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
    public var position(default,null): Int;
    public var mesh(default, null) : MeshObject;
    
    public var velocity(default, null) : Vec4;    
    public var feature(default, null) : Feature;

    public function new( player : Player, feature : Feature)  {
        super();
        this.player = player;
        this.feature = feature;
        notifyOnInit( () -> {
            mesh = cast object.getChild('ElectronMesh');
            DataTools.loadMaterial('Game', 'Player'+(player.index), m -> {                
                mesh.materials = m;                
                switch feature {
                case Spawner:
                    mesh.visible = false;
                    Scene.active.spawnObject( 'SpawnerElectronMesh', object, obj -> {
                        obj.visible = true;
                        var m : MeshObject = cast obj;
                        m.materials = mesh.materials;
                    });
                default:
                }
            }); 
            object.transform.scale.x = object.transform.scale.y = object.transform.scale.z = 0.01;
            Tween.to({
                props: {x: 1, y: 1, z: 1},
                duration: 1.0,
                target: object.transform.scale,
                ease: Ease.ElasticOut,
                tick: object.transform.buildMatrix
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
        position=index;
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
