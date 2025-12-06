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

/// Performer of a set of actions regarding one stage of the build pipeline.
///
/// ## On thread safety
///
/// `on-build` may run multiple steps of the build pipeline in parallel; because of that, each step
/// conforms to the `Sendable` protocol. This conformance is *unchecked* and, therefore, mutual
/// exclusion is not enforced at compile-time.
///
/// It is a responsibility of the implementation to ensure that the files which it accesses are not
/// files which may be written to or moved by another step. Failure to adhere to this implicit
/// contract may result in an unexpected file structure.
///
/// ## Conventions of initialization
///
/// The unchecked nature of the conformance of this type to sendable is derived from its
/// ``fileManager`` not being sendable — given the thread-unsafety of its operations. Such unchecked
/// conformance is done by boxing the underlying file manager, i.e., wrapping a reference to it with
/// a wrapper class, which is, itself, sendable.
///
/// However, this is an implementation detail; external consumers *should not* be aware of it, and
/// an
///
/// ```swift
/// init(fileManager: FileManager, projectURL: URL)
/// ```
///
/// *should* be declared for each implementation of this protocol, rather than an
///
/// ```swift
/// init(_fileManagerBox: _FileManagerBox, projectURL: URL)
/// ```
///
/// (which may be provided automatically by Swift).
protocol Step: Sendable {
  /// Holder of the reference to the manager by which files may be modified. Wrapping the manager
  /// by such an instance allows for conforming ``Step`` to sendable, since a file manager is
  /// explicitly declared as non-sendable.
  var _fileManagerBox: _FileManagerBox { get }

  /// URL of the root directory of the Deus project.
  var projectURL: URL { get }

  /// Runs the actions associated to this step of the build process. Non-throwing calls to this
  /// method are guaranteed to *always* produce side effects, as at least one file in the project
  /// will have been changed by it.
  func run() async throws(StepError)
}

extension Step {
  /// Manager by which files may be modified.
  var fileManager: FileManager { _fileManagerBox.fileManager }
}

/// Wrapper by which a reference to a file manager is held, allowing for conforming ``Step`` to the
/// sendable protocol with the implicit contract of there not being concurrent modifications to the
/// same file.
final class _FileManagerBox: @unchecked Sendable {
  /// Non-sendable manager being referenced, by which files may be modified in each implementation
  /// of ``Step``.
  let fileManager: FileManager

  init(_ fileManager: FileManager) { self.fileManager = fileManager }
}

/// Failure resulted from one of the build steps.
enum StepError {
  /// Execution of an executable yielded an error.
  ///
  /// - Parameters:
  ///   - executable: Executable which has been executed.
  ///   - arguments: Arguments passed into the `executable`.
  ///   - message: Contents output to the standard error by the executable.
  /// - SeeAlso: ``Step/spawnSubprocess(for:_:forwardingOutputTo:)``
  case failure(executable: Executable, arguments: [String], message: String?)

  /// An essential executable included by default in the operating system (e.g., `/bin/sh` or
  /// `/usr/bin/find`) or which has been compiled previously has not been found.
  case missing(executable: Executable)

  /// The process does not have permission to modify the file at the given URL.
  ///
  /// - Parameters:
  ///   - modificationKind: The kind of modification the process attempted to perform on the file.
  ///   - fileURL: URL of the file attempted to be modified by the process.
  case unallowed(_ modificationKind: ModificationKind, fileURL: URL)

  /// The output collected from a subprocess is not in the expected form, denoting that external
  /// changes to the file system may have been performed and may be causing a potentially
  /// nonsensical result to be yielded (e.g., spawning `/usr/bin/find` with `on-build -maxdepth 0`
  /// from the directory of the project and the output being empty).
  ///
  /// - Parameters:
  ///   - executable: Executable run by the subprocess.
  ///   - arguments: Arguments passed into the `executable`.
  ///   - output: The unexpected output.
  /// - SeeAlso: ``Step/spawnSubprocess(for:_:forwardingOutputTo:)``
  case unexpectedOutput(executable: Executable, arguments: [String], output: String?)
}

extension StepError: CustomStringConvertible {
  var description: String {
    switch self {
    case .failure(let executable, let arguments, let message):
      message ?? "An error occurred while executing `\(executable) \(arguments)`."
    case .missing(let executable): "Required executable \(executable) not found."
    case .unallowed(let modificationKind, let fileURL):
      "Cannot \(modificationKind.lexemeInBaseForm) \(fileURL)."
    case .unexpectedOutput(let executable, let arguments, let output):
      "`\(executable) \(arguments)` yielded an unexpected output: \"\(output)\"."
    }
  }
}

extension StepError: Error {}

/// Categories of modifications which may be attempted on a file.
enum ModificationKind {
  /// Description of this kind of modification with the verb in its base form, to which a
  /// description of the file attempted to be modified is expected to be concatenated with a
  /// preceding separator.
  fileprivate var lexemeInBaseForm: String {
    switch self {
    case .read: "read"
    case .removal: "remove"
    case .write: "write to"
    }
  }

  /// Reading of the contents of the file.
  case read

  /// Deletion of the file.
  case removal

  /// Updates to the contents of the file.
  case write
}
