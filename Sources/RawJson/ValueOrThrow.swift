//
//  ValueOrThrow.swift
//
//
//  Created by Tomas Harkema on 17/06/2023.
//

import Foundation

public extension PartialCodable {
  func valueOrThrow() throws -> ConcreteType {
    guard let value else {
      if let error {
        throw error
      } else {
        throw NSError(domain: "derp", code: 0)
      }
    }
    return value
  }
}
