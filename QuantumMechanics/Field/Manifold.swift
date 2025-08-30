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
internal import Numerics

/// *n*-dimensional, locally-Euclidean topological space whose neighborhoods by which each of its
/// points is contained are homeomorphic subsets of ℝ*ⁿ*, denoting a resemblance of such
/// neighborhoods to an Euclidean space.
public protocol Manifold {
  /// Type of a position in this ``Manifold``.
  associatedtype Coordinate: Differentiable

  // TODO: Ideally, `lagrangian(coordinate:velocity:time:)` and `potentialEnergy(coordinate:time:)`
  // would return an instance of `Measurement` of `UnitEnergy` and `UnitAction` respectively, where
  // `UnitAction` represents eV/eV⁻¹ in particle physics or J/s in classical mechanics. However,
  // SourceKitService crashes when such type is extended to conform to `Differentiable` as of Swift
  // 6.2-snapshot-2025-08-21.

  /// Calculates the Lagrangian *L* over the given coordinate and moment in time.
  ///
  /// The Lagrangian is a smooth, scalar function on the tangent bundle (the union of every tangent
  /// space at all coordinates *qₙ* in which lies the velocity *q̇ₙ* associated to each of them; i.e.,
  /// a bundle whose coordinates are (*qₙ*, *q̇ₙ*)) of this ``Manifold``. It is the density with which
  /// the `coordinate` moves over `time`, part of the formula for an action *S* (the path of such
  /// coordinate):
  ///
  /// - *S*[*q*] = ∫*ᵗ²ₜ₁* *L*(*q*, *q̇*, *t*) × ∂*t*; or simply
  /// - *S* = ∫*ᵗ²ₜ₁* *L* × ∂*t*.
  ///
  /// - Parameters:
  ///   - coordinate: The coordinate *q*.
  ///   - velocity: Rate of change *q̇* of the `coordinate` over `time`; its velocity.
  ///   - time: Time *t* at which the coordinate is.
  /// - Returns: A scalar in a Lagrangian density 𝐿, determined by the type of coordinate of this
  ///   ``Manifold``.
  @differentiable(reverse,wrt: (coordinate, velocity))
  func lagrangian(
    coordinate: Coordinate,
    velocity: Coordinate.TangentVector,
    time: Double
  ) -> Double

  /// Calculates the potential energy *V* = *E₀* - *Eₖ*, scalar function whose gradient outputs a
  /// force, in this ``Manifold`` at a given coordinate and a specified time.
  ///
  /// - Parameters:
  ///   - coordinate: The coordinate *q*.
  ///   - time: Time *t* at which the coordinate is.
  /// - Returns: The potential energy *V* in eV.
  /// - SeeAlso: ``Foundation/UnitEnergy/electronvolts``
  @differentiable(reverse,wrt: coordinate)
  func potentialEnergy(coordinate: Coordinate, time: Double) -> Double

  /// The Lorentz factor *γ* quantifies the dilation of time, contraction of length and energy
  /// relativization in a rest frame in relation to an event occurring at the given velocity `v`.
  ///
  /// - Parameter velocity: Velocity of the event in 1/c².
  /// - Returns: The dimensionless change in the system in which a ``Manifold`` is from a rest
  ///   frame, resulted from the event.
  @differentiable(reverse,wrt: velocity)
  func lorentzFactor(velocity: Coordinate.TangentVector) -> Double
}

extension Manifold
where Coordinate.TangentVector: FloatingPoint, Coordinate.TangentVector.Magnitude == Double {
  @differentiable(reverse)
  public func lorentzFactor(velocity: Coordinate.TangentVector) -> Double {
    return 1
      / (1 - velocity * velocity / UnitSpeed.lightSquared.converter.baseUnitValue(fromValue: 1))
      .squareRoot()
  }
}
