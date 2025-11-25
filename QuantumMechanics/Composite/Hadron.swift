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

/// ``Particle`` composed by two or more ``Quark``s which are bound by strong force. It is the
/// compositor of nucleons — such as protons and neutrons — and, therefore, the most common
/// composite ``Particle`` in the universe.
///
/// ## Classification
///
/// Hadrons are divided into two families:
///
/// Family     | Baryon number        | Composition       |
/// ---------- | -------------------- | ----------------- |
/// ``Meson``  | 0                    | qⁱ ⊗ q̄ⱼ           |
/// Baryon     | +1                   | εⁱʲᵏ qⁱ ⊗ qʲ ⊗ qᵏ |
///
/// > Glossary: • **Baryon number**: ⅓ of the difference between the number of quarks and that of
///               antiquarks. Because of ``Color`` confinement, a phenomenon in which
///               ``ColoredParticle``s are confined, hadrons cannot have a net ``Color`` charge;
///               thus, a hadron being composed of three ``Quark``s of distinct ``Color``s (a
///               baryon) or of a ``Quark`` and an antiquark (a meson) has a ``Color``-neutral
///               state — it is white;\
///             • **q̄**: antiquark, the antiparticle of a ``Quark``.\
///             • **⊗**: tensor product of two vector spaces *V* and *W*: an *m* × *n* matrix, where
///               *m* is the number of components of *V* and *n* is that of *W*.
public protocol Hadron: ColoredParticle {
  associatedtype ColorLike = White

  /// ``Quark``s by which this ``Hadron`` is composed, bound by strong force via the gluon
  /// ``Particle``s.
  var quarks: [AnyQuarkLike] { get }
}

extension Hadron {
  /// The default implementation of ``isPartiallyEqual(to:)``.
  ///
  /// - Parameter other: ``Hadron`` to which this one will be compared.
  /// - Returns: `true` if the properties shared by these ``Hadron`` values are equal; otherwise,
  ///   `false`.
  func _hadronIsPartiallyEqual(to other: some Hadron) -> Bool {
    _coloredParticleLikeIsPartiallyEqual(to: other) && quarks.elementsEqual(other.quarks)
  }
}

extension Hadron where Self: ParticleLike {
  public func isPartiallyEqual(to other: some ParticleLike) -> Bool {
    if let other = other as? any Hadron {
      _hadronIsPartiallyEqual(to: other)
    } else if let other = other as? any ColoredParticleLike {
      _coloredParticleLikeIsPartiallyEqual(to: other)
    } else {
      _particleLikeIsPartiallyEqual(to: other)
    }
  }
}

extension Hadron where Self: ColoredParticleLike {
  public var charge: ElectricCharge {
    var quantityInBaseUnit = 0.0
    for quark in quarks { quantityInBaseUnit += quark.charge.quantityInBaseUnit }
    return .init(quantityInBaseUnit: quantityInBaseUnit)
  }
  public var colorLike: ColorLike { white as! ColorLike }
}
