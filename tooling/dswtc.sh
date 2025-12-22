#!/bin/sh

project_directory="$(dirname "$(realpath "$0")")"/..
dswtc_version="$(cat "$project_directory"/.swift-version | xargs)"
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
