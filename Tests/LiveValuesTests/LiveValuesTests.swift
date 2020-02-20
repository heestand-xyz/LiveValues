import XCTest
@testable import LiveValues
import Foundation
import Combine

final class LiveValuesTests: XCTestCase {

    @Live<CGFloat>(default: 0.0, name: "Val", info: "Value") var val
    
    override func setUp() {
        val = 0.5
    }
    
    override func tearDown() {}
        
    func testLive() {
        XCTAssertEqual(_val.wrappedValue, 0.5)
    }
    
    func testCombine() {
        var v: CGFloat?
        let p = _val.publisher().sink { value in
            print("sink", value)
            v = value
        }
        val = 0.75
        val = 1.0
        XCTAssertNotNil(v)
        XCTAssertEqual(v, 1.0)
    }

    static var allTests = [
        ("testLive", testLive),
        ("testCombine", testCombine),
    ]
    
}
