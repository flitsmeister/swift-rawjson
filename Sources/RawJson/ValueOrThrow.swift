//
//  ValueOrThrow.swift
//
//
//  Created by Tomas Harkema on 17/06/2023.
//

import Foundation

extension PartialCodable {
  public func valueOrThrow() throws -> ConcreteType {
    guard let value = value else {
      if let error = error {
        throw error
      } else {
        throw NSError(domain: "derp", code: 0)
      }
    }
    return value
  }
}