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

/// Result of the tokenization of a dTeX source by the lexer.
typealias _dTeXUnparsedExpression<Source: _dTeXSource> = [_AnyDTeXToken<Source>]

extension Collection where Element: _dTeXToken {
  /// Conjunct textual representation of each token in the unparsed expression.
  var text: String { map(\.text).joined() }
}

/// Extractor of tokens of dTeX sources.
class _dTeXLexer {
  private init() {}

  /// Extracts the tokens present in the given `source`.
  ///
  /// Different from TeX, the equation **should not** be surrounded by dollar signs ($) in case
  /// their purpose is to delimit inline math mode, as dTeX already operates only in such mode of
  /// TeX. Including these symbols at the start and/or the end of the string without escaping them
  /// results in an invalid dTeX main expression.
  static func tokenize<Source>(_ source: Source) -> _dTeXUnparsedExpression<Source>
  where Source: _dTeXSource {
    guard !source.isEmpty else { return [] }
    return
      ([
        _dTeXDescendantExpressionEndDelimiterTokenizer<Source>.self,
        _dTeXDescendantExpressionStartDelimiterTokenizer<Source>.self,
        _dTeXIdentifierTokenizer<Source>.self, _dTeXOperatorTokenizer<Source>.self,
        _dTeXWhitespaceTokenizer<Source>.self
      ] as [any _dTeXTokenizer<Source>.Type]).flatMap({ tokenizerType in
        tokenizerType.tokenize(source).map { token in _AnyDTeXToken(token) }
      }).sorted()
  }
}

/// Wrapper which erases the type of a token.
struct _AnyDTeXToken<Source: _dTeXSource>: _dTeXToken, Sendable {
  /// Original type of the token, erased by this wrapper; or `nil` in case this wrapper was
  /// initialized from a text instead of a base token.
  let erasedType: (any _dTeXToken<Source>.Type)?

  let text: Source.SubSequence

  static var description: String { "any token" }

  init(_ base: any _dTeXToken<Source>) {
    self =
      if let base = base as? Self { base } else {
        .init(erasedType: type(of: base), text: base.text)
      }
  }

  init(_ text: Source.SubSequence) { self = .init(erasedType: nil, text: text) }

  private init(erasedType: (any _dTeXToken<Source>.Type)?, text: Source.SubSequence) {
    self.erasedType = erasedType
    self.text = text
  }

  func `is`(_ type: any _dTeXToken<Source>.Type) -> Bool { Self.self == type || erasedType == type }
}

extension _AnyDTeXToken: Equatable {
  static func == (lhs: Self, rhs: Self) -> Bool { lhs.text == rhs.text }
}

