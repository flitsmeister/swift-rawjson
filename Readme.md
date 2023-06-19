# RawJson

RawJson is a small Swift Package to do some heavy lifting for JSON parsing and falling back to unparsable JSON.

## Example:

```swift
struct Person: Codable {
    let name: String
    let age: Double
}

let personsJson = """
[{
    "name": "Tomas",
    "age": "29", // BANG!
}]
"""

let json = try JSONDecoder().decode([FallbackCodable<Person>].self, from: personsJson.data(using: .utf8)!)

// This will succeed: it wil return a typesafe JSON Enum containing all the values...
```

## Run swiftformat

```sh
swift package plugin --allow-writing-to-package-directory swiftformat
```
