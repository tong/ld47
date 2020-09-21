console.info("--- LD47 ---");

project.addLibrary("tron");

if (platform === Platform.HTML5) {
    project.addAssets("Assets/html5/**");
    project.targetOptions.html5.disableContextMenu = true;
    project.targetOptions.html5.canvasId = "viewport";
    //project.targetOptions.html5.scriptName = appName;
}
