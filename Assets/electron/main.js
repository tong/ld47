'use strict';

const { app, ipcMain, BrowserWindow } = require("electron");

let win;

app.commandLine.appendSwitch('ignore-gpu-blacklist');

app.on("ready",() => {
    win = new BrowserWindow({
      width: 1920,
      height: 1080,
      center: true,
      //resizable: true,
      icon: 'icon.svg',
      autoHideMenuBar: true,
      backgroundColor: '#000',
      backgroundThrottling: false,
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
