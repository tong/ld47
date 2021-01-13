// Auto-generated
let project = new Project('superposition_0_3_29');

project.addSources('Sources');
project.addLibrary("/home/tong/sdk/armsdk/armory");
project.addLibrary("/home/tong/sdk/armsdk/iron");
project.addLibrary("tron");
project.addLibrary("/home/tong/sdk/armsdk/lib/haxebullet");
project.addAssets("/home/tong/sdk/armsdk/lib/haxebullet/ammo/ammo.wasm.js", { notinlist: true });
project.addAssets("/home/tong/sdk/armsdk/lib/haxebullet/ammo/ammo.wasm.wasm", { notinlist: true });
project.addParameter('armory.trait.physics.bullet.RigidBody');
project.addParameter("--macro keep('armory.trait.physics.bullet.RigidBody')");
project.addParameter('superposition.Quit');
project.addParameter("--macro keep('superposition.Quit')");
project.addParameter('superposition.Credits');
project.addParameter("--macro keep('superposition.Credits')");
project.addParameter('superposition.trait.RotateObject');
project.addParameter("--macro keep('superposition.trait.RotateObject')");
project.addParameter('superposition.electron.Bomber');
project.addParameter("--macro keep('superposition.electron.Bomber')");
project.addParameter('superposition.Help');
project.addParameter("--macro keep('superposition.Help')");
project.addParameter('superposition.Boot');
project.addParameter("--macro keep('superposition.Boot')");
project.addParameter('superposition.Mainmenu');
project.addParameter("--macro keep('superposition.Mainmenu')");
project.addParameter('superposition.ui.PauseMenu');
project.addParameter("--macro keep('superposition.ui.PauseMenu')");
project.addParameter('armory.trait.physics.bullet.PhysicsWorld');
project.addParameter("--macro keep('armory.trait.physics.bullet.PhysicsWorld')");
project.addParameter('superposition.Marker');
project.addParameter("--macro keep('superposition.Marker')");
project.addParameter('superposition.Game');
project.addParameter("--macro keep('superposition.Game')");
project.addShaders("build_ld47/compiled/Shaders/*.glsl", { noembed: false});
project.addAssets("build_ld47/compiled/Assets/**", { notinlist: true });
project.addAssets("build_ld47/compiled/Shaders/*.arm", { notinlist: true });
project.addAssets("/home/tong/sdk/armsdk/armory/Assets/brdf.png", { notinlist: true });
project.addAssets("/home/tong/sdk/armsdk/armory/Assets/smaa_area.png", { notinlist: true });
project.addAssets("/home/tong/sdk/armsdk/armory/Assets/smaa_search.png", { notinlist: true });
project.addAssets("Bundled/config.arm", { notinlist: true });
project.addAssets("Bundled/font/mono.ttf", { notinlist: false });
project.addAssets("Bundled/font/title.ttf", { notinlist: false });
project.addAssets("Bundled/icon.png", { notinlist: true });
project.addAssets("Bundled/image/process.png", { notinlist: true });
project.addAssets("Bundled/image/syn.png", { notinlist: true });
project.addAssets("Bundled/image/tong.png", { notinlist: true });
project.addAssets("Bundled/image/topy.png", { notinlist: true });
project.addAssets("Bundled/image/vril.png", { notinlist: true });
project.addAssets("Bundled/sound/atom_death.wav", { notinlist: true , quality: 0.8999999761581421});
project.addAssets("Bundled/sound/atom_takeover.wav", { notinlist: true , quality: 0.8999999761581421});
project.addAssets("Bundled/sound/boot.wav", { notinlist: true , quality: 0.8999999761581421});
project.addAssets("Bundled/sound/electron_death.wav", { notinlist: true , quality: 0.8999999761581421});
project.addAssets("Bundled/sound/electron_fire_deny.wav", { notinlist: true , quality: 0.8999999761581421});
project.addAssets("Bundled/sound/electron_fire_p1.wav", { notinlist: true , quality: 0.8999999761581421});
project.addAssets("Bundled/sound/electron_fire_p2.wav", { notinlist: true , quality: 0.8999999761581421});
project.addAssets("Bundled/sound/electron_fire_p3.wav", { notinlist: true , quality: 0.8999999761581421});
project.addAssets("Bundled/sound/electron_fire_p4.wav", { notinlist: true , quality: 0.8999999761581421});
project.addAssets("Bundled/sound/electron_hit.wav", { notinlist: true , quality: 0.8999999761581421});
project.addAssets("Bundled/sound/game_finish.wav", { notinlist: true , quality: 0.8999999761581421});
project.addAssets("Bundled/sound/game_start.wav", { notinlist: true , quality: 0.8999999761581421});
project.addAssets("Bundled/sound/player_death.wav", { notinlist: true , quality: 0.8999999761581421});
project.addAssets("Bundled/sound/player_move.wav", { notinlist: true , quality: 0.8999999761581421});
project.addAssets("Data/hdr/shanghai_bund_1k.hdr", { notinlist: true });
project.addAssets("Data/tex/Metal032/Metal032_2K_Color.jpg", { notinlist: true });
project.addAssets("Data/tex/Metal032/Metal032_2K_Displacement.jpg", { notinlist: true });
project.addAssets("Data/tex/Metal032/Metal032_2K_Metalness.jpg", { notinlist: true });
project.addAssets("Data/tex/Metal032/Metal032_2K_Normal.jpg", { notinlist: true });
project.addAssets("Data/tex/Metal032/Metal032_2K_Roughness.jpg", { notinlist: true });
project.addAssets("Data/tex/MetalPlates004/MetalPlates004_2K_Color.jpg", { notinlist: true });
project.addAssets("Data/tex/MetalPlates004/MetalPlates004_2K_Metalness.jpg", { notinlist: true });
project.addAssets("Data/tex/MetalPlates004/MetalPlates004_2K_Normal.jpg", { notinlist: true });
project.addAssets("Data/tex/MetalPlates004/MetalPlates004_2K_Roughness.jpg", { notinlist: true });
project.addAssets("Data/tex/concrete_impact.png", { notinlist: true });
project.addAssets("Data/tex/gridbox1.png", { notinlist: true });
project.addParameter('--times');
project.addLibrary("/home/tong/sdk/armsdk/lib/zui");
project.addAssets("/home/tong/sdk/armsdk/armory/Assets/font_default.ttf", { notinlist: false });
project.addDefine('arm_deferred');
project.addDefine('arm_csm');
project.addDefine('arm_clusters');
project.addDefine('rp_hdr');
project.addDefine('rp_renderer=Deferred');
project.addDefine('rp_shadowmap');
project.addDefine('rp_shadowmap_cascade=2048');
project.addDefine('rp_shadowmap_cube=1024');
project.addDefine('rp_background=World');
project.addDefine('rp_render_to_texture');
project.addDefine('rp_compositornodes');
project.addDefine('rp_antialiasing=SMAA');
project.addDefine('arm_veloc');
project.addDefine('rp_supersampling=1');
project.addDefine('rp_ssgi=SSAO');
project.addDefine('rp_bloom');
project.addDefine('rp_motionblur=Object');
project.addDefine('rp_pp');
project.addDefine('rp_chromatic_aberration');
project.addDefine('rp_gbuffer2');
project.addDefine('rp_translucency');
project.addDefine('arm_physics');
project.addDefine('arm_bullet');
project.addDefine('arm_noembed');
project.addDefine('arm_soundcompress');
project.addDefine('arm_audio');
project.addDefine('arm_ui');
project.addDefine('arm_skin');
project.addDefine('arm_particles');
project.addDefine('arm_config');
// --------------------------------------------------------
let RELEASE = false;
let ELECTRON = false;
// --------------------------------------------------------

let args = process.argv.slice(2);
process.argv.forEach( (val,index,array) => {
    if (val === '-release') {
        RELEASE = true;
    }
    if (val === '-electron') {
        ELECTRON = true;
    }
});

console.info(project.name + "-" + project.version + " " + platform);

//project.addAssets("Assets/sound/**",{quality: 0.9});
project.addParameter("-main superposition.App");0
//project.addParameter("--macro 'superposition.Build.app()'");
project.addDefine("source-map");
project.addDefine("source-header=");

if (RELEASE) {
    project.addParameter("-dce full");
    //project.addParameter("--no-traces");
    project.addDefine("analyzer-optimize");
    project.addDefine("superposition_release");
} else {
    
}

//const proc = require('child_process');

if (platform === Platform.HTML5) {
    project.targetOptions.html5.disableContextMenu = true;
    project.targetOptions.html5.canvasId = "viewport";
    project.addAssets("Data/icon.svg");
    if (ELECTRON) {
        project.addAssets("Assets/electron/**");
        project.addLibrary("electron");
        //callbacks.postHaxeCompilation = () => {};
    } else {
        project.addAssets("Assets/web/**");
        //project.targetOptions.html5.scriptName = 'app';
    }
}


resolve(project);
