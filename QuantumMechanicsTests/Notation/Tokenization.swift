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

@testable import QuantumMechanics

/// Association between the types of tokenizers and an example of expression matching their tokens.
/// Facilitates testing tokenization (extraction of tokens).
enum Tokenization<Expression>: CaseIterable where Expression: _dTeXSource {
  /// Type of the tokenizer by which the tokens of the ``expression`` may be extracted.
  var tokenizerType: any _dTeXTokenizer<Expression>.Type {
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

  /// dTeX source composed only by characters which match exclusively the related tokenizer. Will be
  /// invalid in case this is of the parameterized kind, since the parameters are not present.
  var source: String {
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
