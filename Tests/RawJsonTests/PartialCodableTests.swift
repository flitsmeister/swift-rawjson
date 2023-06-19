//
//  PartialCodable.swift
//
//
//  Created by Tomas Harkema on 19/06/2023.
//

@testable import RawJson
import XCTest

private struct TestModel: Codable, Hashable, Equatable {
  let test: String
}

final class PartialCodableTests: XCTestCase {
  func test_Success() throws {
    let json = """
    {
    "test": "tomas",
    }
    """.data(using: .utf8)!

    let parsed = try JSONDecoder().decode(PartialCodable<TestModel>.self, from: json)

    XCTAssertEqual(
      parsed,
      PartialCodable(
        value: TestModel(test: "tomas"),
        raw: .dictionary(["test": .string("tomas")])
      )
    )
  }

  func test_Failed() throws {
    let json = """
    {
    "test": 1,
    }
    """.data(using: .utf8)!

    let parsed = try JSONDecoder().decode(PartialCodable<TestModel>.self, from: json)

    XCTAssertEqual(
      parsed,
      PartialCodable(
        value: nil,
        raw: .dictionary(["test": .double(1)])
      )
    )
  }
}
