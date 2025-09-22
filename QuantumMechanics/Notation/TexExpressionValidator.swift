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

/// `Array` containing each of the ``TexSyntaxElementExpectator``s which have been declared by the
/// ``QuantumMechanics`` framework.
private let allElementExpectatorTypes: [any TexExpressionElementExpectator.Type] = [
  TexConstantExpectator.self, TexLiteralExpectator.self
]

/// Set containing a backslash, character by which the start of a named element of TeX syntax is
/// delimited.
private let namedElementDelimiters = CharacterSet(charactersIn: "\\")

/// Parser-like structure which validates the syntax of TeX expressions. Differs from a parser in
/// that it does not produce an abstract syntax tree (AST), limiting itself only to analyzing
/// whether the input is well-formed and represents a valid TeX expression.
///
/// ## Limitations
///
/// This validator, as of the first version of Deus, is incomplete, as it only supports the syntax
/// of mathematical constants and functions and overall expressions required by the application. TeX
/// engines (e.g., LaTeX) tipically allow for structures beyond the scope of mathematics, which is
/// not the end goal of this validator; therefore, unrelated features are unsupported.
///
/// Attempts of validating expressions which include unsupported syntax will terminate the process,
/// as will inputting malformed TeX expressions.
///
/// ## Supported elements
///
/// | Constant    | Function       | Operator  |
/// |-------------|----------------|-----------|
/// | `\hbar`     | `\frac{a}{b}`  | `{a}^{b}` |
/// | `\pi`       | `\overline{a}` | `{a}_{b}` |
///
/// ## Reference
///
/// For more details on the TeX specification beyond the scope covered by this validator, check the
/// copy of [The TeXbook](https://web.math.ucsb.edu/~bigelow/books/texbook.pdf) authored by its
/// creator, Donald Knuth, provided by the University of California, Santa Barbara (UCSB).
public final class _TexExpressionValidator {
  private init() {}

  /// Asserts that the given `expression` is well-formed and represents a valid TeX expression (as
  /// per the TeX specification, within the limitations of this validator). Passing in an invalid
  /// syntax causes the process to terminate.
  ///
  /// - Parameter expression: TeX expression to be validated.
  static func validate(_ expression: String) {
    do { try validateOrThrow(expression) } catch { fatalError(error.localizedDescription) }
  }

  /// Function to which validation is delegated by the public, static overload. This one throws an
  /// error instead of terminating the process; not because this is the intended behavior of this
  /// validator, but due to a crash in SourceKitService as of Xcode 26.0 which prevents testing
  /// the behavior of the function with `expect(processExitsWith:performing:)`.
  ///
  /// - Parameter expression: TeX expression to be validated.
  static func validateOrThrow(_ expression: String) throws(TexSyntaxError) {
    guard !expression.isBlank else { throw TexSyntaxError.blank }

    // Subscripting here is problematic: will error fatally if the syntax is not blank but prefixed
    // with whitespaces (e.g., ` {a}^{b}`).
    let firstElement = expression[
      expression.startIndex..<(expression.firstIndex(of: " ") ?? expression.endIndex)
    ]

    let firstElementCharacters = CharacterSet(firstElement.unicodeScalars)

    var elementIterator = TexExpressionElementIterator(expression: expression)
    while let element = elementIterator.next() {
      let characters = CharacterSet(element.unicodeScalars)
      allElementExpectatorTypes.compactMap { expectatorType in
        guard expectatorType.expects(generally: characters) else {
          return nil as [any TexExpressionElementExpectator]?
        }
        return expectatorType.allCases.filter { expectator in
          expectator.expects(specifically: characters)
        }
      }.joined()
    }
  }
}

/// Error which can be thrown while validating TeX syntax.
///
/// Realistically, these cases would not be referenced by callers of the validation API, as
/// validation should be performed by calling `_TexSyntaxValidator/validate(_:)` rather than
/// `_TextSyntaxValidator/validateOrThrow(_:)`.
public enum TexSyntaxError {
  /// The syntax is empty.
  case blank

  /// None of the supported element expectators support the given `syntax`. Thrown when such syntax
  /// is found at the start of the overall string.
  case unexpected(syntax: Substring)
}

extension TexSyntaxError: Error {
  var localizedDescription: String {
    switch self {
    case .blank: return "TeX expression cannot be blank."
    case .unexpected(let syntax):
      let elementDescriptions = allElementExpectatorTypes.map(\.elementDebugDescription)
      let enumeratedElementDescriptions =
        elementDescriptions.count == 1
        ? elementDescriptions[0]
        : "\(elementDescriptions.dropLast().joined()) or \(elementDescriptions.last!)"
      return "Expected \(enumeratedElementDescriptions); got \"\(syntax)\"."
    }
  }
}

