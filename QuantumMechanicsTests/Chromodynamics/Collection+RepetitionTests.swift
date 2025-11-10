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

import Testing

struct CollectionRepetitionTests {
  @Suite("Spreading")
  struct SpreadingTests {
    @Test
    func spreadingEmptyCollectionReturnsEmptyArray() {
      #expect([Int]().spread(by: { _ in 2 }) == [])
    }

    @Test
    func spreadingPopulatedCollectionToOneReturnsTheCollectionItself() {
      #expect([2, 4].spread(by: { _ in 1 }) == [2, 4])
    }

    @Test
    func spreadsPopulatedCollectionToMany() {
      #expect([2, 4].spread(by: { n in n }) == [2, 2, 4, 4, 4, 4])
    }
  }
}
