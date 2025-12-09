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

@testable import RelativityKit
import Testing

@Suite("Clock+Testing tests")
struct ClockTestingTests {
  @Test
  func bodyIsCalledOnce() async {
    var callCount = 0
    await withClock { _ in callCount += 1 }
    #expect(callCount == 1)
  }

  @Test
  func clockIsStartedPreemptivelyByDefault() async {
    await withClock { clock in
      await clock.advanceTime(by: .tick, spacing: .extreme)
      #expect(await clock.elapsedTime == .tick)
    }
  }

  @Test
  func clockIsNotStartedPreemptivelyWhenAskedNotTo() async {
    await withClock(isStartedPreemptively: false) { clock in
      await clock.advanceTime(by: .tick, spacing: .extreme)
      #expect(await clock.elapsedTime == .zero)
    }
  }

  @Test
  func clockIsResetAfterCallToBody() async {
    var capturedClock: Clock?
    await withClock { clock in capturedClock = clock }
    guard let capturedClock else { fatalError("Clock was not captured.") }
    await capturedClock.advanceTime(by: .tick, spacing: .extreme)
    #expect(await capturedClock.elapsedTime == .zero)
  }
}
