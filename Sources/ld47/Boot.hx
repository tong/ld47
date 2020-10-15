package ld47;

class Boot extends Trait {
	@prop
	public var scene:String = "Mainmenu";

	public function new() {
		super();
		Log.info('Boot');
		notifyOnInit(() -> {
			ld47.UI.init(() -> {
				var kb = Input.getKeyboard();
				var mouse = Input.getMouse();
				Data.getImage('process.png', img -> {
					notifyOnUpdate(() -> {
						if (kb.started("space") || kb.started("return") || mouse.started("left")) {
							proceed();
							return;
						}
						for (i in 0...4) {
							var gp = Input.getGamepad(i);
							if (gp.started('cross')) {
								proceed();
								return;
							}
						}
					});
					notifyOnRender2D((g) -> {
						final sw = System.windowWidth();
						final sh = System.windowHeight();
						g.end();
						g.color = 0xff000000;
						g.fillRect(0, 0, sw, sh);
						g.color = 0xffffffff;
						g.drawImage(img, sw / 2 - img.width / 2, sh / 2 - img.height / 2);
						g.begin(false);
					});
					#if !kha_html5
					Tween.timer(0.2, proceed);
					#end
				});
			});
		});
	}

	inline function proceed() {
		//var win = kha.Window.get(0);
		//win.title = Main.projectName;
		// win.changeWindowFeatures( 1);
		// win.mode = Fullscreen;
		// trace(win);
		Scene.setActive(scene);
	}
}
