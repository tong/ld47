package ld47;

import kha.graphics2.Graphics;

class Quit extends Trait {

	public function new() {
		super();
		notifyOnInit( () -> {
            var images = ['process','sulfur','syn','tong','topy','vril'];
            var img = images[Std.int(Math.random()*(images.length-1))];
            Data.getImage( '$img.png', img -> {
                function render(g:Graphics) {
                    final sw = System.windowWidth(), sh = System.windowHeight();
                    g.end();
                    g.color = 0xffffffff;
					g.drawImage( img, sw/2 - img.width/2, sh/2 - img.height/2 );
                    g.begin( false );
                }
                notifyOnRender2D( g -> {
                    render( g );
                    removeRender2D( render );
                    Tween.timer( 0.2, System.stop );
                });
            }); 
		});
    }
    
}
