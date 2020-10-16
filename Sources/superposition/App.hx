package superposition;

#if kha_html5
import js.Browser.document;
import js.Browser.window;
import js.html.CanvasElement;
import kha.Macros;
#end

class App {
	static function main() {
		
		// TODO
		iron.system.Input.Gamepad.buttons = tron.Input.Gamepad.buttonsXBOX360;

		inline function start() {
			Main.main();
			Log.info(Main.projectName + ' ' + Main.projectVersion);
		}

		#if kha_html5
		window.onload = () -> {
			document.getElementById("title").remove();
			document.getElementById("footer").textContent = "v" + Main.projectVersion;
			var viewport:CanvasElement = cast document.getElementById(Macros.canvasId());
			// viewport.style.display = 'block';
			// var ctx = viewport.getContext2d({ alpha: false });
			/* var resize = () -> {
					viewport.width = Std.int(window.innerWidth * window.devicePixelRatio);
					viewport.height = Std.int(window.innerHeight * window.devicePixelRatio);
					viewport.style.width = document.documentElement.clientWidth + "px";
					viewport.style.height = document.documentElement.clientHeight + "px";
				}
				window.onresize = resize;
				resize(); */
			start();
		}
		#else
		start();
		#end
	}
}
