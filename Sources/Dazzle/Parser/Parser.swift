import Foundation
import PathKit
import Stencil
import Yams

class Parser {
    private var sourceData: [String: Any]

    init(sourceData: [String: Any]) {
        self.sourceData = sourceData
    }

    func parse() throws -> Tags {
        var tags = Tags()

        for (key, value) in sourceData {
            if key == "event" {
                let events = value as! [[String: String]]
                for event in events {
                    var name: String?
                    var params: [String: String] = [:]
                    var reference: [Tags.Event.Reference] = []

                    for (key, value) in event {
                        if key == "name" {
                            name = value
                        } else if value.starts(with: "=") {
                            var variable = value
                            variable.remove(at: variable.startIndex)

                            reference.append(
                                .init(type: variable.pascalCase(), variable: variable)
                            )
                        } else {
                            params[key] = value
                        }
                    }

                    guard let identifier = name else {
                        throw ParserError.missingEventIdentifier
                    }

                    tags.event.append(
                        Tags.Event(
                            name: identifier,
                            params: params,
                            references: reference
                        )
                    )
                }
            } else {
                guard let list = value as? [String] else {
                    throw ParserError.unexpectedData
                }
                tags.base.append(
                    Tags.Base(key: key.pascalCase(), value: list)
                )
            }
        }

        return tags
    }
}
