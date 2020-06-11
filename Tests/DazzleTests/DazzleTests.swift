import XCTest
import Dazzle

final class DazzleTests: XCTestCase {

    func testParser() throws {

        let parser = Parser(sourceData: [
            "screen": [
                "home",
                "settings"
            ],
            "event": [
                [
                    "name": "myCustomEvent",
                    "flow": "onboarding",
                    "screen": "=screen"
                ]
            ]
        ])

        let result = try parser.parse()

        XCTAssert(result.base.count == 1)
        XCTAssert(result.event.count == 1)

        let references = try XCTUnwrap(result.event.first?.references)
        XCTAssert(references.count == 1)
        let variable = try XCTUnwrap(references.first)
        XCTAssert(variable.fixedInput == true)
        XCTAssert(variable.type == "Screen")
        XCTAssert(variable.variable == "screen")
    }

    static var allTests = [
        ("testParser", testParser),
    ]
}
