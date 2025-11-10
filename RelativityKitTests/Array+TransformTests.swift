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

struct ArrayTransformTests {
  @Test
  func transformsBasedOnEachElement() async throws {
    let unmappedElements = [NSObject](count: 2) { _ in NSObject() }
    let mappedElements = await unmappedElements.map { listener in listener }
    for (index, mappedElement) in mappedElements.enumerated() {
      #expect(mappedElement === unmappedElements[index])
    }
  }

  @Test
  func transforms() async throws {
    #expect(await [2, 4].map { element in element * element } == [4, 16])
  }
}
