# Reflection

**Reflection** provides an API for advanced reflection at runtime including dynamic construction of types.

## Note

This is a fork of [Zewo's Reflection library](https://github.com/Zewo/Reflection) that adds more support for reading the type metadata.

## Usage

```swift
import Reflection

struct Person {
  var firstName: String
  var lastName: String
  var age: Int
}

// Reflects the instance properties of type `Person`
let properties = try properties(Person)

var person = Person(firstName: "John", lastName: "Smith", age: 35)

// Retrieves the value of `person.firstName`
let firstName: String = try get("firstName", from: person)

// Sets the value of `person.age`
try set(36, key: "age", for: &person)

// Creates a `Person` from a dictionary
let friend: Person = try construct(dictionary: ["firstName" : "Sarah",
                                                "lastName" : "Gates",
                                                "age" : 28])


```

## Installation

```swift
import PackageDescription

let package = Package(
    dependencies: [
        .Package(url: "https://github.com/nuclearace/Reflection.git", majorVersion: 0, minor: 14),
    ]
)
```

## Advanced Usage

```swift
// `Reflection` can be extended for higher-level packages to do mapping and serializing.
// Here is a simple `Mappable` protocol that allows deserializing of arbitrary nested structures.

import Reflection

typealias MappableDictionary = [String : Any]

enum Error : ErrorProtocol {
    case missingRequiredValue(key: String)
}

protocol Mappable {
    init(dictionary: MappableDictionary) throws
}

extension Mappable {

    init(dictionary: MappableDictionary) throws {
        self = try construct { property in
            if let value = dictionary[property.key] {
                if let type = property.type as? Mappable.Type, let value = value as? MappableDictionary {
                    return try type.init(dictionary: value)
                } else {
                    return value
                }
            } else {
                throw Error.missingRequiredValue(key: property.key)
            }
        }
    }

}

struct Person : Mappable {
    var firstName: String
    var lastName: String
    var age: Int
    var phoneNumber: PhoneNumber
}

struct PhoneNumber : Mappable {
    var number: String
    var type: String
}

let dictionary = [
    "firstName" : "Jane",
    "lastName" : "Miller",
    "age" : 54,
    "phoneNumber" : [
        "number" : "924-555-0294",
        "type" : "work"
    ] as MappableDictionary
] as MappableDictionary

let person = try Person(dictionary: dictionary)

```

## License

This project is released under the MIT license. See [LICENSE](LICENSE) for details.

[swift-badge]: https://img.shields.io/badge/Swift-3.0-orange.svg?style=flat
[swift-url]: https://swift.org
[mit-badge]: https://img.shields.io/badge/License-MIT-blue.svg?style=flat
[mit-url]: https://tldrlegal.com/license/mit-license
