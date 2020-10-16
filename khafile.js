// Auto-generated
let project = new Project('Superposition');

project.addSources('Sources');
project.addLibrary("/home/tong/sdk/armsdk/armory");
project.addLibrary("/home/tong/sdk/armsdk/iron");
project.addLibrary("tron");
project.addParameter('superposition.HUD');
project.addParameter("--macro keep('superposition.HUD')");
project.addParameter('superposition.Mainmenu');
project.addParameter("--macro keep('superposition.Mainmenu')");
project.addParameter('superposition.Credits');
project.addParameter("--macro keep('superposition.Credits')");
project.addParameter('superposition.PauseMenu');
project.addParameter("--macro keep('superposition.PauseMenu')");
project.addParameter('superposition.Quit');
project.addParameter("--macro keep('superposition.Quit')");
project.addParameter('superposition.Help');
project.addParameter("--macro keep('superposition.Help')");
project.addParameter('superposition.Settings');
project.addParameter("--macro keep('superposition.Settings')");
project.addParameter('superposition.Boot');
project.addParameter("--macro keep('superposition.Boot')");
project.addShaders("build_ld47/compiled/Shaders/*.glsl", { noembed: false});
project.addAssets("build_ld47/compiled/Assets/**", { notinlist: true });
project.addAssets("build_ld47/compiled/Shaders/*.arm", { notinlist: true });
project.addAssets("/home/tong/sdk/armsdk/armory/Assets/brdf.png", { notinlist: true });
project.addAssets("/home/tong/sdk/armsdk/armory/Assets/smaa_area.png", { notinlist: true });
project.addAssets("/home/tong/sdk/armsdk/armory/Assets/smaa_search.png", { notinlist: true });
project.addAssets("Bundled/font/mono.ttf", { notinlist: false });
project.addAssets("Bundled/font/title.ttf", { notinlist: false });
project.addAssets("Bundled/icon.png", { notinlist: true });
project.addAssets("Bundled/image/disktree.png", { notinlist: true });
project.addAssets("Bundled/image/process.png", { notinlist: true });
project.addAssets("Bundled/image/sulfur.png", { notinlist: true });
project.addAssets("Bundled/image/syn.png", { notinlist: true });
project.addAssets("Bundled/image/tong.png", { notinlist: true });
project.addAssets("Bundled/image/topy.png", { notinlist: true });
project.addAssets("Bundled/sound/atom_ambient_1.wav", { notinlist: true , quality: 0.8999999761581421});
project.addAssets("Bundled/sound/atom_ambient_2.wav", { notinlist: true , quality: 0.8999999761581421});
project.addAssets("Bundled/sound/atom_ambient_3.wav", { notinlist: true , quality: 0.8999999761581421});
project.addAssets("Bundled/sound/atom_ambient_4.wav", { notinlist: true , quality: 0.8999999761581421});
project.addAssets("Bundled/sound/atom_ambient_5.wav", { notinlist: true , quality: 0.8999999761581421});
project.addAssets("Bundled/sound/atom_ambient_6.wav", { notinlist: true , quality: 0.8999999761581421});
project.addAssets("Bundled/sound/atom_ambient_7.wav", { notinlist: true , quality: 0.8999999761581421});
project.addAssets("Bundled/sound/atom_ambient_8.wav", { notinlist: true , quality: 0.8999999761581421});
project.addAssets("Bundled/sound/atom_ambient_9.wav", { notinlist: true , quality: 0.8999999761581421});
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
project.addAssets("Bundled/sound/game_ambient_1.wav", { notinlist: true , quality: 0.8999999761581421});
project.addAssets("Bundled/sound/game_ambient_2.wav", { notinlist: true , quality: 0.8999999761581421});
project.addAssets("Bundled/sound/game_ambient_3.wav", { notinlist: true , quality: 0.8999999761581421});
project.addAssets("Bundled/sound/game_finish.wav", { notinlist: true , quality: 0.8999999761581421});
project.addAssets("Bundled/sound/game_start.wav", { notinlist: true , quality: 0.8999999761581421});
project.addAssets("Bundled/sound/player_death.wav", { notinlist: true , quality: 0.8999999761581421});
project.addAssets("Bundled/sound/player_move.wav", { notinlist: true , quality: 0.8999999761581421});
project.addAssets("Data/tex/Metal032/Metal032_2K_Color.jpg", { notinlist: true });
project.addAssets("Data/tex/Metal032/Metal032_2K_Displacement.jpg", { notinlist: true });
project.addAssets("Data/tex/Metal032/Metal032_2K_Metalness.jpg", { notinlist: true });
project.addAssets("Data/tex/Metal032/Metal032_2K_Normal.jpg", { notinlist: true });
project.addAssets("Data/tex/Metal032/Metal032_2K_Roughness.jpg", { notinlist: true });
project.addAssets("Data/tex/concrete_impact.png", { notinlist: true });
project.addParameter('--times');
project.addLibrary("/home/tong/sdk/armsdk/lib/zui");
project.addAssets("/home/tong/sdk/armsdk/armory/Assets/font_default.ttf", { notinlist: false });
project.addDefine('arm_deferred');
project.addDefine('arm_csm');
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
project.addDefine('rp_ssr');
project.addDefine('rp_ssr_half');
project.addDefine('rp_motionblur=Object');
project.addDefine('rp_pp');
project.addDefine('rp_chromatic_aberration');
project.addDefine('rp_gbuffer2');
project.addDefine('rp_translucency');
project.addDefine('armory');
project.addDefine('arm_audio');
project.addDefine('arm_soundcompress');
project.addDefine('arm_ui');
project.addDefine('arm_skin');
project.addDefine('arm_particles');
// --------------------------------------------------------
let RELEASE = false;
let ELECTRON = false;
// --------------------------------------------------------

var args = process.argv.slice(2);
console.info(args);
process.argv.forEach( (val,index,array) => {
    if (val === '-release') {
        RELEASE = true;
    }
    if (val === '-electron') {
        ELECTRON = true;
    }
});

console.info(project.name + "-" + project.version + " " + platform);

project.addParameter("-main superposition.App");

if (RELEASE) {
    project.addParameter("-dce full");
    //project.addParameter("--no-traces");
    project.addDefine("analyzer-optimize");
    project.addDefine("superposition_release");
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
    }
}


resolve(project);
