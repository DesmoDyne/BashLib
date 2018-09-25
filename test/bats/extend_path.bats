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


# TODO: create issue at github.com / bats-core: setup / teardown sample code ?
# TODO: if two tests have the same text and the second fails,
#       both are reported as failures, even though the first succeeds
# TODO: shellcheck parsing is severely messed up in here


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

    # first line: function under test always prints this
    first_line='verify required executables are available in PATH:'

    # last line: printed after error message
    last_line='please see function code for usage and sample code'

    # error message 1
    # shellcheck disable=SC2034
    err_msg_1='ERROR: wrong number of arguments'

    # error message 2
    # shellcheck disable=SC2034
    err_msg_2='ERROR: <req_tools> argument is not an array'

    # error message 3
    # shellcheck disable=SC2034
    err_msg_3='ERROR: <ext_paths> argument is not an array'

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

# ------------------------------------------------------------------------------

# https://github.com/bats-core/bats-core#run-test-other-commands

@test 'extend_path without arguments fails, prints an error, does not change PATH' {

  path_before="${PATH}"
  run extend_path
  path_after="${PATH}"

  [ "${path_before}" = "${path_after}" ]

  # echo "expected:"
  # echo "${first_line}"$'\n'"${err_msg_1}"$'\n'"${last_line}"

  # echo "actual:"
  # echo "${output}"

  # shellcheck disable=SC2154
  [ "${status}" -eq 1 ]
  # shellcheck disable=SC2154
  [ "${output}" = "${first_line}"$'\n'"${err_msg_1}"$'\n'"${last_line}" ]
}

@test 'extend_path with one argument fails, prints an error, does not change PATH' {

  path_before="${PATH}"
  run extend_path 'first_arg'
  path_after="${PATH}"

  [ "${path_before}" = "${path_after}" ]

  # shellcheck disable=SC2154
  [ "${status}" -eq 1 ]
  # shellcheck disable=SC2154
  [ "${output}" = "${first_line}"$'\n'"${err_msg_1}"$'\n'"${last_line}" ]
}

@test 'extend_path with three arguments fails, prints an error, does not change PATH' {

  path_before="${PATH}"
  run extend_path 'first_arg' 'second_arg' 'third_arg'
  path_after="${PATH}"

  [ "${path_before}" = "${path_after}" ]

  # shellcheck disable=SC2154
  [ "${status}" -eq 1 ]
  # shellcheck disable=SC2154
  [ "${output}" = "${first_line}"$'\n'"${err_msg_1}"$'\n'"${last_line}" ]
}

# ------------------------------------------------------------------------------

@test 'extend_path with string as first argument fails, prints an error, does not change PATH' {

  path_before="${PATH}"
  run extend_path 'first_arg' 'second_arg'
  path_after="${PATH}"

  [ "${path_before}" = "${path_after}" ]

  # shellcheck disable=SC2154
  [ "${status}" -eq 1 ]
  # shellcheck disable=SC2154
  [ "${output}" = "${first_line}"$'\n'"${err_msg_2}"$'\n'"${last_line}" ]
}

@test 'extend_path with string as second argument fails, prints an error, does not change PATH' {

  req_tools2=()

  path_before="${PATH}"
  run extend_path req_tools2 'second_arg'
  path_after="${PATH}"

  [ "${path_before}" = "${path_after}" ]

  # shellcheck disable=SC2154
  [ "${status}" -eq 1 ]
  # shellcheck disable=SC2154
  [ "${output}" = "${first_line}"$'\n'"${err_msg_3}"$'\n'"${last_line}" ]
}

@test 'extend_path with integer as first argument fails, prints an error, does not change PATH' {

  path_before="${PATH}"
  run extend_path 42 'second_arg'
  path_after="${PATH}"

  [ "${path_before}" = "${path_after}" ]

  # shellcheck disable=SC2154
  [ "${status}" -eq 1 ]
  # shellcheck disable=SC2154
  [ "${output}" = "${first_line}"$'\n'"${err_msg_2}"$'\n'"${last_line}" ]
}

@test 'extend_path with integer as second argument fails, prints an error, does not change PATH' {

  req_tools=()

  path_before="${PATH}"
  run extend_path req_tools 42
  path_after="${PATH}"

  [ "${path_before}" = "${path_after}" ]

  # shellcheck disable=SC2154
  [ "${status}" -eq 1 ]
  # shellcheck disable=SC2154
  [ "${output}" = "${first_line}"$'\n'"${err_msg_3}"$'\n'"${last_line}" ]
}

