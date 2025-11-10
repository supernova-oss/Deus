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

@Suite("Collection+Index tests")
struct CollectionIndexTests {
  @Suite("Absolutization")
  struct AbsolutizationTests {
    @Test
    func absolutizesExistingIndex() {
      let sentence = "Hello, world!"
      let word = sentence[
        sentence.index(
          sentence.startIndex,
          offsetBy: 7
        )...sentence.index(sentence.endIndex, offsetBy: -2)
      ]
      #expect(word.abs(word.startIndex) == 0)
      #expect(word.abs(word.endIndex) == 5)
    }
  }
}
