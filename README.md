# Dazzle

Dazzle is a command-line tool for parsing and generating analytics code based on a single YAML.
Initially we only support Swift generation.

> Note: This tool is also useful as a general-purpose tool for generating enumerations based on a YAML. We will be referring only to analytics generation to maintain simplicity and to reduce the scope of the initial implementation.

## Quick Start

1. Inside your brand new project folder create an `events.yml` file and put the following inside.

```yaml
screen:
  - home
  - settings

event:
  -
    name: user_tap_button
    flow: onboarding
    screen: =screen
```

2. Run `dazzle scaffold`. This will create full-featured templates (only Swift supported at the moment) for you. You can modify these templates or create your custom ones.
A new folder named `Templates` will be created.

3. Run `dazzle generate events.yml` and after the success message, you will see an `Output` folder with your brand new generated files. If you open the Swift one you will see something like this.

```swift
import Foundation

enum Screen: String {
    case home
    case settings
}

enum Event {
    case user_tap_button(screen: Screen)

    var name: String {
        switch self {
        case .user_tap_button:
            return "user_tap_button"
        }
    }

    var params: [String: String] {
        switch self {
        case .user_tap_button(let screen):
            return [
                "flow": "onboarding",
                "screen": screen.rawValue
            ]
        }
    }
}
```

## Installation

### Make

```sh
$ git clone https://github.com/cadizjavier/Dazzle.git
$ cd Dazzle
$ make install
```

## Usage

### CLI commands

`dazzle generate events.yml` Do code generation for the events defined on the `events.yml` file. This is the default command, if you omit the `generate` word it will work.

`dazzle scaffold` Copy all the predefined templates to your project.

`dazzle validate events.yml` Validates that the provided YAML complies with the supported DSL.

### YAML DSL


#### General spec

You can define as many events as you want and the dictionary can have any amount of key-value pairs.

```yaml
screen:
  - home
  - settings

firstFlow:
  -
    name: event_1
    control: list
    action: swipe

secondFlow:
  -
    name: event_2
    action: tap
```

There are two types of root nodes:

1. An array of elements defines the possible different states that a key could have. These are support nodes for reusable values.

2. An array of dictionaries defines the events. Every element of the array needs to have a key called `name`. This key will be the identifier for the generated enumeration. These are the main nodes and contains the actual tracked events. You can have as many of these nodes as you want.

#### Variables

Two types of variables exist:

  - Let's say for example that our `event_1` can be triggered using `swipe` or `tap`. You can define an `action` variable that includes both states and then refer to that variable with the `=` prefix like so.

  - For free input variable text the tag `=input` is provided.

Example:

```yaml
action:
  - tap
  - swipe

events:
  -
    name: event_1
    control: list
    action: =action
    input: =input
```

### Integration

Let's say that you want to generate analytics for your brand new app using this tool. If we import the generated file used on the Quick Start section we will only need to define our custom Analytics class like this:

```swift
class MyAnalytics {

    static func log(event: Event) {
        // Firebase example of custom event
        Analytics.logEvent(event.name, parameters: event.params)
    }
}
```

That's it, the generation is done in such a way that creates the name and the params for you based on a simple easy to read YAML that can be created by anyone.

To trigger any analytics event you must only do.

```swift
// Refered to the Quick Start generation:
MyAnalytics.log(event: .event_1(action: .tap))
```

### Benefits

- It will log for you any additional static param. (like the `control` key or any field that is not a variable)

- Since everything is type-safe you are avoiding typos on your strings params.

- The compiler will warn you in case a new generation has different sets of variables or even if an event no longer exists.


### Exposed Stencil variables

- `baseTag` 
It provides all the info relative to the root nodes that will act as the variables of the events.
Each element of the collection is a variable with all the possible states and the following structure:
    - `key`: The name of the root node.
    - an array of `value`: Each of the possible values for that node key.

- `eventTag` Provides a collection of all the possible events.
Each element of the collection has the following structure:
    - `name`: The primary identifier of the event.
    - `params`: A dictionary of type [String: String] that has all the remaining keys and values of all the parameters of the event.
    - `references`: Since an event can contain variables, this structure has an array of all the defined variables (character `=` in the YAML) as follow:
        - `fixedInput`: Boolean that identifies if the value is based on fixed values or if is a free input.
        - `type`: The type of the variable.
        - `variable`: The name of the variable.


## Attributions

This tool is powered by:

- [Stencil](https://github.com/stencilproject/Stencil)
- [SwiftArgumentParser](https://github.com/apple/swift-argument-parser)
- [Yams](https://github.com/jpsim/Yams)

The [StencilSwiftTemplate](https://github.com/SwiftGen/StencilSwiftKit/blob/master/README.md#stencilswifttemplate) class is used as a workaround to remove some generated lines. ([Stencil/#22](https://github.com/stencilproject/Stencil/issues/22))

## Contributions
Pull requests and issues are welcome.

## License

Dazzle is licensed under the MIT license. See [LICENSE](LICENSE) for more info.
