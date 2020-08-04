import Foundation

public struct Tags {
    public var common: [Common] = []
    public var events: [String: [Event]] = [:]

    func toDictionary() -> [String: Any] {
        return [
            "commonTags": common,
            "eventsTags": events,
        ]
    }

    public struct Common {
        public let key: String
        public let value: [String]
    }

    public struct Event {
        public let name: String
        public let params: [String: String]
        public let references: [Reference]

        public struct Reference {
            public let fixedInput: Bool
            public let type: String
            public let variable: String
        }
    }
}
