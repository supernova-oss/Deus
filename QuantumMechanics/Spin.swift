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

/// Intrinsic angular momentum of a ``Particle`` that denotes the amount of symmetric faces it has
/// in a turn of 360º. Due to the scale at which they are presented, spins are not equivalent to
/// rotations in the classical sense; they are considered, therefore, a fundamentally-quantum
/// property.
///
/// It is measured in discrete multiples of the reduced Planck constant (*ħ*), expressible by *ħ*ℚ =
/// {n × *ħ* | n ∈ ℚ}, with *ħ* = *h* / (2 × π), where *h* is the Planck constant (equal to
/// 6.62607015 × 10⁻³⁴ J/s) which poses as a separator between the classical scale — in which energy
/// and momentum vary continuosly — and the quantum one — in which they are quantized or discrete.
public enum Spin: Sendable {
  /// 0 *ħ* ``Spin``. The quantum state of ``Particle``s without ``Spin`` remains unchanged across
  /// transformations.
  case zero

  /// ½ *ħ* ``Spin``. The fermion returns to its initial configuration after completing two turns
  /// (720º).
  case half
}
