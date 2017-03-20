import XCTest
@testable import Mine

class MineTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertEqual(Mine().text, "Hello, World!")
    }


    static var allTests : [(String, (CommandMineTests) -> () throws -> Void)] {
        return [
            ("testExample", testExample),
        ]
    }
}
