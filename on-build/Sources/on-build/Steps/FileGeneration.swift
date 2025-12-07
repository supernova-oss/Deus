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
import Subprocess
import SwiftFormat
import System

/// ``Step`` in which Swift files are generated for their respective templates (files primarily
/// identified by a `.swift.gyb` extension).
struct FileGeneration: Step {
  let _fileManagerBox: _FileManagerBox
  let projectURL: URL

  /// URLs of the templates whose Swift files which would have been generated from them are not
  /// present. Their absence may be the result of prior manual deletion.
  private var unpairedTemplateURLs: Set<URL> {
    get async throws(StepError) {
      let arguments = [".", "-name", "*.swift.gyb", "-type", "f"]
      guard let found = try? await spawnSubprocessAndCapture(.find, arguments) else {
        throw .missing(executable: .git)
      }
      var templateURLsAsStrings = found.components(separatedBy: .newlines)
      templateURLsAsStrings.removeLast()
      return .init(
        try unsafeCallWithTypedThrowsCast(to: StepError.self) {
          try templateURLsAsStrings.compactMap({ (templatePath: String) throws -> URL? in
            guard fileManager.fileExists(atPath: "\(projectURL.path())/\(templatePath)") else {
              throw StepError.unexpectedOutput(
                executable: .git,
                arguments: arguments,
                output: templatePath,
                reason: "The file does not exist."
              )
            }
            let generatedFileURL = generatedFileURL(fromTemplateAtPath: templatePath)
            guard !fileManager.fileExists(atPath: generatedFileURL.path()) else { return nil }
            return .init(
              filePath: templatePath,
              directoryHint: .notDirectory,
              relativeTo: projectURL
            )
          })
        }
      )
    }
  }

  private let projectFilePath: FilePath

  /// Names of the directories of Python packages under the `tooling` directory at the root of the
  /// project. Each package included in this array will be pip-installed in the virtual environment
  /// and, subsequently, accessible by every template file.
  private static let pythonPackages = ["reflection"]

  init(fileManager: FileManager, projectURL: URL) {
    self._fileManagerBox = .init(fileManager)
    self.projectURL = projectURL
    self.projectFilePath = .init(projectURL.path())
  }

  func run() async throws(StepError) {
    try await spawnSubprocess(.python3, ["-m", "venv", "tooling/.venv"])
    try await installPythonPackages()
    try await generateFilesFromTemplates()
  }

  /// Installs each Python package in the `tooling` directory at the root of the project which are
  /// in the ``pythonPackages`` array. Each installation is performed parallel to each other within
  /// a task group, with this function returning when all installations have finished successfully.
  private func installPythonPackages() async throws(StepError) {
    guard
      let enumerator = fileManager.enumerator(
        at: .init(filePath: "tooling", directoryHint: .isDirectory, relativeTo: projectURL),
        includingPropertiesForKeys: [.pathKey],
        options: [.producesRelativePathURLs, .skipsHiddenFiles, .skipsSubdirectoryDescendants]
      )
    else { return }
    let pip = Executable.name("\(projectURL.path())/tooling/.venv/bin/pip")
    try await unsafeCallWithTypedThrowsCast(to: StepError.self) {
      try await withThrowingTaskGroup { taskGroup in
        for case let packageURLRelativeToToolingDirectory as URL in AnySequence(enumerator) {
          guard packageURLRelativeToToolingDirectory.hasDirectoryPath else { continue }
          let packageName = packageURLRelativeToToolingDirectory.lastPathComponent
          guard Self.pythonPackages.contains(packageName) else { continue }
          taskGroup.addTask(name: "Installation of `\(packageName)` Python " + "package") {
            let packagePathRelativeToProjectDirectory =
              "tooling/\(packageURLRelativeToToolingDirectory.relativePath)"
            try await spawnSubprocess(
              pip,
              ["install", "-r", "\(packagePathRelativeToProjectDirectory)/requirements.txt"]
            )
            try await spawnSubprocess(
              pip,
              ["install", "./\(packagePathRelativeToProjectDirectory)"]
            )
          }
        }
        try await taskGroup.waitForAll()
      }
    }
  }

