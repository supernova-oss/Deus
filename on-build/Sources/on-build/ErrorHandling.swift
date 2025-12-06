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

/// Calls the given `closure` as a closure by which an error of the specified type can be thrown.
/// This is an unsafe operation, and will result in undefined behavior in case the `closure` throws
/// an error which is not of the passed-in type; the responsibility of ensuring such match is
/// brought upon the caller.
///
/// - Parameters:
///   - errorType: The only type of error throwable by the `closure` (unchecked).
///   - closure: Closure to be cast to `() async throws(ErrorType) -> Result` and called.
func unsafeCallWithErrorCast<ErrorType, Result>(
  to errorType: ErrorType.Type,
  _ closure: @escaping () throws -> Result
) throws(ErrorType) -> Result where ErrorType: Error {
  try unsafeBitCast(closure, to: (() throws(ErrorType) -> Result).self)()
}

/// Calls the given `closure` as a closure by which an error of the specified type can be thrown.
/// This is an unsafe operation, and will result in undefined behavior in case the `closure` throws
/// an error which is not of the passed-in type; the responsibility of ensuring such match is
/// brought upon the caller.
///
/// - Parameters:
///   - errorType: The only type of error throwable by the `closure` (unchecked).
///   - closure: Closure to be cast to `() async throws(ErrorType) -> Result` and called.
func unsafeCallWithErrorCast<ErrorType, Result>(
  to errorType: ErrorType.Type,
  _ closure: @escaping () async throws -> Result
) async throws(ErrorType) -> Result where ErrorType: Error {
  try await unsafeBitCast(closure, to: (() async throws(ErrorType) -> Result).self)()
}
