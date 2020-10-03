package ld47;

class Atom extends Trait {

    public var rotationSpeed : Float;
    public var numSlots : Int;
    public var electrons : Array<Electron>;
    public var orbitRadius : Float;
    public var player(default,null) : Player;
    
    var lastSpawn : Float;
    var spawnTime : Float;

    public function new() {
        super();
        spawnTime = Game.active.time;
    }

    public function setPlayer(p:Player) {
        if( player != null ) {
        }
        return player = p;
    }

    public function setPostion( x : Float, y : Float ) {
        object.transform.loc.x = x;
		object.transform.loc.y = y;
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
        for( electron in electrons ) {
            electron.update();
        }
        if (Game.active.time - lastSpawn>=spawnTime) {                
             spawnElectrons();
         }     
    }

    public function spawnElectrons()
        {
            lastSpawn = Now();
            var spawnerCount = electrons.filter(e:electrons -> e.features.contains(Feature.Spawner) ).length;
            var spawnCount = min(numSlots - electron.length, spawnerCount);
            for( index in 0...spawnCount )
                {
                        var newElectron = new Electron(player, new Array<Features>(), this);
                        addElectron(newElectron);

                    } );                    
                }
        }

    public function addElectron(electron:Electron)
        {
            electrons.push(electron);
            //move electron object into atom object            
            electron.object.location = getElectronPosition(electrons.length);

            Scene.active.spawnObject( 'Electron', object, obj -> {
                trace(obj);                
                obj.addTrait( electron );
        }

    private function getElectronPosition(count:int)
        {            
            var angle = 2*PI*count/numSlots;
            return new Vetor3D(orbitRadius*sin(angle), orbitRadius*cos(angle),0);
        }
}
