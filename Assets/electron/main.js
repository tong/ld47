'use strict';

const { app, BrowserWindow } = require("electron");

let win = null;

app.commandLine.appendSwitch('ignore-gpu-blacklist');

app.on("window-all-closed", () => {
  app.quit();
});

app.on("ready", () => {
  win = new BrowserWindow({
    width: 1920,
    height: 1080,
    //show: false,
    center: true,
    useContentSize: true,
    //resizable: true,
    icon: 'icon.svg',
    autoHideMenuBar: true,
    backgroundColor: '#000',
    backgroundThrottling: false,
    webPreferences: {
      webgl: true,
      nodeIntegration: true,
      nodeIntegrationInWorker: true,
      devTools: true
    }
  });
  //mainWindow.setContentSize
  //win.setTitle("Superposition");
  //win.webContents.openDevTools();
  win.loadFile(__dirname + '/index.html')
  win.on("closed", () => {
    win = null;
  });
  win.center();
  //win.show();
});
