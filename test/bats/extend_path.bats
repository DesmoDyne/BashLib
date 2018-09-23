#!/usr/bin/env bats

# extend_path.bats
#
# bats unit tests for extend_path function from dd-generic.lib
#
# author  : stefan schablowski
# contact : stefan.schablowski@desmodyne.com
# created : 2018-09-23


# https://github.com/sstephenson/bats     <-- original project, dead since 2014
# https://github.com/bats-core/bats-core  <-- active fork of the project above
# https://github.com/ztombol/bats-assert  <-- bats support project
# https://github.com/ztombol/bats-file    <-- bats support project
# https://github.com/ztombol/bats-support <-- bats support project
# https://github.com/ztombol/bats-docs    <-- bats support project documentation

# recommended reads on bats:
# https://medium.com/@pimterry/testing-your-shell-scripts-with-bats-abfca9bdc5b9

# if using Atom <atom.io>, installing
# language-bats extensions is recommended:
# https://github.com/jkamenik/language-bats

# WARNING: bats is extremely sensitive to the coding style used:
# If the opening curly brace at the end of the @test line is moved to the next
# line, the test just does not run; no error message, no warning, nothing :-(((
# If it is on the same line, the test does run, but shellcheck fails to parse
# the code and reports errors and warnings. In contrast, the closing curly brace
# must be on a new line.
# TODO: create issue at https://github.com/bats-core/bats-core/issues

# NOTE: status, output and lines variables are defined by bats; from this
# test's perspective, they just pop into existence, so shellcheck reports
# them as warnings; from bats doc ref'd above:
#   The $status variable contains the status code of the command, and the
#   $output variable contains the combined contents of the command's standard
#   output and standard error streams. A third special variable, the $lines
#   array, is available for easily accessing individual lines of output.

# NOTE: all bats files are copied to a temporary folder and are run from there
# (for "isolation"); therefore, relative paths often don't work as expected;
# in these cases, bats typically fails with error code 127 and messages like
#   /usr/local/Cellar/bats-core/1.1.0/libexec/bats-core/bats-exec-test:
#   line 52: <some command>: command not found
# or
#    ✗ invoking extend_path without arguments fails and prints an error
#      (from function `setup' in test file test/bats/extend_path.bats, line 64)
#        `source "${PATH_TO_LUT}/dd-generic.lib"' failed
#      /var/folders/b3/gvjf33sx3xdfb8jblyp3jy680000gp/T/bats.61788.src: ...
#    ... line 64: <some file>: No such file or directory
# or
#    ✗ invoking extend_path without arguments fails and prints an error
#      (in test file extend_path.bats, line 62)
#        `[ "${status}" -eq 1 ]' failed with status 127
#
#   1 test, 1 failure
# and is less than helpful in diagnosing this issue; as a means to debug,
# display error message using e.g. echo "output: ${output}" after run call


# TODO: post to SO, ask for canonical way to test functions in library
# TODO: create issue at github.com / bats-core: setup / teardown sample code


function setup
{
    # path from this script to project root
    path_to_proj_root='../..'

    # path to library with functions under test, relative to project root
    path_to_lut='code/lib/dd-generic.lib'

    # absolute path to library; need to use bats variable to work around
    # bats copying test files to temp folder and relative folder don't work:
    # https://github.com/bats-core/bats-core#special-variables
    path_to_library="${BATS_TEST_DIRNAME}/${path_to_proj_root}/${path_to_lut}"

    # NOTE: this only tests if library can be sourced;
    # functions are only defined in "$(...)" subshell,
    # so a second source for use in here is required
    # https://github.com/koalaman/shellcheck/wiki/SC1090
    # shellcheck disable=SC1090
    if ! output="$(source "${path_to_library}" 2>&1)"
    then
        echo "${output}"
        return 1
    fi

    # shellcheck disable=SC1090
    source "${path_to_library}"

    return 0
}

# https://github.com/bats-core/bats-core#run-test-other-commands
@test "invoking extend_path without arguments fails and prints an error" {

  run extend_path

  # shellcheck disable=SC2154
  [ "${status}" -eq 1 ]
  # shellcheck disable=SC2154
  [ "${lines[0]}" = 'verify required executables are available in PATH:' ]
  [ "${lines[1]}" = 'ERROR: wrong number of arguments' ]
  [ "${lines[2]}" = 'usage: extend_path "<required tools>" "<paths>"' ]
}
