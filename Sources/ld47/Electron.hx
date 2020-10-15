package ld47;

import iron.data.MaterialData;

enum Core {
    None;
    Bomber;
    Spawner;
    UpSpeeder;
    DownSpeeder;
    Laser;
}

class Electron extends Trait {

    public static var defaultColor = new Vec4( 0, 1, 0 );

    public final player : Player;
    public final core : Core;

    public var atom(default,null) : Atom;
    public var position(default,null): Int;
    public var mesh(default, null) : MeshObject;
    public var velocity(default, null) : Vec4;    

    public function new( player : Player, core : Core )  {
        super();
        this.player = player;
        this.core = core;
        notifyOnInit( () -> {
            Scene.active.spawnObject( EnumValueTools.getName( core )+'ElectronMesh', object, obj -> {
                mesh = cast obj;
                mesh.visible = true;
                mesh.transform.loc.set(0,0,0);
                mesh.transform.buildMatrix();
                object.transform.scale.x = object.transform.scale.y = object.transform.scale.z = 0.01;
                Tween.to({
                    props: {x: 1, y: 1, z: 1},
                    duration: 1.0,
                    target: object.transform.scale,
                    ease: Ease.ElasticOut,
                    tick: object.transform.buildMatrix
                });
            });
        });
    }

    public function update() {
        if( Game.active.paused )
            return;
        //mesh.transform.rotate( new Vec4(0,1,0,1), 0.01 );
        if (velocity != null) {
            object.transform.translate( velocity.x/50, velocity.y/50, 0 );
        }
    } 

    public function setPostion( v : Vec2 ) {
        object.transform.loc.x = v.x;
		object.transform.loc.y = v.y;
		//object.transform.loc.z = 0;
		object.transform.buildMatrix();
    }

    public function setAtom(a:Atom, index:Int) {
        trace('attach electron to atom of player ${a.player.index} at index $index');
        atom = a;
        position = index;
        velocity = null;
        DataTools.loadMaterial('Game', 'Player'+(player.index+1), n -> {
            mesh.materials = n;
        });
    } 

    public function setVelocity(v:Vec4) {
        trace('fire electron: $v');
        setDirection(v);
        atom = null;
        velocity = v;
    }

    public function setDirection(dir:Vec4){
        var angleX = Math.atan( dir.z / dir.y );
        if( dir.y < 0 ) angleX = -angleX;
        var angleZ = Math.atan( dir.y / dir.x ) - HALF_PI;
        if( dir.x < 0 ) angleZ += Math.PI;
        object.transform.setRotation( angleX, 0, angleZ );
        object.transform.buildMatrix();
    }

    public function destroy() {
        object.remove();
    }
}
