import Foundation

enum ParserError: Error {
    case unableToLoadYaml
    case unableToParseYaml
    case unexpectedData
    case missingEventIdentifier

    var localizedDescription: String {
        switch self {
        case .unexpectedData:
            return """
                Unexpected collection in YAML. This is probably due that we are expecting a list and we are getting a collection of events.
                Review that your events list root node is called 'events:'
                """
        case .missingEventIdentifier:
            return """
                Every event should have a key called "name" that will be the identifier used in the analytics.
                """
        default:
            return "Missing error description."
        }
    }
}
