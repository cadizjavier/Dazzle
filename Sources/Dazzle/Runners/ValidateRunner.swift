import Foundation

class ValidateRunner {
    private let fileName: String

    init(fileName: String?) {
        self.fileName = fileName ?? "events.yml"
    }

    func run() {
        switch Loader(sourcePath: fileName).load() {
        case .success(let brain):
            switch Parser(sourceData: brain.sourceData).parse() {
            case .success:
                print("\(fileName) YAML is ready to use for generation.")
            case .failure(let error):
                print(error.localizedDescription)
            }
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
}
