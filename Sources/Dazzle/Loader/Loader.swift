import Foundation
import PathKit
import Yams

class Loader {
    private let sourcePath: String?

    init(sourcePath: String?) {
        self.sourcePath = sourcePath
    }

    func load() -> Result<Brain, LoaderError> {

        guard let sourcePath = sourcePath else {
            return .failure(.missingConfigFile)
        }

        let path = Path(sourcePath)

        guard path.exists else {
            return .failure(.missingSourceFile)
        }

        guard let sourceContent: String = try? path.read() else {
            return .failure(.unableToLoadSourceFile)
        }

        guard let yamlContent = try? Yams.load(yaml: sourceContent) else {
            return .failure(.unableToLoadYaml)
        }

        guard let yamlDictionary = yamlContent as? [String: Any] else {
            return .failure(.unableToParseYaml)
        }

        return .success(.init(
            templatesPath: "Templates",
            destinationPath: "Output",
            sourceData: yamlDictionary
        ))
    }
}
