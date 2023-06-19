//
//  FallbackCodable.swift
//  
//
//  Created by Tomas Harkema on 17/06/2023.
//

import Foundation

public enum FallbackCodable<ConcreteType>: Codable where ConcreteType: Codable {

  case value(ConcreteType)
  case raw(RawJson, Error)

  public init(from decoder: Decoder) throws {
    do {
      self = .value(try ConcreteType.init(from: decoder))
    } catch {
      self = .raw(try RawJson(from: decoder), error)
    }
  }

  public func encode(to encoder: Encoder) throws {
    switch self {
    case .value(let value):
      try value.encode(to: encoder)
    case .raw(let raw, _):
      try raw.encode(to: encoder)
    }
  }

  public var value: ConcreteType? {
    switch self {
    case .value(let value):
      return value
    case .raw:
      return nil
    }
  }
}
