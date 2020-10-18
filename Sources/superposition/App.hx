package superposition;

class App {

	static function main() {
		
		inline function start() {
			
			// TODO
			//iron.system.Input.Gamepad.buttons = tron.Input.Gamepad.buttonsXBOX360;
			
			Main.main();
			Log.info(Main.projectName + ' ' + Main.projectVersion);
		
		/* 	armory.data.Config.load( () -> {
				trace(armory.data.Config.raw);
				//armory.renderpath.RenderPathCreator.applyConfig();
			}); */
		}

		#if kha_html5
		/*
		window.onload = () -> {
			document.getElementById("title").remove();
			document.getElementById("footer").textContent = "v" + Main.projectVersion;
			var viewport:CanvasElement = cast document.getElementById(Macros.canvasId());
			// viewport.style.display = 'block';
			// var ctx = viewport.getContext2d({ alpha: false });
			var resize = () -> {
					viewport.width = Std.int(window.innerWidth * window.devicePixelRatio);
					viewport.height = Std.int(window.innerHeight * window.devicePixelRatio);
					viewport.style.width = document.documentElement.clientWidth + "px";
					viewport.style.height = document.documentElement.clientHeight + "px";
				}
				window.onresize = resize;
				resize();
				start();
			}
		*/
		start();
		#else
		start();
		#end
	}
}
