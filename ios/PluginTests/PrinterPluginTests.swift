import XCTest
import ZebraSDK
@testable import Plugin

class PrinterTests: XCTestCase {
    private let implementation = Printer()

    override func setUp() {
        super.setUp()

        implementation.ip = "10.200.4.60"
        implementation.port = 9100
    }

    override func tearDown() {
        super.tearDown()
    }
    
    func testDiscover() {
        let hops = 1
        let waitForResponsesTimeout = 1000
        let response = implementation.discover(hops: hops, waitForResponsesTimeout: waitForResponsesTimeout)

        let addresses = response["payload"] as! [DiscoveredPrinter]
        
        XCTAssertEqual("10.200.4.60", addresses[0].address)
    }
    
    func testHealth() {
        let response = implementation.health()
        let printerStatus = response["payload"] as! PrinterStatus
        
        XCTAssertEqual(true, printerStatus.isReadyToPrint)
    }
    
    func testHealthWithNoConnection() {
        implementation.ip = ""
        implementation.port = 0
        
        let response = implementation.health()
        let error = response["payload"] as! String
        
        XCTAssertEqual("The connection is not open", error)
    }
    
    func testPrint() {        
        let data = "BTP010101#040999000834#05MX#06FLT NO: MX1998#09PVU 0999000834#15SEQ: 0000#16Bag Weight: 0.0 lb#17#28FLT NO: MX 1998 #29PVU#30TO#4203Aug21#43PNR NO: K1YY7Y#44KALSCHEUER/BRIAN#50BREEZE#52PVU   0999000834#53FLT NO: 1998#"
        
        let response = implementation.print(data: data)

        let status = response["status"] as! String
        
        XCTAssertEqual("Success", status)
    }
    
    func testPrintWithNoConnection() {
        implementation.ip = ""
        implementation.port = 0
        
        let data = "Easy Breezy"
        
        let response = implementation.print(data: data)
        let error = response["payload"] as! String
        
        XCTAssertEqual("The connection is not open", error)
    }
}
