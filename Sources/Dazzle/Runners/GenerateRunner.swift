import Foundation

public class GenerateRunner {
    private let fileName: String

    public init(fileName: String) {
        self.fileName = fileName
    }

    public func run() throws {
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
