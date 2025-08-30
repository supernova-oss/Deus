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

import _Differentiation
import Foundation

/// 1-dimensional, unitary ``Space``.

// TODO: These implementations are not intended to be referenced in production; their main purpose
// is the testing of the differentiations performed by the `_Differentiation` module for the
// Lagrangian of a real line (i.e., 1D space), the simplest space there is.
//
// As of Swift 6.2-snapshot-2025-08-21, implementing `Space` in a test framework crashes the
// frontend due to the differentiation. Exposing it as internal API hidden by an underscore is a
// paliative work around such issue.
struct _1DSpace: Space {
  public typealias ConfigurationManifold = _1DManifold

  public let mass: Double

  @differentiable(reverse,wrt: (coordinate, velocity))
  public func lagrangian(
    coordinate: _1DManifold.Point,
    velocity: _1DManifold.Point.TangentVector,
    time: Double
  ) -> Double {
    kineticEnergy(velocity: velocity) - potentialEnergy(coordinate: coordinate, time: time)
  }

  /// Potential energy *V* = *E₀* - *Eₖ*, scalar function whose gradient outputs a force, at the
  /// given coordinate and time. Since this 1D ``Space`` exists only for testing purposes and
  /// strives to be as simple as possible in terms of calculus, its *V* at any coordinate and time
  /// will always be zero.
  ///
  /// - Parameters:
  ///   - coordinate: The coordinate *q*.
  ///   - time: Time *t* at which the coordinate is.
  /// - Returns: Zero; this implementation of a real line contains no potential energy.
  /// - SeeAlso: ``Space/kineticEnergy(velocity:)``
  @differentiable(reverse,wrt: coordinate)
  public func potentialEnergy(coordinate: _1DManifold.Point, time: Double) -> Double { 0 }
}

/// 1-dimensional, unitary ``Manifold``.
public struct _1DManifold {}

extension _1DManifold: Manifold { public typealias Point = Double }
