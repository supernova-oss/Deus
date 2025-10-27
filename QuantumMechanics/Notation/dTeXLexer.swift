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

/// Result of the tokenization of an unparsed expression by the lexer.
typealias _dTeXSyntax<Expression: _dTeXUnparsedExpression> = [_AnyDTeXToken<Expression>]

extension _dTeXSyntax where Element: _dTeXToken {
  /// Conjunct textual representation of each token in the syntax.
  var text: String { map(\.text).joined() }
}

/// Extractor of tokens of dTeX expressions.
class _dTeXLexer {
  private init() {}

  /// Extracts the tokens present in the given `expression`.
  ///
  /// Different from TeX, the equation **should not** be surrounded by dollar signs ($) in case
  /// their purpose is to delimit inline math mode, as dTeX already operates only in such mode of
  /// TeX. Including these symbols at the start and/or the end of the string without escaping them
  /// results in an invalid dTeX main expression.
  static func tokenize<Expression>(_ expression: Expression) -> _dTeXSyntax<Expression>
  where Expression: _dTeXUnparsedExpression {
    guard !expression.isEmpty else { return [] }
    return
      ([
        _dTeXDescendantExpressionEndDelimiterTokenizer<Expression>.self,
        _dTeXDescendantExpressionStartDelimiterTokenizer<Expression>.self,
        _dTeXIdentifierTokenizer<Expression>.self, _dTeXOperatorTokenizer<Expression>.self,
        _dTeXWhitespaceTokenizer<Expression>.self
      ] as [any _dTeXTokenizer<Expression>.Type]).flatMap({ tokenizerType in
        tokenizerType.tokenize(expression).map { token in _AnyDTeXToken(token) }
      }).sorted()
  }
}

/// Wrapper which erases the type of a token.
struct _AnyDTeXToken<Expression: _dTeXUnparsedExpression>: _dTeXToken {
  let text: Expression.SubSequence

  init(_ base: any _dTeXToken<Expression>) {
    self = if let base = base as? Self { base } else { .init(base.text) }
  }

  init(_ text: Expression.SubSequence) { self.text = text }
}

extension _AnyDTeXToken: Equatable {
  static func == (lhs: Self, rhs: Self) -> Bool { lhs.text == rhs.text }
}

