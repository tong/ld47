package ld47;

import kha.math.FastMatrix3;

class HUD extends Trait {

    public var visible = true;
    
    var text = "";

	public function new() {
		super();
		//backbuffer = kha.Image.createRenderTarget(272, 480);
		//System.notifyOnFrames(game.render)
		notifyOnInit( () -> {
           /*  Data.getFont( 'mono.ttf', f -> {
                font = f;
                notifyOnUpdate( update );
                notifyOnRender2D( render );
            }); */
            notifyOnUpdate( update );
            notifyOnRender2D( render );
		});
	}

	function update() {
        var game = Game.active;
        text =  "LD47 "+Std.int( (game.time*100) )/100;
	}

	function render( g : kha.graphics2.Graphics ) {

        if( !visible ) return;

        g.end();

        final fontSize = 16;
        final textWidth = UI.font.width( fontSize, text ) ;
        
        g.color = 0xff0000ff;
        g.fillRect( 0, 0, textWidth, fontSize );
       
        g.color = 0xffffffff;
        g.font = UI.font;
		g.fontSize = fontSize;
        g.drawString( text, 0, 0 ); 

        g.begin( false );
	}
}
