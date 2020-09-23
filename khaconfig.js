
const RELEASE = false;

console.info(project.name+" "+project.version);

//project.addLibrary("tron");

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
