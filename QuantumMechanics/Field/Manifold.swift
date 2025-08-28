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

  // TODO: Ideally, L(q:q̇:t:) and V(q:t:) would return an instance of Measurement of UnitEnergy and
  // UnitAction respectively, where UnitAction represents eV/eV⁻¹ in particle physics or J/s in
  // classical mechanics. However, SourceKitService crashes when such type is extended to conform to
  // Differentiable as of Swift 6.2-snapshot-2025-08-21.

  /// Calculates the Lagrangian over the given coordinate and moment in time.
  ///
  /// The Lagrangian *L* is a smooth, scalar function on the tangent bundle (the union of every
  /// tangent space at all coordinates in which lies the velocity associated to each of them; i.e.,
  /// a bundle whose coordinates are (qₙ, q̇ₙ)) of this ``Manifold``. It is the density with which `q`
  /// moves over `t`, part of the formula for an action *S* (the path of such coordinate):
  ///
  /// **S[q] = ∫ᵗ²ₜ₁ *L*(q, q̇, t) × ∂*t***; or simply **S = ∫ᵗ²ₜ₁ *L* × ∂*t***.
  ///
  /// - Parameters:
  ///   - q: Coordinate *q* at which the configuration is located.
  ///   - q̇: Rate of change of `q` over `t`, *q*’(*t*); its velocity.
  ///   - t: Time at which the configuration is.
  /// - Returns: A scalar in a Lagrangian density 𝐿, determined by the type of coordinate of this
  ///   ``Manifold``.
  @differentiable(reverse,wrt: (q, q̇))
  func L(q: Coordinate, q̇: Coordinate.TangentVector, t: Double) -> Double

  /// Calculates the potential energy *V* = E - E₀, scalar whose gradient outputs a force, in this
  /// ``Manifold`` at a given coordinate and a specified time.
  ///
  /// - Parameters:
  ///   - q: Coordinate *q* at which the configuration is located.
  ///   - t: Time at which the configuration is.
  /// - Returns: The potential energy *V* in eV.
  /// - SeeAlso: ``Foundation/UnitEnergy/electronvolts``
  func V(q: Double, t: Double) -> Double
}
