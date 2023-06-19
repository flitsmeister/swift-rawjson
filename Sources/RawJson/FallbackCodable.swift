//
//  FallbackCodable.swift
//
//
//  Created by Tomas Harkema on 17/06/2023.
//

import Foundation

/// A type to fallback to a raw representation of the JSON object if parsing of the `ConcreteType` fails.
///
/// Use this type either as a top level catch, or for certain sub values.
///
/// Example:
/// ```swift
///
/// // Top level example
///
/// struct Model: Codable {
///   let test: String
/// }
///
/// try JSONDecoder().decode([FallbackCodable<Model>].self, from: data)
///
/// // Nested example
///
/// private struct NestedModel: Codable, Equatable {
///   let test: FallbackCodable<String>
/// }
///
/// let object = try JSONDecoder().decode(NestedModel.self, from: data)
///
/// object.value // NestedModel(test: .value("tomas"))
///
/// ```
public enum FallbackCodable<ConcreteType>: Codable where ConcreteType: Codable {
  /// This value will be present when parsing of `ConcreteType` succeeds.
  case value(ConcreteType)

  /// This value will be present if parsing of `ConcreteType` fails. You'll get a `RawJson` object which contains a
  /// Swift representation of the JSON object, and the error which was thrown during parsing.
  case raw(RawJson, Error)

  public init(from decoder: Decoder) throws {
    do {
      self = try .value(ConcreteType(from: decoder))
    } catch {
      self = try .raw(RawJson(from: decoder), error)
    }
  }

  public func encode(to encoder: Encoder) throws {
    switch self {
    case let .value(value):
      try value.encode(to: encoder)
    case let .raw(raw, _):
      try raw.encode(to: encoder)
    }
  }

  public var value: ConcreteType? {
    switch self {
    case let .value(value):
      return value
    case .raw:
      return nil
    }
  }
}

extension FallbackCodable: Equatable where ConcreteType: Equatable {
  public static func == (_ lhs: FallbackCodable<ConcreteType>, _ rhs: FallbackCodable<ConcreteType>) -> Bool {
    switch (lhs, rhs) {
    case let (.value(lhsValue), .value(rhsValue)):
      return lhsValue == rhsValue

    case let (.raw(lhsValue, _), .raw(rhsValue, _)):
      return lhsValue == rhsValue

    default:
      return false
    }
  }
}
