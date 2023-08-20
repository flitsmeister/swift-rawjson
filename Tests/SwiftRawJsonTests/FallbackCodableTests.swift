//
//  FallbackCodableTests.swift
//
//
//  Created by Tomas Harkema on 19/06/2023.
//

@testable import SwiftRawJson
import XCTest

private struct TestModel: Codable, Hashable, Equatable {
  let test: String
}

private struct TestNestedModel: Codable, Hashable, Equatable {
  let test: FallbackCodable<String>
}

private struct TestArrayModel: Codable, Hashable, Equatable {
  let test: [FallbackCodable<String>]
}

final class FallbackCodableTests: XCTestCase {
  func test_Success() throws {
    let json = """
    [{
    "test": "tomas",
    }]
    """.data(using: .utf8)!

    let parsed = try JSONDecoder().decode([FallbackCodable<TestModel>].self, from: json)

    assertEqual(parsed, [
      FallbackCodable.value(TestModel(test: "tomas")),
    ])
  }

  func test_Failed() throws {
    let json = """
    [{
    "test": 1,
    },{
    "test": null,
    }]
    """.data(using: .utf8)!

    let parsed = try JSONDecoder().decode([FallbackCodable<TestModel>].self, from: json)

    assertEqual(parsed, [
      FallbackCodable.raw(
        .dictionary([
          "test": .double(1.0),
        ]),
        NSError(domain: "derp", code: 0)
      ),
      FallbackCodable.raw(
        .dictionary([
          "test": .null,
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

    assertEqual(parsed, [
      FallbackCodable.value(TestModel(test: "tomas")),
      FallbackCodable.raw(
        .dictionary([
          "test": .double(1.0),
        ]),
        NSError(domain: "derp", code: 0)
      ),
    ])
  }

  func testNested_Success() throws {
    let json = """
    [{
    "test": "tomas",
    }]
    """.data(using: .utf8)!

    let parsed = try JSONDecoder().decode([TestNestedModel].self, from: json)

    assertEqual(parsed, [
      TestNestedModel(test: .value("tomas")),
    ])
  }

  func testNested_Failed() throws {
    let json = """
    [{
    "test": 1,
    }]
    """.data(using: .utf8)!

    let parsed = try JSONDecoder().decode([TestNestedModel].self, from: json)

    assertEqual(parsed, [
      TestNestedModel(test: .raw(.double(1), NSError(domain: "derp", code: 0))),
    ])
  }

  func testNested_Combined() throws {
    let json = """
    [{
    "test": "tomas",
    }, {
    "test": 1,
    }]
    """.data(using: .utf8)!

    let parsed = try JSONDecoder().decode([TestNestedModel].self, from: json)

    assertEqual(parsed, [
      TestNestedModel(test: .value("tomas")),
      TestNestedModel(test: .raw(.double(1), NSError(domain: "derp", code: 0))),
    ])
  }

  func testNestedArray_Success() throws {
    let json = """
    [{
    "test": ["tomas", "harkema"],
    }]
    """.data(using: .utf8)!

    let parsed = try JSONDecoder().decode([TestArrayModel].self, from: json)

    assertEqual(parsed, [
      TestArrayModel(test: [
        .value("tomas"),
        .value("harkema"),
      ]),
    ])
  }

  func testNestedArray_Failed() throws {
    let json = """
    [{
    "test": ["tomas", 1],
    },{
    "test": ["tomas", null],
    }]
    """.data(using: .utf8)!

    let parsed = try JSONDecoder().decode([TestArrayModel].self, from: json)

    assertEqual(parsed, [
      TestArrayModel(test: [
        .value("tomas"),
        .raw(.double(1), NSError(domain: "derp", code: 0)),
      ]),
      TestArrayModel(test: [
        .value("tomas"),
        .raw(.null, NSError(domain: "derp", code: 0)),
      ]),
    ])
  }

  func testArray_Success() throws {
    let json = """
    [{
    "test": ["tomas", "harkema"],
    }, null]
    """.data(using: .utf8)!

    let parsed = try JSONDecoder().decode([FallbackCodable<TestArrayModel>].self, from: json)

    assertEqual(parsed, [
      .value(
        TestArrayModel(test: [
          .value("tomas"),
          .value("harkema"),
        ])
      ),
      .raw(.null, NSError(domain: "derp", code: 0)),
    ])
  }
}
