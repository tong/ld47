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
    //Freezer;
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
    
    var velocity : Vec4;    
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
                        //trace(body);
                    }
                });
                body = mesh.getTrait(RigidBody);
                // body.setAngularFactor( 0, 0, 0 );
                // body.setLinearVelocity( 0, 0, 0 );
                // body.syncTransform();
                //body.notifyOnContact( a -> trace(a) );
            });
        });
        notifyOnUpdate( update );
    }

    function update() {

        if( body == null || !body.ready ) return;
        body.syncTransform();

        if (velocity != null) {
       
            object.transform.translate( velocity.x/50, velocity.y/50, 0 );

            var contacts = PhysicsWorld.active.getContactPairs( body );
            if( contacts != null ) {
                if( contacts[0] != null ) {
                    var rb = PhysicsWorld.active.rbMap.get( contacts[0].a );
                    if( rb == body ) rb = PhysicsWorld.active.rbMap.get( contacts[0].b );
                    trace(rb.object.name);
                    if( rb.object.name.startsWith('Atom') ) {
                        var atom = rb.object.parent.getTrait(Atom);
                        if( atom != null ) {
                            //TODO
                            trace("ATOM HIT");
                            //SoundEffect.play('electron_hit',false,true,0.3);
                            object.remove();
                            atom.hit( this );
                        }
                    }
                }
            }
        }

       // body.syncTransform();

        /*
        switch core {
        case Bomber:
            var wr = new Quat().fromMat( mesh.transform.world ); 
            mesh.transform.rotate( Vec4.zAxis(), -wr.z );
            mesh.transform.buildMatrix();
        default:
        } */
    } 

    public function setAtom( a : Atom, index : Int ) {
        trace('attach electron to atom of player ${a.player.index} at index $index');
        atom = a;
        position = index;
        velocity = null;
        DataTools.loadMaterial('Game', 'Player'+(player.index+1), n -> {
            if( mesh != null ) mesh.materials = n;
        });
    }

    public function setPostion( v : Vec2 ) {
        object.transform.loc.x = v.x;
		object.transform.loc.y = v.y;
		//object.transform.loc.z = 0;
        object.transform.buildMatrix();
        body.syncTransform();
    }

    public function setDirection(dir:Vec4){
        var angleX = Math.atan( dir.z / dir.y );
        if( dir.y < 0 ) angleX = -angleX;
        var angleZ = Math.atan( dir.y / dir.x ) - HALF_PI;
        if( dir.x < 0 ) angleZ += Math.PI;
        object.transform.setRotation( angleX, 0, angleZ );
        object.transform.buildMatrix();
        body.syncTransform();
    }

    public function fire( dir : Vec4 ) {
        //trace('fire: $v');
        //body.applyImpulse( new Vec4(40,66,0) );
        //body.setLinearVelocity( 0, 100, 0 );
        setDirection( dir );
        atom = null;
        velocity = dir;
    }

   /*  public function dispose() {
        object.remove();
    } */
}