/// Specification of ``_dTeXDescendantExpressionEndDelimiterToken``.
struct _dTeXDescendantExpressionEndDelimiterTokenizer<Expression>: _dTeXTokenizer
where Expression: _dTeXUnparsedExpression {
  static var regex: Regex<Expression.SubSequence> { #/}/# }

  static func token(
    of text: Expression.SubSequence
  ) -> _dTeXDescendantExpressionEndDelimiterToken<Expression> { .init(text) }
}

/// Specification of ``_dTeXDescendantExpressionStartDelimiterToken``.
struct _dTeXDescendantExpressionStartDelimiterTokenizer<Expression>: _dTeXTokenizer
where Expression: _dTeXUnparsedExpression {
  static var regex: Regex<Expression.SubSequence> { #/\{|\(/# }

  static func token(
    of text: Expression.SubSequence
  ) -> _dTeXDescendantExpressionStartDelimiterToken<Expression> { .init(text) }
}

/// Specification ``_dTeXWhitespaceToken``.
struct _dTeXWhitespaceTokenizer<Expression>: _dTeXTokenizer
where Expression: _dTeXUnparsedExpression {
  static var regex: Regex<Expression.SubSequence> { #/\s/# }

  static func token(of text: Expression.SubSequence) -> _dTeXWhitespaceToken<Expression> {
    .init(text)
  }
}

/// Specification of ``_dTeXIdentifierToken``.
struct _dTeXIdentifierTokenizer<Expression>: _dTeXTokenizer
where Expression: _dTeXUnparsedExpression {
  static var regex: Regex<Expression.SubSequence> { #/\\[a-z]{3,}/# }

  static func token(of text: Expression.SubSequence) -> _dTeXIdentifierToken<Expression> {
    .init(text.dropFirst())
  }
}

/// Specification of ``_dTeXOperatorToken``.
struct _dTeXOperatorTokenizer<Expression>: _dTeXTokenizer
where Expression: _dTeXUnparsedExpression {
  static var regex: Regex<Expression.SubSequence> { #/\+|\*|\^|-|//# }

  static func token(of text: Expression.SubSequence) -> _dTeXOperatorToken<Expression> {
    .init(text)
  }
}

/// Structure responsible for returning tokens of a specific type from sequences of characters of a
/// dTeX expression.
protocol _dTeXTokenizer<Expression> where Expression: _dTeXUnparsedExpression {
  /// Expression for which this specification of a token is.
  associatedtype Expression: StringProtocol

  /// Token extractable by this tokenizer.
  associatedtype Token: _dTeXToken<Expression>

  /// Regular expression by which this ``_dTeXToken`` is matched.
  static var regex: Regex<Expression.SubSequence> { get }

  /// Returns the token of the `text`.
  ///
  /// - Parameter text: Matching portion of the expression as it is.
  static func token(of text: Expression.SubSequence) -> Token
}

extension _dTeXTokenizer {
  /// Extracts every sequence of characters from an expression which matches the ``regex``,
  /// returning each found token. Implies that such expression is not empty, as such check is
  /// performed by ``_dTeXLexer/tokenize(_:)``.
  ///
  /// - Parameter expression: dTeX expression to tokenize.
  static func tokenize(_ expression: Expression) -> [Token] {
    expression.matches(of: regex).map { match in token(of: match.output) }
  }
}

/// Closing brace (}) or parenthesis ()) delimiting the end of a descendant expression of its
/// ancestor expression.
struct _dTeXDescendantExpressionEndDelimiterToken<Expression>: _dTeXToken
where Expression: _dTeXUnparsedExpression {
  let text: Expression.SubSequence

  init(_ text: Expression.SubSequence) { self.text = text }
}

/// Opening brace ({) or parenthesis (() indicating the beginning of an expression which is a
/// descendant of its ancestor expression.
struct _dTeXDescendantExpressionStartDelimiterToken<Expression>: _dTeXToken
where Expression: _dTeXUnparsedExpression {
  let text: Expression.SubSequence

  init(_ text: Expression.SubSequence) { self.text = text }
}

/// Unique, language-defined name of an element, composed by a backslash (\\) and lowercase letters.
struct _dTeXIdentifierToken<Expression>: _dTeXToken where Expression: _dTeXUnparsedExpression {
  let text: Expression.SubSequence

  init(_ text: Expression.SubSequence) { self.text = text }
}

/// Character which indicates an operation with the expression at the left and the one at the right.
struct _dTeXOperatorToken<Expression>: _dTeXToken where Expression: _dTeXUnparsedExpression {
  let text: Expression.SubSequence

  init(_ text: Expression.SubSequence) { self.text = text }
}

/// Whitespace ( ) for separating one element or expression from another.
struct _dTeXWhitespaceToken<Expression>: _dTeXToken where Expression: _dTeXUnparsedExpression {
  let text: Expression.SubSequence

  init(_ text: Expression.SubSequence) { self.text = text }
}

/// Combination of non-whitespaced characters with semantic meaning within a dTeX expression. They
/// are present in their raw, uncategorized form in an unparsed expression and are extracted and
/// converted into implementations of this protocol by the ``_dTeXLexer``.
protocol _dTeXToken<Expression>: Comparable, Hashable, Sendable
where Expression.SubSequence: Sendable {
  associatedtype Expression: _dTeXUnparsedExpression

  /// Representation of this token as it is in the expression.
  var text: Expression.SubSequence { get }

  /// Instantiates this token, defining the given portion of the expression as its ``text``.
  ///
  /// - Parameter text: Representation of this token as it is in the expression.
  init(_ text: Expression.SubSequence)
}

extension _dTeXToken {
  /// Version of this token unassociated to the expression from which it was extracted.
  var detached: _AnyDTeXToken<String> {
    if let self = self as? any _dTeXToken<String> { return .init(self) }
    return .init(.init(text))
  }
}

extension _dTeXToken where Self: Comparable {
  static func < (lhs: Self, rhs: Self) -> Bool { lhs.text.startIndex < rhs.text.startIndex }
}

extension _dTeXToken where Self: Equatable, Expression: Equatable {
  static func == (lhs: Self, rhs: Self) -> Bool { lhs.text == rhs.text }
}

extension _dTeXToken where Self: Hashable {
  func hash(into hasher: inout Hasher) {
    hasher.combine(ObjectIdentifier(Self.self))
    hasher.combine(text)
  }
}

extension String: _dTeXUnparsedExpression {}

extension Substring: _dTeXUnparsedExpression {}

/// An unparsed expression written in dTeX.
protocol _dTeXUnparsedExpression: StringProtocol where SubSequence == Substring {}
