package ld47;

import kha.math.FastMatrix3;

class HUD extends Trait {

    public var visible = true;
    
    var text = "";

	public function new() {
		super();
		notifyOnInit( () -> {
            //notifyOnUpdate( update );
            notifyOnRender2D( render );
		});
	}

	function update() {
	}

	function render( g : kha.graphics2.Graphics ) {

        if( !visible ) return;

        final game = Game.active;
        final sw = System.windowWidth();
        final sh = System.windowHeight();
        //final fontSize = 16;
        final padding = 4;

        g.end();

        g.font = UI.font;
		g.fontSize = UI.fontSize;
        g.color = 0xffffffff;

       /* 
       g.color = 0xff0000ff;
        g.fillRect( 0, 0, textWidth, fontSize );
        g.color = 0xffffffff;
        g.font = UI.font;
		g.fontSize = fontSize;
        g.drawString( text, 0, 0 );  */
        
        var px = 0.0;
        for( player in game.players ) {
            var txt = player.name.toUpperCase();
            var numElectrons = 0;
            var numAtoms = 0;
            for( atom in Game.active.atoms ) {
                if( atom.player == player ) {
                    numAtoms++;
                    numElectrons += atom.electrons.length;
                }
            }
            txt += ' A$numAtoms E$numElectrons';
            var txtWidth = UI.font.width( UI.fontSize, txt );
            g.color = player.color;
            g.fillRect( px, 0, txtWidth + padding*2, UI.fontSize + padding*2 );
            g.color = 0xffffffff;
            g.drawString( txt, px+padding, padding ); 
            px += txtWidth + padding*2;
        }

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
            final textWidth = UI.font.width( UI.fontSize, text );
            
            g.drawString( text, px - textWidth/2, py - UI.fontSize/2 ); 
        }

        g.begin( false );
	}
}
