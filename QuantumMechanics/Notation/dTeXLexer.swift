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
class dTeXLexer {
  /// Extracts the tokens present in the given string, expected to be a main expression in dTeX.
  ///
  /// Different from TeX, the equation _should not_ be surrounded by dollar signs ($) in case their
  /// purpose is to delimit inline math mode, as dTex already operates only in such mode of TeX.
  /// Including these symbols at the start and/or the end of the string without escaping them
  /// results in an invalid dTeX main expression.
  static func tokenize<Expression>(_ expression: Expression) -> [dTeXToken<Expression>]
  where Expression: StringProtocol, Expression.SubSequence == Substring {
    guard !expression.isEmpty else { return [] }
    return
      ([
        DescendantExpressionStartDelimiterTokenizer<Expression>.self,
        DescendantExpressionEndDelimiterTokenizer<Expression>.self,
        IdentifierTokenizer<Expression>.self
      ] as [any dTeXTokenTokenizer<Expression>.Type]).flatMap({ tokenizer in
        tokenizer.tokenize(expression)
      }).sorted()
  }
}

/// Combination of non-whitespaced characters with semantic meaning within a dTeX expression. They
/// are present in their raw, uncategorized form in a string and are extracted and converted into
/// cases of this enum by ``dTeXLexer``.
enum dTeXToken<Expression>: Comparable where Expression: StringProtocol {
  /// Indices of the portion of the main expression at which the characters matched by this token
  /// are.
  var indices: ClosedRange<Expression.Index> {
    switch self {
    case .descendantExpressionStartDelimiter(let indices): indices
    case .descendantExpressionEndDelimiter(let indices): indices
    case .identifier(let text): text.range
    }
  }

  /// Opening brace ({) indicating the beginning of an expression which is a descendant of the main
  /// expression.
  case descendantExpressionStartDelimiter(indices: ClosedRange<Expression.Index>)

  /// Closing brace (}) delimiting the end of a descendant expression of the main expression.
  case descendantExpressionEndDelimiter(indices: ClosedRange<Expression.Index>)

  /// Unique, language-defined name of an element, composed by a backslash (\) and lowercase
  /// letters.
  case identifier(_ text: Expression.SubSequence)

  static func < (lhs: Self, rhs: Self) -> Bool { lhs.indices.upperBound < rhs.indices.upperBound }
}

/// Specificatrion of ``dTeXToken/descendantExpressionStartDelimiter``.
private struct DescendantExpressionStartDelimiterTokenizer<Expression>: dTeXTokenTokenizer
where Expression: StringProtocol, Expression.SubSequence == Substring {
  let token: dTeXToken<Expression>

  static var regex: Regex<Substring> { #/{/# }

  static func token(of text: Substring) -> dTeXToken<Expression> {
    .descendantExpressionStartDelimiter(indices: text.range)
  }
}

/// Specification of ``dTeXToken/descendantExpressionEndDelimiter``.
private struct DescendantExpressionEndDelimiterTokenizer<Expression>: dTeXTokenTokenizer
where Expression: StringProtocol, Expression.SubSequence == Substring {
  let token: dTeXToken<Expression>

  static var regex: Regex<Substring> { #/}/# }

  static func token(of text: Substring) -> dTeXToken<Expression> {
    .descendantExpressionEndDelimiter(indices: text.range)
  }
}

extension BidirectionalCollection {
  /// Range of the indices of this collection.
  fileprivate var range: ClosedRange<Index> {
    guard startIndex != endIndex else { return startIndex...endIndex }
    return startIndex...index(before: endIndex)
  }
}

/// Specification of ``dTeXToken/identifier(_:)``.
private struct IdentifierTokenizer<Expression>: dTeXTokenTokenizer
where Expression: StringProtocol, Expression.SubSequence == Substring {
  static var regex: Regex<Substring> { #/\\[a-z]{3,}/# }

  static func token(of text: Substring) -> dTeXToken<Expression> { .identifier(text.dropFirst()) }
}

/// Structure responsible for returning tokens of a specific type from sequences of characters of a
/// dTeX expression.
private protocol dTeXTokenTokenizer<Expression> where Expression.SubSequence == Substring {
  /// Expression for which this specification of a token is.
  associatedtype Expression: StringProtocol

  /// Regular expression by which this ``dTeXToken`` is matched.
  static var regex: Regex<Substring> { get }

  /// Returns the token of the `text`.
  ///
  /// - Parameter text: Matching portion of the expression as it is.
  static func token(of text: Substring) -> dTeXToken<Expression>
}

extension dTeXTokenTokenizer {
  /// Extracts every sequence of characters from an expression which matches the ``regex``,
  /// returning each found token. Implies that such expression is not empty, as such check is
  /// performed by ``dTeXLexer/tokenize(expression:)``.
  ///
  /// - Parameter expression: dTeX expression to tokenize.
  fileprivate static func tokenize(_ expression: Expression) -> [dTeXToken<Expression>] {
    expression.matches(of: regex).map { match in token(of: match.output) }
  }
}
