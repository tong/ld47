package ld47;

import kha.graphics2.Graphics;

class Quit extends Trait {

	public function new() {
		super();
		//gamma.renderpath.Postprocess.camera_uniforms[10] = 0.0;
		notifyOnInit( () -> {
			Log.info( 'Quit' );
            if( Input.mouse.locked ) Input.mouse.unlock();
            Data.getImage( 'quit.png', img -> {
                function render(g:Graphics) {
                    final sw = System.windowWidth();
                    final sh = System.windowHeight();
                    g.end();
                    g.color = 0xff0000ff;
                    g.fillRect( 0, 0, sw, sh );
                    g.color = 0xffffffff;
					g.drawImage( img, sw/2 - img.width/2, sh/2 - img.height/2 );
                    g.begin( false );
                }
                notifyOnRender2D( g -> {
                    render( g );
                    removeRender2D( render );
                    System.stop();
                });
            });
		});
	}
}
