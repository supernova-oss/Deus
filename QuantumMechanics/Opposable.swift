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

/// Matter or property which has a counterpart of opposite charge: its ``Anti`` part.
///
/// There is an imbalance regarding the amount of matter and antimatter in nature, unexplained by
/// the Standard Model. In 1967, Andrei Sakharov theorized that such disproportion may have arisen
/// after the very early universe (first 10⁻¹² seconds — picosecond — of its existence) due to
/// factors now known as Sakharov conditions, such as violation of the Baryon number and
/// interactions occurred out of thermal equilibrium.
public protocol Opposable {}

/// Counterpart of an ``Opposable``.
public struct Anti<Counterpart: Opposable> {
  /// Non-anti-matter or -property version of this one.
  let counterpart: Counterpart

  public init(_ counterpart: consuming Counterpart) { self.counterpart = counterpart }
}

extension Anti: Equatable where Counterpart: Equatable {
  public static func == (lhs: Self, rhs: Self) -> Bool { lhs.counterpart == rhs.counterpart }
}

extension Anti: Sendable where Counterpart: Sendable {}
