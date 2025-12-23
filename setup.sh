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

# This script performs the initial configuration of the environment for building and testing Deus
# locally. It is recommended that it be run after the project is cloned and every time the Swift
# toolchain in use is changed, given that the project relies on a specific development snapshot of
# such toolchain.

project_directory="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"

install_swiftly() {
  if [ ! -d ~/.swiftly ]; then
    curl -O https://download.swift.org/swiftly/darwin/swiftly.pkg
    installer -pkg swiftly.pkg -target CurrentUserHomeDirectory
    ~/.swiftly/bin/swiftly init --assume-yes --skip-install
  fi
  source ~/.swiftly/env.sh
}

install_dswtc() {
  dswtcinfo path &>/dev/null || swiftly install --assume-yes --use "$(dswtcinfo version)"
  assert_eq                                                      \
    "$(swiftly use --print-location 2>/dev/null | head -n 1)"    \
    "$(dswtcinfo path)"                                          \
    'Swift of Swiftly is not that of the development toolchain.'
  assert_eq                                                                     \
    "$(swift --version 2>/dev/null | head -n 1)"                                \
    'Apple Swift version 6.3-dev (LLVM 36e07716208ae15, Swift 7b214378007870f)' \
    'Version of Swift is not 6.3-dev.'
}

intercept_dswtc_ld() {
  # This is weird: neither dswtc nor toolchains posterior to it as of December 17, 2025 include the
  # GNU linker (ld), which is required by SwiftPM for linking object files. And, for some reason
  # unknown by me, ld outputs the details of its version successfully before `swift build` is called
  # (by `swift run`), but yields an empty string when `swift build` calls it.
  #
  # https://github.com/swiftlang/swift-build/blob/ff02f8db335e41af9ccdc15896a94c667d31288b/Sources/SWBCore/SpecImplementations/Tools/LinkerTools.swift#L1916-L1920
  #
  # As a workaround, we intercept calls to ld, outputting the details of its version which are
  # expected by the caller when the `version_details` flag is passed in; otherwise, the call is
  # forwarded to the ld included in macOS.
  #
  # For more details on this issue, see https://github.com/supernova-oss/Deus/pull/58.
  local linker_path="$(dswtcinfo path)"/usr/bin/ld
  cat > "$linker_path".c << 'EOF'
#include <stdio.h>
#include <string.h>
#include <unistd.h>

int main(int argc, char **argv) {
  if (!strcmp(argv[1], "-version_details")) {
    printf(
      "{"
        "\"version\": \"1221.4\", "
        "\"architectures\": ["
          "\"armv6\", "
          "\"arm64\", "
          "\"arm64_32\", "
          "\"arm64e\", "
          "\"armv6m\", "
          "\"armv7\", "
          "\"armv7s\", "
          "\"armv7em\", "
          "\"armv7k\", "
          "\"armv7m\", "
          "\"armv8.1m.main\", "
          "\"armv8m.main\", "
          "\"i386\", "
          "\"x86_64\", "
          "\"x86_64h\""
        "], "
        "\"lto\": {"
          "\"runtime_api_version\": 29, "
          "\"static_api_version\": 29, "
          "\"version_string\": \"LLVM version 17.0.0\""
        "}, "
        "\"tapi\": {"
          "\"version\": \"17.0.0\", "
          "\"version_string\": \"Apple TAPI version 17.0.0 (tapi-1700.3.8)\""
        "}"
      "}"
    );
  } else {
    execv("/usr/bin/ld", argv);
  }
  return 0;
}
EOF
  clang "$linker_path".c -o "$linker_path"
  rm "$linker_path".c
  assert_eq                                                    \
    "$(find "$(dswtcinfo path)"/usr/bin -maxdepth 1 -name ld)" \
    "$linker_path"                                             \
    'Interceptor ld was not included in the toolchain.'
}

export PATH="$project_directory"/bin:$PATH
(
  source "$project_directory"/tooling/assert.sh
  install_swiftly
  install_dswtc
  intercept_dswtc_ld
)
