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
