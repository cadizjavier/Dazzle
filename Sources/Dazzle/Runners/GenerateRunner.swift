import Foundation

class GenerateRunner {
    private let fileName: String

    init(fileName: String) {
        self.fileName = fileName
    }

    func run() throws {
        let brain = try Loader(sourcePath: fileName).load()
        let tags = try Parser(sourceData: brain.sourceData).parse()

        let generator = Generator(
            templatesPath: brain.templatesPath,
            destinationPath: brain.destinationPath,
            tags: tags
        )

        try generator.generate()
        print("Generation finished successfully.")
    }
}
