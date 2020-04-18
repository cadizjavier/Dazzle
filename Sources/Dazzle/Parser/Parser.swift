import Foundation
import Yams
import Stencil
import PathKit

class Parser {
    private var sourceData: [String: Any]

    init(sourceData: [String: Any]) {
        self.sourceData = sourceData
    }

    func parse() -> Result<Tags, ParserError> {
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

                            reference.append(.init(type: variable.capitalized, variable: variable))
                        } else {
                            params[key] = value
                        }
                    }

                    tags.event.append(
                        Tags.Event(
                            name: name!,
                            params: params,
                            references: reference
                        )
                    )
                }
            } else {
                guard let list = value as? [String] else {
                    return .failure(.unexpectedData)
                }
                tags.base.append(
                    Tags.Base(key: key.capitalized, value: list)
                )
            }
        }

        return .success(tags)
    }
}
