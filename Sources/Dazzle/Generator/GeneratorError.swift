import Foundation

enum GeneratorError: Error {
    case missingTemplatesFolder
    case unableToRegenerateOutputFolder
    case unableToRenderTemplate

    var localizedDescription: String {
        switch self {
        case .missingTemplatesFolder:
            return """
                Templates are missing:
                You must have a "Templates" folder with at least a template file inside.
                The command "dazzle scaffold" will create the default templates for you.
                """
        default:
            return "Unable to write the generated files."
        }
    }
}
