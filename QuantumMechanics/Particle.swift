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

/// Subatomic excitation of an underlying field, which exhibits discrete interactions with other
/// fields. Differs from vacuum fluctuations or delocalized modes on such field in that it is
/// localized: it has a wavepacket of location. Such localization is made possible by
/// collapse-like, interpretation-defined consequence of measuring its wavefunction Ψ(*x*, *t*),
/// where *x* is the position and *t* is the time.
///
/// ## Classification
///
/// Particles are divided into two families:
///
/// Family    | Spin              | Characterization                                                                                                                        |
/// --------- | ----------------- | --------------------------------------------------------------------------------------------------------------------------------------- |
/// Boson     | s ∈ ℤ × *ħ*       | **Bose–Einstein distribution**: there can be an integer multiple of *nQ* number of particles in a concentration per unit of its volume. |
/// Fermion   | s ∈ (ℤ + ½) × *ħ* | **Pauli exclusion**: identical particles of such family cannot have equal quantum states in the same spacetime.                         |
///
/// - SeeAlso: ``Spin``
public protocol Particle: ParticleLike, Opposable {}

extension Anti: Comparable, ParticleLike where Counterpart: Particle {
  public var spin: Spin { counterpart.spin }
  public var symbol: String { counterpart.symbol + "̅" }
  public var charge: ElectricCharge { -counterpart.charge }

  public func getMass(approximatedBy approximator: Approximator<Mass>) -> Mass {
    counterpart.getMass(approximatedBy: approximator)
  }
}

/// Base protocol to which ``Particle``s and antiparticles conform.
public protocol ParticleLike: Comparable, Sendable {
  /// Intrinsic angular momentum of this type of ``ParticleLike``.
  var spin: Spin { get }

  /// Force experienced by this type of ``ParticleLike``s in an electromagnetic field.
  var charge: ElectricCharge { get }

  /// Character which identifies this type of ``ParticleLike`` as per the International System of
  /// Units (SI).
  var symbol: String { get }

  /// Performs a partial equality comparison between this ``ParticleLike`` and the given one by
  /// testing all their properties common to such protocol against each other.
  ///
  /// ## Partiality
  ///
  /// This method returning `true` does not necessarily denote that both ``ParticleLike``s are
  /// equal; rather, as the name implies, the existing equality is partial, meaning that properties
  /// that are specific to either `Self` or the type of `other` may differ and, therefore, still
  /// differentiate them from one another.
  ///
  /// Some ``ParticleLike``s might resort to their type-specific equality comparison, falling back
  /// to the partial comparison in case the first deems their structure different (e.g., an
  /// `Equatable` ``ParticleLike`` initially tests `self == other`; if `false`, then the partial
  /// comparison is performed).
  ///
  /// ## Implicit contract with `Equatable` ``ParticleLike``s
  ///
  /// Comparing two ``ParticleLike``s of the same type which conform to the `Equatable` protocol by
  /// calling this method should always return `true` when `self == other`. However, because of the
  /// aforementioned considerations on partiality, `isPartiallyEqual(to: other) && self == other`
  /// may be `false`.
  ///
  /// - Parameter other: ``ParticleLike`` to which this one will be compared.
  /// - Returns: `true` if the properties shared by these ``ParticleLike`` values are equal;
  ///   otherwise, `false`.
  func isPartiallyEqual(to other: some ParticleLike) -> Bool

  /// Obtains the amount of rest energy of this ``ParticleLike``.
  ///
  /// - Parameter approximator: ``Approximator`` of the mass.
  func getMass(approximatedBy approximator: Approximator<Mass>) -> Mass
}

extension ParticleLike {
  public func isPartiallyEqual(to other: some ParticleLike) -> Bool {
    guard let other = other as? Self else { return _particleLikeIsPartiallyEqual(to: other) }
    return self == other || _particleLikeIsPartiallyEqual(to: other)
  }

  /// The default implementation of ``isPartiallyEqual(to:)``.
  ///
  /// This function is distinct from the public one in that it allows for overriders which employ
  /// type-specific checks to resort to the default check in case such type-specific checks return
  /// `false`.
  ///
  /// - Parameter other: ``ParticleLike`` to which this one will be compared.
  /// - Returns: `true` if the properties shared by these ``ParticleLike`` values are equal;
  ///   otherwise, `false`.
  func _particleLikeIsPartiallyEqual(to other: some ParticleLike) -> Bool {
    return spin == other.spin && charge == other.charge
      && getMass(approximatedBy: .base) == other.getMass(approximatedBy: .base)
      && symbol == other.symbol
  }
}

extension ParticleLike where Self: Comparable {
  public static func < (lhs: Self, rhs: Self) -> Bool {
    lhs.getMass(approximatedBy: .base) < rhs.getMass(approximatedBy: .base)
  }

  public static func > (lhs: Self, rhs: Self) -> Bool {
    lhs.getMass(approximatedBy: .base) > rhs.getMass(approximatedBy: .base)
  }
}

extension ParticleLike where Self: Equatable {
  public static func == (lhs: Self, rhs: Self) -> Bool { lhs.isPartiallyEqual(to: rhs) }
}
