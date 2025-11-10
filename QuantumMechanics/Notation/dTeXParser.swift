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

import Foundation

/// Abstract syntax tree resulted from parsing an unparsed dTeX expression.
typealias _dTeXAST<Source: _dTeXSource> = Sequence<_AnyDTeXParsedExpression<Source>>

/// Produces the abstract syntax tree (AST) of a dTeX source tokenized by the lexer.
class _dTeXParser {
  private init() {}

  /// Produces the AST of an unparsed dTeX expression.
  ///
  /// Unparsed–parsed-expression conversions are performed by searching for subsequences of tokens
  /// in the unparsed expression which match one of the lexemes described by each type of parsed
  /// expression in its discretion.
  ///
  /// Alongside the production of such tree, the unparsed expression also gets validated; in case
  /// there is invalid syntax (such as unsupported or unknown tokens/lexemes, unexpected characters
  /// or duplicated whitespaces/newlines), an error will be thrown. In this regard, dTeX is
  /// non-lenient: there is only one correct way of writing valid syntax, and anything differing
  /// from such way causes an error.
  ///
  /// If this function returns, the output is guaranteed to be the AST of a valid dTeX expression.
  ///
  /// - Parameter unparsedExpression: Unparsed dTeX expression whose AST will be produced.
  static func ast<Source>(
    of unparsedExpression: _dTeXUnparsedExpression<Source>
  ) -> some _dTeXAST<Source> where Source: _dTeXSource {
    guard !unparsedExpression.isEmpty else { fatalError("Expected an expression.") }
    let discretion = _AnyDTeXParsedExpression<Source>._discretion
    var ast = Set<_AnyDTeXParsedExpression<Source>>()
    lazy var errors = Dictionary<
      _dTeXUnparsedExpression<Source>.SubSequence, _dTeXUnexpectedTokenError<Source>
    >()
    for startIndex in unparsedExpression.indices {
      let lexeme = unparsedExpression[startIndex...]
      for matcher in discretion {
        do {
          try matcher._match(
            against: lexeme,
            inUnparsedExpressionOfType: _dTeXUnparsedExpression<Source>.self
          )
        } catch let error {
          errors[lexeme] = error
          continue
        }

        // Reaching this point means that matching this matcher against the lexeme succeeded;
        // therefore, we can make a parsed expression from it and add it to the AST.
        ast.insert(._make(from: lexeme, matching: matcher))

        // Since all failures of matching the description of a lexeme are deemed as errors (see the
        // `catch` block above), there may have been a matcher against which this lexeme was matched
        // and failed; having undergone matching and added the parsed expression made from such
        // lexeme to the AST means that the previous error should not be accounted for — for we have
        // found the matcher by which the lexeme is accepted.
        errors.removeValue(forKey: lexeme)
      }
    }
    if let error = errors.first { fatalError("\(error)") }
    return ast
  }
}

/// Wrapper which erases the type of a parsed expression.
struct _AnyDTeXParsedExpression<Source>: _dTeXParsedExpression where Source: _dTeXSource {
  let text: Source.SubSequence

  static var _discretion: [_dTeXLexemeMatcher<Source>] {
    _dTeXConstantIdentifier<Source>._discretion
  }

  private init(text: Source.SubSequence) { self.text = text }

  static func _make(
    from lexeme: _dTeXUnparsedExpression<Source>.SubSequence,
    matching lexemeMatcher: _dTeXLexemeMatcher<Source>
  ) -> Self { .init(text: lexeme.text[...]) }
}

/// Parsed identifier of a constant, a predefined reference to a symbol that does not receive any
/// arguments, from an unparsed expression.
enum _dTeXConstantIdentifier<Source>: _dTeXParsedExpression where Source: _dTeXSource {
  var text: Source.SubSequence {
    switch (self) {
    case .hbar(let text): text
    case .pi(let text): text
    }
  }

  static var _discretion: [_dTeXLexemeMatcher<Source>] {
    [
      [.withText("hbar", type: _dTeXIdentifierToken<Source>.self)],
      [.withText("pi", type: _dTeXIdentifierToken<Source>.self)]
    ]
  }

  /// ħ.
  case hbar(_ text: Source.SubSequence)

  /// π.
  case pi(_ text: Source.SubSequence)

  static func _make(
    from lexeme: _dTeXUnparsedExpression<Source>.SubSequence,
    matching lexemeMatcher: _dTeXLexemeMatcher<Source>
  ) -> Self {
    let text = lexeme[0].text
    return switch lexemeMatcher {
    case Self._discretion[0]: .hbar(text)
    default: .pi(text)
    }
  }
}

