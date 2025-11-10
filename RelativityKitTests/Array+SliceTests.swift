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

struct ArraySliceTests {
  @Test
  func returnsEmptyArrayWhenSlicingWithoutIndices() throws {
    #expect([0, 1, 2, 3].sliced(0..<0).isEmpty)
  }

  @Test
  func returnsOriginalSingleElementArrayWhenSlicingWithIndicesEqualToItsOwn() throws {
    let elements = [NSObject()]
    let slice = elements.sliced(0..<1)
    #expect(slice.count == 1)
    #expect(slice[0] === elements[0])
  }

  @Test
  func returnsOriginalMultiElementArrayWhenSlicingWithIndicesEqualToItsOwn() throws {
    let elements = [NSObject](count: 4) { _ in NSObject() }
    let slice = elements.sliced(0..<5)
    #expect(slice.count == 4)
    for (index, element) in slice.enumerated() { #expect(element === elements[index]) }
  }

  @Test
  func slices() throws { #expect([0, 1, 2, 3].sliced(1..<3) == [1, 2]) }
}
