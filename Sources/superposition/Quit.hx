package superposition;

import kha.graphics2.Graphics;

class Quit extends Trait {
	public function new() {
		super();
		notifyOnInit(() -> {
            var sw = System.windowWidth();
            var sh = System.windowHeight();
            var radius = 50;
            function render( framebuffer : Array<kha.Framebuffer> ) {
				var g = framebuffer[0].g2;
				g.begin();
				g.color = 0xffffffff;
				kha.graphics2.GraphicsExtension.fillCircle( g, sw/2-radius/2, sh/2-radius/2, radius );
                g.end();
            }
			System.notifyOnFrames( render );
			Tween.timer( 0.05, System.stop );
			// var images = ['process','sulfur','syn','tong','topy','vril'];
			// var img = images[Std.int(Math.random()*(images.length-1))];
			/*
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
			 */
		});
	}
}
