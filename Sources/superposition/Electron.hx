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
    public var index(default,null): Int;
    public var mesh(default,null) : MeshObject;
    public var body(default,null) : RigidBody;
    public var velocity(default,null) : Vec4;    

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
                body = mesh.getTrait(RigidBody);
                //body.group = 2;
                //body.ready = false;
                // body.setAngularFactor( 0, 0, 0 );
                // body.setLinearVelocity( 0, 0, 0 );
                // body.syncTransform();
                //body.notifyOnContact( a -> trace(a) );
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
            });
        });
        notifyOnRemove( () -> {
            if( atom != null ) {
                atom.removeElectron( this );
                atom = null;
            }
            body.removeFromWorld();
            Game.active.flyingElectrons.remove( this );
        });
        notifyOnUpdate( update );
    }

    public function update() {

        if( body == null || !body.ready ) return;

        switch core {
        case Bomber:
            var wr = new Quat().fromMat( mesh.transform.world ); 
            mesh.transform.rotate( Vec4.zAxis(), -wr.z );
            mesh.transform.buildMatrix();
            default:
        }
                
        body.syncTransform();

        if (velocity != null) {
       
            object.transform.translate( velocity.x/50, velocity.y/50, 0 );

            var contacts = PhysicsWorld.active.getContactPairs( body );
            if( contacts != null ) {
                Log.warn(contacts.length+' CONTACTS');
                for( contact in contacts ) {
                    var rb = PhysicsWorld.active.rbMap.get( contact.a );
                    if( rb == body ) rb = PhysicsWorld.active.rbMap.get( contact.b );
                    if( rb == null ) {
                        trace('??? no rigid body ???');
                        return;
                    }
                    //trace(object.name+" hit "+rb.object.name);
                    if( rb.object.name.startsWith('Atom') ) {
                        var atom = rb.object.parent.getTrait(Atom);
                        if( atom != null ) {
                            //trace('electron has hit an atom');
                            atom.hit( this );
                            explode();
                            if( atom.player == null ) Game.active.flyingElectrons.remove( this );
                        } else {
                            trace('unknown object: '+rb.object );
                        }
                    } else if( rb.object.name.startsWith('ElectronCore') ) {
                        var electron = rb.object.parent.getTrait( Electron );
                        if( electron != null ) {
                            //trace('electron has hit an electron');
                            if( electron.player == player ) {
                                //explode();
                                //electron.explode();
                                //electron.atom.removeElectron( electron );
                            } else {
                                explode();
                                electron.explode();
                            }
                        }
                    } else {
                        trace('electron has hit an unknown object '+rb.object);
                        explode();
                        return;
                    }
                }
            }
        }
    }

    public function setAtom( atom : Atom, index : Int ) {
        trace('attach electron to atom of player ${atom.player.index} at index $index');
        this.atom = atom;
        this.index = index;
        velocity = null;
        body.ready = true;
        DataTools.loadMaterial('Game', 'Player'+(player.index+1), m -> {
            if( mesh != null ) mesh.materials = m;
        });
    }

    public function setPostion( v : { x : Float, y : Float } ) {
        object.transform.loc.x = v.x;
		object.transform.loc.y = v.y;
		//object.transform.loc.z = 0;
        object.transform.buildMatrix();
        if( body != null ) body.syncTransform();
    }

    public function setDirection(dir:Vec4){
        var angleX = Math.atan( dir.z / dir.y );
        if( dir.y < 0 ) angleX = -angleX;
        var angleZ = Math.atan( dir.y / dir.x ) - HALF_PI;
        if( dir.x < 0 ) angleZ += Math.PI;
        object.transform.setRotation( angleX, 0, angleZ );
        object.transform.buildMatrix();
        if( body != null )body.syncTransform();
    }

    public function fire( dir : Vec4 ) {
        //body.applyImpulse( new Vec4(40,66,0) );
        //body.setLinearVelocity( 0, 100, 0 );
        velocity = dir;
        atom = null;
        setDirection( dir );
    }

    public function explode() {
        object.remove();
        velocity = null;
        //var light : LightObject = cast mesh.getChild('ElectronExplosionLight');
        //light.visible = true;
        SoundEffect.play('electron_hit',false,true,0.5);
        Scene.active.spawnObject( 'ElectronExplosion', null, obj -> {
            var explosion : MeshObject = cast obj;
            explosion.transform.loc.x = object.transform.worldx();
            explosion.transform.loc.y = object.transform.worldy();
            explosion.transform.loc.z = object.transform.worldz() + 1;
            explosion.transform.rotate( Vec4.zAxis(), Math.random() * 360 );
            @:privateAccess explosion.tilesheet.onActionComplete = () -> {
                explosion.remove();
            }
        });
    }

    public function toString() : String {
        var s = 'Electron$index($core,p=${player.index}';
        if( atom != null ) s += ',a=${atom.index})';
        return s;
    }
}
