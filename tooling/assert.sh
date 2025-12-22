#!/bin/sh
# ===--------------------------------------------------------------------------------------------===
# Copyright © 2016 Mark Torok. All rights reserved.
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
# associated documentation files (the “Software”), to deal in the Software without restriction,
# including without limitation the rights to use, copy, modify, merge, publish, distribute,
# sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all copies or
# substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
# DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT
# OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
# ===--------------------------------------------------------------------------------------------===

# Deus-specific changes:
#
# - Compliance to POSIX;
# - logging of successful assertions;
# - removal of array equality and inequality asserters; and
# - replacement of header comment describing the program by the MIT license notice.

if command -v tput &>/dev/null && tty -s; then
  RED=$(tput setaf 1)
  GREEN=$(tput setaf 2)
  MAGENTA=$(tput setaf 5)
  NORMAL=$(tput sgr0)
  BOLD=$(tput bold)
else
  RED=$(echo -en "\e[31m")
  GREEN=$(echo -en "\e[32m")
  MAGENTA=$(echo -en "\e[35m")
  NORMAL=$(echo -en "\e[00m")
  BOLD=$(echo -en "\e[01m")
fi

log_header() {
  printf "\n${BOLD}${MAGENTA}==========  %s  ==========${NORMAL}\n" "$@" >&2
}

log_success() {
  printf "${GREEN}✔ %s${NORMAL}\n" "$@" >&2
}

log_failure() {
  printf "${RED}✖ %s${NORMAL}\n" "$@" >&2
}


assert_eq() {
  local expected="$1"
  local actual="$2"
  local msg="${3-}"

  if [ "$expected" = "$actual" ]; then
    log_success "$expected"
    return 0
  else
    [ "${#msg}" -gt 0 ] && log_failure "$expected == $actual :: $msg" || true
    return 1
  fi
}

assert_not_eq() {
  local expected="$1"
  local actual="$2"
  local msg="${3-}"

  if [ ! "$expected" = "$actual" ]; then
    log_success "$expected != $actual"
    return 0
  else
    [ "${#msg}" -gt 0 ] && log_failure "$expected != $actual :: $msg" || true
    return 1
  fi
}

assert_true() {
  local actual="$1"
  local msg="${2-}"

  assert_eq true "$actual" "$msg"
  return "$?"
}

assert_false() {
  local actual="$1"
  local msg="${2-}"

  assert_eq false "$actual" "$msg"
  return "$?"
}

assert_empty() {
  local actual=$1
  local msg="${2-}"

  assert_eq "" "$actual" "$msg"
  return "$?"
}

assert_not_empty() {
  local actual=$1
  local msg="${2-}"

  assert_not_eq "" "$actual" "$msg"
  return "$?"
}

assert_contain() {
  if [ $# -lt 1 ]; then
    return 1
  fi

  local haystack="$1"
  local needle="${2-}"
  local msg="${3-}"

  if [ -z "${needle:+x}" ]; then
    return 0;
  fi

  if [ -z "$haystack" ]; then
    [ "${#msg}" -gt 0 ] && log_failure "(\"\") is empty :: $msg" || true
    return 1;
  fi

  if [ -z "${haystack##*$needle*}" ]; then
    return 0
  else
    [ "${#msg}" -gt 0 ] && log_failure "$haystack doesn't contain $needle :: $msg" || true
    return 1
  fi
}

assert_not_contain() {
  local haystack="$1"
  local needle="${2-}"
  local msg="${3-}"

  if [ -z "${needle:+x}" ]; then
    return 0;
  fi

  if [ -z "$haystack" ]; then
    return 0;
  fi

  if [ "${haystack##*$needle*}" ]; then
    return 0
  else
    [ "${#msg}" -gt 0 ] && log_failure "$haystack contains $needle :: $msg" || true
    return 1
  fi
}

assert_gt() {
  local first="$1"
  local second="$2"
  local msg="${3-}"

  if [ "$first" -gt  "$second" ]; then
    return 0
  else
    [ "${#msg}" -gt 0 ] && log_failure "$first > $second :: $msg" || true
    return 1
  fi
}

assert_ge() {
  local first="$1"
  local second="$2"
  local msg="${3-}"

  if [ "$first" -ge  "$second" ]; then
    return 0
  else
    [ "${#msg}" -gt 0 ] && log_failure "$first >= $second :: $msg" || true
    return 1
  fi
}

assert_lt() {
  local first="$1"
  local second="$2"
  local msg="${3-}"

  if [ "$first" -lt  "$second" ]; then
    return 0
  else
    [ "${#msg}" -gt 0 ] && log_failure "$first < $second :: $msg" || true
    return 1
  fi
}

assert_le() {
  local first="$1"
  local second="$2"
  local msg="${3-}"

  if [ "$first" -le  "$second" ]; then
    return 0
  else
    [ "${#msg}" -gt 0 ] && log_failure "$first <= $second :: $msg" || true
    return 1
  fi
}
