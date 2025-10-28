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

/// Produces the abstract syntax tree (AST) of an unparsed dTeX expression which has been tokenized
/// by the lexer.
class _dTeXParser {
  private init() {}

  /// Produces the AST of an expression written in dTeX.
  ///
  /// Alongside the production of such tree, the expression also gets validated; in case there is
  /// invalid syntax (such as unsupported or unknown elements, unexpected characters or duplicated
  /// whitespaces/newlines), an error will be thrown. In this regard, dTeX is non-lenient: there is
  /// only one correct way of writing valid syntax, and anything differing from such way causes an
  /// error.
  ///
  /// If this function returns, the output is guaranteed to be the AST of a valid dTeX expression.
  ///
  /// - Parameter syntax: Tokens from an unparsed dTeX expression whose AST will be produced.
  static func ast<Source>(of syntax: [_AnyDTeXToken<Source>]) -> _AnyDTeXParsedExpression<Source>
  where Source: _dTeXUnparsedExpression {
    guard !syntax.isEmpty else { fatalError("Expected an expression.") }
    return .init(text: syntax.text[...])
  }
}

/// Wrapper which erases the type of a parsed expression.
struct _AnyDTeXParsedExpression<Source>: _dTeXParsedExpression
where Source: _dTeXUnparsedExpression {
  let text: Source.SubSequence

  static var discretion: [_dTeXSyntax<String>] { _dTeXConstantIdentifier<Source>.discretion }

  init(detachedSyntax: _dTeXSyntax<String>, attachedSyntax: _dTeXSyntax<Source>) {
    self = .init(text: attachedSyntax.text[...])
  }

  init(text: Source.SubSequence) { self.text = text }
}

/// Parsed identifier of a constant, a predefined reference to a symbol that does not receive any
/// arguments, from an unparsed expression.
enum _dTeXConstantIdentifier<Source>: _dTeXParsedExpression where Source: _dTeXUnparsedExpression {
  var text: Source.SubSequence {
    switch (self) {
    case .hbar(let text): text
    case .pi(let text): text
    }
  }

  static var discretion: [_dTeXSyntax<String>] {
    [[.init(_dTeXIdentifierToken("hbar"))], [.init(_dTeXIdentifierToken("pi"))]]
  }

  /// ħ.
  case hbar(_ text: Source.SubSequence)

  /// π.
  case pi(_ text: Source.SubSequence)

  init(detachedSyntax: _dTeXSyntax<String>, attachedSyntax: _dTeXSyntax<Source>) {
    var discretionIterator = Self.discretion.makeIterator()
    self =
      switch detachedSyntax {
      case discretionIterator.next(): .hbar(attachedSyntax[attachedSyntax.startIndex].text)
      case discretionIterator.next(): .pi(attachedSyntax[attachedSyntax.startIndex].text)
      default:
        fatalError(
          "Expected an `hbar` or a `pi` constant identifier; got `\(attachedSyntax.text)` instead."
        )
      }
  }
}

/// Result of the validation of an unparsed expression which has been tokenized. Expressions of this
/// type are guaranteed to be valid dTeX expressions, and result from producing an AST for such
/// unparsed expression.
protocol _dTeXParsedExpression: Equatable, Hashable {
  /// Unparsed expression by which this parsed one originated.
  associatedtype Source: _dTeXUnparsedExpression

  /// Subsequence of the source which matches one of the discrete combinations of this parsed
  /// expression.
  var text: Source.SubSequence { get }

  /// Bi-dimensional matrix of possible syntaxes extracted from an unparsed expression produced by
  /// the lexer by which this type of parsed expression can be composed. Any other combination is
  /// that of another type of parsed expression or, if not, invalid.
  static var discretion: [_dTeXSyntax<String>] { get }

  /// Initializes this type of parsed expression from both versions of the syntax produced by the
  /// lexer: the _attached_ and the _detached_ one.
  ///
  /// - Parameters:
  ///   - detachedSyntax: Syntax which retains no information regarding its source, starting at
  ///     index zero.
  ///   - attachedSyntax: Syntax which is related to its source, maintaining the original index of
  ///     each of its characters.
  init(detachedSyntax: _dTeXSyntax<String>, attachedSyntax: _dTeXSyntax<Source>)
}

extension _dTeXParsedExpression {
  /// Extracts all occurrences of this type of parsed expression in the given `syntax` produced by
  /// the lexer.
  ///
  /// Token–parsed-expression conversions are performed by searching for subsequences of tokens in
  /// the `syntax` which match one of the combinations specified by this type in its ``discretion``,
  /// with each finding being included in the resulting set.
  ///
  /// This function returning an empty set denotes that no subsequence of tokens matches one of the
  /// possibilities for this type.
  ///
  /// - Parameter syntax: Tokens from an unparsed dTeX expression.
  static func find(in syntax: _dTeXSyntax<Source>) -> Set<Self> {
    guard !syntax.isEmpty else { return [] }
    let detachments = Dictionary(
      uniqueKeysWithValues: syntax.map { attachedToken in (attachedToken, attachedToken.detached) }
    )
    let detachedSyntax = Array(detachments.values)
    return .init(
      zip(discretion.indices, discretion).compactMap { (discretionIndex, discretionSyntax) in
        // The discretion contains syntaxes which are not associated to a particular unparsed
        // expression (meaning: they contain only detached tokens). However, the given syntax is
        // attached; therefore, each of its tokens is mapped to their detached version in order for
        // them to be comparable with those of the current discretion syntax, allowing for checking
        // the actual syntax — now detached — against the current discretion one.
        var detachedMatch = detachedSyntax
        detachedMatch.formIntersection(discretionSyntax, by: \.text)
        guard
          detachedMatch.elementsEqual(
            discretionSyntax,
            by: { matchToken, discretionToken in matchToken.text == discretionToken.text }
          )
        else {
          // Reaching this branch denotes that the actual syntax is empty or contains tokens other
          // than those defined for the current discretion syntax. After returning, the actual
          // syntax will be checked against the remaining from the discretion or, if none is left,
          // the process may get terminated elsewhere.
          return nil
        }

        // Given that the previous guard succeeded, the actual syntax matches the current discretion
        // syntax; we, then, convert the detached match between them into an attached syntax and
        // initialize an instance of this type of parsed expression into the resulting set.
        let attachedMatch = detachedMatch.compactMap { detachedMatchToken in
          let detachedTypeErasedMatchToken = detachedMatchToken.detached
          return detachments.first(where: { (_, detachedTypeErasedSyntaxToken) in
            detachedTypeErasedMatchToken == detachedTypeErasedSyntaxToken.detached
          })?.key
        }
        return .init(detachedSyntax: detachedMatch, attachedSyntax: attachedMatch)
      }
    )
  }
}
