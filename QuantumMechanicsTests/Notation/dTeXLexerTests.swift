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
  /// Association between the types of tokenizers and an example of expression matching their
  /// tokens. Facilitates testing tokenization (extraction of tokens).
  private enum Tokenization<Expression>: CaseIterable where Expression: _dTeXUnparsedExpression {
    /// Type of the tokenizer by which the tokens of the ``expression`` may be extracted.
    fileprivate var tokenizerType: any _dTeXTokenizer<Expression>.Type {
      switch self {
      case .descendantExpressionEndDelimiter:
        _dTeXDescendantExpressionEndDelimiterTokenizer<Expression>.self
      case .descendantExpressionStartDelimiter:
        _dTeXDescendantExpressionStartDelimiterTokenizer<Expression>.self
      case .identifier: _dTeXIdentifierTokenizer<Expression>.self
      case .operator: _dTeXOperatorTokenizer<Expression>.self
      case .whitespace: _dTeXWhitespaceTokenizer<Expression>.self
      }
    }

    /// dTeX expression composed only by characters which match exclusively the related tokenizer.
    /// Will be invalid in case this is of the parameterized kind, since the parameters are not
    /// present.
    fileprivate var expression: String {
      switch self {
      case .descendantExpressionEndDelimiter: "}"
      case .descendantExpressionStartDelimiter: "{"
      case .identifier: "\\hbar"
      case .operator: "^"
      case .whitespace: " "
      }
    }

    /// For ``_DescendantExpressionEndDelimiterTokenizer``.
    case descendantExpressionEndDelimiter

    /// For ``_DescendantExpressionStartDelimiterTokenizer``.
    case descendantExpressionStartDelimiter

    /// For ``_IdentifierTokenizer``.
    case identifier

    /// For ``_OperatorTokenizer``.
    case `operator`

    /// For ``_WhitespaceTokenizer``.
    case whitespace
  }

  @Test(arguments: Tokenization<String>.allCases)
  private func tokenizesSingleTokenExpression(_ tokenization: Tokenization<String>) {
    #expect(
      _dTeXLexer.tokenize(tokenization.expression)
        == tokenization.tokenizerType.tokenize(tokenization.expression).map { token in
          _AnyDTeXToken(token)
        }
    )
  }

  @Test(arguments: Tokenization<String>.allCases)
  private func tokenizesDuplicateTokenExpression(_ tokenization: Tokenization<String>) {
    let expression = tokenization.expression + tokenization.expression;
    #expect(
      _dTeXLexer.tokenize(expression).elementsEqual(
        tokenization.tokenizerType.tokenize(expression).map { token in _AnyDTeXToken(token) }[..<2]
      )
    )
  }
}
