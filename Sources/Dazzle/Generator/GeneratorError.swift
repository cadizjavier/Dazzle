import Foundation

enum GeneratorError: LocalizedError {
    case missingTemplatesFolder

    var errorDescription: String {
        switch self {
        case .missingTemplatesFolder:
            return """
                Templates are missing:
                You must have a "Templates" folder with at least a template file inside.
                The command "dazzle scaffold" will create the default templates for you.
                """
        }
    }
}
