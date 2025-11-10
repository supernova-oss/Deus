// ===-------------------------------------------------------------------------------------------===
// Copyright © 2025 Supernova. All rights reserved.
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

import Foundation
import Testing

struct ArrayInitializerTests {
  @Test
  func isEmptyWhenCountIsNegative() throws { #expect([Int](count: -2) { index in index }.isEmpty) }

  @Test
  func elementsAreNotInitializedWhenCountIsNegative() throws {
    var elementInitializationCount = 0
    let _ = [Int](count: -2) { index in
      elementInitializationCount += 1
      return index
    }
    #expect(elementInitializationCount == 0)
  }

  @Test
  func callsElementInitializerAsManyTimesAsSpecified() throws {
    var elementInitializerCallCount = 0
    let _ = [Int](count: 2) { index in
      elementInitializerCallCount += 1
      return index
    }
    #expect(elementInitializerCallCount == 2)
  }

  @Test
  func containsAsManyElementsAsSpecified() throws {
    #expect([Int](count: 2) { index in index }.count == 2)
  }

  @Test
  func elementsAreReferentiallyEqualToInitializedOnes() throws {
    var initializedElements = [NSObject?](repeating: nil, count: 2)
    let initializerBasedElements = [NSObject](count: 2) { index in
      let element = NSObject()
      initializedElements[index] = element
      return element
    }
    for (index, element) in initializerBasedElements.enumerated() {
      #expect(element === initializedElements[index])
    }
  }
}
