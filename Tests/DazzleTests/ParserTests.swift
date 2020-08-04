import XCTest
import Dazzle

final class ParserTests: XCTestCase {

    func testSimpleIntegratedScenario() throws {

        let parser = Parser(sourceData: [
            "screen": ["home", "settings", "about"],
            "language": ["ES", "EN"],
            "home": [
                ["name": "myFirstStep", "step": "first"],
                ["name": "mySecondStep", "step": "second"]
            ],
            "settings": [
                [
                    "name": "mySettingsEvent",
                    "flow": "=input",
                    "screen": "=screen",
                    "language": "=language"
                ]
            ]
        ])

        let result = try parser.parse()

        // Test common tags
        XCTAssertEqual(result.common.count, 2)

        let screenTag = try XCTUnwrap(result.common.first(where: { $0.key == "Screen" }))
        XCTAssertEqual(screenTag.value.count, 3)

        let languageTag = try XCTUnwrap(result.common.first(where: { $0.key == "Language" }))
        XCTAssertEqual(languageTag.value.count, 2)

        // Test events tags
        XCTAssertEqual(result.events.count, 2)

        let homeTag = try XCTUnwrap(result.events["Home"])
        XCTAssertEqual(homeTag.count, 2)
        XCTAssertEqual(homeTag[0].name, "myFirstStep")
        XCTAssertEqual(homeTag[0].params["step"], "first")
        XCTAssertEqual(homeTag[1].name, "mySecondStep")
        XCTAssertEqual(homeTag[1].params["step"], "second")

        let settingsTag = try XCTUnwrap(result.events["Settings"])
        XCTAssertEqual(settingsTag.count, 1)
        XCTAssertEqual(settingsTag[0].name, "mySettingsEvent")

        XCTAssertEqual(settingsTag[0].references.count, 3)

        let flowSettingsReference = try XCTUnwrap(settingsTag[0].references.first(where: { $0.variable == "flow" }))
        XCTAssertEqual(flowSettingsReference.fixedInput, false)
        XCTAssertEqual(flowSettingsReference.type, "String")

        let screenSettingsReference = try XCTUnwrap(settingsTag[0].references.first(where: { $0.variable == "screen" }))
        XCTAssertEqual(screenSettingsReference.fixedInput, true)
        XCTAssertEqual(screenSettingsReference.type, "Screen")

        let languageSettingsReference = try XCTUnwrap(settingsTag[0].references.first(where: { $0.variable == "language" }))
        XCTAssertEqual(languageSettingsReference.fixedInput, true)
        XCTAssertEqual(languageSettingsReference.type, "Language")
    }

    static var allTests = [
        ("testParser", testSimpleIntegratedScenario),
    ]
}
