import Foundation

class GenerateRunner {
    private let fileName: String

    init(fileName: String) {
        self.fileName = fileName
    }

    func run() {
        switch Loader(sourcePath: fileName).load() {
        case .success(let brain):
            let parser = Parser(sourceData: brain.sourceData)
            switch parser.parse() {
            case .success(let tags):
                let generator = Generator(
                    templatesPath: brain.templatesPath,
                    destinationPath: brain.destinationPath,
                    tags: tags
                )

                switch generator.generate() {
                case .success:
                    print("Generation finished successfully.")
                case .failure(let error):
                    print(error.localizedDescription)
                }

            case .failure(let error):
                print(error.localizedDescription)
            }

        case .failure(let error):
            print(error.localizedDescription)
        }
    }
}
