package ld47;

import ld47.Game.MapData;

class MapStore {

    public static var MAPS : Map<Int,Array<MapData>> = [
        2 => [
            {
                name: 'test1',
                atoms: [
                    { slots: 10, player: 0, position: new Vec2(-.5,0), electrons:[None,Spawner(1.2),Speeder(2.0),Bomber,Shield,Laser,Swastika] },
                    { slots: 10, player: 0, position: new Vec2(-0.5,0.5)  },
                    { slots: 10, player: 0, position: new Vec2(-0.5,-0.5)  },
                    { slots: 10, player: 1, position: new Vec2(0.5,0), electrons:[None,Spawner(1.2),Speeder(2.0),Bomber,Shield,Laser,Swastika] },
                    { slots: 10, player: 1, position: new Vec2(0.5,0.5)  },
                    { slots: 10, player: 1, position: new Vec2(0.5,-0.5)  },
                    { slots: 20, position: new Vec2(0,0)  },
                ]
            },
        ],
        3 => [
            {
                name: 'test1',
                atoms: [
                    { slots: 10, player: 0, electrons:[Spawner(1.2)], position: new Vec2(-.7,0)  },
                    { slots: 10, player: 1, electrons:[Spawner(1.2)], position: new Vec2(.7,0)  },
                    { slots: 10, player: 2, electrons:[Spawner(1.2)], position: new Vec2(0,.3)  },                    
                ] 
            },
        ],
        4 => [
            {
                name: 'test1',
                atoms: [
                    { slots: 10, player: 0, electrons: [Spawner(1.2)], position: new Vec2(-.7,0)  },
                    { slots: 10, player: 1, electrons: [Spawner(1.2)], position: new Vec2(.7,0)  },
                    { slots: 10, player: 2, electrons: [Spawner(1.2)], position: new Vec2(0,.5)  },
                    { slots: 10, player: 3, electrons: [Spawner(1.2)], position: new Vec2(0,-.5)  },
                    { slots: 16, position: new Vec2(-.7,.5) },
                    { slots: 16, position: new Vec2(-.7,-.5) },
                    { slots: 16, position: new Vec2(.7,.5) },
                    { slots: 16, position: new Vec2(.7,-.5) },
                    { slots: 20, position: new Vec2(0,0) }
                ]
            }
        ]
    ];

}
