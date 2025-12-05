#!/usr/bin/swift sh

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
import Subprocess // swiftlang/swift-subprocess ~> 0.1
import SwiftFormat // swiftlang/swift-format ~> 601.0
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
setenv(
  "LICENSE_HEADER_SH",
  """
  # \
  ===--------------------------------------------------------------------------------------------===
  # Copyright © \
  \(Calendar(identifier: .gregorian).dateComponents([.year], from: Date.now).year ?? 2025) \
  Supernova. All rights reserved.   
  #
  # This file is part of the Deus open-source project.
  #
  # This program is free software: you can redistribute it and/or modify it under the terms of the \
  GNU
  # General Public License as published by the Free Software Foundation, either version 3 of the
  # License, or (at your option) any later version.
  #
  # This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; \
  without
  # even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
  # General Public License for more details.
  #
  # You should have received a copy of the GNU General Public License along with this program. If \
  not,
  # see https://www.gnu.org/licenses.
  # \
  ===--------------------------------------------------------------------------------------------===
  """,
  1
)

/// Exports an environment variable, `SRCROOT`, containing the root directory of the project. Such
/// variable already gets exported by Xcode by default; it is only actually exported by this
/// function in case this script, for some reason, is being run directly.
private func exportSrcroot() throws {
  guard ProcessInfo.processInfo.environment["SRCROOT"] == nil else { return }
  setenv("SRCROOT", fileManager.currentDirectoryPath, 0)
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

/// URL of every file which has been modified since the last commit, including both those in the
/// staging area and those unstaged.
private var allModifiedFileURLs: Set<URL> {
  get async throws {
    do {
      async let unstagedModifiedFileURLs = try modifiedFileURLs(ofFilesWhichAre: .unstaged)
      async let stagedModifiedFileURLs = try modifiedFileURLs(ofFilesWhichAre: .staged)
      return await unstagedModifiedFileURLs.union(stagedModifiedFileURLs)
    } catch { throw error }
  }
}

/// State of a file in Git which determines whether it is in the staging area (index), with the
/// presence of such file in it denoting that it will be included in next commit until the file is
/// unstaged.
private enum GitStagingAreaPresence {
  /// Flags for [`git-diff`](https://git-scm.com/docs/git-diff) according to this marker of presence
  /// of files in the staging area.
  var diffingFlags: [String] {
    switch self {
    case .unstaged: []
    case .staged: ["--staged"]
    }
  }

  /// The file is not in the staging area and will not be included in the next commit.
  case unstaged

  /// The file is in the staging area and will be included in the next commit.
  case staged
}

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
    output: .standardOutput,
    error: .standardError
  )
}

/// Obtains the URLs of the files which have been modified since the last commit and are either in
/// the staging area (that is: to be commited) or those which will not be added in the next commit.
/// The sorting is defined by [`git-diff`](https://git-scm.com/docs/git-diff).
///
/// - Parameter stagingAreaPresence: Presence of the files whose URLs will be obtained in the
///   staging area.
private func modifiedFileURLs(
  ofFilesWhichAre stagingAreaPresence: GitStagingAreaPresence
) async throws -> Set<URL> {
  guard
    let modifiedFileURLsAsStrings = try await run(
      .name("/usr/bin/git"),
      arguments: .init(["diff", "--name-only"] + stagingAreaPresence.diffingFlags),
      workingDirectory: srcrootFilePath,
      output: .string(limit: .max),
      error: .standardError
    ).standardOutput?.components(separatedBy: .newlines)
  else { return [] }
  return Set(
    Array(
      unsafeUninitializedCapacity: modifiedFileURLsAsStrings.count,
      initializingWith: { pointer, initializedCount in
        guard var currentBaseAddress = pointer.baseAddress else { return }
        for modifiedFileURLAsString in modifiedFileURLsAsStrings {
          defer { currentBaseAddress = currentBaseAddress.successor() }
          guard !modifiedFileURLAsString.isEmpty else { continue }
          currentBaseAddress.initialize(
            to: .init(
              filePath: .init(modifiedFileURLAsString),
              directoryHint: .notDirectory,
              relativeTo: srcrootURL
            )
          )
          initializedCount += 1
        }
      }
    )
  )
}

// MARK: - GYB

/// URL of the templates whose Swift files which would have been generated from them are not
/// present. Their absence may be the result of manual deletion.
private var unpairedTemplateURLs: Set<URL> {
  get async throws {
    guard
      let templateURLsAsStrings = try await run(
        .name("/usr/bin/find"),
        arguments: [".", "-name", "*.swift.gyb", "-type", "f"],
        workingDirectory: srcrootFilePath,
        output: .string(limit: .max),
        error: .standardError
      ).standardOutput?.components(separatedBy: .newlines)
    else { return [] }
    return .init(
      templateURLsAsStrings.compactMap { templateURLAsString in
        let templateURL = URL(
          filePath: templateURLAsString,
          directoryHint: .notDirectory,
          relativeTo: srcrootURL
        )
        let generatedFileURL = generatedFileURL(fromTemplateAt: templateURL)
        guard !fileManager.fileExists(atPath: generatedFileURL.path()) else { return nil }
        return templateURL
      }
    )
  }
}

