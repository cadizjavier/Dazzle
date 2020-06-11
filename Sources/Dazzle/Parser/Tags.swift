import Foundation

public struct Tags {
    public var base: [Base] = []
    public var event: [Event] = []

    func toDictionary() -> [String: Any] {
        return [
            "baseTags": base,
            "eventTags": event,
        ]
    }

    public struct Base {
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