  /// Generates Swift files based on each template present in the project.
  private func generateFilesFromTemplates() async throws(StepError) {
    let unpairedTemplateURLs = try await unpairedTemplateURLs
    var potentialTemplateURLs = unpairedTemplateURLs
    potentialTemplateURLs.formUnion(try await modifiedFileURLs)
    let formatConfigurationURL = projectURL.appending(path: ".swift-format")
    try await unsafeCallWithTypedThrowsCast(to: StepError.self) {
      try await withThrowingTaskGroup { taskGroup in
        for templateURL in potentialTemplateURLs {
          guard
            unpairedTemplateURLs.contains(templateURL)
              || templateURL.lastPathComponent.hasSuffix(".swift.gyb")
          else { continue }
          taskGroup.addTask {
            let generatedFileURL = generatedFileURL(fromTemplateAtPath: templateURL.relativePath)
            try await generateFile(from: templateURL, at: generatedFileURL)
            try await format(at: generatedFileURL, withConfigurationAt: formatConfigurationURL)
          }
        }
        try await taskGroup.waitForAll()
      }
    }
  }

  /// Generates a file from a template.
  ///
  /// - Parameters:
  ///   - templateURL: URL of the `.swift.gyb` file from which the file should be generated.
  ///   - generatedFileURL: URL of the file to be generated. Expected to be the result of calling
  ///     ``generatedFileURL(fromTemplateAtPath:)``.
  private func generateFile(from templateURL: URL, at generatedFileURL: URL) async throws(StepError)
  {
    try await spawnSubprocess(
      .name("\(projectURL.path())/tooling/.venv/bin/python3"),
      [
        "tooling/gyb.py", "--line-directive", "", "-o", generatedFileURL.relativePath,
        templateURL.path()
      ]
    )
  }

  /// Rewrites the Swift file at the given URL.
  ///
  /// - Parameters:
  ///   - fileURL: URL of the Swift file to be formatted.
  ///   - configurationURL: URL of the formatting configuration file.
  private func format(
    at fileURL: URL,
    withConfigurationAt configurationURL: URL
  ) async throws(StepError) {
    guard let formatConfiguration = try? Configuration(contentsOf: configurationURL) else {
      throw StepError.unallowed(.read, fileURL: configurationURL)
    }
    do { try SwiftFormatter(configuration: formatConfiguration).format(at: fileURL) } catch {
      throw StepError.unallowed(.write, fileURL: fileURL)
    }
  }

  /// Produces the URL of a Swift file, relative to the ``projectURL``, which either will be or has
  /// been generated for the template at the given URL. Guaranteeing that the `templateURL` is the
  /// URL of a template is a responsibility of the caller; calling this function with a URL which
  /// does not meet such criteria may produce a nonsensical URL.
  ///
  /// - Parameter templatePath: Path of the template, relative to the ``projectURL``, from which the
  ///   Swift file at the returned URL may be or has been generated.
  private func generatedFileURL(fromTemplateAtPath templatePath: some StringProtocol) -> URL {
    let templateNameIndex =
      if let lastPathSeparatorIndex = templatePath.lastIndex(of: "/") {
        templatePath.index(after: lastPathSeparatorIndex)
      } else { templatePath.startIndex }
    var generatedFileName = templatePath[templateNameIndex...]

    // Given the URL of a template, the last four characters of the name are of the ".gyb" substring
    // of the ".swift.gyb" suffix.
    generatedFileName.removeLast(4)

    let templateDirectoryPath = templatePath[..<templateNameIndex]
    return .init(
      filePath:
        "\(templateDirectoryPath)\(templateDirectoryPath.isEmpty ? "" : "/")\(generatedFileName)",
      directoryHint: .notDirectory,
      relativeTo: projectURL
    )
  }
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
