#!/usr/bin/swift sh

// ===-------------------------------------------------------------------------------------------===
// Copyright © 2025 Deus
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
import Subprocess // swiftlang/swift-subprocess ~> 0.1
import System

/// `FileManager` by which files will be written to or removed.
private nonisolated var fileManager: FileManager { FileManager.default }

// MARK: - Environment

/// Exported `SRCROOT` environment variable.
private nonisolated var srcroot: String { requireenv("SRCROOT") }

/// `FilePath` of the `SRCROOT`.
private nonisolated var srcrootFilePath: FilePath { .init(srcroot) }

/// `URL` of the `SRCROOT`.
private nonisolated var srcrootURL: URL { .init(filePath: srcroot, directoryHint: .isDirectory) }

try exportSrcroot()
exportLicenseHeaders()

/// Exports an environment variable, `SRCROOT`, containing the root directory of the project. Such
/// variable already gets exported by Xcode by default; it is only actually exported by this
/// function in case this script, for some reason, is being run directly.
private func exportSrcroot() throws {
  guard ProcessInfo.processInfo.environment["SRCROOT"] == nil else { return }
  setenv("SRCROOT", fileManager.currentDirectoryPath, 0)
}

/// Exports variations of the license header which must be present in each user-generated file of
/// Deus, according to the file into which it is intended to be written. Implies that the maximum
/// length of a column is of 100 characters, formatting the headers accordingly.
///
/// +-------------+------------------------+
/// | File        | Variable               |
/// +-------------+------------------------+
/// | .sh         | `LICENSE_HEADER_SH`    |
/// +-------------+------------------------+
/// | .swift      | `LICENSE_HEADER_SWIFT` |
/// +-------------+------------------------+
private func exportLicenseHeaders() {
  let year = Calendar(identifier: .gregorian).dateComponents([.year], from: Date.now).year!
  setenv(
    "LICENSE_HEADER_SH",
    """
    # \
    ===--------------------------------------------------------------------------------------------===
    # Copyright © \(year) Deus
    #
    # This file is part of the Deus open-source project.
    #
    # This program is free software: you can redistribute it and/or modify it under the terms of \
    the GNU
    # General Public License as published by the Free Software Foundation, either version 3 of the
    # License, or (at your option) any later version.
    #
    # This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; \
    without
    # even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
    # General Public License for more details.
    #
    # You should have received a copy of the GNU General Public License along with this program. \
    If not,
    # see https://www.gnu.org/licenses.
    # \
    ===--------------------------------------------------------------------------------------------===
    """,
    1
  )
  setenv(
    "LICENSE_HEADER_SWIFT",
    """
    // \
    ===-------------------------------------------------------------------------------------------===
    // Copyright © \(year) Deus
    //
    // This file is part of the Deus open-source project.
    //
    // This program is free software: you can redistribute it and/or modify it under the terms of \
    the
    // GNU General Public License as published by the Free Software Foundation, either version 3 \
    of the
    // License, or (at your option) any later version.
    //
    // This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; \
    without
    // even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
    // General Public License for more details.
    //
    // You should have received a copy of the GNU General Public License along with this program. If
    // not, see https://www.gnu.org/licenses.
    // \
    ===-------------------------------------------------------------------------------------------===
    """,
    1
  )
}

/// Asserts that an environment variable with the given `name` has been exported, returning its
/// value. In case such variable was not exported, this script gets interrupted.
///
/// - Parameter name: Name of the variable expected to have been exported in the environment.
/// - Returns: The value assigned to the environment variable.
private func requireenv(_ name: String) -> String {
  guard let value = getenv(name) else { fatalError("\(name) is not exported.") }
  return .init(cString: value)
}

// MARK: - Git

try await writePreCommitHook()

/// Writes a hook which formats all .swift files according to .swift-format, located at the
/// directory of the project.
private func writePreCommitHook() async throws {
  let hooksURL = srcrootURL.appending(path: ".git/hooks")
  let preCommitURL = hooksURL.appending(path: "pre-commit")
  try fileManager.createDirectory(at: hooksURL, withIntermediateDirectories: true)
  fileManager.createFile(
    atPath: preCommitURL.path(),
    contents: """
      #!/bin/sh
      \(requireenv("LICENSE_HEADER_SH"))

      swift-format -p -r -i \(srcroot)
      swift-format lint -p -r -s \(srcroot)
      git add .

      """.data(using: .utf8)
  )
  try await run(
    .name("/bin/chmod"),
    arguments: ["+x", preCommitURL.path()],
    workingDirectory: srcrootFilePath,
    output: .standardOutput
  )
}

// MARK: - GYB

try await withVenv(generateBoilerplate)

/// Configures the Python virtual environment (venv) for the given `body`, deconfiguring it
/// afterwards.
///
/// - Parameter body: Lambda to be executed while the venv is configured.
private func withVenv(_ body: () async throws -> Void) async throws {
  try await run(
    .name("/usr/bin/python3"),
    arguments: ["-m", "venv", ".venv"],
    workingDirectory: srcrootFilePath,
    output: .standardOutput
  )
  try await run(
    .name("\(srcroot)/.venv/bin/pip"),
    arguments: ["install", "pip", "--upgrade"],
    workingDirectory: srcrootFilePath,
    output: .standardOutput
  )
  try await run(
    .name("\(srcroot)/.venv/bin/pip"),
    arguments: ["install", "inflect"],
    workingDirectory: srcrootFilePath,
    output: .standardOutput
  )
  try await body()
  try await run(
    .name("/bin/rm"),
    arguments: ["-rf", ".venv"],
    workingDirectory: srcrootFilePath,
    output: .standardOutput
  )
}

/// Generates .swift files based on each .swift.gyb file present in the project.
private func generateBoilerplate() async throws {
  let suffix = ".swift.gyb"
  for await var file in fileManager.flatten(at: URL(filePath: srcroot, directoryHint: .isDirectory))
  {
    var name = file.lastPathComponent
    guard !file.hasDirectoryPath && name.hasSuffix(suffix) && name != suffix else { continue }
    name.removeSubrange(
      name.index(name.endIndex, offsetBy: -suffix.count)...name.index(before: name.endIndex)
    )
    try await run(
      .name("/usr/bin/python3"),
      arguments: [
        "gyb.py", "--line-directive", "", "-o",
        "\(file.deletingLastPathComponent().path())/\(name).swift", "\(file.path())"
      ],
      workingDirectory: srcrootFilePath,
      output: .standardOutput
    )
  }
}

extension FileManager {
  /// Collects the `URL` of each regular file and directory at the given `url` recursively.
  ///
  /// - Parameter url: `URL` of the directory whose contents' `URL`s will be flattened.
  /// - Returns: The `URL` of every file at the given `url`, its subdirectories, theirs and so on.
  ///   In case the given `url` is that of a regular file instead of a directory, it will be
  ///   singly returned.
  fileprivate func flatten(at url: URL) -> AsyncStream<URL> {
    guard url.hasDirectoryPath else {
      return .init { continuation in
        continuation.yield(url)
        continuation.finish()
      }
    }
    guard let enumerator = enumerator(at: url, includingPropertiesForKeys: nil) else {
      return .init { continuation in continuation.finish() }
    }
    return .init { continuation in
      Task {
        while let unflattenedURL = enumerator.nextObject() as? URL {
          for await flattenedURL in flatten(at: unflattenedURL) { continuation.yield(flattenedURL) }
        }
        continuation.finish()
      }
    }
  }
}
