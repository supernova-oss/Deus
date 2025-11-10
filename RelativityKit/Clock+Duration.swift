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

extension Duration {
  /// Whether an integer amount of ticks can be performed by a ``Clock`` within this `Duration`.
  var canOnlyCompriseWholeTicks: Bool {
    let comprisableTickCount = Double(attoseconds) / .init(Self.tickScale)
    return comprisableTickCount.truncatingRemainder(dividingBy: 1) == 0
  }

  /// Amount of times a ``Clock`` can perform a subtick within this `Duration`.
  var comprisableSubtickCount: Double { .init(attoseconds) / .init(Self.subtickScale) }

  /// Amount of attoseconds within a ``tick``.
  static let tickScale = Int128(tick.attoseconds)

  /// `Duration` by which a tick (1,000 subticks) is comprised: 1 ms.
  ///
  /// - SeeAlso: ``subtick``
  static let tick = Self.milliseconds(1)

  /// Amount of attoseconds within a ``subtick``.
  static let subtickScale = Int128(subtick.attoseconds)

  /// `Duration` by which a subtick is comprised: 1 μs.
  ///
  /// - SeeAlso: ``tick``
  static let subtick = Self.microseconds(1)

  /// Makes a `Duration` within which a ``Clock`` can perform subticks the specified amount of
  /// times.
  ///
  /// - Parameter count: Quantity of subticks comprised by the `Duration`.
  static func subticks(_ count: some BinaryInteger) -> Self { .microseconds(count) }
}
