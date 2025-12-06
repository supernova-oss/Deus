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

extension Step {
  /// URLs of files which have been modified since the last commit, including both those in the
  /// staging area and those unstaged.
  var modifiedFileURLs: Set<URL> {
    get async throws(StepError) {
      var modifiedFileURLs = try await modifiedFileURLs(.unstaged)
      modifiedFileURLs.formUnion(try await self.modifiedFileURLs(.staged))
      return modifiedFileURLs
    }
  }

  /// Obtains the URLs of files which have been modified since the last commit and are either in the
  /// staging area (that is: to be commited) or those which will not be added in the next commit.
  /// The sorting is defined by [`git-diff`](https://git-scm.com/docs/git-diff).
  ///
  /// - Parameter stagingAreaPresence: Presence of the files whose URLs will be obtained in the
  ///   staging area.
  func modifiedFileURLs(
    _ stagingAreaPresence: StagingAreaPresence
  ) async throws(StepError) -> Set<URL> {
    guard
      let differences = try await spawnSubprocess(
        for: .git,
        ["diff", "--name-only"] + stagingAreaPresence.differentiationFlags,
        forwardingOutputTo: .string(limit: .max)
      )
    else { throw .missing(executable: .git) }
    var modifiedFilePaths = differences.components(separatedBy: .newlines)
    modifiedFilePaths.removeLast()
    return .init(
      try modifiedFilePaths.map({ (modifiedFilePath: String) throws(StepError) -> URL in
        .init(filePath: modifiedFilePath, directoryHint: .notDirectory, relativeTo: projectURL)
      })
    )
  }
}

/// State of a file in Git which determines whether it is in the staging area (index), with the
/// presence of such file in it denoting that it will be included in next commit until the file is
/// unstaged.
enum StagingAreaPresence {
  /// Flags for [`git-diff`](https://git-scm.com/docs/git-diff) according to this marker of
  /// presence of files in the staging area.
  fileprivate var differentiationFlags: [String] {
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
