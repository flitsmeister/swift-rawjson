//
//  assertEqual.swift
//
//
//  Created by Tomas Harkema on 21/06/2023.
//

import XCTest

private extension CollectionDifference {
  func testDescription(for change: Change) -> String? {
    switch change {
    case let .insert(index, element, association):
      if let oldIndex = association {
        return """
        Element moved from index \(oldIndex) to \(index): \(element)
        """
      } else {
        return "Additional element at index \(index): \(element)"
      }
    case let .remove(index, element, association):
      // If a removal has an association, it means that
      // it's part of a move, which we're handling above.
      guard association == nil else {
        return nil
      }

      return "Missing element at index \(index): \(element)"
    }
  }
}

private extension CollectionDifference {
  func asTestErrorMessage() -> String {
    let descriptions = compactMap(testDescription)

    guard !descriptions.isEmpty else {
      return ""
    }

    return "- " + descriptions.joined(separator: "\n- ")
  }
}

func assertEqual<T: BidirectionalCollection>(
  _ first: T,
  _ second: T,
  file: StaticString = #file,
  line: UInt = #line
) where T.Element: Hashable {
  let diff = second.difference(from: first).inferringMoves()
  let message = diff.asTestErrorMessage()

  XCTAssert(message.isEmpty, """
  The two collections are not equal. Differences:
  \(message)
  """, file: file, line: line)
}
