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

@Suite("Any+TypeErasure tests")
struct AnyTypeErasureTests {
  @Suite("AnyReplaceableCollection")
  struct AnyReplaceableCollectionTests {
    @Test
    func isInitializedContainingElementsOfOriginalCollection() {
      let originalCollection = [0, 2, 4]
      let typeErasedCollection = AnyRangeReplaceableCollection(originalCollection)
      #expect(typeErasedCollection.elementsEqual(originalCollection))
    }

    @Test
    func errorsWhenAccessingElementAtIndexOutOfRange() async {
      await #expect(processExitsWith: .failure) {
        let collection = AnyRangeReplaceableCollection([0, 2, 4])
        let _ = collection[collection.index(before: collection.startIndex)]
      }
      await #expect(processExitsWith: .failure) {
        let collection = AnyRangeReplaceableCollection([0, 2, 4])
        let _ = collection[collection.endIndex]
      }
    }

    @Test
    func accessesElementRandomly() {
      let collection = AnyRangeReplaceableCollection([0, 2, 4])
      #expect(collection[collection.index(after: collection.startIndex)] == 2)
    }

    @Test
    func replacesSubrange() {
      var collection = AnyRangeReplaceableCollection([0, 12, 16, 8])
      collection.replaceSubrange(
        collection.index(
          after: collection.startIndex
        )...collection.index(collection.endIndex, offsetBy: -2),
        with: [2, 4]
      )
      #expect(collection.elementsEqual([0, 2, 4, 8]))
    }
  }
}
