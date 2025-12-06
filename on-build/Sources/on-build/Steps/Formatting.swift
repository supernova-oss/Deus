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

/// ``Step`` in which a Git hook for formatting all Swift files before each commit is written.
struct Formatting: Step {
  let _fileManagerBox: _FileManagerBox
  let projectURL: URL

  init(fileManager: FileManager, projectURL: URL) {
    self._fileManagerBox = .init(fileManager)
    self.projectURL = projectURL
  }

  func run() async throws(StepError) {
    var hooksURL = projectURL.appending(path: ".git")
    hooksURL.append(path: "hooks")
    let preCommitURL = hooksURL.appending(path: "pre-commit")
    do { try fileManager.createDirectory(at: hooksURL, withIntermediateDirectories: true) } catch {
      throw .unallowed(.write, fileURL: hooksURL)
    }
    do {
      try """
      #!/bin/sh
      # \
      ===--------------------------------------------------------------------------------------------===
      # Copyright © \
      \(Calendar(identifier: .gregorian).dateComponents([.year], from: Date.now).year ?? 2025) \
      Supernova. All rights reserved.   
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
      # even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the \
      GNU
      # General Public License for more details.
      #
      # You should have received a copy of the GNU General Public License along with this program. \
      If not,
      # see https://www.gnu.org/licenses.
      # \
      ===--------------------------------------------------------------------------------------------===

      swift-format -p -r -i \(projectURL.path())
      swift-format lint -p -r -s \(projectURL.path())
      git add .

      """.write(to: preCommitURL, atomically: true, encoding: .utf8)
    } catch { throw .unallowed(.write, fileURL: preCommitURL) }
    try await spawnSubprocess(for: .chmod, ["+x", preCommitURL.path()])
  }
}
