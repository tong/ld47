package superposition;

import superposition.Game.MapData;

class MapStore {

    //public static function validate( data : MapData ) : Array<String> {

    public static var MAPS : Map<Int,Array<MapData>> = [
        2 => [
            {
                name: 'test2.1',
                atoms: [
                    { slots: 16, player: 0, loc: { x: -0.6, y: 0.0 }, electrons: [None,None,Spawner(1.1),Bomber,Shield], rotationSpeed: 0.3 },
                    { slots: 16, player: 1, loc: { x: 0.6, y: 0 }, electrons: [None,None,Spawner(1.1),Bomber,Shield], rotationSpeed: -0.3 },
                    { slots: 20, loc: { y: 0.6 }, rotationSpeed: 0.6 },
                    { slots: 20, loc: { y: -0.6 }, rotationSpeed: -0.6 },
                    { slots: 4, rotationSpeed: 0.3  },
                ]
            },
            {
                name: 'test2.2',
                atoms: [
                    { slots: 10, player: 0, electrons:[None,Spawner(0.2),Spawner(0.2)], loc: { x: -0.7,y: 0.6 }, rotationSpeed: 0.5 },
                    { slots: 10, player: 1, electrons:[None,Spawner(0.2),Spawner(0.2)], loc: { x: 0.7, y: 0.6 }, rotationSpeed: -0.5 },
                    { slots: 30, rotationSpeed: 0.3, loc: { y: 0.2 }  },
                    { slots: 20, rotationSpeed: 0.2, loc: { x: -0.4, y: -0.4 }  },
                    { slots: 20, rotationSpeed: -0.2, loc: { x: 0.4, y: -0.4 }  },
                ] 
            },
            {
                name: 'test2.3',
                atoms: [
                    { slots: 8, player: 0, electrons:[None,Spawner(0.2),Spawner(0.2),Bomber], loc: { x: -0.8 }, rotationSpeed: 0.25 },
                    { slots: 12, player: 0, electrons:[None], loc: { x: 0.4, y: 0.4 }, rotationSpeed: -0.25 },
                    { slots: 12, player: 0, electrons:[None], loc: { x: 0.4, y: -0.4 }, rotationSpeed: 0.25 },

                    { slots: 8, player: 1, electrons:[None,Spawner(0.2),Spawner(0.2),Bomber], loc: { x: 0.8 }, rotationSpeed: -0.25 },
                    { slots: 12, player: 1, electrons:[None], loc: { x: -0.4, y: 0.4 }, rotationSpeed: 0.25 },
                    { slots: 12, player: 1, electrons:[None], loc: { x: -0.4, y: -0.4 }, rotationSpeed: -0.25 },

                    { slots: 8, loc: { y: 0.7 }, rotationSpeed: 0.2  },
                    { slots: 22, rotationSpeed: 0.1   },
                    { slots: 8, loc: { y: -0.7 }, rotationSpeed: 0.2  },
                ] 
            },
        ],
        3 => [
            {
                name: 'test3.1',
                atoms: [
                    { slots: 10, player: 0, electrons:[None,Spawner(0.5)], loc: { x: -0.7,y: 0.6 }, rotationSpeed: 0.5 },
                    { slots: 10, player: 1, electrons:[None,Spawner(0.5)], loc: { x: 0.7, y: 0.6 }, rotationSpeed: -0.5 },
                    { slots: 10, player: 2, electrons:[None,Spawner(0.5)], loc: { y: -0.5 }, rotationSpeed: 0.5 },
                    { slots: 24, loc: { y: 0.3 }  },
                    { slots: 16, loc: { x: -0.5, y: -0.3 } },
                    { slots: 16, loc: { x: 0.5 , y: -0.3 } },
                    { slots: 8, loc: { x: -0.8 , y: -0.7 } },
                    { slots: 8, loc: { x: 0.8 , y: -0.7 } },
                ] 
            },
        ],
        4 => [
            {
                name: 'test4.1',
                atoms: [
                    { slots: 14, player: 0, electrons: [Spawner(1.2)], loc: { x: -0.7, y: 0.0 }, rotationSpeed: 0.5 },
                    { slots: 14, player: 1, electrons: [Spawner(1.2)], loc: { x: 0.7, y: 0 }, rotationSpeed: -0.5 },
                    { slots: 14, player: 2, electrons: [Spawner(1.2)], loc: { x: 0, y: .5 }, rotationSpeed: 0.5 },
                    { slots: 14, player: 3, electrons: [Spawner(1.2)], loc: { x: 0, y: -.5 }, rotationSpeed: -0.5 },
                ]
            },
        ]
    ];

}