try await withVenv(generateBoilerplate)

/// Configures the Python virtual environment (venv) for the given `body`, deconfiguring it
/// afterwards. Upon execution of the `body`, all Python tools in the `tooling` directory at the
/// root of the project will have been built and installed, and are available to be used by other
/// Python files.
///
/// - Parameter body: Lambda to be executed while the venv is configured.
private func withVenv(_ body: () async throws -> Void) async throws {
  try await run(
    .name("/usr/bin/python3"),
    arguments: ["-m", "venv", "tooling/.venv"],
    workingDirectory: srcrootFilePath,
    output: .standardOutput,
    error: .standardError
  )
  guard
    let enumerator = fileManager.enumerator(
      at: URL(filePath: "tooling", directoryHint: .isDirectory, relativeTo: srcrootURL),
      includingPropertiesForKeys: [.pathKey],
      options: [.producesRelativePathURLs, .skipsHiddenFiles, .skipsSubdirectoryDescendants]
    )
  else { return }
  try await withThrowingTaskGroup { taskGroup in
    for case let packageURL as URL in enumerator {
      guard packageURL.hasDirectoryPath else { continue }
      taskGroup.addTask(name: "Installation of `\(packageURL.lastPathComponent)` Python package") {
        try await run(
          .name("\(srcroot)/tooling/.venv/bin/pip"),
          arguments: ["install", "-r", "./tooling/\(packageURL.relativePath)/requirements.txt"],
          workingDirectory: srcrootFilePath,
          output: .standardOutput,
          error: .standardError
        )
        try await run(
          .name("\(srcroot)/tooling/.venv/bin/pip"),
          arguments: ["install", "./tooling/\(packageURL.relativePath)"],
          workingDirectory: srcrootFilePath,
          output: .standardOutput,
          error: .standardError
        )
      }
    }
    try await taskGroup.waitForAll()
  }
  try await body()
}

/// Generates .swift files based on each .swift.gyb file present in the project.
private func generateBoilerplate() async throws {
  let formatter = SwiftFormatter(
    configuration: try .init(contentsOf: srcrootURL.appending(path: ".swift-format"))
  )
  let unpairedTemplateURLs = try await unpairedTemplateURLs
  var potentialTemplateURLs = unpairedTemplateURLs
  potentialTemplateURLs.formUnion(allModifiedFileURLs)
  try await withThrowingTaskGroup { taskGroup in
    for templateURL in potentialTemplateURLs {
      guard
        unpairedTemplateURLs.contains(templateURL)
          || templateURL.lastPathComponent.hasSuffix(".swift.gyb")
      else { continue }
      taskGroup.addTask {
        let generatedFileURL = generatedFileURL(fromTemplateAt: templateURL)
        try await run(
          .name("\(srcroot)/tooling/.venv/bin/python3"),
          arguments: [
            "tooling/gyb.py", "--line-directive", "", "-o", generatedFileURL.relativePath,
            templateURL.path()
          ],
          workingDirectory: srcrootFilePath,
          output: .standardOutput,
          error: .standardError
        )
        try formatter.format(at: generatedFileURL)
      }
    }
    try await taskGroup.waitForAll()
  }
}

/// Produces the URL of a Swift file which either will be or has been generated for the template at
/// the given URL. Guaranteeing that the `templateURL` is the URL of a template is a responsibility
/// of the caller; calling this function with a URL which does not meet such criteria may produce a
/// nonsensical URL.
///
/// - Parameter templateURL: URL of the `.swift.gyb` file from which the Swift file at the returned
///   URL may be or has been generated.
private func generatedFileURL(fromTemplateAt templateURL: URL) -> URL {
  var templateName = templateURL.lastPathComponent

  // Given the URL of a template, the last four characters of the name are of the ".gyb" substring
  // of the ".swift.gyb" suffix.
  templateName.removeLast(4)

  return templateURL.deletingLastPathComponent().appending(
    path: templateName,
    directoryHint: .notDirectory
  )
}

extension SwiftFormatter {
  /// Formats the file at given `URL` according to the specified configuration.
  ///
  /// - Parameter fileURL: `URL` of the .swift file to be formatted.
  fileprivate func format(at fileURL: URL) throws {
    var output = ""
    try format(contentsOf: fileURL, to: &output)
    try output.write(to: fileURL, atomically: true, encoding: .utf8)
  }
}
