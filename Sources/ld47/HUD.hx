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
        /* var str = "";
        for( player in game.players ) {
            str += player.name' ';
        } */
	}

	function render( g : kha.graphics2.Graphics ) {

        if( !visible ) return;

        g.end();

        final fontSize = 16;
        final textWidth = UI.font.width( fontSize, text );
        
        g.color = 0xff0000ff;
        g.fillRect( 0, 0, textWidth, fontSize );
       
        g.color = 0xffffffff;
        g.font = UI.font;
		g.fontSize = fontSize;
        g.drawString( text, 0, 0 ); 

        /*
        var px = 0;
        for( player in game.players ) {
            var txt = 'PLAYER:'+player.name;
            var w = UI.font.width( fontSize, txt );
            px += w;
            g.color = player.color;
            g.drawString( txt, px, 0 ); 
        }
        */

        final sw = System.windowWidth();
        final sh = System.windowHeight();
        final cam = Scene.active.camera;

        g.color = 0xff000000;

        for( i in 0...Game.active.atoms.length ) {

            var atom = Game.active.atoms[i];

            var loc = atom.object.transform.world.getLoc();
			var v = new Vec4();
			v.setFrom( loc );
			v.applyproj( cam.V );
            v.applyproj( cam.P );
            
            final distance = Std.int( cam.transform.world.getLoc().distanceTo( loc ) * 100 ) / 100;
			//trace(distance);
			
			var px = Std.int( (sw/2) + sw * v.x / 2 );
            var py = Std.int( (sh/2) - sh * v.y / 2 );
            
            var text = 'A'+i;
            final textWidth = UI.font.width( fontSize, text );
            
            g.drawString( text, px - textWidth/2, py - fontSize/2 ); 
        }

        g.begin( false );
	}
}
