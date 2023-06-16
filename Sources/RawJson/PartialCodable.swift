//
//  PartialCodable.swift
//  
//
//  Created by Tomas Harkema on 17/06/2023.
//

import Foundation

public struct PartialCodable<ConcreteType>: Codable where ConcreteType: Codable {
  public let value: ConcreteType
  public let raw: RawJson

  public init(from decoder: Decoder) throws {
    raw = try RawJson(from: decoder)
    value = try ConcreteType.init(from: decoder)
  }

  public func encode(to encoder: Encoder) throws {
    try raw.encode(to: encoder)
    try value.encode(to: encoder)
  }
}
