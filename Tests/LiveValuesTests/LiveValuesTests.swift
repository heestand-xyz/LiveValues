import XCTest
@testable import LiveValues
import Foundation
import Combine

final class LiveValuesTests: XCTestCase {

    @Live(default: 0.0, name: "Val", info: "Value") var val: LiveFloat
    
    override func setUp() {}
    
    override func tearDown() {}
    
    func testSeconds() {
        val = .seconds
        let exp = expectation(description: "Seconds")
        RunLoop.current.add(Timer(timeInterval: 1.0, repeats: false, block: { _ in
            XCTAssertEqual(round(self.val.cg * 10) / 10, 1.0)
            RunLoop.current.add(Timer(timeInterval: 1.0, repeats: false, block: { _ in
                XCTAssertEqual(round(self.val.cg * 10) / 10, 2.0)
                RunLoop.current.add(Timer(timeInterval: 1.0, repeats: false, block: { _ in
                    XCTAssertEqual(round(self.val.cg * 10) / 10, 3.0)
                    exp.fulfill()
                }), forMode: .common)
            }), forMode: .common)
        }), forMode: .common)
        waitForExpectations(timeout: 4.0)
    }
    
    func testSink() {
        var v: CGFloat?
        let p = _val.publisher().sink { value in
            print("sink", value)
            v = value.cg
        }
        val = 0.75
        val = 1.0
        XCTAssertNotNil(v)
        XCTAssertEqual(v, 1.0)
        p.cancel()
    }
    
    func testLiveSink() {
        val = .live
        var v: CGFloat?
        let p = _val.publisher().sink { value in
            print("sink", value)
            XCTAssertNotEqual(v, value.cg)
            v = value.cg
        }
        XCTAssertNotNil(v)
        p.cancel()
    }

    static var allTests = [
        ("testSeconds", testSeconds),
        ("testSink", testSink),
        ("testLiveSink", testLiveSink),
    ]
    
}
