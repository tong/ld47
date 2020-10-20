package superposition;

import kha.math.FastMatrix3;

using kha.graphics2.GraphicsExtension;

class HUD extends Trait {

	static inline var PADDING_X = 3;
	static inline var PADDING_Y = 0;

	public var visible = true;

	public function new() {
		super();
		notifyOnInit(() -> {
			notifyOnRender2D(render);
		});
	}

	function render(g:kha.graphics2.Graphics) {

		if (!visible || Game.active.paused || Game.active.finished )
			return;

		final sw = System.windowWidth(), sh = System.windowHeight();
		//final paddingX = 3, paddingY = 0;
		final height = UI.fontSize + PADDING_Y * 2;

		g.end();

		g.font = UI.font;
		g.fontSize = UI.fontSize;
		g.color = 0xffffffff;

		//var transform = FastMatrix3.rotation(MathTools.degToRad(-90));
		//transform._21 = sh;
		//g.pushTransformation(transform);

		var px = 0.0;
		//var cx = 8.0;

		for (i in 0...Game.active.players.length) {

			var player = Game.active.players[i];
			var color = Player.COLORS[player.index];
			var atoms = Game.active.atoms.filter(a -> a.player == player);
			var numElectrons = 0;
			var numFlyingElectrons = 0;
			for( a in atoms ) numElectrons += a.electrons.length;
			for( e in Game.active.flyingElectrons ) if( e.player == player ) numFlyingElectrons++;
			//trace('P'+player.index+': '+atoms.length+" :: "+player.atoms.length);

			g.color = color;
			g.fillRect( px, 0, 200, height );

			var text = 'P' + (i + 1) + ' A' + atoms.length+' E'+numElectrons+'/'+numFlyingElectrons;
			g.color = 0xff000000;
			g.drawString(text, px + PADDING_X, PADDING_Y );
			
			px += 200;

			/*
			var percentAtoms = atoms.length / Game.active.atoms.length;
			var width = sh * percentAtoms;
			g.color = color;
			g.fillRect(px, 0, sh * percentAtoms, height);

			var text = 'P' + (i + 1) + ' A' + atoms.length+' E'+numElectrons+'/'+numFlyingElectrons;
			//var text = 'P' + (i + 1);
			var textWidth = UI.font.width( g.fontSize, text );
			g.color = 0xff000000;
			g.drawString(text, px + paddingX, paddingY);
			*/
			
			/* //var cx = px + textWidth + paddingX*4;
			//var cx = px + paddingX*4;
			var cr = 6;
			g.color = color;
			for( i in 0...atoms.length ) {
				g.fillCircle( cx, height/2 + paddingY*2, cr );
				cx += (i*(cr*2));
			}
			
			px += width;
			*/
		}

		//g.popTransformation();
		g.begin(false);
	}
}
