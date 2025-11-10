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

/// Bézier curve whose endpoints are controlled by one control ``Point`` each; consists, therefore,
/// of four points.
///
/// ## Formula
///
/// B(*t*) = (1 - *t*)³P₀ + 3(1 - *t*)²*t*P₁ + 3(1 - *t*)*t*²P₂ + *t*³P₃, where 0 ≤ *t* ≤ 1
private struct CubicBezierCurve: BezierCurveProtocol {
  /// ``Control`` of the start endpoint.
  let start: Control

  /// ``Control`` of the end endpoint.
  let end: Control

  subscript(_ t: Double) -> Point {
    Self.assertIsInRange(t: t)
    let (p0, p1, p2, p3, y) = (
      start.controllee, start.controller, end.controller, end.controllee, 1 - t
    )
    return (p0 * pow(y, 3)) as Point + p1 * 3 * pow(y, 2) * t + p2 * 3 * y * pow(t, 2) + p3
      * pow(t, 3)
  }
}

/// Property of non-linear Bézier curves (i.e., quadratic, cubic and higher-degree ones) that
/// comprises a controlled ``Point`` and another one which controls it: its control ``Point``. The
/// first is positioned on the curve in relation to the latter (which is not, itself, part of the
/// curve).
public struct Control: Sendable {
  /// ``Control`` whose both ``Point``s are (0, 0).
  static let zero = Self.init(controller: .zero, controllee: .zero)

  /// ``Point`` which influences the ``controllee`` by arching the curve toward itself.
  fileprivate let controller: Point

  /// Enpoint or interpolation ``Point`` controlled by the ``controller``.
  fileprivate let controllee: Point

  private init(controller: Point, controllee: Point) {
    self.controller = controller
    self.controllee = controllee
  }

  /// Returns a ``Control``.
  ///
  /// - Parameters:
  ///   - controller: ``Point`` which influences the ``controllee`` by arching the curve toward
  ///     itself.
  ///   - controllee: Anchor or interpolation ``Point`` controlled by the ``controller``.
  fileprivate static func with(controller: Point, controllee: Point) -> Self {
    guard controller != .zero || controllee != .zero else { return .zero }
    return .init(controller: controller, controllee: controllee)
  }
}

extension Point {
  /// Defines the given ``Point`` as the control ``Point`` of this one in a Bézier curve.
  ///
  /// - Parameter controller: ``Point`` which influences this one by arching the curve toward
  ///   itself.
  public func controlled(by controller: Self) -> Control {
    Control.with(controller: controller, controllee: self)
  }
}

/// Parametric curve defined by a set of ``Point``s.
public protocol BezierCurveProtocol: Sendable {
  /// Obtains a ``Point`` in this curve.
  ///
  /// - Parameter t: Progression across the curve on which the ``Point`` is.
  ///
  ///   0 ≤ `t` ≤ 1.
  subscript(_ t: Double) -> Point { get }
}

extension BezierCurveProtocol {
  /// Performs an assertion when in debug configuration that guarantees that ``t`` is ≥ 0 and ≤ 1.
  ///
  /// Should be called by all implementations of ``subscript(_:)`` prior to any calculation.
  ///
  /// - Parameter t: Progression across a Bézier curve.
  fileprivate static func assertIsInRange(t: Double) {
    assert(
      (0.0...1).contains(t),
      "t represents a progression between the points of the bezier curve; therefore, it must be >= "
        + "0 and <= 1 (was \(t))."
    )
  }
}

/// Factory of Bézier curves.
public struct BezierCurve {
  /// Makes a cubic Bézier curve.
  ///
  /// - Parameters:
  ///   - start: P₀ = `start.controllee` and P₁ = `start.controller`.
  ///   - end: P₂ = `end.controller` and P₃ = `end.controllee`.
  public static func make(from start: Control, to end: Control) -> some BezierCurveProtocol {
    CubicBezierCurve(start: start, end: end)
  }
}
