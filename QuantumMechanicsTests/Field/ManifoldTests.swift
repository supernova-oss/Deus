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

#if canImport(_Differentiation)
import Testing

@testable import QuantumMechanics

struct ManifoldTests {
  @Test
  func calculatesLagrangian() { #expect(RealLine(mass: .zero).kineticEnergy(velocity: 0) == .zero) }
}

/// 1-dimensional, unitary ``Space``.
private struct RealLine: Space {
  public typealias ConfigurationManifold = UnidimensionalManifold

  public let mass: Mass

  public func lagrangianDensity(
    coordinate: UnidimensionalManifold.Point,
    velocity: UnidimensionalManifold.Point.TangentVector,
    time: Double
  ) -> Energy {
    kineticEnergy(velocity: velocity) - potentialEnergy(coordinate: coordinate, time: time)
  }

  /// Potential ``Energy`` *V* = *E₀* - *Eₖ*, scalar function whose gradient outputs a force, at the
  /// given coordinate and time. Since this 1D ``Space`` exists only for testing purposes and
  /// strives to be as simple as possible in terms of calculus, its *V* at any coordinate and time
  /// will always be zero.
  ///
  /// - Parameters:
  ///   - coordinate: The coordinate *q*.
  ///   - time: Time *t* at which the coordinate is.
  /// - Returns: Zero; this implementation of a real line contains no potential ``Energy``.
  /// - SeeAlso: ``Space/kineticEnergy(velocity:)``
  public func potentialEnergy(coordinate: UnidimensionalManifold.Point, time: Double) -> Energy {
    .zero
  }
}

/// 1-dimensional, unitary ``Manifold``.
private struct UnidimensionalManifold {}

extension UnidimensionalManifold: Manifold { public typealias Point = Double }
#endif
