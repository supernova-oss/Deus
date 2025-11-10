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

import Testing

@testable import RelativityKit

@Suite("Clock+Duration tests")
struct ClockDurationTests {
  @Test
  func oneSubtickIsOneMicrosecond() {
    #expect(Duration.subtick == .microseconds(1))
    #expect(Duration.subticks(1) == .microseconds(1))
  }

  @Test
  func oneTickIsOneMillisecond() { #expect(Duration.tick == .milliseconds(1)) }

  @Test
  func comprisableSubtickCountIsAmountOfAttosecondsConvertedIntoMicroseconds() {
    #expect(Duration.nanoseconds(2_500).comprisableSubtickCount == 2.5)
  }

  @Test
  func nonIntegerAmountOfTicksCannotCompriseOnlyWholeTicks() {
    #expect(!Duration.subticks(1_024).canOnlyCompriseWholeTicks)
  }

  @Test
  func integerAmountOfTicksCanCompriseOnlyWholeTicks() {
    #expect(Duration.subticks(2_000).canOnlyCompriseWholeTicks)
  }
}
