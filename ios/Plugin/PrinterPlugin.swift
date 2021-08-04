import Foundation
import Capacitor
import ZebraSDK
import os

/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitorjs.com/docs/plugins/ios
 */
@objc(PrinterPlugin)
public class PrinterPlugin: CAPPlugin {
    private let implementation = Printer()
    
    @objc func setupConnection(_ call: CAPPluginCall) {
        let ip = call.getString("ip") ?? ""
        let port = call.getInt("port") ?? 0
        
        implementation.ip = ip;
        implementation.port = port;
        
        call.resolve([
            "status": "Success"
        ]);
    }
    
    @objc func discover(_ call: CAPPluginCall) {
        let hops = call.getInt("hops") ?? 1;
        let waitForResponsesTimeout = call.getInt("waitForResponsesTimeout") ?? 10000;
        
        let response = implementation.discover(hops: hops, waitForResponsesTimeout: waitForResponsesTimeout);
        
        call.resolve(response);
    }

    @objc func health(_ call: CAPPluginCall) {
        call.resolve(implementation.health())
    }
    
    @objc func print(_ call: CAPPluginCall) {
        let data = call.getString("data") ?? ""
        call.resolve(implementation.print(data: data))
    }
}
