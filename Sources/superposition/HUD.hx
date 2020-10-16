package superposition;

import kha.math.FastMatrix3;

class HUD extends Trait {

	public var visible = true;

	public function new() {
		super();
		notifyOnInit(() -> {
			notifyOnRender2D(render);
		});
	}

	function render(g:kha.graphics2.Graphics) {
		if (!visible || Game.active.paused)
			return;

		final game = Game.active;
		final sw = System.windowWidth(), sh = System.windowHeight();
		final paddingX = 3, paddingY = 0;
		final height = UI.fontSize + paddingY * 2;

		g.end();

		g.font = UI.font;
		g.fontSize = UI.fontSize;
		g.color = 0xffffffff;

		//var transform = FastMatrix3.rotation(MathTools.degToRad(-90));
		//transform._21 = sh;
		//g.pushTransformation(transform);

		var px = 0.0;
		for (i in 0...game.players.length) {
			var player = game.players[i];
			var color = Player.COLORS[player.index];
			var atoms = game.atoms.filter(a -> a.player == player);
			var percentAtoms = atoms.length / game.atoms.length;
			var width = sh * percentAtoms;
			g.color = color;
			g.fillRect(px, 0, sh * percentAtoms, height);

			//var text = 'P' + (i + 1) + ' A' + atoms.length;
			var text = 'P' + (i + 1);
			g.color = 0xff000000;
			g.drawString(text, px + paddingX, paddingY);
			px += width;
		}

		//g.popTransformation();
		g.begin(false);
	}
}
