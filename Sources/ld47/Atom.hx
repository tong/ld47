package ld47;

class Atom extends Trait {

    public var rotationSpeed : Float;
    public var numSlots : Int;
    public var electrons : Array<Electron> = [];
    public var orbitRadius : Float;
    public var player(default,null) : Player;
    
    var lastSpawn : Float;
    var spawnTime : Float = 10.0;

    public function new() {
        super();
        lastSpawn = Game.active.time;
    }

    public function setPlayer(p:Player) {
        if( player != null ) {
        }
        return player = p;
    }

    public function setPostion( v : Vec2 ) {
        object.transform.loc.x = v.x;
		object.transform.loc.y = v.y;
		//object.transform.loc.z = 0;
		object.transform.buildMatrix();
    }

    public function hit( electron : Electron ) {
        if (player == null) {
                setPlayer(electron.player);
                addElectron(electron);                    
        } else if(player == electron.player) {
                addElectron(electron);
        } else {                    
                var e = electrons.pop();
                e.object.remove();
                e.object.remove();
        }
    }

    public function update() {
        /*
        for( electron in electrons ) {
            electron.update();
        }
        if (Game.active.time - lastSpawn>=spawnTime) {                
            spawnElectrons();
        }     
        */
    }

    public function spawnElectrons()
        {
            lastSpawn = Game.active.time;
            
            // var spawnerCount = electrons.filter( (e:Electron) -> return e.features.contains(ld47.Electron.Feature.Spawner) ).length;
            var spawnerCount = 0;
            for( e in electrons ) {
                for( f in e.features ) {
                    if( Std.is( f, Electron.Feature.Spawner) ) {
                        spawnerCount++;
                    }
                }
            }

            var spawnCount = Std.int( Math.min(numSlots - electrons.length, spawnerCount) );
            for( index in 0...spawnCount )
                {
                    var newElectron = new Electron(player, new Array<ld47.Electron.Feature>(), this);
                    addElectron(newElectron);
                }
        }

    public function addElectron(electron:Electron)
        {
            electrons.push(electron);
            //move electron object into atom object            
          //  electron.object.location = getElectronPosition(electrons.length);
            var pos = getElectronPosition( electrons.length );
            electron.setPostion( pos );

            Scene.active.spawnObject( 'Electron', object, obj -> {
                trace(obj);                
                obj.addTrait( electron );
            });
        }

    private function getElectronPosition(count:Int)
        {            
            var angle = 2*Math.PI*count/numSlots;
            return new Vec2( orbitRadius* Math.sin(angle), orbitRadius* Math.cos(angle) );
        }
}
