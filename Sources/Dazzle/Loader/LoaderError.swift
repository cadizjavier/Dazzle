import Foundation

enum LoaderError: Error {
    case missingConfigFile
    case missingSourceFile
    case unableToLoadSourceFile
    case unableToLoadYaml
    case unableToParseYaml

    var localizedDescription: String {
        switch self {
        case .missingConfigFile:
            return """
            Config file is missing.
            - Provide a config.yml file (refer to the documentation).
            or
            - Pass te path of the events filename using the -f flag.
            """
        default:
            return "Missing error description."
        }
    }
}
