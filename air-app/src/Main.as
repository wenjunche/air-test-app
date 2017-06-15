package {

import fin.desktop.ExternalWindow;
import fin.desktop.RuntimeConfiguration;
import fin.desktop.Window;

import flash.display.Sprite;
import flash.events.Event;
import flash.text.TextField;

import fin.desktop.RuntimeConfiguration;
import fin.desktop.InterApplicationBus;
import fin.desktop.System;
import fin.desktop.RuntimeLauncher;


public class Main extends Sprite {
    protected var runtimeLauncher:RuntimeLauncher;
    private var openfinSystem:fin.desktop.System;
    private var textField:TextField;

    public function Main() {
        textField = new TextField();
        textField.width = 200;
        textField.height = 100;
        textField.multiline = true;
        textField.text = "Starting OpenFin Runtime...\n";
        addChild(textField);

        var cfg:RuntimeConfiguration = new RuntimeConfiguration("Air Test App");
        cfg.appManifestUrl = "https://demoappdirectory.openf.in/desktop/config/apps/OpenFin/HelloOpenFin/app2.json";
        cfg.onConnectionReady = onConnectionReady;
        cfg.onConnectionError = onConnectionError;
        cfg.onConnectionClose = onConnectionClose;
        cfg.connectionTimeout = 15000;

        runtimeLauncher = new RuntimeLauncher(cfg);
    }


    private function onConnectionReady():void {
        textField.appendText("Connection Successful! \n");
        InterApplicationBus.getInstance().publish("AirTopic", {value: "From Air Main Window"});
        fin.desktop.System.getInstance().getVersion(function (v:String) {
            textField.appendText("Connected to Runtime " + v + "\n");
        });

        var exWindow: ExternalWindow = new ExternalWindow(stage.nativeWindow, "grid", "interapp-air");
        exWindow.joinGroup(new Window("OpenFinHelloWorld", "OpenFinHelloWorld"));
    }

    private function onConnectionError(reason:String = null):void {
        textField.appendText("Connection failed " + reason + "\n");
    }

    private function onConnectionClose(reason:String = null):void {
        textField.appendText("Connection close " + reason + "\n");
    }

    private function onExit(event:Event):void {
        textField.appendText("Exiting \n");
    }


}
}
