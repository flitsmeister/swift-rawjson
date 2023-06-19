//
//  PartialCodable.swift
//
//
//  Created by Tomas Harkema on 19/06/2023.
//

@testable import RawJson
import XCTest

private struct TestModel: Codable, Equatable {
  let test: String
}

private struct TestNestedModel: Codable, Equatable {
  let test: PartialCodable<String>
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
    XCTAssertNil(parsed.error)
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
    
    XCTAssertNotNil(parsed.error)
  }
    
    func testNested_Success() throws {
      let json = """
      {
      "test": "tomas",
      }
      """.data(using: .utf8)!

      let parsed = try JSONDecoder().decode(TestNestedModel.self, from: json)

      XCTAssertEqual(
        parsed,
        TestNestedModel(test: PartialCodable(value: "tomas", raw: .string("tomas")))
      )
      
      
      XCTAssertNil(parsed.test.error)
    }

    func testNested_Failed() throws {
      let json = """
      {
      "test": 1,
      }
      """.data(using: .utf8)!

      let parsed = try JSONDecoder().decode(TestNestedModel.self, from: json)

      XCTAssertEqual(
        parsed,
        TestNestedModel(test: PartialCodable(value: nil, raw: .double(1)))
      )
      
      XCTAssertNotNil(parsed.test.error)
    }
}
