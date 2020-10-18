package superposition;

class App {

	static function main() {
		
		// TODO
		iron.system.Input.Gamepad.buttons = tron.Input.Gamepad.buttonsXBOX360;
		
		Main.main();
		Log.info(Main.projectName + ' ' + Main.projectVersion);
	
		/*	
		armory.data.Config.load( () -> {
			trace(armory.data.Config.raw);
			//armory.renderpath.RenderPathCreator.applyConfig();
		});
		*/
	}
}