/// Result of the validation of an unparsed expression which has been tokenized. Expressions of this
/// type are guaranteed to be valid dTeX expressions, and result from producing an AST for such
/// unparsed expression.
protocol _dTeXParsedExpression: Equatable, Hashable {
  /// dTeX source from which the unparsed expression originated.
  associatedtype Source: _dTeXSource

  /// Subsequence of the source which matches one of the discrete combinations of this parsed
  /// expression.
  var text: Source.SubSequence { get }

  /// Bi-dimensional matrix of descriptions of possible lexemes extracted from an unparsed
  /// expression produced by the lexer by which this type of parsed expression can be composed. Any
  /// other combination is that of another type of parsed expression or, if not, invalid.
  static var _discretion: [_dTeXLexemeMatcher<Source>] { get }

  /// Produces this type of parsed expression from a lexeme without performing any verification on
  /// its anatomy.
  ///
  /// This factory method should only be called in cases in which the `lexeme` has been previously
  /// matched against the `lexeme` described in the ``discretion`` by the given matcher, and *should
  /// not* be called by consumers external to the dTeX source analysis machinery.
  ///
  /// - Parameters:
  ///   - lexeme: Subsequence from an unparsed dTeX expression containing the tokens encompassed by
  ///     one of the lexemes described in the ``discretion`` of this type of parsed expression.
  ///     Since no checking is done by this function, the guarantee of validity of the returned
  ///     expression is, instead, imposed on the caller.
  ///   - lexemeMatcher: One of the matchers in the ``discretion`` by which the given `lexeme` is
  ///     described.
  static func _make(
    from lexeme: _dTeXUnparsedExpression<Source>.SubSequence,
    matching lexemeMatcher: _dTeXLexemeMatcher<Source>
  ) -> Self
}

/// Descriptor of the anatomy of a lexeme.
///
/// Its structure may resemble that of a standalone sequence, differing in that recursions over the
/// anatomy of the lexeme are made possible due to their lazy nature: any occurrence of a
/// `recursion` matcher will only be expanded when necessary.
struct _dTeXLexemeMatcher<Source> where Source: _dTeXSource {
  /// Matchers of the tokens by which the lexeme being described is composed.
  fileprivate var _submatchers: [_dTeXLexemeSubmatcher<Source>]

  /// Determines whether the given `lexeme` is of the lexeme described by this matcher.
  ///
  /// - Parameters:
  ///   - lexeme: dTeX lexeme whose structure will be checked against.
  ///   - unparsedExpressionType: Type of the unparsed expression from which the `lexeme` is.
  /// - Throws: If a token which is unexpected by this matcher is found in the `lexeme`.
  func _match<UnparsedExpression>(
    against lexeme: UnparsedExpression.SubSequence,
    inUnparsedExpressionOfType unparsedExpressionType: UnparsedExpression.Type
  ) throws(_dTeXUnexpectedTokenError<Source>)
  where
    UnparsedExpression: Collection, UnparsedExpression.Element == _AnyDTeXToken<Source>,
    UnparsedExpression.SubSequence: RandomAccessCollection, UnparsedExpression.SubSequence: Sendable
  {
    guard !lexeme.isEmpty else {
      throw _dTeXUnexpectedTokenError(
        lexeme: .init(lexeme),
        unexpectedToken: nil,
        expectedSubmatcher: .anyOf(_AnyDTeXToken<Source>.self)
      )
    }
    var iterator = _submatchers.makeBidirectionalIterator()
    while let submatcher = iterator.next() {
      try submatcher._match(
        against: lexeme,
        inUnparsedExpressionOfType: unparsedExpressionType,
        onDidRequestRecursion: { (token) throws(_dTeXUnexpectedTokenError<Source>) in
          do {
            try _submatchers[_submatchers.index(before: _submatchers.endIndex)]._match(
              against: [token],
              inUnparsedExpressionOfType: _dTeXUnparsedExpression<Source>.self,
              onDidRequestRecursion: { _ in
                fatalError(
                  "Unexpected recursion request: it should be imposed on the initialization of a "
                    + "matcher that it cannot contain a `recursive` submatcher as its first or "
                    + "last one; but the token at one of its extremes requested a recursion. "
                    + "This should never happen."
                )
              }
            )
          } catch {
            iterator.reset()
            try _match(
              against: lexeme.dropFirst(iterator.currentIndex + 1),
              inUnparsedExpressionOfType: UnparsedExpression.self
            )
          }
        }
      )
    }
  }
}

