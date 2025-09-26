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

struct dTeXLexerTests {
  @Test
  func tokenizesDescendantExpressionStartDelimiter() {
    let expression = "{"
    #expect(
      dTeXLexer.tokenize(expression) == [
        .descendantExpressionStartDelimiter(indices: expression.startIndex...expression.startIndex)
      ]
    )
  }

  @Test
  func tokenizesDescendantExpressionEndDelimiter() {
    let expression = "}"
    #expect(
      dTeXLexer.tokenize(expression) == [
        .descendantExpressionEndDelimiter(indices: expression.startIndex...expression.startIndex)
      ]
    )
  }

  @Test
  func tokenizesIdentifier() {
    let expression = "\\hbar"
    #expect(dTeXLexer.tokenize("\\hbar") == [.identifier(expression.dropFirst())])
  }
}