@test 'extend_path with float as first argument fails, prints an error, does not change PATH' {

  path_before="${PATH}"
  run extend_path 42.23 'second_arg'
  path_after="${PATH}"

  [ "${path_before}" = "${path_after}" ]

  # shellcheck disable=SC2154
  [ "${status}" -eq 1 ]
  # shellcheck disable=SC2154
  [ "${output}" = "${first_line}"$'\n'"${err_msg_2}"$'\n'"${last_line}" ]
}

@test 'extend_path with float as second argument fails, prints an error, does not change PATH' {

  req_tools=()

  path_before="${PATH}"
  run extend_path req_tools 42.23
  path_after="${PATH}"

  [ "${path_before}" = "${path_after}" ]

  # shellcheck disable=SC2154
  [ "${status}" -eq 1 ]
  # shellcheck disable=SC2154
  [ "${output}" = "${first_line}"$'\n'"${err_msg_3}"$'\n'"${last_line}" ]
}

# ------------------------------------------------------------------------------

@test 'extend_path with two empty array arguments succeeds, does not change PATH' {

  req_tools=()
  ext_paths=()

  path_before="${PATH}"
  run extend_path req_tools ext_paths
  path_after="${PATH}"

  [ "${path_before}" = "${path_after}" ]

  # shellcheck disable=SC2154
  [ "${status}" -eq 0 ]
  # shellcheck disable=SC2154
  [ "${output}" = "${first_line}" ]
}

@test 'extend_path with two empty array arguments (alternate notation) succeeds, does not change PATH' {

  declare -a req_tools=()
  declare -a ext_paths=()

  path_before="${PATH}"
  run extend_path req_tools ext_paths
  path_after="${PATH}"

  [ "${path_before}" = "${path_after}" ]

  # shellcheck disable=SC2154
  [ "${status}" -eq 0 ]
  # shellcheck disable=SC2154
  [ "${output}" = "${first_line}" ]
}

@test 'extend_path with empty <req_tools> and any path in <ext_paths> succeeds, does not change PATH' {

  req_tools=()
  ext_paths=('this_path_is_not_used')

  path_before="${PATH}"
  run extend_path req_tools ext_paths
  path_after="${PATH}"

  [ "${path_before}" = "${path_after}" ]

  # shellcheck disable=SC2154
  [ "${status}" -eq 0 ]
  # shellcheck disable=SC2154
  [ "${output}" = "${first_line}" ]
}

@test 'extend_path with nonexistent tool and empty <ext_paths> fails, does not change PATH' {

  req_tools=('this_tool_does_not_exist')
  ext_paths=()

  path_before="${PATH}"
  run extend_path req_tools ext_paths
  path_after="${PATH}"

  exp_line_2='  this_tool_does_not_exist: FAIL'

  [ "${path_before}" = "${path_after}" ]

  # shellcheck disable=SC2154
  [ "${status}" -eq 1 ]
  # shellcheck disable=SC2154
  [ "${output}" = "${first_line}"$'\n'"${exp_line_2}" ]
}

@test 'extend_path with existent tool and empty <ext_paths> succeeds, does not change PATH' {

  req_tools=('ls')
  ext_paths=()

  path_before="${PATH}"
  run extend_path req_tools ext_paths
  path_after="${PATH}"

  exp_line_2='  ls: OK'

  [ "${path_before}" = "${path_after}" ]

  # shellcheck disable=SC2154
  [ "${status}" -eq 0 ]
  # shellcheck disable=SC2154
  [ "${output}" = "${first_line}"$'\n'"${exp_line_2}" ]
}

@test 'extend_path with existent tool in PATH and any path in <ext_paths> succeeds, does not change PATH' {

  req_tools=('ls')
  ext_paths=('this_path_is_not_used')

  path_before="${PATH}"
  run extend_path req_tools ext_paths
  path_after="${PATH}"

  exp_line_2='  ls: OK'

  [ "${path_before}" = "${path_after}" ]

  # shellcheck disable=SC2154
  [ "${status}" -eq 0 ]
  # shellcheck disable=SC2154
  [ "${output}" = "${first_line}"$'\n'"${exp_line_2}" ]
}
