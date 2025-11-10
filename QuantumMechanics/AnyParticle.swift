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

import Foundation

/// ``ParticleLike`` whose type information has been erased.
public struct AnyParticleLike: ParticleLike {
  public let spin: Spin
  public let charge: Measurement<UnitElectricCharge>
  public let symbol: String

  /// ``ParticleLike`` based on which this one was initialized.
  let base: any ParticleLike

  public init(_ base: some ParticleLike) {
    if let base = base as? Self {
      self = base
    } else if let base = base as? AnyParticle {
      self.base = base.base
      spin = base.spin
      charge = base.charge
      symbol = base.symbol
    } else {
      self.base = base
      spin = base.spin
      charge = base.charge
      symbol = base.symbol
    }
  }

  public func getMass(
    approximatedBy approximator: Approximator<Measurement<UnitMass>>
  ) -> Measurement<UnitMass> { base.getMass(approximatedBy: approximator) }
}

extension AnyParticleLike: Equatable {
  public static func == (lhs: Self, rhs: Self) -> Bool {
    lhs._particleLikeIsPartiallyEqual(to: rhs)
  }
}

/// ``Particle`` whose type information has been erased.
public struct AnyParticle: ParticleLike {
  public let spin: Spin
  public let charge: Measurement<UnitElectricCharge>
  public let symbol: String

  /// ``Particle`` based on which this one was initialized.
  let base: any Particle

  public init(_ base: some Particle) {
    if let base = base as? Self {
      self = base
    } else if let base = base as? AnyParticleLike,
      let unerasedParticleLike = base.base as? any Particle
    {
      self.base = unerasedParticleLike
      spin = base.spin
      charge = base.charge
      symbol = base.symbol
    } else {
      self.base = base
      spin = base.spin
      charge = base.charge
      symbol = base.symbol
    }
  }

  public func getMass(
    approximatedBy approximator: Approximator<Measurement<UnitMass>>
  ) -> Measurement<UnitMass> { base.getMass(approximatedBy: approximator) }
}

extension AnyParticle: Equatable {
  public static func == (lhs: Self, rhs: Self) -> Bool {
    lhs._particleLikeIsPartiallyEqual(to: rhs)
  }
}
