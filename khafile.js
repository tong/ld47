// Auto-generated
let project = new Project('ld47');

project.addSources('Sources');
project.addLibrary("/home/tong/sdk/armsdk/armory");
project.addLibrary("/home/tong/sdk/armsdk/iron");
project.addLibrary("/home/tong/sdk/armsdk/lib/haxebullet");
project.addAssets("/home/tong/sdk/armsdk/lib/haxebullet/ammo/ammo.wasm.js", { notinlist: true });
project.addAssets("/home/tong/sdk/armsdk/lib/haxebullet/ammo/ammo.wasm.wasm", { notinlist: true });
project.addParameter('arm.Boot');
project.addParameter("--macro keep('arm.Boot')");
project.addParameter('arm.Title');
project.addParameter("--macro keep('arm.Title')");
project.addParameter('arm.HUD');
project.addParameter("--macro keep('arm.HUD')");
project.addParameter('armory.trait.physics.bullet.PhysicsWorld');
project.addParameter("--macro keep('armory.trait.physics.bullet.PhysicsWorld')");
project.addParameter('armory.trait.WalkNavigation');
project.addParameter("--macro keep('armory.trait.WalkNavigation')");
project.addParameter('armory.trait.internal.DebugConsole');
project.addParameter("--macro keep('armory.trait.internal.DebugConsole')");
project.addParameter('armory.trait.internal.Bridge');
project.addParameter("--macro keep('armory.trait.internal.Bridge')");
project.addParameter('arm.trait.RotateObject');
project.addParameter("--macro keep('arm.trait.RotateObject')");
project.addParameter('arm.Game');
project.addParameter("--macro keep('arm.Game')");
project.addShaders("build_ld47/compiled/Shaders/*.glsl", { noembed: false});
project.addAssets("build_ld47/compiled/Assets/**", { notinlist: true });
project.addAssets("build_ld47/compiled/Shaders/*.arm", { notinlist: true });
project.addAssets("/home/tong/sdk/armsdk/armory/Assets/brdf.png", { notinlist: true });
project.addAssets("/home/tong/sdk/armsdk/armory/Assets/smaa_area.png", { notinlist: true });
project.addAssets("/home/tong/sdk/armsdk/armory/Assets/smaa_search.png", { notinlist: true });
project.addAssets("Bundled/boot.png", { notinlist: true });
project.addAssets("Bundled/boot.wav", { notinlist: true , quality: 0.8999999761581421});
project.addAssets("Bundled/icon.png", { notinlist: true });
project.addAssets("Bundled/mono.ttf", { notinlist: false });
project.addAssets("Bundled/title.png", { notinlist: true });
project.addAssets("Bundled/title.wav", { notinlist: true , quality: 0.8999999761581421});
project.addAssets("Data/shanghai_bund_1k.hdr", { notinlist: true });
project.addShaders("/home/tong/sdk/armsdk/armory/Shaders/debug_draw/**");
project.addParameter('--times');
project.addLibrary("/home/tong/sdk/armsdk/lib/zui");
project.addAssets("/home/tong/sdk/armsdk/armory/Assets/font_default.ttf", { notinlist: false });
project.addDefine('arm_deferred');
project.addDefine('arm_csm');
project.addDefine('rp_hdr');
project.addDefine('rp_renderer=Deferred');
project.addDefine('rp_shadowmap');
project.addDefine('rp_shadowmap_cascade=1024');
project.addDefine('rp_shadowmap_cube=512');
project.addDefine('rp_background=World');
project.addDefine('rp_render_to_texture');
project.addDefine('rp_compositornodes');
project.addDefine('rp_antialiasing=SMAA');
project.addDefine('rp_supersampling=1');
project.addDefine('rp_ssgi=SSAO');
project.addDefine('arm_audio');
project.addDefine('arm_physics');
project.addDefine('arm_bullet');
project.addDefine('arm_noembed');
project.addDefine('arm_soundcompress');
project.addDefine('arm_debug');
project.addDefine('arm_ui');
project.addDefine('arm_skin');
project.addDefine('arm_particles');

const RELEASE = false;

console.info(project.name+" "+project.version);

project.addLibrary("tron");

if (RELEASE) {
    project.addParameter("-dce full");
    project.addParameter("--no-traces");
    project.addDefine("analyzer-optimize");
}

if (platform === Platform.HTML5) {
    project.addAssets("Assets/html5/**");
    project.targetOptions.html5.disableContextMenu = true;
    project.targetOptions.html5.canvasId = "viewport";
}


resolve(project);
