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
import _Differentiation

/// A "space" is a Deus-specific combination of a configuration space *Q* on a ``Manifold`` *M*; a
/// Lagrangian phase space *TQ*, tangent to *Q*, containing pairs of coordinates *q* and velocities
/// *q̇*; and a Hamiltonian phase space _T_*_Q_, a set of (*qⁱ*, *pᵢ*) cotagent to *Q*, associating
/// each coordinate to its momentum.
public protocol Space {
  /// ``Manifold`` at which each configuration of this ``Space`` is.
  associatedtype ConfigurationManifold: Manifold

  /// ``Measurement`` resulted from calculating a ``lagrangianDensity(coordinate:velocity:time:)``.
  /// Differs between the type of mechanics (i.e., quantum and classical) and interpretations within
  /// quantum mechanics.
  associatedtype LagrangianDensity: Measurement

  /// Type of a coordinate in this ``Space``.
  typealias Coordinate = ConfigurationManifold.Point

  /// Sum of the mass of every configuration within this ``Space``.
  var mass: Mass { get }

  /// Calculates the Lagrangian density *𝐿* over the given coordinate and moment in time.
  ///
  /// The Lagrangian is a smooth, scalar function on the tangent bundle (the union of every tangent
  /// space at all coordinates *qⁱ* in which lies the velocity *q̇ⁱ* associated to each of them;
  /// i.e., a bundle whose coordinates are (*qⁱ*, *q̇ⁱ*)) of this ``Space``. It outputs the density
  /// with which the `coordinate` moves over `time`, part of the formula for an action *S* (the path
  /// of such coordinate):
  ///
  /// - *S*[*q*] = ∫*ᵗ²ₜ₁* *L*(*q*, *q̇*, *t*) × ∂*t*; or simply
  /// - *S* = ∫*ᵗ²ₜ₁* *L* × ∂*t*.
  ///
  /// - Parameters:
  ///   - coordinate: The coordinate *q*.
  ///   - velocity: Rate of change *q̇* of the `coordinate` over `time`; its velocity in 1/c².
  ///   - time: Time *t* at which the coordinate is.
  /// - Returns: A unitized scalar in a Lagrangian density *𝐿*.
  /// - SeeAlso: ``Speed/light``
  func lagrangianDensity(
    coordinate: Coordinate,
    velocity: Coordinate.TangentVector,
    time: Double
  ) -> LagrangianDensity

  /// Calculates the potential energy *V* = *E₀* - *Eₖ*, scalar function whose gradient outputs a
  /// force, in this ``Space`` at a given coordinate and a specified time.
  ///
  /// - Parameters:
  ///   - coordinate: The coordinate *q*.
  ///   - time: Time *t* at which the coordinate is.
  func potentialEnergy(coordinate: Coordinate, time: Double) -> Energy

  /// The Lorentz factor *γ* quantifies the dilation of time, contraction of length and energy
  /// relativization in a rest frame in relation to an event occurring at the given `velocity`.
  ///
  /// - Parameter velocity: Velocity of the event in 1/*c*.
  /// - Returns: The dimensionless change in the system in which a ``Space`` is from a rest frame,
  ///   resulted from the event.
  /// - SeeAlso: ``Speed/light``
  func lorentzFactor(velocity: Coordinate.TangentVector) -> Energy
}

extension Space {
  /// The kinetic energy *Eₖ* describes the amount of energy of the motion of a coordinate *q*.
  ///
  /// - Parameter velocity: Velocity of *q* in 1/c.
  /// - SeeAlso: ``Speed/light``
  public func kineticEnergy(velocity: Coordinate.TangentVector) -> Energy {
    .joules((lorentzFactor(velocity: velocity).quantityInBaseUnit - 1) * mass.quantityInBaseUnit)
  }
}

extension Space
where Coordinate.TangentVector: FloatingPoint, Coordinate.TangentVector.Magnitude == Double {
  public func lorentzFactor(velocity: ConfigurationManifold.Point.TangentVector) -> Energy {
    let lightSpeedInMetersPerSecond = Speed.light(1).quantityInBaseUnit
    return .joules(
      1
        / (1 - velocity * velocity / lightSpeedInMetersPerSecond * lightSpeedInMetersPerSecond)
        .squareRoot()
    )
  }
}
#endif
