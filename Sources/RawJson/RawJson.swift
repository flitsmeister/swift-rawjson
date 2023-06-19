//
//  RawJson.swift
//
//
//  Created by Tomas Harkema on 17/06/2023.
//

import Foundation

/// RawJson type safely represents a JSON object. This is meant to replace Any when using `JSONSerialization`.
/// In this package, its mainly use to make `PartialCodable` and `FallbackCodable` work.
///
/// Instead of:
/// ```swift
/// let obj = try JSONSerialization.jsonObject(with: data) as? [String: Ant]
/// ```
/// ...do:
/// ```swift
/// let obj = try JSONDecoder().decode(RawJson.self, from: data)
/// if case .dictionary(let dict) = obj {
///   print(dict
/// }
/// ```
public enum RawJson: Codable, Equatable {
  case bool(Bool)
  case double(Double)
  case string(String)
  indirect case array([RawJson])
  indirect case dictionary([String: RawJson])

  public init(from decoder: Decoder) throws {
    if let container = try? decoder.container(keyedBy: JSONCodingKeys.self) {
      self = RawJson(from: container)
    } else if let container = try? decoder.unkeyedContainer() {
      self = RawJson(from: container)
    } else {
      let container = try decoder.singleValueContainer()

      if let boolValue = try? container.decode(Bool.self) {
        self = .bool(boolValue)
      } else if let doubleValue = try? container.decode(Double.self) {
        self = .double(doubleValue)
      } else if let intValue = try? container.decode(Int.self) {
        self = .double(Double(intValue))
      } else if let stringValue = try? container.decode(String.self) {
        self = .string(stringValue)
      } else {
        throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: decoder.codingPath, debugDescription: ""))
      }
    }
  }

  private init(from container: KeyedDecodingContainer<JSONCodingKeys>) {
    var dict: [String: RawJson] = [:]
    for key in container.allKeys {
      if let value = try? container.decode(Bool.self, forKey: key) {
        dict[key.stringValue] = .bool(value)
      } else if let value = try? container.decode(Double.self, forKey: key) {
        dict[key.stringValue] = .double(value)
      } else if let value = try? container.decode(String.self, forKey: key) {
        dict[key.stringValue] = .string(value)
      } else if let value = try? container.nestedContainer(keyedBy: JSONCodingKeys.self, forKey: key) {
        dict[key.stringValue] = RawJson(from: value)
      } else if let value = try? container.nestedUnkeyedContainer(forKey: key) {
        dict[key.stringValue] = RawJson(from: value)
      }
    }
    self = .dictionary(dict)
  }

  private init(from container: UnkeyedDecodingContainer) {
    var container = container
    var arr: [RawJson] = []
    while !container.isAtEnd {
      if let value = try? container.decode(Bool.self) {
        arr.append(.bool(value))
      } else if let value = try? container.decode(Double.self) {
        arr.append(.double(value))
      } else if let value = try? container.decode(String.self) {
        arr.append(.string(value))
      } else if let value = try? container.nestedContainer(keyedBy: JSONCodingKeys.self) {
        arr.append(RawJson(from: value))
      } else if let value = try? container.nestedUnkeyedContainer() {
        arr.append(RawJson(from: value))
      }
    }
    self = .array(arr)
  }

  public func encode(to encoder: Encoder) throws {
    switch self {
    case let .bool(value):
      var container = encoder.singleValueContainer()
      try container.encode(value)

    case let .double(value):
      var container = encoder.singleValueContainer()
      try container.encode(value)

    case let .string(value):
      var container = encoder.singleValueContainer()
      try container.encode(value)

    case let .array(value):
      var container = encoder.unkeyedContainer()

      for item in value {
        try container.encode(item)
      }

    case let .dictionary(dict):
      var container = encoder.container(keyedBy: JSONCodingKeys.self)

      for (key, value) in dict {
        try container.encode(value, forKey: JSONCodingKeys(stringValue: key)!)
      }
    }
  }
}
