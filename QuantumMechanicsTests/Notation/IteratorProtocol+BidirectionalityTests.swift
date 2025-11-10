// ===-------------------------------------------------------------------------------------------===
// Copyright © 2025 Deus
//
// This file is part of the Deus open-source project.
//
// This program is free software: you can redistribute it and/or modify it under the terms of the
// GNU General Public License as published by the Free Software Foundation, either version 3 of the
// License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without
// even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
// General Public License for more details.
//
// You should have received a copy of the GNU General Public License along with this program. If
// not, see https://www.gnu.org/licenses.
// ===-------------------------------------------------------------------------------------------===

import Testing

@testable import QuantumMechanics

@Suite("IteratorProtocol+Bidirectionality tests")
struct IteratorProtocolBidirectionalityTests {
  @Test
  func startsAtIndexBeforeStartOne() {
    let collection = [0, 2]
    let iterator = collection.makeBidirectionalIterator()
    #expect(iterator.currentIndex == collection.index(before: collection.startIndex))
  }

  @Test
  func iteratesForward() {
    let collection = [0, 2, 4, 8]
    var iterator = collection.makeBidirectionalIterator()
    for repetitionIndex in 0..<2 {
      let expectedCurrentIndex = collection.index(collection.startIndex, offsetBy: repetitionIndex)
      #expect(iterator.next() == collection[expectedCurrentIndex])
      #expect(iterator.currentIndex == expectedCurrentIndex)
    }
  }

  @Test
  func iteratesBackward() {
    let collection = [0, 2, 4, 8]
    var iterator = collection.makeBidirectionalIterator()
    for _ in 0...2 { let _ = iterator.next() }
    #expect(iterator.previous() == 2)
    #expect(iterator.currentIndex == collection.index(after: collection.startIndex))
  }

  @Test
  func resets() {
    let collection = [0, 2, 4]
    var iterator = collection.makeBidirectionalIterator()
    for _ in 0...2 { let _ = iterator.next() }
    iterator.reset()
    #expect(iterator.currentIndex == collection.index(before: collection.startIndex))
    #expect(iterator.next() == 0)
  }
}
