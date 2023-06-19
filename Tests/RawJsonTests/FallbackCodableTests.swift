@testable import RawJson
import XCTest

struct TestModel: Codable, Hashable, Equatable {
    let test: String
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
