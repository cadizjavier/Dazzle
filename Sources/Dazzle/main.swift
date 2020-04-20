import ArgumentParser
import Foundation
import PathKit

struct Dazzle: ParsableCommand {
    public static let configuration = CommandConfiguration(
        abstract: "Generate analytics configuration based on YAML",
        subcommands: [Validate.self, Scaffold.self]
    )

    @Option(name: .short, help: "Name of the analytics file.")
    var fileName: String?

    func run() throws {
        MainRunner(fileName: fileName).run()
    }
}

extension Dazzle {
    struct Validate: ParsableCommand {
        static let configuration = CommandConfiguration(
            abstract: "Validates the correctness of the input events YAML."
        )

        @Option(name: .short, help: "Name of the analytics file.")
        var fileName: String?

        func run() {
            ValidateRunner(fileName: fileName).run()
        }
    }
}

extension Dazzle {
    struct Scaffold: ParsableCommand {
        static let configuration = CommandConfiguration(
            abstract:
                "Creates default templates in different languages (only Swift supported at the moment)."
        )

        func run() {
            ScaffoldRunner().run()
        }
    }
}

Dazzle.main()
