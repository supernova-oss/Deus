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

@Suite("String+Scanning tests")
struct StringScanningTests {
  @Suite("Inlined index")
  struct InlinedIndexTests {
    // TODO: Check whether the test can be uncommented without crashing SourceKitService.
    //
    // @Test(
    //   .disabled(
    //     "SourceKitService crashes on Xcode 26.0.1 whenever the implementation of this function "
    //       + "is analyzed. This portion is commented due to the analysis being performed by the "
    //       + "compiler frontend and such crash consequently occurring on indexing, file changes "
    //       + "or anytime Xcode decides to trigger analysis."
    //   )
    // )
    // func errorsWhenIndexIsOutOfRange() async {
    //   let string = ""
    //   await #expect(processExitsWith: .failure) {
    //     let _ = string.column(ofCharacterAt: string.endIndex)
    //   }
    // }

    @Test
    func inlinedIndexOfFirstCharacterOfStringEqualsToStartIndex() {
      let string = "Hello,\nworld!"
      #expect(string.inlinedIndex(ofCharacterAt: string.startIndex) == string.startIndex)
    }

    @Test
    func inlinedIndexOfColumnOfFirstCharacterInSecondLineEqualsToStartIndex() {
      let string = "Hello,\nworld!"
      #expect(
        string.inlinedIndex(ofCharacterAt: string.index(string.startIndex, offsetBy: 6))
          == string.startIndex
      )
    }
  }

  @Suite("Line index")
  struct LineIndexTests {
    @Test(arguments: 0...5)
    func indexOfFirstLineEqualsToStartIndex(offsettingCharacterIndexBy characterIndexOffset: Int) {
      let string = "Hello,\nworld!"
      #expect(
        string.lineIndex(
          ofCharacterAt: string.index(string.startIndex, offsetBy: characterIndexOffset)
        ) == string.startIndex
      )
    }

    @Test(arguments: 6...11)
    func obtainsIndexOfSubsequentLine(offsettingCharacterIndexBy characterIndexOffset: Int) {
      let string = "Hello,\nworld!"
      #expect(
        string.lineIndex(
          ofCharacterAt: string.index(string.startIndex, offsetBy: characterIndexOffset)
        ) == string.index(after: string.startIndex)
      )
    }
  }
}
