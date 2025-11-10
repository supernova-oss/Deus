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

/// Abstraction of an exact location on or movement across a 2D plane.
public protocol TwoD: AdditiveArithmetic, CustomStringConvertible, Sendable {
  /// Final position in the x-axis.
  var x: Double { get }

  /// Final position in the y-axis.
  var y: Double { get }

  /// Initializes a 2D abstraction with the given coordinates.
  ///
  /// - Parameters:
  ///   - x: Final position in the x-axis.
  ///   - y: Final position in the y-axis.
  init(x: Double, y: Double)
}

extension TwoD {
  /// Initializes a 2D abstraction based on an existing one.
  ///
  /// - Parameter base: 2D abstraction whose coordinates will be set to those of the initialized
  ///   one.
  init(from base: any TwoD) { self = .at(x: base.x, y: base.y) }

  /// Multiplies each coordinate of the 2D abstraction by the value.
  ///
  /// - Parameters:
  ///   - lhs: 2D abstraction whose coordinates will be multiplied by the value.
  ///   - rhs: Value by which the coordinates of the 2D abstraction will be multiplied.
  /// - Returns: Another 2D abstraction whose coordinates are the result of multiplying those of the
  ///   given one by the value; or the given 2D abstraction itself in case it was multiplied by 1.
  public static func * (lhs: Self, rhs: Double) -> Self {
    guard rhs != 1 else { return lhs }
    return .at(x: lhs.x * rhs, y: lhs.y * rhs)
  }

  /// Returns a 2D abstraction at the given coordinates.
  ///
  /// - Parameters:
  ///   - x: Final position in the x-axis.
  ///   - y: Final position in the y-axis.
  public static func at(x: Double, y: Double) -> Self {
    x == 0 && y == 0 ? .zero : .init(x: x, y: y)
  }

  /// Multiplies this 2D abstraction by the other via scalar/dot product.
  ///
  /// - Parameter rhs: 2D abstraction by which this one will be multiplied.
  /// - Returns: The resultant scalar value.
  public func scalar(_ rhs: Self) -> Double { x * rhs.x + y * rhs.y }

  /// Multiplies this 2D abstraction by the other via cross product.
  ///
  /// - Parameter rhs: 2D abstraction by which this one will be multiplied.
  /// - Returns: The resultant cross product.
  public func cross(_ rhs: Self) -> Double { x * rhs.x - y * rhs.y }
}

extension TwoD where Self: AdditiveArithmetic {
  public static func + (lhs: Self, rhs: Self) -> Self {
    guard lhs != .zero else { return rhs }
    guard rhs != .zero else { return lhs }
    return .at(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
  }

  public static func - (lhs: Self, rhs: Self) -> Self {
    guard lhs != rhs else { return .zero }
    guard rhs != .zero else { return lhs }
    return .at(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
  }
}

extension TwoD where Self: Equatable {
  /// Checks whether both 2D abstractions end up in the same, exact position.
  ///
  /// > Attention: This function performs a strict equality comparison and, therefore, may be
  /// inappropriate, given the precision (or lack thereof) of floating-point numbers and that the
  /// coordinates of a 2D abstraction are `Double`s. For an *approximate* comparison, call
  /// ``isApproximate(to:)`` instead.
  ///
  /// - Parameters:
  ///   - lhs: 2D abstraction to be compared with `rhs`.
  ///   - rhs: 2D abstraction to be compared with `lhs`.
  /// - Returns: `true` when both 2D abstractions are equal; or `false` when their final coordinates
  ///   differ.
  public static func == (lhs: Self, rhs: Self) -> Bool { lhs.x == rhs.x && lhs.y == rhs.y }

  /// Compares both 2D abstractions approximately, determining whether they end up in approximate
  /// positions. The precision of such approximation is as defined by
  /// `FloatingPoint.isApproximate(to:)`.
  ///
  /// - Parameter rhs: 2D abstraction to be compared with this one.
  /// - SeeAlso: ``==(_:_:)``
  public func isApproximate(to rhs: Self) -> Bool {
    x.isApproximate(to: rhs.x) && y.isApproximate(to: rhs.y)
  }
}

extension FloatingPoint {
  /// Determines whether this floating-point number is approximately equal to the given one.
  ///
  /// As a floating-point number on either side may be more or less precise than that on the other
  /// when compared strictly via `==(_:_:)` (such as in `.pi == 3.14159`, which returns `false`),
  /// this method of comparison consists of three stages which aim a lay or purposeful approximation
  /// equality check, complacent with the [IEEE Standard for Floating-Point
  /// Arithmetic](https://standards.ieee.org/ieee/754/11684) (IEEE 754):
  ///
  /// 1. Checks, first, whether both values are, indeed, exactly equal to each other. If so, returns
  ///    `true`; otherwise, proceeds;
  /// 2. Checks, then, whether |`self`| or |`rhs`| is zero or their sum results in a value which is
  ///    less than the `leastNormalMagnitude` (the least a floating-point number can be while
  ///    maintaining precision stability). If so, returns `true` in case |`self` - `rhs`| is less
  ///    than the amount of steps from it toward the `leastNormalMagnitude` by units in last
  ///    position (ULPs) of 1; else, `false`; otherwise, proceeds;
  /// 3. Checks, finally, whether |`self` - `rhs`| is less than the ULP of 1. If so, returns `true`;
  ///    else, `false`.
  /// - Parameter rhs: Floating-point number with which this one will be compared.
  /// - Returns: `true` if both values are deemed approximately equal by the terms of this function;
  ///   otherwise, `false`.
  fileprivate func isApproximate(to rhs: Self) -> Bool {
    let absLhs = abs(self)
    let absRhs = abs(rhs)
    guard absLhs != absRhs else { return true }
    let absDiff = abs(absLhs - absRhs)
    guard absLhs != 0 && absRhs != 0 && abs(absLhs + absRhs) >= .leastNormalMagnitude else {
      return absDiff < .ulpOfOne * .leastNormalMagnitude
    }
    return absDiff < .ulpOfOne
  }
}

extension TwoD where Self: CustomStringConvertible {
  public var description: String { "(\(x), \(y))" }
}

/// An exact location in a 2D plane.
public struct Point: TwoD {
  public static let zero = Self.init(x: 0, y: 0)

  public let x: Double
  public let y: Double

  public init(x: Double, y: Double) {
    self.x = x
    self.y = y
  }
}