extension _dTeXLexemeMatcher: Equatable {
  static func == (lhs: Self, rhs: Self) -> Bool { lhs._submatchers.elementsEqual(rhs._submatchers) }
}

extension _dTeXLexemeMatcher: ExpressibleByArrayLiteral {
  /// Initializes a description of a lexeme of an unparsed dTeX expression.
  ///
  /// - Parameter elements: Submatchers of the tokens by which the lexeme is composed.
  init(arrayLiteral elements: _dTeXLexemeSubmatcher<Source>...) {
    guard !elements.isEmpty else { fatalError("Described lexeme cannot be empty.") }
    guard
      ![elements[elements.startIndex], elements[elements.index(before: elements.endIndex)]]
        .contains(where: { element in return if case .recursion = element { true } else { false } })
    else {
      fatalError(
        "\(elements) is unexpandable because either its first or last submatcher is a "
          + "`recursion` submatcher (which recurses over the description of the lexeme), incurring "
          + "in an infinite repetition and resulting in an overflow."
      )
    }
    _submatchers = .init(elements)
  }
}

/// Descriptional representation of one or more tokens of an unparsed dTeX expression. Matches a
/// subset of tokens superficially, allowing for describing a lexeme without knowledge about every
/// specificity of the input unparsed expression (e.g., the indices of the substring corresponding
/// to the textual representation of such lexeme).
enum _dTeXLexemeSubmatcher<Source> where Source: _dTeXSource {
  /// Matches any token whose type is the given one, regardless of the structure of such token.
  ///
  /// - Parameter type: Type of the matching token.
  case anyOf(_ type: any _dTeXToken<Source>.Type)

  /// Matches, recursively, a subsequence of tokens matching the entire anatomy of the lexeme,
  /// including matchers prior to it and those that follow. Useful for nestable elements, which
  /// allow for occurrences of themselves within them.
  case recursion

  /// Matches any token whose text is equal to the given one. The type of the text of the token
  /// (e.g., a string or a substring) and its indices are disregarded, and the match occurs
  /// exclusively against its characters.
  ///
  /// - Parameters:
  ///   - text: Detached version of the text expected to be that of the token.
  ///   - type: Type expected to be that of token. If `nil`, any token whose text is the given one
  ///     will match.
  case withText(_ text: Source, type: (any _dTeXToken<Source>.Type)? = nil)
}

extension _dTeXLexemeSubmatcher {
  /// Matches against the entirety of the given `lexeme`.
  ///
  /// - Complexity: O(1).
  /// - Parameters:
  ///   - lexeme: dTeX lexeme whose anatomy will be matched against.
  ///   - unparsedExpressionType: Type of the unparsed expression from which the `lexeme` is.
  ///   - onDidRequestRecursion: Callback called by this function in case this submatcher is a
  ///     ``recursion`` submatcher and recursion has been requested — analogous to having its
  ///     occurence in the `lexeme` replaced by the entire anatomy of the `lexeme`.
  ///
  ///     The token passed into this callback — the first in the `lexeme` — should be checked
  ///     against the submatcher which describes the end of the `lexeme`, allowing for determining
  ///     whether recursion of its description is necessary. Logically, such match of the final
  ///     submatcher against this token being successful means that the end of the described
  ///     `lexeme` was reached, and no other occurrence of it within itself exists. The
  ///     responsibility of performing this check is imposed on the caller.
  fileprivate func _match<UnparsedExpression>(
    against lexeme: UnparsedExpression.SubSequence,
    inUnparsedExpressionOfType unparsedExpressionType: UnparsedExpression.Type,
    onDidRequestRecursion: (_AnyDTeXToken<Source>) throws(_dTeXUnexpectedTokenError<Source>) -> Void
  ) throws(_dTeXUnexpectedTokenError<Source>)
  where
    UnparsedExpression: Collection, UnparsedExpression.Element == _AnyDTeXToken<Source>,
    UnparsedExpression.SubSequence: RandomAccessCollection, UnparsedExpression.SubSequence: Sendable
  {
    var lexemeIterator = lexeme.makeIterator()
    switch self {
    case .anyOf(let type):
      guard let token = lexemeIterator.next() else {
        throw _dTeXUnexpectedTokenError(
          lexeme: .init(lexeme),
          unexpectedToken: nil,
          expectedSubmatcher: self
        )
      }
      guard token.is(type) else {
        print("\(token) is not of type \(type)!")
        throw _dTeXUnexpectedTokenError(
          lexeme: .init(lexeme),
          unexpectedToken: token,
          expectedSubmatcher: self
        )
      }
    case .recursion:
      guard let token = lexemeIterator.next() else {
        throw _dTeXUnexpectedTokenError(
          lexeme: .init(lexeme),
          unexpectedToken: nil,
          expectedSubmatcher: self
        )
      }
      try onDidRequestRecursion(token)
    case .withText(let text, let type):
      guard let token = lexemeIterator.next() else {
        throw _dTeXUnexpectedTokenError(
          lexeme: .init(lexeme),
          unexpectedToken: nil,
          expectedSubmatcher: self
        )
      }
      guard token.text.elementsEqual(text) else {
        throw _dTeXUnexpectedTokenError(
          lexeme: .init(lexeme),
          unexpectedToken: token,
          expectedSubmatcher: self
        )
      }
      guard let type else { return }
      guard token.is(type) else {
        throw _dTeXUnexpectedTokenError(
          lexeme: .init(lexeme),
          unexpectedToken: token,
          expectedSubmatcher: self
        )
      }
    }
  }
}

