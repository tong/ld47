package superposition;

class Boot extends Trait {
	
	@prop
	public var scene:String = "Mainmenu";

	public function new() {
		super();
		Log.info('Boot');
		notifyOnInit(() -> {
			UI.init(() -> {
				Data.getImage('process.png', img -> {
					var keyboard = Input.getKeyboard();
					var mouse = Input.getMouse();
					notifyOnUpdate(() -> {
						if (keyboard.started("space") || keyboard.started("return") || mouse.started("left")) {
							proceed();
							return;
						}
						for (i in 0...4) {
							var gp = Input.getGamepad(i);
							if (gp.started('a')) {
								proceed();
								return;
							}
						}
					});
					function render( g : kha.graphics2.Graphics ) {
						var sw = System.windowWidth(), sh = System.windowHeight();
						g.end();
						g.color = 0xff000000;
						g.fillRect(0, 0, sw, sh);
						g.color = 0xffffffff;
						g.drawImage(img, sw / 2 - img.width / 2, sh / 2 - img.height / 2);
						g.begin(false);
					}
					notifyOnRender2D( g -> {
						render( g );
						removeRender2D( render );
					});
					#if !kha_html5
					Tween.timer( 0.2, proceed );
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
