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

/// Extractor of tokens of dTeX expressions.
class _dTeXLexer {
  private init() {}

  /// Extracts the tokens present in the given string, expected to be a main expression in dTeX.
  ///
  /// Different from TeX, the equation **should not** be surrounded by dollar signs ($) in case
  /// their purpose is to delimit inline math mode, as dTeX already operates only in such mode of
  /// TeX. Including these symbols at the start and/or the end of the string without escaping them
  /// results in an invalid dTeX main expression.
  static func tokenize<Expression>(_ expression: Expression) -> [_dTeXToken<Expression>]
  where Expression: StringProtocol, Expression.SubSequence == Substring {
    guard !expression.isEmpty else { return [] }
    return _tokenizerTypes(expressionType: Expression.self).flatMap({ tokenizer in
      tokenizer.tokenize(expression)
    }).sorted()
  }

  /// Obtains the type of every implementation of ``dTeXTokenizer``.
  ///
  /// - Parameter expressionType: Type of the dTeX expression from which the tokens are extracted.
  static func _tokenizerTypes<Expression>(
    expressionType: Expression.Type
  ) -> [any _dTeXTokenizer<Expression>.Type]
  where Expression: StringProtocol, Expression.SubSequence == Substring {
    ([
      _DescendantExpressionEndDelimiterTokenizer<Expression>.self,
      _DescendantExpressionStartDelimiterTokenizer<Expression>.self,
      _IdentifierTokenizer<Expression>.self, _WhitespaceTokenizer<Expression>.self
    ] as [any _dTeXTokenizer<Expression>.Type])
  }
}

/// Combination of non-whitespaced characters with semantic meaning within a dTeX expression. They
/// are present in their raw, uncategorized form in a string and are extracted and converted into
/// cases of this enum by ``dTeXLexer``.
enum _dTeXToken<Expression> where Expression: StringProtocol, Expression.SubSequence: Sendable {
  /// Indices of the portion of the main expression at which the characters matched by this token
  /// are.
  var indices: ClosedRange<Expression.Index> {
    switch self {
    case .descendantExpressionEndDelimiter(let indices): indices
    case .descendantExpressionStartDelimiter(let indices): indices
    case .identifier(let text): text.range
    case .whitespace(let index): index...index
    }
  }

  /// Closing brace (}) delimiting the end of a descendant expression of the main expression.
  case descendantExpressionEndDelimiter(indices: ClosedRange<Expression.Index>)

  /// Opening brace ({) indicating the beginning of an expression which is a descendant of the main
  /// expression.
  case descendantExpressionStartDelimiter(indices: ClosedRange<Expression.Index>)

  /// Unique, language-defined name of an element, composed by a backslash (\) and lowercase
  /// letters.
  case identifier(_ text: Expression.SubSequence)

  /// Whitespace ( ) for separating one element or expression from another.
  case whitespace(index: Expression.Index)
}

extension _dTeXToken: Comparable {
  static func < (lhs: Self, rhs: Self) -> Bool { lhs.indices.upperBound < rhs.indices.upperBound }
}

extension _dTeXToken: Equatable where Expression: Equatable {
  static func == (lhs: Self, rhs: Self) -> Bool {
    if case .identifier(let lhsText) = lhs, case .identifier(let rhsText) = rhs {
      lhsText == rhsText
    } else {
      lhs.indices == rhs.indices
    }
  }
}

extension _dTeXToken: Sendable {}

/// Specification of ``dTeXToken/descendantExpressionEndDelimiter``.
struct _DescendantExpressionEndDelimiterTokenizer<Expression>: _dTeXTokenizer
where Expression: StringProtocol, Expression.SubSequence == Substring {
  let token: _dTeXToken<Expression>

  static var regex: Regex<Substring> { #/}/# }

  static func token(of text: Substring) -> _dTeXToken<Expression> {
    .descendantExpressionEndDelimiter(indices: text.range)
  }
}

/// Specificatrion of ``dTeXToken/descendantExpressionStartDelimiter``.
struct _DescendantExpressionStartDelimiterTokenizer<Expression>: _dTeXTokenizer
where Expression: StringProtocol, Expression.SubSequence == Substring {
  let token: _dTeXToken<Expression>

  static var regex: Regex<Substring> { #/{/# }

  static func token(of text: Substring) -> _dTeXToken<Expression> {
    .descendantExpressionStartDelimiter(indices: text.range)
  }
}

extension BidirectionalCollection {
  /// Range of the indices of this collection.
  var range: ClosedRange<Index> {
    guard startIndex != endIndex else { return startIndex...endIndex }
    return startIndex...index(before: endIndex)
  }
}

/// Specification ``dTeXToken/whitespace(index:)``.
struct _WhitespaceTokenizer<Expression>: _dTeXTokenizer
where Expression: StringProtocol, Expression.SubSequence == Substring {
  let token: _dTeXToken<Expression>

  static var regex: Regex<Substring> { #/\s/# }

  static func token(of text: Substring) -> _dTeXToken<Expression> {
    .whitespace(index: text.startIndex)
  }
}

/// Specification of ``dTeXToken/identifier(_:)``.
struct _IdentifierTokenizer<Expression>: _dTeXTokenizer
where Expression: StringProtocol, Expression.SubSequence == Substring {
  static var regex: Regex<Substring> { #/\\[a-z]{3,}/# }

  static func token(of text: Substring) -> _dTeXToken<Expression> { .identifier(text.dropFirst()) }
}

/// Structure responsible for returning tokens of a specific type from sequences of characters of a
/// dTeX expression.
protocol _dTeXTokenizer<Expression> where Expression.SubSequence == Substring {
  /// Expression for which this specification of a token is.
  associatedtype Expression: StringProtocol

  /// Regular expression by which this ``dTeXToken`` is matched.
  static var regex: Regex<Substring> { get }

  /// Returns the token of the `text`.
  ///
  /// - Parameter text: Matching portion of the expression as it is.
  static func token(of text: Substring) -> _dTeXToken<Expression>
}

extension _dTeXTokenizer {
  /// Extracts every sequence of characters from an expression which matches the ``regex``,
  /// returning each found token. Implies that such expression is not empty, as such check is
  /// performed by ``dTeXLexer/tokenize(_:)``.
  ///
  /// - Parameter expression: dTeX expression to tokenize.
  static func tokenize(_ expression: Expression) -> [_dTeXToken<Expression>] {
    expression.matches(of: regex).map { match in token(of: match.output) }
  }
}