extension _dTeXLexemeSubmatcher: CustomStringConvertible {
  /// Description of the expectancy of this submatcher, following the same guidelines of that of a
  /// type of token.
  var description: String {
    return switch self {
    case .anyOf(let type): type.description
    case .recursion: "a recursion"
    case .withText(let text, let type):
      "\((type ?? _AnyDTeXToken<Source>.self).description) with text \"\(text)\""
    }
  }
}

extension _dTeXLexemeSubmatcher: Equatable {
  public static func == (lhs: Self, rhs: Self) -> Bool {
    switch lhs {
    case .anyOf(let lhsType):
      guard case .anyOf(let rhsType) = rhs else { return false }
      return lhsType == rhsType
    case .recursion:
      guard case .recursion = rhs else { return false }
      return true
    case .withText(let lhsText, let lhsType):
      guard case .withText(let rhsText, let rhsType) = lhs else { return false }
      return lhsText == .init(rhsText) && lhsType == rhsType
    }
  }
}

extension _dTeXLexemeSubmatcher: Hashable {
  func hash(into hasher: inout Hasher) {
    switch self {
    case .anyOf(let type): hasher.combine(ObjectIdentifier(type))
    case .recursion: hasher.combine(1)
    case .withText(let text, let type):
      hasher.combine(text)
      let typeID: ObjectIdentifier? = if let type { ObjectIdentifier(type) } else { nil }
      hasher.combine(typeID)
    }
  }
}

/// Failure occured while matching a lexeme because of an unexpected token.
struct _dTeXUnexpectedTokenError<Source>: Error where Source: _dTeXSource {
  /// The lexeme containing the ``unexpectedToken``.
  let lexeme: AnyCollection<_AnyDTeXToken<Source>>.SubSequence

  /// Token which was found unexpectedly in the ``lexeme``. This being `nil` denotes that a token
  /// was expected but none was given.
  let unexpectedToken: _AnyDTeXToken<Source>?

  /// Submatcher of the token which was expected to be found in the ``lexeme`` instead of the
  /// ``unexpectedToken``.
  let expectedSubmatcher: _dTeXLexemeSubmatcher<Source>
}

extension _dTeXUnexpectedTokenError: CustomStringConvertible {
  var description: String {
    let unscanned = "Expected \(expectedSubmatcher)"
    guard let unexpectedToken else { return unscanned }
    let lexemeText = lexeme.text
    let characterIndex = unexpectedToken.text.startIndex
    let absLineIndex = lexemeText.abs(lexemeText.lineIndex(ofCharacterAt: characterIndex))
    let absInlinedIndex = lexemeText.abs(lexemeText.inlinedIndex(ofCharacterAt: characterIndex))
    return "\(unscanned) at line \(absLineIndex + 1), column \(absInlinedIndex + 1)"
  }
}

extension _dTeXUnexpectedTokenError: Equatable {
  static func == (lhs: Self, rhs: Self) -> Bool {
    lhs.unexpectedToken == rhs.unexpectedToken && lhs.expectedSubmatcher == rhs.expectedSubmatcher
  }
}
