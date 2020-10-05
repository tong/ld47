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
                    {slots: 10, player: 0, electrons:[Electron.Feature.Spawner], position: new Vec2(-8,0)  },
                    {slots: 10, player: 1, electrons:[Electron.Feature.Spawner], position: new Vec2(8,0)  },
                    {slots: 10, player: 2, electrons:[Electron.Feature.Spawner], position: new Vec2(0,4)  },
                    {slots: 10, player: 3, electrons:[Electron.Feature.Spawner], position: new Vec2(0,-4)  },
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
                    {slots: 10, player: 0, electrons:[Electron.Feature.Spawner], position: new Vec2(-8,0)  },
                    {slots: 10, player: 1, electrons:[Electron.Feature.Spawner], position: new Vec2(8,0)  },
                    {slots: 10, player: 2, electrons:[Electron.Feature.Spawner], position: new Vec2(0,4)  },                    
                    { slots: 16, position: new Vec2(-8,4) },
                    { slots: 16, position: new Vec2(-8,-4) },
                    { slots: 16, position: new Vec2(8,4) },
                    { slots: 16, position: new Vec2(8,-4) },
                    { slots: 20, position: new Vec2(0,0) }
                ] 
            });  
            
            maps.push( {
                name: 'hard',
                atoms: [
                    {slots: 8, player: 0, electrons:[Electron.Feature.Spawner], position: new Vec2(0,4)  },
                    {slots: 8, player: 1, electrons:[Electron.Feature.Spawner], position: new Vec2(-4,-4)  },
                    {slots: 8, player: 2, electrons:[Electron.Feature.Spawner], position: new Vec2(4,-4)  },                    
                    { slots: 16, position: new Vec2(0,-4) },
                    { slots: 16, position: new Vec2(2,0) },
                    { slots: 16, position: new Vec2(-2,0) }                    
                ] 
            }); 

            maps.push( {
                name: 'normal',
                atoms: [
                    {slots: 6, player: 0, electrons:[Electron.Feature.Spawner], position: new Vec2(0,4)  },
                    {slots: 6, player: 1, electrons:[Electron.Feature.Spawner], position: new Vec2(-4,-4)  },
                    {slots: 6, player: 2, electrons:[Electron.Feature.Spawner], position: new Vec2(4,-4)  },                    
                    { slots: 10, position: new Vec2(0,-4) },
                    { slots: 10, position: new Vec2(2,0) },
                    { slots: 10, position: new Vec2(-2,0) },
                    { slots: 10, position: new Vec2(-2,-2) },
                    { slots: 10, position: new Vec2(2,-2) },
                    { slots: 10, position: new Vec2(0,2) }
                ] 
            }); 

            maps.push( {
                name: 'sun',
                atoms: [
                    {slots: 6, player: 0, electrons:[Electron.Feature.Spawner], position: new Vec2(0,4)  },
                    {slots: 6, player: 1, electrons:[Electron.Feature.Spawner], position: new Vec2(-5,-4)  },
                    {slots: 6, player: 2, electrons:[Electron.Feature.Spawner], position: new Vec2(5,-4)  },                    
                    { slots: 15, position: new Vec2(0,0) },
                    { slots: 8, position: new Vec2(2,2) },
                    { slots: 8, position: new Vec2(-2,2) },
                    { slots: 8, position: new Vec2(-3,-2) },
                    { slots: 8, position: new Vec2(-2,-4) },
                    { slots: 8, position: new Vec2(3,-2) },
                    { slots: 8, position: new Vec2(2,-4) }
                ] 
            }); 
        }
        else if (players == 2){
            maps.push( {
                name: 'intro',
                atoms: [
                    {slots: 10, player: 0, electrons:[Electron.Feature.Spawner], position: new Vec2(-8,0)  },
                    {slots: 10, player: 1, electrons:[Electron.Feature.Spawner], position: new Vec2(8,0)  },                    
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
                    {slots: 10, player: 0, electrons:[Electron.Feature.Spawner, Electron.Feature.None], position: new Vec2(-8,-4)  },
                    {slots: 10, player: 1, electrons:[Electron.Feature.Spawner, Electron.Feature.None], position: new Vec2(8,4)  },                    
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
                    {slots: 10, player: 0, electrons:[Electron.Feature.Spawner, Electron.Feature.Spawner], position: new Vec2(-8,-4)  },
                    {slots: 10, player: 1, electrons:[Electron.Feature.Spawner, Electron.Feature.Spawner], position: new Vec2(8,4)  },                    
                    { slots: 20, position: new Vec2(0,0) }
                ]
            }); 

            maps.push( {
                name: 'be safe',
                atoms: [
                    {slots: 10, player: 0, electrons:[Electron.Feature.Spawner], position: new Vec2(-8,0)  },
                    {slots: 10, player: 1, electrons:[Electron.Feature.Spawner], position: new Vec2(8,0)  },                    
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
                    {slots: 10, player: 0, electrons:[Electron.Feature.Spawner], position: new Vec2(-8,0)  },
                    {slots: 10, player: 1, electrons:[Electron.Feature.Spawner], position: new Vec2(8,0)  },                    
                    { slots: 16, player: 1, electrons:[Electron.Feature.None], position: new Vec2(-4,2) },
                    { slots: 16, player: 1, electrons:[Electron.Feature.None], position: new Vec2(-4,-2) },
                    { slots: 16, player: 0, electrons:[Electron.Feature.None], position: new Vec2(4,2) },
                    { slots: 16, player: 0, electrons:[Electron.Feature.None], position: new Vec2(4,-2) },
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