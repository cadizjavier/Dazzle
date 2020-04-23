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

    func generate() throws {
        let templates = templatesPath.glob("*")
        guard templates.count > 0 else {
            throw GeneratorError.missingTemplatesFolder
        }

        if destinationPath.exists {
            try destinationPath.delete()
        }
        try destinationPath.mkdir()

        let fileNames = templates.compactMap { $0.components.last }
        for fileName in fileNames {
            let destinationFileName = destinationPath + Path(fileName)
            let output = try renderTemplate(templateName: fileName)
            try destinationFileName.write(output)
        }
    }

    private func renderTemplate(templateName: String) throws -> String {
        return try environment.renderTemplate(
            name: templateName,
            context: tags.toDictionary()
        )
    }
}
