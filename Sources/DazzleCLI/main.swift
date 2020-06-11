import ArgumentParser
import Dazzle

struct Dazzle: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "A Swift command-line tool for generating analytics.",
        version: "0.1.0",
        subcommands: [Generate.self, Validate.self, Scaffold.self],
        defaultSubcommand: Generate.self
    )

    init() {}
}

extension Dazzle {
    struct Generate: ParsableCommand {
        static let configuration = CommandConfiguration(
            abstract: "Generate analytics configuration based on YAML."
        )

        @Argument(help: "Name of the analytics file.")
        var fileName: String

        func run() throws {
            try GenerateRunner(fileName: fileName).run()
        }
    }
}

extension Dazzle {
    struct Validate: ParsableCommand {
        static let configuration = CommandConfiguration(
            abstract: "Validates the correctness of the input events YAML."
        )

        @Argument(help: "Name of the analytics file.")
        var fileName: String

        func run() throws {
            try ValidateRunner(fileName: fileName).run()
        }
    }
}

extension Dazzle {
    struct Scaffold: ParsableCommand {
        static let configuration = CommandConfiguration(
            abstract:
                "Creates default templates in different languages (only Swift supported at the moment)."
        )

        func run() throws {
            try ScaffoldRunner().run()
        }
    }
}

Dazzle.main()
