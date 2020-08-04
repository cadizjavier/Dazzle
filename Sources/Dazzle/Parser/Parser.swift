import Foundation
import PathKit
import Stencil
import Yams

public class Parser {
    private var sourceData: [String: Any]
    private var tags = Tags()

    public init(sourceData: [String: Any]) {
        self.sourceData = sourceData
    }

    public func parse() throws -> Tags {
        for (key, value) in sourceData {
            /*
             Everything that is an array of dictionaries will
             be a collection of events.
             */
            if let events = value as? [[String: String]] {
                for event in events {
                    var name: String?
                    var params: [String: String] = [:]
                    var reference: [Tags.Event.Reference] = []

                    for (key, value) in event {
                        if key == "name" {
                            name = value
                        } else if value == "=input" {
                            reference.append(
                                .init(fixedInput: false, type: "String", variable: key)
                            )
                        } else if value.starts(with: "=") {
                            var variable = value
                            variable.remove(at: variable.startIndex)

                            reference.append(
                                .init(fixedInput: true, type: variable.pascalCase(), variable: variable)
                            )
                        } else {
                            params[key] = value
                        }
                    }

                    guard let identifier = name else {
                        throw ParserError.missingEventIdentifier
                    }

                    let pascalKey = key.pascalCase()
                    if tags.events[pascalKey] == nil {
                        tags.events[pascalKey] = []
                    }

                    tags.events[pascalKey]?.append(
                        Tags.Event(
                            name: identifier,
                            params: params,
                            references: reference
                        )
                    )
                }
            }

            /*
             Otherwise (array of values) it will refer as the
             the common values that can be used as multiple selections.
             */
            if let values = value as? [String] {
                tags.common.append(
                    Tags.Common(key: key.pascalCase(), value: values)
                )
            }
        }

        return tags
    }
}
