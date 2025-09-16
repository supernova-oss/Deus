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

/// Wrapper for erasing the specific type of a given ``Notation``.
public final class AnyNotation: Notation {
  public let _terms: [AnyNotation]
  public let _flatDescription: String

  required init(_ base: some Notation) {
    _terms = base._terms as? [AnyNotation] ?? base._terms.map(AnyNotation.init)
    _flatDescription = base._flatDescription
  }

  /// Erases the type of the given ``Notation`` by wrapping it with an instance of this class.
  ///
  /// - Parameter base: ``Notation`` whose type will be erased.
  public static func make(_ base: some Notation) -> Self {
    if let base = base as? Self { return base }
    return .init(base)
  }
}

extension AnyNotation: Equatable {
  public static func == (lhs: AnyNotation, rhs: AnyNotation) -> Bool {
    lhs._terms.count == rhs._terms.count && zip(lhs._terms, rhs._terms).allSatisfy(==)
  }
}

extension Array: Notation where Element: Notation {
  public var _flatDescription: String { _terms.map(\.description).joined() }
  public var _terms: [Element] { self }
}

/// Term constituting a mathematical notation, be it an independent one or one which is part of
/// another. "ab² + c" is an example of notation. Acts as an alternative to the limited
/// representability in plaintext of mathematical characters and expressions.
///
/// ## Constraints of notations in plaintext
///
/// There is a limit for what can be represented in plaintext. Some mathematical characters may be
/// provided by the encoding (e.g., UTF-8), but, even then, the final notation might still not be
/// technically correct and precise.
///
/// Consider, for example, that we want to express the quantum-mechanical behavior of a particle at
/// a given temperature via the thermal de Broglie wavelength (its meaning is not important for the
/// purposes of this documentation; the notation is). In plaintext, it could be notated as
///
/// `((mk_BT)/(2πħ²))^(3/2)`
///
/// The underscore \_ denotes that the term that follows is subscripted, while the circunflex
/// signalizes that the next term in parenthesis is superscripted. Given the constraints imposed by
/// the encoding, notating it in such a way may be OK in some contexts, but also potentially
/// misleading in others. For instance, what is it that is being subscripted in the first term of
/// the first ratio: is it B? Or is it both B and T?
///
/// ## Notational abstraction
///
/// These limitations are the motivation for this abstraction. A notation built by instantiating
/// a struct or class conforming to this protocol can be represented in various forms, such as the
/// discussed plaintext one and in TeX format, which allows for more semantic preciseness.
/// Mathematical symbols are constructed through the DSL, and can be converted into such different
/// forms later on.
///
/// E.g., suppose we want to notate the prior expression in an abstract manner:
///
/// ```swift
/// (("mk" + Sub("B") + "T") / "2" + Pi() + (ReducedPlanck() ^ 2)) ^ ("3" / "2")
/// ```
///
/// Now, there is no room for suspiscion on whether it was only B that was subscripted. The
/// expression is notated clearly, and can be converted into plaintext (i.e., its ``description``
/// can be accessed) or LeX afterwards.
public protocol Notation: CustomStringConvertible, Equatable, Sendable {
  /// Whether this ``Notation`` contains more than one term or its single term, x, contains only one
  /// term, which is different from x. Compoundness is the opposite of flatness.
  var isCompound: Bool { get }

  /// `String` representation for when this ``Notation`` is flat (non-compound).
  ///
  /// - SeeAlso: ``isCompound``
  var _flatDescription: String { get }

  /// `String` representation for when this ``Notation`` is compound (non-flat).
  ///
  /// - SeeAlso: ``isCompound``
  var _compoundDescription: String { get }

  /// Type of each of the ``terms``.
  associatedtype Term: Notation

  /// ``Notation``s onto which this one is applied.
  var _terms: [Term] { get }
}

extension Notation {
  public var isCompound: Bool {
    guard _terms.count > 0 else { return false }
    guard _terms.count == 1 else { return true }
    let singleTerm = _terms[0]
    guard singleTerm._terms.count > 0 else { return false }
    guard singleTerm._terms.count == 1 else { return true }
    guard let singleTermOfSingleTerm = singleTerm._terms[0] as? Term else { return true }
    return singleTermOfSingleTerm != singleTerm
  }

  public var _compoundDescription: String { "(\(_flatDescription))" }
}

extension Notation where Self: CustomStringConvertible {
  public var description: String { isCompound ? _compoundDescription : _flatDescription }
}

extension Notation where Self: Equatable, Term: Equatable {
  public static func == (lhs: Self, rhs: Self) -> Bool { lhs._terms.elementsEqual(rhs._terms) }
}
