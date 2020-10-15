'use strict';

const { app, ipcMain, BrowserWindow } = require("electron");

let win;

//app.commandLine.appendSwitch('enable-unsafe-es3-apis');
app.commandLine.appendSwitch('ignore-gpu-blacklist');

app.on("ready",() => {
    win = new BrowserWindow({
    width: 1920,
    height: 1080,
    backgroundColor: '#000',
    //resizable: true,
    //show: false,
    autoHideMenuBar: true,
    backgroundThrottling: false,
    //experimentalFeatures: true,
    webPreferences: {
      webgl: true,
      nodeIntegration: true,
      nodeIntegrationInWorker: true
    }
  });
  win.loadFile(__dirname+'/index.html')
  win.on("closed", () => {
    win = null;
  });
});

app.on("window-all-closed", () => {
  if (process.platform !== "darwin") {
    app.quit();
  }
});

/*
ipcMain.on( 'app', function(e,a){
  console.log(e,a);
  if( a === "restart") {
    win.close();
    createWindow();
  }
});
*/
