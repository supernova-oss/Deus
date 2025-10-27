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

@Suite("RangeReplaceableCollection+Set tests")
struct RangeReplaceableCollectionSetTests {
  @Suite("Intersection")
  struct IntersectionTests {
    @Test
    func intersectionBetweenEmptyCollectionsIsEmpty() {
      var emptyCollection: [AnyHashable] = []
      emptyCollection.formIntersection([], by: \.self)
      #expect(emptyCollection.isEmpty)
    }

    @Test
    func intersectionBetweenAMultiElementCollectionAndAnEmptyOneIsEmpty() {
      var multiElementCollection = [0, 1, 2]
      multiElementCollection.formIntersection([], by: \.self)
      #expect(multiElementCollection.isEmpty)
    }

    @Test
    func intersectionBetweenAnEmptyCollectionAndAMultiElementOneIsEmpty() {
      var emptyCollection: [AnyHashable] = []
      emptyCollection.formIntersection([0, 1, 2], by: \.self)
      #expect(emptyCollection.isEmpty)
    }

    @Test
    func formsAnIntersectionBetweenASingleElementCollectionAndAMultiElementOne() {
      var singleElementCollection = [0]
      singleElementCollection.formIntersection([0, 1, 2], by: \.self)
      #expect(singleElementCollection == [0])
    }

    @Test
    func formsAnIntersectionBetweenMultiElementCollectionsWithoutRepetitions() {
      var multiElementCollection = [0, 1, 2]
      multiElementCollection.formIntersection([0, 2, 4], by: \.self)
      #expect(multiElementCollection == [0, 2])
    }

    @Test
    func formsAnIntersectionBetweenMultiElementCollectionsWithRepetitions() {
      var multiElementCollection = [0, 1, 2, 2]
      multiElementCollection.formIntersection([0, 2, 4], by: \.self)
      #expect(multiElementCollection == [0, 2, 2])
    }
  }
}
