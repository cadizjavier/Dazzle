import Foundation

class ValidateRunner {
    private let fileName: String

    init(fileName: String) {
        self.fileName = fileName
    }

    func run() throws {
        let brain = try Loader(sourcePath: fileName).load()
        _ = try Parser(sourceData: brain.sourceData).parse()

        print("\(fileName) YAML is ready to use for generation.")
    }
}
