import XCTest
@testable import LiveValues
import Foundation
import Combine

@available(OSX 10.15, *)
final class LiveValuesTests: XCTestCase {

//    @Live(default: 0.0, name: "Val", info: "Value") var val: LiveFloat
    
//    var sunk: AnyCancellable!
    
    override func setUp() {
//        sunk = _val.publisher().throttle(for: .seconds(0.1), scheduler: RunLoop.current, latest: true).sink { value in
//            print("sink", value)
//        }
    }
    
    override func tearDown() {
//        sunk.cancel()
    }
    
//    func testSeconds() {
//        val = .secondsSinceNow
//        XCTAssertEqual(round(val.cg * 10) / 10, 0.0)
//        let exp = expectation(description: "Seconds")
//        RunLoop.current.add(Timer(timeInterval: 1.0, repeats: false, block: { _ in
//            XCTAssertEqual(round(self.val.cg * 10) / 10, 1.0)
//            RunLoop.current.add(Timer(timeInterval: 1.0, repeats: false, block: { _ in
//                XCTAssertEqual(round(self.val.cg * 10) / 10, 2.0)
//                RunLoop.current.add(Timer(timeInterval: 1.0, repeats: false, block: { _ in
//                    XCTAssertEqual(round(self.val.cg * 10) / 10, 3.0)
//                    exp.fulfill()
//                }), forMode: .common)
//            }), forMode: .common)
//        }), forMode: .common)
//        waitForExpectations(timeout: 3.1)
//    }
//
//    func testSink() {
//        var v: CGFloat?
//        let p = _val.publisher().sink { value in
//            print("sink", value)
//            v = value.cg
//        }
//        val = 0.75
//        val = 1.0
//        XCTAssertNotNil(v)
//        XCTAssertEqual(v, 1.0)
//        p.cancel()
//    }
//
//    func testLiveSink() {
//        val = .live
//        var v: CGFloat?
//        let p = _val.sink { value in
//            XCTAssertNotEqual(v, value.cg)
//            v = value.cg
//        }
//        wait(for: 1.0)
//        XCTAssertNotNil(v)
//        p.cancel()
//    }
//
//    func wait(for duration: Double) {
//        let exp = expectation(description: "Wait")
//        RunLoop.current.add(Timer(timeInterval: duration, repeats: false, block: { _ in
//            exp.fulfill()
//        }), forMode: .common)
//        waitForExpectations(timeout: duration + 0.1)
//    }
    
    func testHex() {
        let colors: [(String, LiveColor)] = [
            ("ff0000", .red),
            ("00ff00", .green),
            ("0000ff", .blue),
        ]
        for color in colors {
            let hexA: [Int] = LiveColor(hex: "#" + color.0).list.map({ Int(round($0 * 255)) })
            let hexB: [Int] = LiveColor(hex: color.0).list.map({ Int(round($0 * 255)) })
            let raw: [Int] = color.1.list.map({ Int(round($0 * 255)) })
            XCTAssertEqual(hexA, hexB, "Hex AB")
            XCTAssertEqual(hexA, raw, "HexARaw")
            XCTAssertEqual(hexB, raw, "HexBRaw")
        }
    }

    static var allTests = [
//        ("testSeconds", testSeconds),
//        ("testSink", testSink),
//        ("testLiveSink", testLiveSink),
        ("testHex", testHex),
    ]
    
}
