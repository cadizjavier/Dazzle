import Foundation

extension String {
    func pascalCase() -> String {
        self.components(separatedBy: "_")
            .map { $0.capitalized }
            .joined(separator: "")
    }
}
