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
            var playerColor = Player.COLORS[player.index];
            var txt = player.name.toUpperCase();
            var numElectrons = 0;
            var numAtoms = 0;

            for( atom in game.atoms ) {
                if( atom.player == player ) {
                    numAtoms++;
                    numElectrons += atom.electrons.length;
                }
            }
            txt += ' A$numAtoms E$numElectrons';

            var percentAtoms = numAtoms/game.atoms.length;
            final width = sh*percentAtoms;

            g.color = playerColor;
            g.fillRect( px, 0, sh*percentAtoms, UI.fontSize + paddingY*2 );

            g.color = 0xff000000;
            g.drawString( txt, px + paddingX, paddingY ); 

            px += width;
        }

        //g.color = 0xff000000;
        //g.fillRect( px, 0, sh-px, UI.fontSize );

        g.popTransformation();

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

        g.begin( false );
	}
}
