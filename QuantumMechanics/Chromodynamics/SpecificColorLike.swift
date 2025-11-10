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

/// Final state of confined ``ColoredParticle``s whose net ``Color`` charge is zero, making them
/// effectively colorless. Results from the combination of ``Color``-anticolor pairs or of all
/// ``SingleColor``s (``red`` + ``green`` + ``blue``).
public let white = White()

/// Red (r) direction in the ``Color`` field.
public let red = Red()

/// Green (g) direction in the ``Color`` field.
public let green = Green()

/// Blue (b) direction in the ``Color`` field.
public let blue = Blue()

/// Base protocol to which specific colors and anticolors conform.
///
/// - SeeAlso: ``SpecificColor``
public protocol SpecificColorLike: ColorLike {}

extension SpecificColorLike where Self: ColorLike {
  public func `is`(_ other: (some SpecificColorLike).Type) -> Bool { Self.self == other }
}

extension SpecificColorLike where Self: Equatable {
  public static func == (lhs: Self, rhs: Self) -> Bool { true }
}

extension Anti: SpecificColorLike where Counterpart: SpecificColor {}

/// ``Color`` whose type has not been erased (i.e., non-``AnySingleColor``).
public protocol SpecificColor: Color, SpecificColorLike {}

/// Final state of confined ``ColoredParticleLike``s whose net ``Color`` charge is zero, making them
/// effectively colorless. Results from the combination of ``Color``-anticolor pairs or of all
/// ``SingleColor``s (``red`` + ``green`` + ``blue``).
public struct White: SingleColor, SpecificColor { fileprivate init() {} }

/// Red (r) direction in the ``Color`` field.
public struct Red: SingleColor, SpecificColor { fileprivate init() {} }

/// Green (g) direction in the ``Color`` field.
public struct Green: SingleColor, SpecificColor { fileprivate init() {} }

/// Blue (b) direction in the ``Color`` field.
public struct Blue: SingleColor, SpecificColor { fileprivate init() {} }
