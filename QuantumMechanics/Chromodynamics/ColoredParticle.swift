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

/// Base protocol to which ``ColoredParticle``s and colored antiparticles conform.
public protocol ColoredParticleLike: ParticleLike {
  /// The specific type of ``ColorLike``.
  associatedtype ColorLike: QuantumMechanics.ColorLike

  /// Measured transformation under the SU(3) symmetry.
  var colorLike: ColorLike { get }
}

extension ColoredParticleLike {
  /// The default implementation of ``isPartiallyEqual(to:)``.
  ///
  /// - Parameter other: ``ColoredParticleLike`` to which this one will be compared.
  /// - Returns: `true` if the properties shared by these ``ColoredParticleLike`` values are equal;
  ///   otherwise, `false`.
  func _coloredParticleLikeIsPartiallyEqual(to other: some ColoredParticleLike) -> Bool {
    return _particleLikeIsPartiallyEqual(to: other)
      && (colorLike.is(Red.self) && other.colorLike.is(Red.self)
        || colorLike.is(Anti<Red>.self) && other.colorLike.is(Anti<Red>.self)
        || colorLike.is(Green.self) && other.colorLike.is(Green.self)
        || colorLike.is(Anti<Green>.self) && other.colorLike.is(Anti<Green>.self)
        || colorLike.is(Blue.self) && other.colorLike.is(Blue.self)
        || colorLike.is(Anti<Blue>.self) && other.colorLike.is(Anti<Blue>.self))
  }
}

extension Anti: ColoredParticleLike where Counterpart: ColoredParticle {
  public var colorLike: Anti<Counterpart.ColorLike> {
    Anti<Counterpart.ColorLike>(counterpart.colorLike)
  }
}

/// Direct (in the case of a gluon ``Particle``) or indirect result of a localized excitation of the
/// ``Color`` field.
public protocol ColoredParticle: ColoredParticleLike, Particle where ColorLike: Color {}

extension ColoredParticle where Self: ParticleLike {
  public func isPartiallyEqual(to other: some ParticleLike) -> Bool {
    if let other = other as? any ColoredParticle {
      _coloredParticleLikeIsPartiallyEqual(to: other)
    } else {
      _particleLikeIsPartiallyEqual(to: other)
    }
  }
}
