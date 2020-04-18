import PathKit
import Stencil

class Generator {
    private let templatesPath: Path
    private let destinationPath: Path
    private let tags: Tags

    private let environment: Environment

    init(templatesPath: Path, destinationPath: Path, tags: Tags) {
        self.templatesPath = templatesPath
        self.destinationPath = destinationPath
        self.tags = tags

        let fsLoader = FileSystemLoader(paths: [templatesPath])
        environment = Environment(
            loader: fsLoader,
            extensions: nil,
            templateClass: StencilSwiftTemplate.self
        )
    }

    func generate() -> Result<Void, Error> {
        let templates = templatesPath.glob("*")
        let fileNames = templates.compactMap { $0.components.last }

        do {
            if destinationPath.exists {
                try destinationPath.delete()
            }
            try destinationPath.mkdir()

            for fileName in fileNames {
                let destinationFileName = destinationPath + Path(fileName)
                let output = try renderTemplate(templateName: fileName)
                try destinationFileName.write(output)
            }

            return .success(())
        } catch let error {
            return .failure(error)
        }
    }

    private func renderTemplate(templateName: String) throws -> String {
        return try environment.renderTemplate(
            name: templateName,
            context: tags.toDictionary()
        )
    }
}
