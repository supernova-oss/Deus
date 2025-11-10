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

@Suite("RandomAccessCollection+Chunk tests")
struct RandomAccessCollectionChunkTests {
  @Test(arguments: [false, true])
  func chunkingAnEmptyCollectionReturnsAnEmptyArray(allowsPartiality: Bool) {
    #expect([Int]().chunked(into: 2, allowsPartiality: allowsPartiality) == [])
  }

  @Test(arguments: [0, -2], [false, true])
  func chunkingWithAZeroedOrNegativeSizeReturnsAnEmptyArray(size: Int, allowsPartiality: Bool) {
    #expect([2, 4].chunked(into: size, allowsPartiality: allowsPartiality) == [])
  }

  @Test(arguments: [2, 4], [false, true])
  func
    chunkingWithASizeEqualToOrGreaterThanTheCountReturnsAnArrayWhoseOnlyElementIsTheCollectionItself(
      size: Int,
      allowsPartiality: Bool
    )
  { #expect([2, 4].chunked(into: size, allowsPartiality: allowsPartiality) == [[2, 4]]) }

  @Test(arguments: [false, true])
  func chunksImpartially(allowsPartiality: Bool) {
    #expect(
      [2, 4, 8, 16].chunked(into: 2, allowsPartiality: allowsPartiality).map { chunks in
        .init(chunks)
      } == [[2, 4], [8, 16]]
    )
  }

  @Test
  func chunksPartially() {
    #expect(
      [2, 4, 8, 16, 32, 64, 128, 256].chunked(into: 3, allowsPartiality: true).map({ chunks in
        .init(chunks)
      }) == [[2, 4, 8], [16, 32, 64], [128, 256]]
    )
  }
}
