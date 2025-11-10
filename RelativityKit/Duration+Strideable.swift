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

extension Duration: @retroactive Strideable {
  /// Calculates the distance between this distance and another one.
  ///
  /// - Parameter other: `Duration` whose distance in relation to this one will be calculated.
  public func distance(to other: Duration) -> Int128 { other.attoseconds - attoseconds }

  /// Advances this `Duration` by the given amount of attoseconds.
  ///
  /// - Parameter n: Attoseconds towards which this `Duration` is to be advanced.
  public func advanced(by n: Int128) -> Duration {
    guard n != 0 else { return self }
    return .init(attoseconds: attoseconds + n)
  }
}
