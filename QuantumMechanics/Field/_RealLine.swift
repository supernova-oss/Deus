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

/// 1D, unitary ``Manifold``.

// TODO: This Manifold implementation is not intended to be referenced in production; its main
// purpose is the testing of the differentiations performed by the _Differentiation module for the
// Lagrangian of a real line, the simplest manifold there is.
//
// As of 6.2-snapshot-2025-08-21, implementing Manifold crashes the frontend due to the
// differentiation. Exposing it as public API hidden by an underscore is a paliative workaround for
// such issue.
public struct _RealLine {
  /// Sum of the mass of all coordinates in eV/c².
  let mass: Double
}

extension _RealLine: Manifold {
  @differentiable(reverse,wrt: (q, q̇))
  public func L(q: Double, q̇: Double.TangentVector, t: Double) -> Double { T(q̇: q̇) - V(q: q, t: t) }

  /// Potential energy *V* = E - E₀, scalar whose gradient outputs a force, at the given coordinate
  /// and time. Since this ``RealLine`` exists only for testing purposes and strives to be as simple
  /// as possible in terms of calculus, its *V* at any coordinate and time will always be zero.
  ///
  /// - Parameters:
  ///   - q: Coordinate *q* at which the configuration is located.
  ///   - t: Time at which the configuration is.
  /// - Returns: Zero; this implementation of a real line contains no potential energy.
  public func V(q: Double, t: Double) -> Double { 0 }

  /// The kinetic term describes the amount of energy used by an object in motion for it to perform
  /// such movement.
  func T(q̇: Double) -> Double { (γ(v: q̇) - 1) * mass }

  /// The Lorentz factor *γ* quantifies the dilation of time, contraction of length and energy
  /// relativization in a rest frame in relation to an event occurring at the given velocity `v`.
  ///
  /// - Parameter v: Velocity of the event in m/s.
  /// - Returns: The dimensionless change in the system in which this ``RealLine`` is for the
  ///   inertial observer of the event.
  private func γ(v: Double) -> Double {
    1 / (1 - pow(v, 2) / c²._converted(to: .metersPerSecond).value).squareRoot()
  }
}
