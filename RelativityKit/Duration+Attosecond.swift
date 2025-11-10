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
  /// Total amount of attoseconds represented by this `Duration`, computed by summing the
  /// attoseconds component and the converted seconds one.
  public var attoseconds: Int128 {
    .init(components.seconds) * Self.secondScaleAsInt128 + .init(components.attoseconds)
  }

  /// Amount of attoseconds within 1 s represented as an 128-bit integer.
  static let secondScaleAsInt128 = Int128(secondScaleAsDouble)

  /// Amount of attoseconds within 1 s represented as a `Double`.
  private static let secondScaleAsDouble = 1e18

  /// Minimum representable `Duration` of -2.923 × 10¹¹ a.
  private static let min = Self.init(secondsComponent: .min, attosecondsComponent: .min)

  /// Maximum representable `Duration` of 2.923 × 10¹¹ a.
  private static let max = Self.init(secondsComponent: .max, attosecondsComponent: .max)

  /// Initializes a ``Duration`` which represents an amount of attoseconds, the most precise unit in
  /// which such type can be represented.
  ///
  /// - Parameter attoseconds: The amount of attoseconds to be represented by the initialized
  ///   `Duration`, distributed to both of its components according to how much of the whole value
  ///   they can fit into their 64 bits.
  init(attoseconds: Int128) {
    guard attoseconds != 0 else {
      self = .zero
      return
    }
    let seconds = Int128(Double(attoseconds) / Self.secondScaleAsDouble)
    let secondsComponent = attoseconds % Self.secondScaleAsInt128
    guard let attosecondsComponent = Int64(exactly: secondsComponent) else {
      // The attoseconds component overflowing the capacity of a 64-bit integer does not necessarily
      // result in us having to return the minimum or maximum duration, since we can still fall back
      // to representing most of the duration in seconds — with 1e18 attoseconds being only 1 s and,
      // consequently, requiring less bits.
      //
      // Below, the attoseconds component is clamped (set as either Int64.min or Int64.max), while
      // the seconds component is defined as that clamped amount of attoseconds, converted into
      // seconds, subtracted from the advanced seconds.
      let clampedAttosecondsComponent = Int64(clamping: secondsComponent)
      let clampedSecondsComponent = Int64(
        clamping: seconds - .init(clampedAttosecondsComponent) / Self.secondScaleAsInt128
      )

      // If any of these guards fail, there was an overflow even when trying to represent most of
      // the duration in seconds. Not much else can be done here other than clamping to the minimum
      // or maximum duration.
      guard clampedSecondsComponent > .min else {
        self = .min
        return
      }
      guard clampedSecondsComponent < .max else {
        self = .max
        return
      }

      self = .init(
        secondsComponent: clampedSecondsComponent,
        attosecondsComponent: clampedAttosecondsComponent
      )
      return
    }
    guard let secondsComponent = Int64(exactly: seconds) else {
      // Now, the same as above is done for the seconds component when it cannot be represented in
      // only 64 bits. Some of it will be converted into attoseconds and added to the total in
      // attoseconds, resorting to returning the minimum or maximum duration in case it still
      // overflows.
      //
      // This is way less significant than the previous case, given that ⌊log₂(1e18)⌋ + 1 (= 60)
      // bits are required for representing as few as 1 s in attoseconds.
      let clampedAdvancedSecondsComponent = Int64(clamping: seconds)
      let remainingSecondsComponent = seconds - .init(clampedAdvancedSecondsComponent)
      let clampedAdvancedAttosecondsComponent = Int64(
        clamping: Int128(attosecondsComponent) + remainingSecondsComponent
          * Self.secondScaleAsInt128
      )
      guard clampedAdvancedSecondsComponent > .min || clampedAdvancedAttosecondsComponent > .min
      else {
        self = .min
        return
      }
      guard clampedAdvancedSecondsComponent < .max || clampedAdvancedAttosecondsComponent < .max
      else {
        self = .max
        return
      }
      self = .init(
        secondsComponent: clampedAdvancedSecondsComponent,
        attosecondsComponent: clampedAdvancedAttosecondsComponent
      )
      return
    }
    self = .init(secondsComponent: secondsComponent, attosecondsComponent: attosecondsComponent)
  }
}
