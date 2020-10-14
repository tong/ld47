package ld47;

class App {

	static function main() {
		//TODO
		iron.system.Input.Gamepad.buttons = tron.Input.Gamepad.buttonsXBOX360;
		Main.main();
		Log.info( Main.projectName+' '+Main.projectVersion );
	}
}
