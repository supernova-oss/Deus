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
  @Test(arguments: Tokenization<String>.allCases)
  private func tokenizesSingleTokenExpression(_ tokenization: Tokenization<String>) {
    #expect(
      _dTeXLexer.tokenize(tokenization.source)
        == tokenization.tokenizerType.tokenize(tokenization.source).map { token in
          _AnyDTeXToken(token)
        }
    )
  }

  @Test(arguments: Tokenization<String>.allCases)
  private func tokenizesDuplicateTokenExpression(_ tokenization: Tokenization<String>) {
    let expression = tokenization.source + tokenization.source;
    #expect(
      _dTeXLexer.tokenize(expression).elementsEqual(
        tokenization.tokenizerType.tokenize(expression).map { token in _AnyDTeXToken(token) }[..<2]
      )
    )
  }
}
