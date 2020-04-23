import Foundation

{% for collection in baseTags %}
enum {{ collection.key }}: String {
    {% for cases in collection.value %}
    case {{ cases }}
    {% endfor %}
}
{% endfor %}

enum Event {
    {% for collection in eventTags %}
    case {{ collection.name }}{% if collection.references %}({% for ref in collection.references %}{{ ref.variable }}: {{ ref.type }}{% if not forloop.last %}, {% endif %}{% endfor %}){% endif %}
    {% endfor %}

    var name: String {
        switch self {
        {% for collection in eventTags %}
        case .{{ collection.name }}:
            return "{{ collection.name }}"
        {% endfor %}
        }
    }

    var params: [String: String] {
        switch self {
        {% for collection in eventTags %}
        case .{{ collection.name }}{% if collection.references %}({% for ref in collection.references %}let {{ ref.variable }}{% if forloop.last %}{% else %}, {% endif %}{% endfor %}){% endif %}:
            return [
                {% for key, value in collection.params %}
                "{{ key }}": "{{ value }}",
                {% endfor %}
                {% for ref in collection.references %}
                "{{ ref.variable }}": {{ ref.variable }}.rawValue,
                {% endfor %}
            ]
        {% endfor %}
        }
    }
}
