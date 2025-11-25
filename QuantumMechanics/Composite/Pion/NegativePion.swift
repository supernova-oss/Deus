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

/// ``Pion`` with a negative ``charge`` (π⁻), resulted from d + ū.
///
/// - SeeAlso: ``DownQuark``
/// - SeeAlso: ``UpQuark``
public struct NegativePion: Equatable, Pion {
  public let symbol = "π⁻"
  public let quarks: [AnyQuarkLike]

  fileprivate init(quarks: [AnyQuarkLike]) { self.quarks = quarks }

  public func getMass(approximatedBy approximator: Approximator<Mass>) -> Mass {
    approximator.approximate(chargedPionMass, chargedPionMassStatisticalUncertainty, .zero)
  }
}

extension DownQuark where ColorLike: SpecificColor {
  /// Combines an up antiquark to this ``DownQuark``.
  ///
  /// - Parameters:
  ///   - lhs: ``DownQuark`` to combine `rhs` to.
  ///   - rhs: Up antiquark to be combined to `lhs`.
  /// - Returns: Result of the d + ū combination: a ``NegativePion``.
  static func + (lhs: Self, rhs: Anti<UpQuark<Self.ColorLike>>) -> NegativePion {
    NegativePion(quarks: [.init(lhs), .init(rhs)])
  }
}
