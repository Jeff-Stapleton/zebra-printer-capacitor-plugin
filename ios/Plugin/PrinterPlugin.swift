import Foundation
import Capacitor
/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitorjs.com/docs/plugins/ios
 */
@objc(PrinterPlugin)
public class PrinterPlugin: CAPPlugin {
    private let implementation = Printer()

    @objc func echo(_ call: CAPPluginCall) {
        let value = call.getString("value") ?? ""
        call.resolve([
            "value": implementation.echo(value)
        ])
    }
    
    @objc func print(_ call: CAPPluginCall) {
        let value = call.getString("value") ?? ""
        let connection = TcpPrinterConnection.init(address: "10.200.0.212", andWithPort:6101);
         connection?.open();
         let cpcl = """
                 ^XA
                 ^FO10,0^GB385,750,3^FS
                 ^CF0,90
                 ^FO120,60^FDBNA^FS
                 ^CF0,30
                 ^FO100,150^FD\(value)^FS
                 ^FO100,180^FDREF2 BL4H8^FS
                 ^BY4,2,270
                 ^FO50,330^BC^FD9784^FS
                 ^XZ
         """;
         let data = cpcl.data(using: .utf8);
        connection?.write(data, error: nil);
             connection?.close();
             call.resolve([
                 "success": true
             ])
        }
}