/// Iterator for each element within a TeX expression, including their child elements, the children
/// of their children, and so on.
///
/// Elements are delimited by exactly one whitespace, and omissions or repetitions of such delimiter
/// will result in an error being thrown or termination of the process by the
/// `TexExpressionValidator``.
private struct TexExpressionElementIterator: IteratorProtocol {
  /// TeX expression whose descendant expressions will be iterated.
  let expression: String

  /// Index of the last character of the last expression obtained through ``next()``.
  private var previousEndIndex: String.Index?

  init(expression: String) { self.expression = expression }

  mutating func next() -> Substring? {
    let previousEndIndex = previousEndIndex ?? expression.startIndex
    self.previousEndIndex = previousEndIndex
    var next = expression[previousEndIndex...]
    next = next[..<(next.firstIndex(of: " ") ?? next.endIndex)]
    return next
  }
}

extension StringProtocol {
  /// Whether this string is composed only by whitespaces or newline characters.
  fileprivate var isBlank: Bool {
    allSatisfy({ character in character.isWhitespace || character.isNewline })
  }
}

/// Validator of supported constants, which are elements of a TeX expression which cannot accept
/// arguments (as does, e.g., `{a}^{b}`); they consist of a backslash (\) followed by the name of
/// the constant.
private enum TexConstantExpectator: TexExpressionNamedElementExpectator {
  var name: String {
    switch self {
    case .hbar: "hbar"
    case .pi: "pi"
    }
  }
  var specificNextTokens: [TexToken] { [.specificElementName(name: name)] }

  static let generalTokens = [TexToken.anyElementName]
  static let elementDebugDescription = "a constant"

  /// ħ.
  case hbar

  /// π.
  case pi
}

/// ``TexSyntaxElementExpectator`` which is identifiable by name. Examples of supported elements
/// that are named are the constant `\hbar` and the function `\fraction{a}{b}`, while a
/// counterexample is the operator `{a}^{b}`.
private protocol TexExpressionNamedElementExpectator: TexExpressionElementExpectator {
  /// Name of of the element as it appears after the backslash (\) in valid TeX syntax.
  var name: String { get }
}

/// ``TextSyntaxElementExpectator`` containing characters which should be evaluated as they are
/// (e.g., `abc`).
private struct TexLiteralExpectator: TexExpressionElementExpectator {
  static let allCases = [Self.init()]
  static let generalTokens = [TexToken.literals]
  static let elementDebugDescription = "a literal"

  private init() {}
}

/// Validator of a specific element within a LeX expression, which determines the tokens expected in
/// valid elements. As each type of element encompasses a discrete set of possibilities (e.g., only
/// some constants such as `\hbar` and `\pi` are supported; the same goes for functions),
/// implementations of this protocol should probably be declared as enums.
private protocol TexExpressionElementExpectator: CaseIterable, Sendable where AllCases == [Self] {
  /// Non-empty `Array` of tokens by which the element is composed. Is specific in that it may be
  /// different from the general ones, given that it takes this specific instance of expectator into
  /// consideration.
  var specificTokens: [TexToken] { get }

  /// Non-empty `Array` of tokens by which the element is composed. As this is a static property,
  /// the tokens contained in it are not specific to an instance of expectator of this type (e.g.,
  /// for an expectator whose element is named, it does not match the specific name of the element;
  /// rather, it matches the overall characters which a name in TeX can contain.
  static var generalTokens: [TexToken] { get }

  /// Trimmed, lower-cased, description of the type of element expected by this expectator
  /// for debugging purposes. May be prefixed by an article ("a", "an", "the", …).
  static var elementDebugDescription: String { get }
}

extension TexExpressionElementExpectator {
  var specificTokens: [TexToken] { Self.generalTokens }

  func expects(specifically characters: CharacterSet) -> Bool {
    specificTokens.contains(where: { token in token.characters.isSuperset(of: characters) })
  }

  /// Returns whether the given set of characters by which an element is composed is one which is
  /// expected by this expectator *without* checking, e.g, the validity of the name of an element;
  /// rather, only the characters themselves will be considered.
  ///
  /// - Parameter characters: Characters of the element.
  static func expects(generally characters: CharacterSet) -> Bool {
    Self.generalTokens.contains(where: { token in token.characters.isSuperset(of: characters) })
  }
}

/// Component of an element in TeX syntax.
private enum TexToken {
  /// Characters matched by this token.
  var characters: CharacterSet {
    switch self {
    case .anyElementName: namedElementDelimiters.union(.lowercaseLetters)
    case .specificElementName(let name): namedElementDelimiters.union(.init(charactersIn: name))
    case .literals: .alphanumerics
    }
  }

  /// Token of the name of any element. May not be a valid element name.
  case anyElementName

  /// Token of the given `name` of an element.
  case specificElementName(name: String)

  /// Token of a sequence of literal characters.
  case literals
}

extension TexToken: CustomDebugStringConvertible {
  var debugDescription: String {
    switch self {
    case .anyElementName: "the name of an element"
    case .specificElementName(let name): "a \(name)"
    case .literals: "literals"
    }
  }
}
