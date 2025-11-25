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

/// ``QuarkLike`` whose flavor information has been erased.
public struct AnyQuarkLike: Discrete, QuarkLike {
  /// ``Quark`` based on which this one was initialized.
  let base: any QuarkLike & Sendable

  public static let discretion = AnyQuark.discretion.flatMap { quark in
    [Self.init(quark), .init(Anti(quark))]
  }

  public let spin: Spin
  public let charge: ElectricCharge
  public let symbol: String
  public let colorLike: AnySingleColorLike

  public init(_ base: some QuarkLike) {
    if let base = base as? Self {
      self = base
    } else if let base = base as? AnyQuark {
      self.base = base.base
      spin = base.spin
      charge = base.charge
      symbol = base.symbol
      colorLike = .init(base.colorLike)
    } else {
      self.base = base
      spin = base.spin
      charge = base.charge
      symbol = base.symbol
      colorLike = .init(base.colorLike)
    }
  }

  public func getMass(approximatedBy approximator: Approximator<Mass>) -> Mass {
    base.getMass(approximatedBy: approximator)
  }
}

extension AnyQuarkLike: Equatable {
  public static func == (lhs: Self, rhs: Self) -> Bool {
    lhs._coloredParticleLikeIsPartiallyEqual(to: rhs)
  }
}

/// ``Quark`` whose flavor information has been erased.
public struct AnyQuark: Discrete, Quark {
  /// ``Quark`` based on which this one was initialized.
  let base: any QuarkLike

  public static let discretion = AnySingleColor.discretion.flatMap { color in
    [
      Self.init(UpQuark(colorLike: color)), .init(DownQuark(colorLike: color)),
      .init(CharmQuark(colorLike: color)), .init(StrangeQuark(colorLike: color)),
      .init(BottomQuark(colorLike: color)), .init(TopQuark(colorLike: color))
    ]
  }.sorted(by: <)

  public let spin: Spin
  public let charge: ElectricCharge
  public let symbol: String
  public let colorLike: AnySingleColor

  public init(_ base: some Quark) {
    if let base = base as? Self {
      self = base
    } else if let base = base as? AnyQuarkLike, let color = base.colorLike as? any SingleColor {
      self.base = base.base
      spin = base.spin
      charge = base.charge
      symbol = base.symbol
      colorLike = .init(color)
    } else {
      self.base = base
      spin = base.spin
      charge = base.charge
      symbol = base.symbol
      colorLike = .init(base.colorLike)
    }
  }

  public func getMass(approximatedBy approximator: Approximator<Mass>) -> Mass {
    base.getMass(approximatedBy: approximator)
  }
}

extension AnyQuark: Equatable {
  public static func == (lhs: Self, rhs: Self) -> Bool {
    lhs._coloredParticleLikeIsPartiallyEqual(to: rhs)
  }
}
