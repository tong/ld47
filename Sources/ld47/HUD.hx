package ld47;

import kha.math.FastMatrix3;

class HUD extends Trait {

    public var visible = true;

	public function new() {
		super();
		notifyOnInit( () -> {
            notifyOnRender2D( render );
		});
	}

	function render( g : kha.graphics2.Graphics ) {

        if( !visible ) return;

        final game = Game.active;
        final sw = System.windowWidth();
        final sh = System.windowHeight();
        final paddingX = 4;
        final paddingY = 1;
        final height = UI.fontSize + paddingY*2;

        g.end();

        g.font = UI.font;
		g.fontSize = UI.fontSize;
        g.color = 0xffffffff;

        var transform = FastMatrix3.rotation( MathTools.degToRad(-90) );
        transform._21 = sh;
		g.pushTransformation( transform );
        
        var px = 0.0;
        for( i in 0...game.players.length ) {

            var player = game.players[i];
            var color = Player.COLORS[player.index];
            
            var atoms = game.atoms.filter( a -> a.player == player );
            var percentAtoms = atoms.length / game.atoms.length;
            var width = sh * percentAtoms;
            
            g.color = color;
            g.fillRect( px, 0, sh*percentAtoms, height );
            
            var text = 'P$i A'+atoms.length;

           /*  g.color = 0xff000000;
            for( i in 0...atoms.length ) {
                g.fillRect( px + 20 + paddingX + (i*(UI.fontSize+2)), paddingY, UI.fontSize, UI.fontSize );
            } */

            g.color = 0xff000000;
            g.drawString( text, px + paddingX, paddingY ); 

            px += width;
          }

         // g.color = 0xffffffff;
          //g.fillRect( px, 0, sh-px, height );

        g.popTransformation();

        /*
        // Atom label
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
        */

        g.begin( false );
	}
}
