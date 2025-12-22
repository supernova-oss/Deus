#!/bin/bash
# ===--------------------------------------------------------------------------------------------===
# Copyright © 2025 Supernova. All rights reserved.
#
# This file is part of the Deus open-source project.
#
# This program is free software: you can redistribute it and/or modify it under the terms of the GNU
# General Public License as published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without
# even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License along with this program. If not,
# see https://www.gnu.org/licenses.
# ===--------------------------------------------------------------------------------------------===

# dswtc stands for "Deus Swift toolchain". Swift toolchains are a set of tools for documenting,
# linking, compiling and debugging Swift sources. Deus requires a version of the Swift toolchain
# which supports automatic differentiation for implementing quantum fields. dswtc is the Swift
# toolchain whose version is that defined by the .swift-version file located at the root of the
# directory of the project.
#
# This script provides information about the dswtc.

dswtc_version="$(cat "$(dirname "${BASH_SOURCE[0]}")"/../.swift-version | xargs)"
if swiftly list 2>/dev/null | grep --quiet "$dswtc_version"; then
  is_dswtc_installed=1
else
  is_dswtc_installed=0
fi

ensure_dswtc_installation() {
  [ "$is_dswtc_installed" -eq 1 ] || exit 1
}

dswtc_id() {
  ensure_dswtc_installation
  echo "$(defaults read "$(dswtc_path)"/Info CFBundleIdentifier)"
}

dswtc_path() {
  ensure_dswtc_installation
  echo ~/Library/Developer/Toolchains/swift-DEVELOPMENT-SNAPSHOT-"${dswtc_version: -10}"-a.xctoolchain
}
