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

/// `on-build` is a package of Deus for comprising several important steps which should be
/// performed automatically upon an Xcode build. The main goal of these steps is to ensure
/// consistency and correctness throughout the project.
@main
struct OnBuild {
  static func main() async throws {
    let fileManager = FileManager.default
    var projectURL = URL(filePath: FileManager.default.currentDirectoryPath)
    projectURL.deleteLastPathComponent()
    try await FileGeneration(fileManager: fileManager, projectURL: projectURL).run()
    try await Formatting(fileManager: fileManager, projectURL: projectURL).run()
  }
}
