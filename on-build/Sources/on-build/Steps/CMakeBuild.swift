//// ===-----------------------------------------------------------------------===
// Copyright © 2026 Supernova
//
// This file is part of the Deus open-source project.
//
// This program is free software: you can redistribute it and/or modify it under
// the terms of the GNU General Public License as published by the Free Software
// Foundation, either version 3 of the License, or (at your option) any later
// version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
// details.
//
// You should have received a copy of the GNU General Public License along with
// this program. If not, see https://www.gnu.org/licenses.
// ===-----------------------------------------------------------------------===

import Foundation

/// ``Step`` in which the C sources of Deus are built with CMake and output to
/// the `.build` directory at the root of the project.
struct CMakeBuild: Step {
  let _fileManagerBox: _FileManagerBox
  let projectURL: URL

  init(fileManager: FileManager, projectURL: URL) {
    self._fileManagerBox = .init(fileManager)
    self.projectURL = projectURL
  }

  func run() async throws(StepError) {
    let outputPath = projectURL.appending(path: ".build").path()
    try await spawnSubprocess(.cmake, ["-B", outputPath])
    try await spawnSubprocess(.cmake, ["--build", outputPath])
  }
}
