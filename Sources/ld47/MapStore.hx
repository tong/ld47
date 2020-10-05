package ld47;

import ld47.Game.MapData;

class MapStore{
    public var maps(default,null): Array<MapData>;

    public function new(players: Int) {
        maps = new Array<MapData>();
        if (players == 4){
            maps.push( {
                name: 'intro',
                atoms: [
                    {slots: 10, player: 0, electrons:1, spawner: 1, position: new Vec2(-8,0)  },
                    {slots: 10, player: 1, electrons:1, spawner: 1, position: new Vec2(8,0)  },
                    {slots: 10, player: 2, electrons:1, spawner: 1, position: new Vec2(0,4)  },
                    {slots: 10, player: 3, electrons:1, spawner: 1, position: new Vec2(0,-4)  },
                    { slots: 16, position: new Vec2(-8,4) },
                    { slots: 16, position: new Vec2(-8,-4) },
                    { slots: 16, position: new Vec2(8,4) },
                    { slots: 16, position: new Vec2(8,-4) },
                    { slots: 20, position: new Vec2(0,0) }
                ]
                

            });       
        }
        else if (players == 3){
            maps.push( {
                name: 'intro',
                atoms: [
                    {slots: 10, player: 0, electrons:1, spawner: 1, position: new Vec2(-8,0)  },
                    {slots: 10, player: 1, electrons:1, spawner: 1, position: new Vec2(8,0)  },
                    {slots: 10, player: 2, electrons:1, spawner: 1, position: new Vec2(0,4)  },                    
                    { slots: 16, position: new Vec2(-8,4) },
                    { slots: 16, position: new Vec2(-8,-4) },
                    { slots: 16, position: new Vec2(8,4) },
                    { slots: 16, position: new Vec2(8,-4) },
                    { slots: 20, position: new Vec2(0,0) }
                ]
                

            });       
        }
        else if (players == 2){
            maps.push( {
                name: 'intro',
                atoms: [
                    {slots: 10, player: 0, electrons:1, spawner: 1, position: new Vec2(-8,0)  },
                    {slots: 10, player: 1, electrons:1, spawner: 1, position: new Vec2(8,0)  },                    
                    { slots: 16, position: new Vec2(-8,4) },
                    { slots: 16, position: new Vec2(-8,-4) },
                    { slots: 16, position: new Vec2(8,4) },
                    { slots: 16, position: new Vec2(8,-4) },
                    { slots: 20, position: new Vec2(0,0) }
                ]
            });    
            
            maps.push( {
                name: 'intro2',
                atoms: [
                    {slots: 10, player: 0, electrons:1, spawner: 1, position: new Vec2(-8,-4)  },
                    {slots: 10, player: 1, electrons:1, spawner: 1, position: new Vec2(8,4)  },                    
                    { slots: 16, position: new Vec2(-8,0) },
                    { slots: 16, position: new Vec2(-8,4) },
                    { slots: 16, position: new Vec2(8,0) },
                    { slots: 16, position: new Vec2(8,-4) },
                    { slots: 20, position: new Vec2(0,0) }
                ]
            }); 

            maps.push( {
                name: 'hardcore',
                atoms: [
                    {slots: 10, player: 0, electrons:1, spawner: 1, position: new Vec2(-8,-4)  },
                    {slots: 10, player: 1, electrons:1, spawner: 1, position: new Vec2(8,4)  },                    
                    { slots: 20, position: new Vec2(0,0) }
                ]
            }); 

            maps.push( {
                name: 'be safe',
                atoms: [
                    {slots: 10, player: 0, electrons:1, spawner: 1, position: new Vec2(-8,0)  },
                    {slots: 10, player: 1, electrons:1, spawner: 1, position: new Vec2(8,0)  },                    
                    { slots: 16, position: new Vec2(-4,2) },
                    { slots: 16, position: new Vec2(-4,-2) },
                    { slots: 16, position: new Vec2(4,2) },
                    { slots: 16, position: new Vec2(4,-2) },
                    { slots: 20, position: new Vec2(0,4) },
                    { slots: 20, position: new Vec2(0,0) },
                    { slots: 20, position: new Vec2(0,-4) }
                ]
            });    

            maps.push( {
                name: 'mayhem',
                atoms: [
                    {slots: 10, player: 0, electrons:1, spawner: 1, position: new Vec2(-8,0)  },
                    {slots: 10, player: 1, electrons:1, spawner: 1, position: new Vec2(8,0)  },                    
                    { slots: 16, player: 1, electrons:1, position: new Vec2(-4,2) },
                    { slots: 16, player: 1, electrons:1, position: new Vec2(-4,-2) },
                    { slots: 16, player: 0, electrons:1, position: new Vec2(4,2) },
                    { slots: 16, player: 0, electrons:1, position: new Vec2(4,-2) },
                    { slots: 20, position: new Vec2(0,4) },
                    { slots: 20, position: new Vec2(0,0) },
                    { slots: 20, position: new Vec2(0,-4) }
                ]
            });    


        }        
    }

    public function getRandom():MapData{
        var index = Math.floor(Math.random()*maps.length);
        return maps[index];
    }
}