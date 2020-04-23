import Foundation
import PathKit
import Yams

class Loader {
    private let sourcePath: String?

    init(sourcePath: String?) {
        self.sourcePath = sourcePath
    }

    func load() throws -> Brain {

        guard let sourcePath = sourcePath else {
            throw LoaderError.missingConfigFile
        }

        let path = Path(sourcePath)

        guard path.exists else {
            throw LoaderError.missingSourceFile
        }

        guard let sourceContent: String = try? path.read() else {
            throw LoaderError.unableToLoadSourceFile
        }

        guard let yamlContent = try? Yams.load(yaml: sourceContent) else {
            throw LoaderError.unableToLoadYaml
        }

        guard let yamlDictionary = yamlContent as? [String: Any] else {
            throw LoaderError.unableToParseYaml
        }

        return .init(
            templatesPath: "Templates",
            destinationPath: "Output",
            sourceData: yamlDictionary
        )
    }
}
