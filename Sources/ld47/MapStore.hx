package ld47;

import ld47.Game.MapData;

class MapStore {

    public static var MAPS : Map<Int,Array<MapData>> = [
        2 => [
            {
                name: 'intro',
                atoms: [
                    { slots: 10, player: 0, electrons:[Spawner], position: new Vec2(-7,0)  },
                    { slots: 10, player: 1, electrons:[Spawner], position: new Vec2(7,0)  },                    
                    { slots: 16, position: new Vec2(-7,3) },
                    { slots: 16, position: new Vec2(-7,-3) },
                    { slots: 16, position: new Vec2(7,3) },
                    { slots: 16, position: new Vec2(7,-3) },
                    { slots: 20, position: new Vec2(0,0) }
                ]
            },
            {
                name: 'intro2',
                atoms: [
                    { slots: 10, player: 0, electrons:[Spawner, None], position: new Vec2(-7,-3)  },
                    { slots: 10, player: 1, electrons:[Spawner, None], position: new Vec2(7,3)  },                    
                    { slots: 16, position: new Vec2(-7,0) },
                    { slots: 16, position: new Vec2(-7,3) },
                    { slots: 16, position: new Vec2(7,0) },
                    { slots: 16, position: new Vec2(7,-3) },
                    { slots: 20, position: new Vec2(0,0) }
                ]
            },
            {
                name: 'hardcore',
                atoms: [
                    { slots: 10, player: 0, electrons:[Spawner, Spawner], position: new Vec2(-7,-3)  },
                    { slots: 10, player: 1, electrons:[Spawner, Spawner], position: new Vec2(7,3)  },                    
                    { slots: 20, position: new Vec2(0,0) }
                ]
            },
            {
                name: 'be safe',
                atoms: [
                    { slots: 10, player: 0, electrons:[Spawner], position: new Vec2(-7,0)  },
                    { slots: 10, player: 1, electrons:[Spawner], position: new Vec2(7,0)  },                    
                    { slots: 16, position: new Vec2(-4,2) },
                    { slots: 16, position: new Vec2(-4,-2) },
                    { slots: 16, position: new Vec2(4,2) },
                    { slots: 16, position: new Vec2(4,-2) },
                    { slots: 20, position: new Vec2(0,3) },
                    { slots: 20, position: new Vec2(0,0) },
                    { slots: 20, position: new Vec2(0,-3) }
                ]
            },
            {
                name: 'mayhem',
                atoms: [
                    { slots: 10, player: 0, electrons:[Spawner], position: new Vec2(-7,0)  },
                    { slots: 10, player: 1, electrons:[Spawner], position: new Vec2(7,0)  },                    
                    { slots: 16, player: 1, electrons:[None], position: new Vec2(-4,2) },
                    { slots: 16, player: 1, electrons:[None], position: new Vec2(-4,-2) },
                    { slots: 16, player: 0, electrons:[None], position: new Vec2(4,2) },
                    { slots: 16, player: 0, electrons:[None], position: new Vec2(4,-2) },
                    { slots: 20, position: new Vec2(0,3) },
                    { slots: 20, position: new Vec2(0,0) },
                    { slots: 20, position: new Vec2(0,-3) }
                ]
            },
            {
                name: 'showdown',
                atoms: [
                    { slots: 10, player: 0, electrons:[Spawner,None,None], position: new Vec2(-7,0)  },
                    { slots: 10, player: 1, electrons:[Spawner,None,None], position: new Vec2(7,0)  },                    
                ]
            }
        ],
        3 => [
            {
                name: 'intro',
                atoms: [
                    { slots: 10, player: 0, electrons:[Spawner], position: new Vec2(-7,0)  },
                    { slots: 10, player: 1, electrons:[Spawner], position: new Vec2(7,0)  },
                    { slots: 10, player: 2, electrons:[Spawner], position: new Vec2(0,3)  },                    
                    { slots: 16, position: new Vec2(-7,3) },
                    { slots: 16, position: new Vec2(-7,-3) },
                    { slots: 16, position: new Vec2(7,3) },
                    { slots: 16, position: new Vec2(7,-3) },
                    { slots: 20, position: new Vec2(0,0) }
                ] 
            },
            {
                name: 'hard',
                atoms: [
                    { slots: 7, player: 0, electrons:[Spawner], position: new Vec2(0,3)  },
                    { slots: 7, player: 1, electrons:[Spawner], position: new Vec2(-4,-3)  },
                    { slots: 7, player: 2, electrons:[Spawner], position: new Vec2(4,-3)  },                    
                    { slots: 16, position: new Vec2(0,-3) },
                    { slots: 16, position: new Vec2(2,0) },
                    { slots: 16, position: new Vec2(-2,0) }                    
                ] 
            },
            {
                name: 'normal',
                atoms: [
                    { slots: 6, player: 0, electrons:[Spawner], position: new Vec2(0,3)  },
                    { slots: 6, player: 1, electrons:[Spawner], position: new Vec2(-4,-3)  },
                    { slots: 6, player: 2, electrons:[Spawner], position: new Vec2(4,-3)  },                    
                    { slots: 10, position: new Vec2(0,-3) },
                    { slots: 10, position: new Vec2(2,0) },
                    { slots: 10, position: new Vec2(-2,0) },
                    { slots: 10, position: new Vec2(-2,-2) },
                    { slots: 10, position: new Vec2(2,-2) },
                    { slots: 10, position: new Vec2(0,2) }
                ] 
            },
            {
                name: 'sun',
                atoms: [
                    { slots: 6, player: 0, electrons:[Spawner], position: new Vec2(0,3)  },
                    { slots: 6, player: 1, electrons:[Spawner], position: new Vec2(-5,-3)  },
                    { slots: 6, player: 2, electrons:[Spawner], position: new Vec2(5,-3)  },                    
                    { slots: 16, position: new Vec2(0,-1) },
                    { slots: 7, position: new Vec2(2,2) },
                    { slots: 7, position: new Vec2(-2,2) },
                    { slots: 7, position: new Vec2(-3,-2) },
                    { slots: 7, position: new Vec2(-2,-3) },
                    { slots: 7, position: new Vec2(3,-2) },
                    { slots: 7, position: new Vec2(2,-3) }
                ] 
            }
        ],
        4 => [
            {
                name: 'intro',
                atoms: [
                    { slots: 10, player: 0, electrons: [Spawner], position: new Vec2(-7,0)  },
                    { slots: 10, player: 1, electrons: [Spawner], position: new Vec2(7,0)  },
                    { slots: 10, player: 2, electrons: [Spawner], position: new Vec2(0,3)  },
                    { slots: 10, player: 3, electrons: [Spawner], position: new Vec2(0,-3)  },
                    { slots: 16, position: new Vec2(-7,3) },
                    { slots: 16, position: new Vec2(-7,-3) },
                    { slots: 16, position: new Vec2(7,3) },
                    { slots: 16, position: new Vec2(7,-3) },
                    { slots: 20, position: new Vec2(0,0) }
                ]
            },
            {
                name: 'empty',
                atoms: [
                    { slots: 10, player: 0, electrons: [Spawner,None,None,None], position: new Vec2(-4,4)  },
                    { slots: 10, player: 1, electrons: [Spawner,None,None,None], position: new Vec2(4,4)  },
                    { slots: 10, player: 2, electrons: [Spawner,None,None,None], position: new Vec2(-4,-4)  },
                    { slots: 10, player: 3, electrons: [Spawner,None,None,None], position: new Vec2(4,-4)  },
                ]
            },
            {
                name: 'no_mercy',
                atoms: [
                    { slots: 10, player: 0, electrons: [None,None,None,None,None,None,None,None], position: new Vec2(-4,4)  },
                    { slots: 10, player: 1, electrons: [None,None,None,None,None,None,None,None], position: new Vec2(4,4)  },
                    { slots: 10, player: 2, electrons: [None,None,None,None,None,None,None,None], position: new Vec2(-4,-4)  },
                    { slots: 10, player: 3, electrons: [None,None,None,None,None,None,None,None], position: new Vec2(4,-4)  },
                ]
            }
        ]
    ];

}
