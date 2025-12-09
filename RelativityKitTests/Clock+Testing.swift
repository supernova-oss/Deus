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

/// Execute-around method (EAM) which produces an instance of a ``Clock``, calls the given closure
/// and resets the ``Clock`` afterward. Prevents us from relying on a shared instance of such type
/// and the necessity of performing manual resets — which can be forgotten, starting the next test
/// in the suite with the shared ``Clock`` in the state left unchanged by the previous test.
///
/// - Parameters:
///   - isStarted: Whether the ``Clock`` should be started automatically before the closure gets
///     called. Defaults to `true`, as this is the behavior intended for most cases.
///   - test: Closure into which the newly created ``Clock`` is passed, and after which such
///   ``Clock`` is reset.
func withClock(
  isStartedPreemptively: Bool = true,
  _ body: (Clock) async throws -> Void
) async rethrows {
  let clock = Clock()
  if isStartedPreemptively { await clock.start() }
  try await body(clock)
  await clock.reset()
}
