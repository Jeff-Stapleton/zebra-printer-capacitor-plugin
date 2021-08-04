import Foundation
import ZebraSDK
import os

@objc public class Printer: NSObject {
    public var ip: String = "";
    public var port: Int = 0;

    @objc private func errorHandle(error: Error) -> Dictionary<String, Any> {
        return [
            "status": "Failed",
            "payload": error.localizedDescription
        ]
    }
    
    @objc public func discover(hops: Int, waitForResponsesTimeout: Int) -> Dictionary<String, Any> {
        do {
            let addresses = try NetworkDiscoverer.multicast(withHops: hops, andWaitForResponsesTimeout: waitForResponsesTimeout) as! [DiscoveredPrinter]
            return [
                "status": "Success",
                "payload": addresses
            ]
        } catch {
            return errorHandle(error: error);
        }
    }
    
    @objc public func health() -> Dictionary<String, Any> {
        let connection = TcpPrinterConnection.init(address: ip, andWithPort: port);
        connection?.open();
        
        do {
            let printer = try ZebraPrinterFactory.getInstance(connection);
            do {
                let status = try printer.getCurrentStatus();
                connection?.close();
                return [
                    "status": "Success",
                    "payload" : status
                ]
            } catch {
                throw error
            }
        } catch {
            connection?.close();
            return errorHandle(error: error);
        }
    }
    
    @objc public func print(data: String) -> Dictionary<String, Any> {
        let connection = TcpPrinterConnection.init(address: ip, andWithPort: port);
        connection?.open();
        // TODO: figure out the format of the bag tag print stream
        let cpcl = """
            ^XA
            ^FO10,0^GB385,750,3^FS
            ^CF0,90
            ^FO120,60^FDBNA^FS
            ^CF0,30
            ^FO100,150^FD\(data)^FS
            ^FO100,180^FDREF2 BL4H8^FS
            ^BY4,2,270
            ^FO50,330^BC^FD9784^FS
            ^XZ
        """;
        let request = cpcl.data(using: .utf8);
        
        var error: NSError? = nil
        connection?.write(request, error: &error);
        connection?.close();
        
        if (error == nil) {
            return [
                "status": "Success",
                "payload": []
            ]
        } else {
            return errorHandle(error: error!)
        }
    }
}
