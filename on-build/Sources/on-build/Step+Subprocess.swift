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

import Subprocess

extension Executable {
  /// Executable at `/bin/chmod`.
  static let chmod = Self.name("/bin/chmod")

  /// Executable at `/usr/bin/find`.
  static let find = Self.name("/usr/bin/find")

  /// Executable at `/usr/bin/git`.
  static let git = Self.name("/usr/bin/git")

  /// Executable at `/usr/bin/python3`.
  static let python3 = Self.name("/usr/bin/python3")
}

extension Step {
  /// Spawns a subprocess and executes the given executable, passing the given arguments in and with
  /// the ``projectURL`` as the working directory. The output is forwarded to the standard output
  /// and ignored; to capture it, call ``spawnSubprocessAndCapture(_:_:)``.
  ///
  /// - Parameters:
  ///   - executable: The executable to execute.
  ///   - arguments: The arguments to pass to the executable.
  func spawnSubprocess(_ executable: Executable, _ arguments: [String]) async throws(StepError) {
    try await spawnSubprocess(executable, arguments, forwardingOutputTo: .standardOutput)
  }

  /// Spawns a subprocess and executes the given executable, passing the given arguments in and with
  /// the ``projectURL`` as the working directory. The output is captured and returned by this
  /// function; to forward it to the standard output, call ``spawnSubprocess(_:_:)``.
  ///
  /// - Parameters:
  ///   - executable: The executable to execute.
  ///   - arguments: The arguments to pass to the executable.
  func spawnSubprocessAndCapture(
    _ executable: Executable,
    _ arguments: [String]
  ) async throws(StepError) -> String {
    guard
      let output = try await spawnSubprocess(
        executable,
        arguments,
        forwardingOutputTo: .string(limit: .max)
      )
    else { throw .unexpectedOutput(executable: executable, arguments: arguments) }
    return output
  }

  /// Spawns a subprocess and executes the given executable, passing the given arguments in and with
  /// the ``projectURL`` as the working directory.
  ///
  /// - Parameters:
  ///   - executable: The executable to execute.
  ///   - arguments: The arguments to pass to the executable.
  ///   - output: The method to use for redirecting the standard output.
  private func spawnSubprocess<Output>(
    _ executable: Executable,
    _ arguments: [String],
    forwardingOutputTo output: Output
  ) async throws(StepError) -> Output.OutputType where Output: OutputProtocol {
    guard
      let result = try? await Subprocess.run(
        executable,
        arguments: .init(arguments),
        workingDirectory: .init(projectURL),
        output: output,
        error: .string(limit: .max)
      )
    else { throw .missing(executable: executable) }
    switch result.terminationStatus {
    case .exited(let code):
      guard code == 0 else {
        throw .failure(executable: executable, arguments: arguments, message: result.standardError)
      }
    case .unhandledException(_):
      throw .failure(executable: executable, arguments: arguments, message: result.standardError)
    }
    return result.standardOutput
  }
}
