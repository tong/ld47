
const RELEASE = false;

console.info(project.name+" "+project.version);

//project.addLibrary("tron");
//project.addParameter("-main ld47.App");
//project.addParameter("--macro include('ld47.App')");

if (RELEASE) {
    project.addParameter("-dce full");
    project.addParameter("--no-traces");
    project.addDefine("analyzer-optimize");
    project.addDefine("ld47_release");
}

if (platform === Platform.HTML5) {
    project.addAssets("Assets/html5/**");
    project.targetOptions.html5.disableContextMenu = true;
    project.targetOptions.html5.canvasId = "viewport";
}
