// ===-------------------------------------------------------------------------------------------===
// Copyright © 2025 Supernova. All rights reserved.
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

/// Type-erased ``SingleColorLike``. Might be ``red``, antired, ``green``, antigreen, ``blue`` or
/// antiblue.
public struct AnySingleColorLike: Discrete, SingleColorLike {
  /// ``SingleColorLike`` whose type has been erased. Casting it to the original type is a safe
  /// operation.
  let base: any SingleColorLike

  public static let discretion = AnySingleColor.discretion.flatMap { color in
    [Self.init(color), .init(Anti(color))]
  }

  public init(_ base: some SingleColorLike) {
    if let base = base as? Self {
      self = base
    } else if let base = base as? AnySingleColor {
      self.base = base.base
    } else {
      self.base = base
    }
  }

  public func `is`(_ other: (some SpecificColorLike).Type) -> Bool { specificType == other }
}

extension AnySingleColorLike: Equatable {
  public static func == (lhs: Self, rhs: Self) -> Bool { lhs.specificType == rhs.specificType }
}

/// Type-erased ``SingleColor``. Might be ``red``, ``green`` or ``blue``.
public struct AnySingleColor: Discrete, SingleColor {
  /// ``SingleColor`` whose type has been erased. Casting it to the original type is a safe
  /// operation.
  let base: any SingleColor

  public static let discretion = [Self.init(red), .init(green), .init(blue)]

  public init(_ base: some SingleColor) {
    if let base = base as? Self {
      self = base
    } else if let base = base as? AnySingleColorLike,
      let unerasedColor = base.base as? any SingleColor
    {
      self.base = unerasedColor
    } else {
      self.base = base
    }
  }

  public func `is`(_ other: (some SpecificColorLike).Type) -> Bool { specificType == other }
}

extension AnySingleColor: Equatable {
  public static func == (lhs: Self, rhs: Self) -> Bool { lhs.specificType == rhs.specificType }
}

extension SingleColorLike {
  /// Actual type of this ``SingleColorLike``, disregarding every erasure.
  ///
  /// ``SpecificColorLike``s can have their type erased by an applicable wrapper. This is useful in
  /// contexts in which their type is unimportant and ignoring them would not cause the simulated
  /// Universe to be in an invalid state. Such erasure can be performed in many ways; take some of
  /// the possible ones as an example, where `self` is a ``SingleColor``:
  ///
  /// ```swift
  /// AnySingleColor(self)
  /// AnySingleColorLike(Anti(self))
  /// Anti(AnySingleColorLike(AnySingleColor(self)))
  /// ```
  ///
  /// …and so on.
  ///
  /// Because they are eraseable *and* there may not be a limit for the amount of times they are
  /// erased, obtaining their types through naive approaches such as
  ///
  /// ```swift
  /// type(of: self)
  /// ```
  ///
  /// or
  ///
  /// ```swift
  /// type(of: self.base)
  /// ```
  ///
  /// may not yield the expected result, given that the type might not be the specific one, but that
  /// of its wrapper. Accessing this property ignores each erasure (if any) and returns the type
  /// which has been originally erased.
  ///
  /// For ``SpecificColorLike``s, this property only acts as a proxy to `type(of: self)`, but
  /// without the opaqueness of the returned type; in these cases, prefer calling `type(of:)`
  /// directly instead.
  fileprivate var specificType: any SingleColorLike.Type {
    if let self = self as? AnySingleColorLike {
      return self.base.specificType
    } else if let self = self as? AnySingleColor {
      return self.base.specificType
    } else if let self = self as? Anti<AnySingleColor> {
      let counterpartSpecificType = self.counterpart.specificType
      return if counterpartSpecificType == Red.self {
        Anti<Red>.self
      } else if counterpartSpecificType == Green.self {
        Anti<Green>.self
      } else if counterpartSpecificType == Blue.self { Anti<Blue>.self } else {
        fatalError(
          "Anticolor \(self) has an unknown counterpart: \(self.counterpart). Conformance to the "
            + "SingleColor protocol is restricted to the QuantumMechanics framework; introductions "
            + "of custom types will likely result in errors such as this one."
        )
      }
    } else {
      return type(of: self)
    }
  }
}
