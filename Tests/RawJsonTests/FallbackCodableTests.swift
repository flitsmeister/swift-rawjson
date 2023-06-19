//
//  FallbackCodableTests.swift
//
//
//  Created by Tomas Harkema on 19/06/2023.
//

@testable import RawJson
import XCTest

private struct TestModel: Codable, Hashable, Equatable {
  let test: String
}

private struct TestNestedModel: Codable, Equatable {
  let test: FallbackCodable<String>
}

final class FallbackCodableTests: XCTestCase {
  func test_Success() throws {
    let json = """
    [{
    "test": "tomas",
    }]
    """.data(using: .utf8)!

    let parsed = try JSONDecoder().decode([FallbackCodable<TestModel>].self, from: json)

    XCTAssertEqual(parsed, [
      FallbackCodable.value(TestModel(test: "tomas")),
    ])
  }

  func test_Failed() throws {
    let json = """
    [{
    "test": 1,
    }]
    """.data(using: .utf8)!

    let parsed = try JSONDecoder().decode([FallbackCodable<TestModel>].self, from: json)

    XCTAssertEqual(parsed, [
      FallbackCodable.raw(
        .dictionary([
          "test": .double(1.0),
        ]),
        NSError(domain: "derp", code: 0)
      ),
    ])
  }

  func test_Combined() throws {
    let json = """
    [{
    "test": "tomas",
    }, {
    "test": 1,
    }]
    """.data(using: .utf8)!

    let parsed = try JSONDecoder().decode([FallbackCodable<TestModel>].self, from: json)

    XCTAssertEqual(parsed, [
      FallbackCodable.value(TestModel(test: "tomas")),
      FallbackCodable.raw(
        .dictionary([
          "test": .double(1.0),
        ]),
        NSError(domain: "derp", code: 0)
      ),
    ])
  }
}