/// Specification of ``_dTeXDescendantExpressionEndDelimiterToken``.
struct _dTeXDescendantExpressionEndDelimiterTokenizer<Source>: _dTeXTokenizer
where Source: _dTeXSource {
  static var regex: Regex<Source.SubSequence> { #/}/# }

  static func token(
    of text: Source.SubSequence
  ) -> _dTeXDescendantExpressionEndDelimiterToken<Source> { .init(text) }
}

/// Specification of ``_dTeXDescendantExpressionStartDelimiterToken``.
struct _dTeXDescendantExpressionStartDelimiterTokenizer<Source>: _dTeXTokenizer
where Source: _dTeXSource {
  static var regex: Regex<Source.SubSequence> { #/\{|\(/# }

  static func token(
    of text: Source.SubSequence
  ) -> _dTeXDescendantExpressionStartDelimiterToken<Source> { .init(text) }
}

/// Specification ``_dTeXWhitespaceToken``.
struct _dTeXWhitespaceTokenizer<Source>: _dTeXTokenizer where Source: _dTeXSource {
  static var regex: Regex<Source.SubSequence> { #/\s/# }

  static func token(of text: Source.SubSequence) -> _dTeXWhitespaceToken<Source> { .init(text) }
}

/// Specification of ``_dTeXIdentifierToken``.
struct _dTeXIdentifierTokenizer<Source>: _dTeXTokenizer where Source: _dTeXSource {
  static var regex: Regex<Source.SubSequence> { #/\\[a-z]{3,}/# }

  static func token(of text: Source.SubSequence) -> _dTeXIdentifierToken<Source> {
    .init(text.dropFirst())
  }
}

/// Specification of ``_dTeXOperatorToken``.
struct _dTeXOperatorTokenizer<Source>: _dTeXTokenizer where Source: _dTeXSource {
  static var regex: Regex<Source.SubSequence> { #/\+|\*|\^|-|//# }

  static func token(of text: Source.SubSequence) -> _dTeXOperatorToken<Source> { .init(text) }
}

/// Structure responsible for returning tokens of a specific type from sequences of characters of a
/// dTeX expression.
protocol _dTeXTokenizer<Source> {
  /// dTeX source to be tokenized.
  associatedtype Source: _dTeXSource

  /// Token extractable by this tokenizer.
  associatedtype Token: _dTeXToken<Source>

  /// Regular expression by which the token is matched.
  static var regex: Regex<Source.SubSequence> { get }

  /// Returns the token of the `text`.
  ///
  /// - Parameter text: Matching portion of the source as it is.
  static func token(of text: Source.SubSequence) -> Token
}

extension _dTeXTokenizer {
  /// Extracts every sequence of characters from a source which matches the ``regex``, returning
  /// each found token. Implies that such source is not empty, as such check is performed by
  /// ``_dTeXLexer/tokenize(_:)``.
  ///
  /// - Parameter source: dTeX source to tokenize.
  static func tokenize(_ source: Source) -> [Token] {
    source.matches(of: regex).map { match in token(of: match.output) }
  }
}

/// Closing brace (}) or parenthesis ()) delimiting the end of a descendant expression of its
/// ancestor expression.
struct _dTeXDescendantExpressionEndDelimiterToken<Source>: _dTeXToken where Source: _dTeXSource {
  let text: Source.SubSequence

  static var description: String { "start of expression" }

  init(_ text: Source.SubSequence) { self.text = text }
}

/// Opening brace ({) or parenthesis (() indicating the beginning of an expression which is a
/// descendant of its ancestor expression.
struct _dTeXDescendantExpressionStartDelimiterToken<Source>: _dTeXToken where Source: _dTeXSource {
  let text: Source.SubSequence

  static var description: String { "end of expression" }

  init(_ text: Source.SubSequence) { self.text = text }
}

/// Unique, language-defined name of an element, composed by a backslash (\\) and lowercase letters.
struct _dTeXIdentifierToken<Source>: _dTeXToken where Source: _dTeXSource {
  let text: Source.SubSequence

  static var description: String { "an identifier" }

  init(_ text: Source.SubSequence) { self.text = text }
}

/// Character which indicates an operation with the expression at the left and the one at the right.
struct _dTeXOperatorToken<Source>: _dTeXToken where Source: _dTeXSource {
  let text: Source.SubSequence

  static var description: String { "an operator" }

  init(_ text: Source.SubSequence) { self.text = text }
}

/// Whitespace ( ) for separating one element or expression from another.
struct _dTeXWhitespaceToken<Source>: _dTeXToken where Source: _dTeXSource {
  let text: Source.SubSequence

  static var description: String { "a whitespace" }

  init(_ text: Source.SubSequence) { self.text = text }
}

/// Combination of non-whitespaced characters with semantic meaning within a dTeX source. They are
/// present in their raw, uncategorized form in an unparsed expression and are extracted and
/// converted into implementations of this protocol by the lexer.
protocol _dTeXToken<Source>: Comparable, Hashable, Sendable where Source.SubSequence: Sendable {
  associatedtype Source: _dTeXSource

  /// Representation of this token as it is in the source.
  var text: Source.SubSequence { get }

  /// Instantiates this token, defining the given portion of the expression as its ``text``.
  ///
  /// - Parameter text: Representation of this token as it is in the source.
  init(_ text: Source.SubSequence)

  /// Determines whether this token is of the given `type`.
  ///
  /// ## On type erasure
  ///
  /// In case this token is type-erased, i.e., is an ``_AnyDTeXToken``, the check will be performed
  /// against both its actual type and its erased one, meaning that calling this function on such
  /// type-erased token as
  ///
  /// ```swift
  /// is(_AnyDTeXToken<Expression>.self)
  /// ```
  ///
  /// results in `true`. Equivalently,
  ///
  /// ```swift
  /// is(_dTeXIdentifierToken<Expression>.self)
  /// ```
  ///
  /// returns `true` in case the erased type is `_dTeXIdentifierToken<Expression>`.
  func `is`(_ type: any _dTeXToken<Source>.Type) -> Bool

  /// Display explanation of the meaning of a token of this type in an unparsed dTeX expression.
  /// Particularly useful for diagnostics.
  ///
  /// This string may be included in another one; therefore, it should make the sentence of which it
  /// may be a part intelligible and natural. This can be achieved by, e.g., having the first word
  /// of such string be decapitalized, an indefinite article at the start and no punctuation
  /// denoting its end.
  ///
  /// For example: the return of
  ///
  /// ```swift
  /// static var description: String { "A token." }
  /// ```
  ///
  /// might be included in an error message stating that a token of such type was expected in a
  /// stage posterior to lexing. If it is added in a position which is not both the start and the
  /// end of a message unpunctuated at its end, the ortography of the final sentence will be
  /// unconventional in Standard English as of November, 2025. Including it in
  ///
  /// ```swift
  /// "Expected \(description)."
  /// ```
  ///
  /// yields
  ///
  /// ```swift
  /// "Expected A token.."
  /// ```
  ///
  /// Rather, prefer following the aforementioned guidelines. Applying them to the previous
  /// description by declaring it as
  ///
  /// ```swift
  /// static var description: String { "a token" }
  /// ```
  ///
  /// would result in that message being
  ///
  /// ```swift
  /// "Expected a token."
  /// ```
  ///
  /// in which is interpolated the syntagm whose ortography is that which is expected by callers of
  /// this getter.
  static var description: String { get }
}

extension _dTeXToken {
  /// Version of this token unassociated from the source from which it was extracted.
  var detached: _AnyDTeXToken<String> {
    if let self = self as? any _dTeXToken<String> { return .init(self) }
    return .init(.init(text))
  }

  func `is`(_ type: any _dTeXToken<Source>.Type) -> Bool { Self.self == type }
}

extension _dTeXToken where Self: Comparable {
  static func < (lhs: Self, rhs: Self) -> Bool { lhs.text.startIndex < rhs.text.startIndex }
}

extension _dTeXToken where Self: Equatable, Source: Equatable {
  static func == (lhs: Self, rhs: Self) -> Bool { lhs.text == rhs.text }
}

extension _dTeXToken where Self: Hashable {
  func hash(into hasher: inout Hasher) {
    hasher.combine(ObjectIdentifier(Self.self))
    hasher.combine(text)
  }
}

extension String: _dTeXSource {}

extension Substring: _dTeXSource {}

/// Raw and unparsed form of an unparsed dTeX expression.
protocol _dTeXSource: Hashable, Sendable, StringProtocol where SubSequence == Substring {}
