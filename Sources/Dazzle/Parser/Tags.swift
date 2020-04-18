import Foundation

struct Tags {
    var base: [Base] = []
    var event: [Event] = []

    func toDictionary() -> [String: Any] {
        return [
            "baseTags": base,
            "eventTags": event
        ]
    }

    struct Base {
        let key: String
        let value: [String]
    }

    struct Event {
        let name: String
        let params: [String: String]
        let references: [Reference]

        struct Reference {
            let type: String
            let variable: String
        }
    }
}
