//
//  PartialCodable.swift
//
//
//  Created by Tomas Harkema on 17/06/2023.
//

import Foundation

public struct PartialCodable<ConcreteType>: Codable where ConcreteType: Codable {
  public let value: ConcreteType?
  public let raw: RawJson
  public let error: Error?

  internal init(value: ConcreteType?, raw: RawJson) {
    self.value = value
    self.raw = raw
    error = nil
  }

  public init(from decoder: Decoder) throws {
    raw = try RawJson(from: decoder)
    do {
      value = try ConcreteType(from: decoder)
      error = nil
    } catch {
      self.error = error
      value = nil
    }
  }

  public func encode(to encoder: Encoder) throws {
    try raw.encode(to: encoder)
    try value.encode(to: encoder)
  }
}

extension PartialCodable: Equatable where ConcreteType: Equatable {
  public static func == (lhs: Self, rhs: Self) -> Bool {
    lhs.value == rhs.value && lhs.raw == rhs.raw
  }
}
