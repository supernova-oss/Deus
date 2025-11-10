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

@Suite("Duration+Strideable tests")
struct DurationStrideableTests {
  @Test
  func advancesByAttoseconds() {
    #expect(
      Duration.zero.advanced(by: Duration.secondScaleAsInt128 + 256)
        == .init(secondsComponent: 1, attosecondsComponent: 256)
    )
  }

  @Test
  func advancesByNanoseconds() {
    #expect(Duration.zero.advanced(by: .init(1e9)) == .nanoseconds(1))
  }

  @Test
  func advancesByMicroseconds() {
    #expect(Duration.zero.advanced(by: .init(1e12)) == .microseconds(1))
  }

  @Test
  func advancesByMilliseconds() {
    #expect(Duration.zero.advanced(by: .init(1e15)) == .milliseconds(1))
  }

  @Test
  func advancesBySeconds() {
    #expect(Duration.zero.advanced(by: Duration.secondScaleAsInt128) == .seconds(1))
  }
}
