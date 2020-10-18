package superposition;

enum Core {
    None;
    Spawner(v:Float); //TODO (speed:Float,?core:Core):
    Speeder(v:Float);
    Bomber;
    Shield;
    Laser;
    Swastika;
    Topy;
    Process;
    //Candyflip;
    //Occupier;
}

class Electron extends Trait {

    public static inline var RADIUS : FastFloat = 0.1;

    public final player : Player;
    public final core : Core;

    public var atom(default,null) : Atom;
    public var position(default,null): Int;
    public var mesh(default,null) : MeshObject;
    public var velocity(default,null) : Vec4;    
   
    var body : RigidBody;

    public function new( player : Player, core : Core )  {
        super();
        this.player = player;
        this.core = core;
        notifyOnInit( () -> {
            Scene.active.spawnObject( 'ElectronCore'+EnumValueTools.getName( core ), object, obj -> {
                mesh = cast obj;
                mesh.visible = true;
                mesh.transform.loc.set(0,0,0);
                mesh.transform.buildMatrix();
                object.transform.scale.x = object.transform.scale.y = object.transform.scale.z = 0.001;
                Tween.to({
                    props: {x: 1, y: 1, z: 1},
                    duration: 1.0,
                    target: object.transform.scale,
                    ease: Ease.ElasticOut,
                    tick: object.transform.buildMatrix,
                    done: () -> {
                        body = mesh.getTrait(RigidBody);
                        //trace(body);
                    }
                });
                //body.setAngularFactor( 0, 0, 0 );
                //body.syncTransform();
                // body.notifyOnContact( (rb) -> trace(mesh.name+'::'+rb.object.name) );
            });
        });
    }

    /* function preUpdate() {
        if( !body.ready ) return;
		body.syncTransform();
	}
 */
    public function update() {

        //if( !body.ready ) return;
        //mesh.transform.rotate( new Vec4(0,1,0,1), 0.01 );

       /*  if( body == null || !body.ready ) return;
        body.syncTransform(); */

        if (velocity != null) {
            object.transform.translate( velocity.x/50, velocity.y/50, 0 );
        }
        switch core {
        case Bomber:
            var wr = new Quat().fromMat( mesh.transform.world ); 
            mesh.transform.rotate( Vec4.zAxis(), -wr.z );
            mesh.transform.buildMatrix();
        default:
        }

       /*  var contacts = PhysicsWorld.active.getContactPairs( body );
        if( contacts != null && contacts.length > 0 ) {
            for( contact in contacts ) {
                var other = PhysicsWorld.active.rbMap.get( contact.a );
                trace( other.object.name );
            }
        } */
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
            if( mesh != null ) mesh.materials = n;
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
        //body.syncTransform();
    }

    public function dispose() {
        object.remove();
    }
}
