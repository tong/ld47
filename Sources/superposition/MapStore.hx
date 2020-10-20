package superposition;

import superposition.Game.MapData;

class MapStore {

    //public static function validate( data : MapData ) : Array<String> {

    public static var MAPS : Map<Int,Array<MapData>> = [
        2 => [
            {
                name: 'mostsimple',
                atoms: [
                    { slots: 16, player: 0, loc: { x: -0.2, y: 0.0 }, electrons: [None,Bomber,Shield,Topy,Process,Swastika] },
                    { slots: 20, player: 0, loc: { x: -0.6, y: 0.5 }, electrons: [None,Bomber,Shield,Topy,Process,Swastika,Swastika,Swastika,Swastika,Swastika] },
                    
                    { slots: 16, player: 1, loc: { x: 0.2, y: 0.0 }, electrons: [None,None,None,None,Spawner(1.1)] },
                    { slots: 20, player: 1, loc: { x: 0.6, y: 0.5 }, electrons: [None,Bomber,Shield,Topy,Process,Swastika,Swastika,Swastika,Swastika,Swastika] },

                    /* { slots:  10, player: 0, loc: { x: -0.5, y: 0.6 }, electrons: [None,None] },
                    { slots:  10, player: 1, loc: { x: 0.5, y: 0.6 }, electrons: [None,None] },
                    
                    */
                    { slots: 20, loc: { x: 0, y: -0.6 } },
                ],
                //blackholes: []
            },
            {
                name: 'test2.1',
                atoms: [
                    { slots: 16, player: 0, loc: { x: -0.3, y: 0.0 }, electrons: [None,None,None,None,None,Spawner(1.1),Bomber,Shield,Topy,Process] },
                    { slots:  10, player: 0, loc: { x: -0.5, y: 0.6 }, electrons: [None,None] },
                    { slots:  10, player: 0, loc: { x: -0.5, y: -0.6 }, electrons: [None,None] },
                    
                    { slots: 16, player: 1, loc: { x: 0.3, y: 0 }, electrons: [None,None,None,None,None,Spawner(1.1),Bomber,Shield,Topy,Process] },
                    { slots: 10, player: 1, loc: { x: 0.5, y: 0.6 }, electrons: [None,None] },

                    { slots: 20, loc: { x: 0.0, y: 0.5 } },
                    { slots: 20, loc: { x: 0.0, y: -0.5 } },
                ]
            },

            {
                name: 'test3.1',
                atoms: [
                    { slots: 10, player: 0, electrons:[None,Spawner(0.5),Spawner(0.5)], loc: { x: -0.8,y: 0.6 } },
                    { slots: 10, player: 0, electrons:[None,None,Spawner(0.5),Bomber], loc: { x: -0.6,y: 0.6 } },
                    { slots: 10, player: 1, electrons:[None,Spawner(0.5),Spawner(0.5)], loc: { x: 0.8,y: 0.6 } },
                    { slots: 10, player: 1, electrons:[None,None,Spawner(0.5),Bomber], loc: { x: 0.6, y: 0.6 } },

                    //{ slots: 16, player: 2, electrons:[None,None,Spawner(0.5),Bomber], loc: { x: 0.0, y: -0.6 } },

                    { slots: 14, loc: { y: 0.7 }  },
                    { slots: 24, loc: { y: 0.1 }  },
                    { slots: 16, loc: { x: -0.5, y: -0.2 } },
                    { slots: 16, loc: { x: 0.5 , y: -0.2 } },

                    { slots: 8, loc: { x: -0.82 , y: -0.75 } },
                    { slots: 8, loc: { x: 0.82 , y: -0.75 } },
                ] 
            },

            /*
            {
                name: 'test2.1',
                atoms: [
                    { slots: 24, player: 0, loc: { x: -0.7, y: 0 }, electrons: [None,Spawner(1.1),Bomber,Shield,Topy,Process] },
                    { slots: 10, player: 0, loc: { x: -0.2, y: 0.5 }, electrons: [None,Spawner(1.1),Bomber,Shield,Topy,Process] },
                    { slots: 10, player: 0, loc: { x:  -0.2, y: -0.5 }, electrons: [None,Spawner(1.1),Bomber,Shield,Topy,Process] },
                    
                    { slots: 8, player: 1, loc: { x: 0.7, y: 0.7 }, electrons: [None,Spawner(1.1),Bomber,Shield,Topy,Process] },
                    { slots: 24, player: 1, loc: { x: 0.7, y: 0 }, electrons: [None,Spawner(1.1),Bomber,Shield,Topy,Process] },
                    { slots: 8, player: 1, loc: { x: 0.7, y: -0.7 }, electrons: [None,Spawner(1.1),Bomber,Shield,Topy,Process] },
                    { slots: 8, player: 1, loc: { x: 0.2, y: 0 }, electrons: [None,Spawner(1.1),Bomber,Shield,Topy,Process] },
                    
                    { slots: 10, loc: { x: 0, y: 0.4 } },
                    { slots: 4, loc: { x: 0, y: -0.4 } }
                ]
            },
            {
                name: 'test2.1',
                atoms: [
                    { slots: 3, player: 0, loc: { x: -0.8, y: .6 }, electrons:[None,None,None] },
                    { slots: 6, player: 0, loc: { x: -0.8, y: 0 }, electrons:[None,None,None] },
                    { slots: 10, player: 0, loc: { x: -0.5, y: 0 }, electrons:[None,None,None,None,None] },
                    { slots: 16, player: 0, loc: { x: -0.0, y: 0 }, electrons:[Bomber,Speeder(1.1),Spawner(1.1),None,None,None,None] },
                    { slots: 32, player: 0, loc: { x: 0.5, y: 0 }, electrons:[Bomber,Speeder(1.1),Spawner(1.1),None,None,None,None,None,None,None,None,None,None,None,None] },
                    // { slots: 16, player: 0, loc: { x: -.7, y: 0 }, electrons:[None,Spawner(1.2),Speeder(1.2),Bomber,Laser,] },
                    // { slots: 6, player: 0, loc: new Vec3(-0.5,-0.5)  },
                    
                    { slots: 6, player: 1, loc: { x: 0, y: 0.8}, electrons:[None] },
                    //{ slots: 10, player: 1, loc: { x: 0.5, y: 0.0 }, electrons:[None,None,None,None,None,None,None,None,None,None] },
                    //{ slots: 16, player: 1, loc: { x: 0.5, y: -0.5 }, electrons:[None,None,None,None,None,None,None,None] },
                    // { slots: 10, player: 1, loc: new Vec3(0.5,0), electrons:[None,Spawner(1.2),Speeder(1.2),Bomber,Laser,Swastika,None,None,None,None] },
                    // { slots: 4, player: 1, loc: new Vec3(0.5,0.5)  },
                    // { slots: 4, player: 1, loc: new Vec3(0.5,-0.5)  },

                    // { slots: 20, loc: new Vec3(0,0)  },
                ]
            },
            {
                name: 'test2.2',
                atoms: [
                    { slots: 10, player: 0, loc: new Vec3(-.7,.7), electrons:[Spawner(0.8)] },
                    { slots: 24, player: 0, loc: new Vec3(-.5,0), electrons:[Spawner(1.2),Swastika,Bomber] },
                    { slots: 10, player: 0, loc: new Vec3(-.7,-.7), electrons:[Spawner(0.8)] },
                    { slots: 10, player: 1, loc: new Vec3(.7,.7), electrons:[Spawner(0.8)] },
                    { slots: 24, player: 1, loc: new Vec3(.5,0), electrons:[Spawner(1.2),Swastika,Bomber] },
                    { slots: 10, player: 1, loc: new Vec3(.7,-.7), electrons:[Spawner(0.8)] },
                    { slots: 6, loc: new Vec3(0,.7) }, 
                    { slots: 6, loc: new Vec3(0,0) }, 
                    { slots: 6, loc: new Vec3(0,-.7) }, 
                ]
            },
            {
                name: 'test2.3',
                atoms: [
                    { slots: 10, player: 0, loc: new Vec3(-.5,0), electrons:[Speeder(0.2)] },
                    { slots: 10, player: 0, loc: new Vec3(-.3,0), electrons:[Speeder(-1.4)] },
                    { slots: 10, player: 1, loc: new Vec3(.5,0), electrons:[Speeder(0.2)] },
                ]
            },
            */
        ],
        3 => [

            {
                name: 'test3.1',
                atoms: [
                    { slots: 10, player: 0, electrons:[None,Spawner(0.5),Spawner(0.5)], loc: { x: -0.8,y: 0.6 } },
                    { slots: 10, player: 0, electrons:[None,None,Spawner(0.5),Bomber], loc: { x: -0.6,y: 0.6 } },
                    { slots: 10, player: 1, electrons:[None,Spawner(0.5),Spawner(0.5)], loc: { x: 0.8,y: 0.6 } },
                    { slots: 10, player: 1, electrons:[None,None,Spawner(0.5),Bomber], loc: { x: 0.6, y: 0.6 } },

                    //{ slots: 16, player: 2, electrons:[None,None,Spawner(0.5),Bomber], loc: { x: 0.0, y: -0.6 } },

                    { slots: 14, loc: { y: 0.7 }, player: 0, electrons:[None,Spawner(10.5),Bomber,Process] },
                    // { slots: 24, loc: { y: 0.1 }  },
                    { slots: 24, loc: { y: 0.1 }  },
                    { slots: 16, loc: { x: -0.5, y: -0.2 } },
                    { slots: 16, loc: { x: 0.5 , y: -0.2 } },

                    { slots: 8, loc: { x: -0.82 , y: -0.75 } },
                    { slots: 8, loc: { x: 0.82 , y: -0.75 } },
                ] 
            },

            
        ],
        4 => [
            {
                name: 'test4.1',
                atoms: [
                    { slots: 10, player: 0, electrons: [Spawner(1.2)], loc: { x: -0.7, y: 0.0 } },
                    { slots: 10, player: 1, electrons: [Spawner(1.2)], loc: { x: 0.7, y: 0 } },
                    { slots: 10, player: 2, electrons: [Spawner(1.2)], loc: { x: 0, y: .5 } },
                    { slots: 10, player: 3, electrons: [Spawner(1.2)], loc: { x: 0, y: -.5 } },
                    // { slots: 16, loc: new Vec3(-.7,.5) },
                    // { slots: 16, loc: new Vec3(-.7,-.5) },
                    // { slots: 16, loc: new Vec3(.7,.5) },
                    // { slots: 16, loc: new Vec3(.7,-.5) },
                    // { slots: 20, loc: new Vec3(0,0) }
                ]
            },
            /* {
                name: 'test4.2',
                atoms: [
                    { slots: 8, player: 0, electrons:[Spawner(1.1),None,None], loc: new Vec3(-.6,.6)  },
                    { slots: 8, player: 1, electrons:[Spawner(1.1),None,None], loc: new Vec3(.6,.6)  },
                    { slots: 8, player: 2, electrons:[Spawner(1.1),None,None], loc: new Vec3(-.6,-.6)  },
                    { slots: 8, player: 3, electrons:[Spawner(1.1),None,None], loc: new Vec3(.6,-.6)  },
                    { slots: 32, loc: new Vec3(0,0)  },                
                    { slots: 4, loc: new Vec3(0,.8)  },                
                    { slots: 4, loc: new Vec3(0,-.8)  },                
                ] 
            }, */
        ]
    ];

}
