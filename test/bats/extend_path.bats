#!/usr/bin/env bats

# extend_path.bats
#
# bats unit tests for extend_path function from dd-bash-lib.sh
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

# NOTE: all bats files are copied to a temporary folder and are run from there
# (for "isolation"); therefore, relative paths often don't work as expected;
# in these cases, bats typically fails with error code 127 and messages like
#   /usr/local/Cellar/bats-core/1.1.0/libexec/bats-core/bats-exec-test:
#   line 52: <some command>: command not found
# or
#    ✗ invoking extend_path without arguments fails and prints an error
#      (from function `setup' in test file test/bats/extend_path.bats, line 64)
#        `source "${PATH_TO_LUT}/dd-bash-lib.sh"' failed
#      /var/folders/b3/gvjf33sx3xdfb8jblyp3jy680000gp/T/bats.61788.src: ...
#    ... line 64: <some file>: No such file or directory
# or
#    ✗ invoking extend_path without arguments fails and prints an error
#      (in test file extend_path.bats, line 62)
#        `[ "${status}" -eq 1 ]' failed with status 127
#
#   1 test, 1 failure
# and is less than helpful in diagnosing this issue; as a means to debug,
# display error message using e.g. echo "output: ${output}" after the test

# NOTE: it is CRUCIAL to be aware of how 'run' works in bats:
#  1. if the function under test (FUT) is called WITHOUT run and fails
#     (i.e. returns 1), a failure is reported immediately (e.g. '`extend_path'
#     failed' in bats output) and the test is aborted, i.e. no further code
#     in the test function after the call to the FUT ever executed; bats
#     variables such as status, output and lines are not available; however,
#     the function output to stderr or stdout is displayed in bats output;
#     TODO: verify output to stdout is indeed printed
#     this can be especially confusing when trying to `echo 'test' >&3` after
#     the call to the FUT as that output never shows up in the bats output
#  2. if the function under test is called WITH run, the function is executed
#     in a subshell and status, output and lines variables are set by bats:
#     https://github.com/bats-core/bats-core/pull/146/ ...
#      ... commits/c5e2404dde9b15b73c510d20bc657800bdec9c0b
#     no matter if the FUT fails or succeeds, test execution carries on until
#     for example a test such as [ "${status}" -eq 0 ] fails, which is then
#     displayed in bats output as a failed test;
#     due to the FUT being called in a subshell, 'run' can not be used when
#     testing changes by the FUT to global variables (such as e.g. PATH) as
#     those changes only become effective in the subshell and not in the test
#
# as a consequence, pairs of two tests are used in here, one testing for the
# changing of PATH, one testing for regular success / failure and output
#
# from https://github.com/bats-core/bats-core#run-test-other-commands:
#   The $status variable contains the status code of the command, and the
#   $output variable contains the combined contents of the command's standard
#   output and standard error streams. A third special variable, the $lines
#   array, is available for easily accessing individual lines of output.
# on a sidenote: from a test's perspective, these variables just pop
# into existence, so shellcheck reports them as SC2154 warnings:
#   https://github.com/koalaman/shellcheck/wiki/SC2154)
#
# TODO: add the above to bats-core doc: https://github.com/bats-core/bats-core

# NOTE: to run these tests without installing bats, use a Docker container, e.g.
#   $ cd <BashLib project root, e.g. ~/DevBase/DesmoDyne/Tools/BashLib>
#   $ docker run --interactive                  \
#                --name BashLib_Test            \
#                --tty                          \
#                --volume "$(pwd):/opt/BashLib" \
#                bats/bats:latest               \
#                /opt/BashLib/test/bats
#         ... <test output> ...
#   # shorter form:
#   $ docker run -it -v "$(pwd):/opt/BashLib" --name BashLib_Test \
#       bats/bats:latest /opt/BashLib/test/bats
#         ... <test output> ...
#   $ docker rm BashLib_Test

# TODO: create issue at github.com / bats-core: setup / teardown sample code ?
# TODO: if two tests have the same text and the second fails,
#       both are reported as failures, even though the first succeeds
# TODO: shellcheck parsing is severely messed up in here
# TODO: permutate over all possible combinations of input arguments ?
# TODO: pre-define variables often used in tests in setup function
# TODO: in all bats tests, make use of lines in addition to output


function setup
{
    # path from this script to project root
    path_to_proj_root='../..'

    # path to library with functions under test, relative to project root
    path_to_lut='code/lib/dd-bash-lib.sh'

    # absolute path to library; need to use bats variable to work around
    # bats copying test files to temp folder and relative folder don't work:
    # https://github.com/bats-core/bats-core#special-variables
    path_to_library="${BATS_TEST_DIRNAME}/${path_to_proj_root}/${path_to_lut}"

    # last line: printed after error message
    last_line='please see function code for usage and sample code'

    # error message 1
    err_msg_1='ERROR: wrong number of arguments'

    # error message 2
    err_msg_2='ERROR: <req_tools> argument is not an array'

    # error message 3
    err_msg_3='ERROR: <ext_paths> argument is not an array'

    # https://github.com/koalaman/shellcheck/wiki/SC2115

    # test folder 1
    folder_1="${BATS_TMPDIR:?}/folder_1"

    # test folder 2
    folder_2="${BATS_TMPDIR:?}/folder_2"

    # test folder 3
    folder_3="${BATS_TMPDIR:?}/folder_3"

    # test tool 1 in folder 1
    tool_11='tool_11'

    # test tool 2 in folder 1
    tool_12='tool_12'

    # test tool 1 in folder 2
    tool_21='tool_21'

    # NOTE: this only tests if library can be sourced;
    # functions are only defined in "$(...)" subshell,
    # so a second source for use in here is required
    # https://github.com/koalaman/shellcheck/wiki/SC1090
    # shellcheck disable=SC1090
    if output="$(source "${path_to_library}" 2>&1)"
    then
        # shellcheck disable=SC1090
        source "${path_to_library}"
    else
        echo "${output}"
        return 1
    fi

    # create test environment

    if ! output="$(mkdir "${folder_1}" "${folder_2}" "${folder_3}" 2>&1)"
    then
        echo "${output}"
        return 1
    fi

    # TODO: use shorter code
    # TODO: I think this only redirects error messages from last command
    if ! output="$(touch     "${folder_1}/${tool_11}" && \
                   chmod a+x "${folder_1}/${tool_11}" && \
                   touch     "${folder_1}/${tool_12}" && \
                   chmod a+x "${folder_1}/${tool_12}" && \
                   touch     "${folder_2}/${tool_21}" && \
                   chmod a+x "${folder_2}/${tool_21}" 2>&1)"
    then
        echo "${output}"
        return 1
    fi

    return 0
}

function teardown
{
    # destroy test environment
    if ! output="$(rm -r "${folder_1}" "${folder_2}" "${folder_3}" 2>&1)"
    then
        echo "${output}"
        return 1
    fi

    # TODO: unset variables defined in setup function ?

    return 0
}


# NOTE: testing if PATH was changed is not possible when using 'run', see above

# ------------------------------------------------------------------------------
# test wrong number of arguments

@test '#01 - extend_path without arguments fails, prints an error' {

  run extend_path

  [ "${status}" -eq 1 ]
  [ "${output}" = "${err_msg_1}"$'\n'"${last_line}" ]
}

@test '#02 - extend_path with one argument fails, prints an error' {

  run extend_path 'first_arg'

  [ "${status}" -eq 1 ]
  [ "${output}" = "${err_msg_1}"$'\n'"${last_line}" ]
}

@test '#03 - extend_path with three arguments fails, prints an error' {

  run extend_path 'first_arg' 'second_arg' 'third_arg'

  [ "${status}" -eq 1 ]
  [ "${output}" = "${err_msg_1}"$'\n'"${last_line}" ]
}

# ------------------------------------------------------------------------------
# test wrong type of first argument

@test '#04 - extend_path with string as first argument fails, prints an error' {

  run extend_path 'first_arg' 'second_arg'

  [ "${status}" -eq 1 ]
  [ "${output}" = "${err_msg_2}"$'\n'"${last_line}" ]
}

@test '#05 - extend_path with integer as first argument fails, prints an error' {

  run extend_path 42 'second_arg'

  [ "${status}" -eq 1 ]
  [ "${output}" = "${err_msg_2}"$'\n'"${last_line}" ]
}

@test '#06 - extend_path with float as first argument fails, prints an error' {

  run extend_path 42.23 'second_arg'

  [ "${status}" -eq 1 ]
  [ "${output}" = "${err_msg_2}"$'\n'"${last_line}" ]
}

# ------------------------------------------------------------------------------
# test wrong type of second argument

@test '#07 - extend_path with string as second argument fails, prints an error' {

  req_tools=()

  run extend_path req_tools 'second_arg'

  [ "${status}" -eq 1 ]
  [ "${output}" = "${err_msg_3}"$'\n'"${last_line}" ]
}

@test '#08 - extend_path with integer as second argument fails, prints an error' {

  req_tools=()

  run extend_path req_tools 42

  [ "${status}" -eq 1 ]
  [ "${output}" = "${err_msg_3}"$'\n'"${last_line}" ]
}

@test '#09 - extend_path with float as second argument fails, prints an error' {

  req_tools=()

  run extend_path req_tools 42.23

  [ "${status}" -eq 1 ]
  [ "${output}" = "${err_msg_3}"$'\n'"${last_line}" ]
}

# ------------------------------------------------------------------------------
# test actual actual function behavior

# NOTE: not using 'run' so change to PATH can be tested, see above

@test '#10 - extend_path with two empty array arguments succeeds, does not change PATH' {

  req_tools=()
  ext_paths=()

  path_before="${PATH}"
  extend_path req_tools ext_paths

  # NOTE: success of the above line is tested implicitly here: if it had failed,
  # this test function would be aborted, no further test code would be executed
  # and the path of execution would never reach any of the lines below

  path_after="${PATH}"

  [ "${path_before}" = "${path_after}" ]
}

@test '#11 - extend_path with two empty array arguments succeeds, prints expected output' {

  req_tools=()
  ext_paths=()

  run extend_path req_tools ext_paths

  [ "${status}" -eq 0 ]
  [ "${output}" = "${first_line}" ]
}

@test '#12 - extend_path with two empty array arguments (alternate notation) succeeds, does not change PATH' {

  declare -a req_tools=()
  declare -a ext_paths=()

  path_before="${PATH}"
  extend_path req_tools ext_paths
  path_after="${PATH}"

  [ "${path_before}" = "${path_after}" ]
}

@test '#13 - extend_path with two empty array arguments (alternate notation) succeeds, prints expected output' {

  declare -a req_tools=()
  declare -a ext_paths=()

  run extend_path req_tools ext_paths

  [ "${status}" -eq 0 ]
  [ "${output}" = "${first_line}" ]
}

@test '#14 - extend_path with empty <req_tools> and any path in <ext_paths> succeeds, does not change PATH' {

  req_tools=()
  ext_paths=('this_path_is_not_used')

  path_before="${PATH}"
  extend_path req_tools ext_paths
  path_after="${PATH}"

  [ "${path_before}" = "${path_after}" ]
}

@test '#15 - extend_path with empty <req_tools> and any path in <ext_paths> succeeds, prints expected output' {

  req_tools=()
  ext_paths=('this_path_is_not_used')

  run extend_path req_tools ext_paths

  [ "${status}" -eq 0 ]
  [ "${output}" = "${first_line}" ]
}

# NOTE: with bats, it is not possible to test if PATH was changed if FUT fails

@test '#16 - extend_path with nonexistent tool and empty <ext_paths> fails' {

  req_tools=('this_tool_does_not_exist')
  ext_paths=()

  run extend_path req_tools ext_paths

  exp_line_2='  this_tool_does_not_exist: FAIL'

  [ "${status}" -eq 1 ]
  [ "${output}" = "${exp_line_2}" ]
}

@test '#17 - extend_path with nonexistent tool and nonexistent path prints folder warning, fails' {

  req_tools=('this_tool_does_not_exist')
  ext_paths=('this_path_does_not_exist')

  run extend_path req_tools ext_paths

  exp_line_2='  this_tool_does_not_exist: FAIL'
  exp_line_3='  WARNING: folder this_path_does_not_exist does not exist; skip'

  [ "${status}" -eq 1 ]
  [ "${output}" = "${exp_line_2}"$'\n'"${exp_line_3}" ]
}

@test '#18 - extend_path with nonexistent tool and path already in PATH prints path warning, fails' {

  # TODO: this assumes /usr/bin is already in PATH (safe enough for now)

  req_tools=('this_tool_does_not_exist')
  ext_paths=('/usr/bin')

  run extend_path req_tools ext_paths

  exp_line_2='  this_tool_does_not_exist: FAIL'
  exp_line_3='  WARNING: path /usr/bin is already in PATH; skip'

  [ "${status}" -eq 1 ]
  [ "${output}" = "${exp_line_2}"$'\n'"${exp_line_3}" ]
}

@test '#19 - extend_path with tool in (unchanged) PATH and empty <ext_paths> succeeds, does not change PATH' {

  # TODO: this assumes ls is in PATH (here and below, safe enough for now)

  req_tools=('ls')
  ext_paths=()

  path_before="${PATH}"
  extend_path req_tools ext_paths
  path_after="${PATH}"

  [ "${path_before}" = "${path_after}" ]
}

@test '#20 - extend_path with tool in (unchanged) PATH and empty <ext_paths> succeeds, prints expected output' {

  req_tools=('ls')
  ext_paths=()

  run extend_path req_tools ext_paths

  [ "${status}" -eq 0 ]
  [ "${output}" = '' ]
}

@test '#21 - extend_path with tool in (unchanged) PATH and path already in PATH succeeds, does not change PATH' {

  req_tools=('ls')
  ext_paths=('/usr/bin')

  path_before="${PATH}"
  extend_path req_tools ext_paths
  path_after="${PATH}"

  [ "${path_before}" = "${path_after}" ]
}

@test '#22 - extend_path with tool in (unchanged) PATH and path already in PATH succeeds, prints expected output' {

  req_tools=('ls')
  ext_paths=('/usr/bin')

  run extend_path req_tools ext_paths

  [ "${status}" -eq 0 ]
  [ "${output}" = '' ]
}

@test '#23 - extend_path with tool in (unchanged) PATH and any path succeeds, does not change PATH' {

  req_tools=('ls')
  ext_paths=('this_path_is_not_used')

  path_before="${PATH}"
  extend_path req_tools ext_paths
  path_after="${PATH}"

  [ "${path_before}" = "${path_after}" ]
}

@test '#24 - extend_path with tool in (unchanged) PATH and any path succeeds, prints expected output' {

  req_tools=('ls')
  ext_paths=('this_path_is_not_used')

  run extend_path req_tools ext_paths

  [ "${status}" -eq 0 ]
  [ "${output}" = '' ]
}

@test '#25 - extend_path with two tools in (unchanged) PATH and any path succeeds, does not change PATH' {

  req_tools=('cat' 'ls')
  ext_paths=('this_path_is_not_used')

  path_before="${PATH}"
  extend_path req_tools ext_paths
  path_after="${PATH}"

  [ "${path_before}" = "${path_after}" ]
}

@test '#26 - extend_path with two tools in (unchanged) PATH and any path succeeds, prints expected output' {

  req_tools=('cat' 'ls')
  ext_paths=('this_path_is_not_used')

  run extend_path req_tools ext_paths

  [ "${status}" -eq 0 ]
  [ "${output}" = '' ]
}

@test '#27 - extend_path with five tools in (unchanged) PATH and any path succeeds, does not change PATH' {

  req_tools=('cat' 'chmod' 'cp' 'date' 'ls')
  ext_paths=('this_path_is_not_used')

  path_before="${PATH}"
  extend_path req_tools ext_paths
  path_after="${PATH}"

  [ "${path_before}" = "${path_after}" ]
}

@test '#28 - extend_path with five tools in (unchanged) PATH and any path succeeds, prints expected output' {

  req_tools=('cat' 'chmod' 'cp' 'date' 'ls')
  ext_paths=('this_path_is_not_used')

  run extend_path req_tools ext_paths

  [ "${status}" -eq 0 ]

  [ "${output}" = '' ]
}

# TODO: also test 1, 2, 5 items in ext_paths ?

# ------------------------------------------------------------------------------

# NOTE: with bats, it is not possible to test if PATH was changed if FUT fails

@test '#29 - extend_path with nonexistent tool and existing path fails - CHANGE TO PATH CAN NOT BE TESTED' {

  req_tools=('this_tool_does_not_exist')
  # NOTE: defined in setup function
  ext_paths=("${folder_1}")

  run extend_path req_tools ext_paths

  exp_line_2='  this_tool_does_not_exist: FAIL'
  # NOTE: not used with default log level
  # exp_line_3="  append ${folder_1} to PATH and retry:"
  exp_line_4='  this_tool_does_not_exist: FAIL'

  [ "${status}" -eq 1 ]

  exp_out="${exp_line_2}"$'\n'"${exp_line_4}"

  [ "${output}" = "${exp_out}" ]
}

@test '#30 - extend_path with existing tool and existing path succeeds, changes PATH' {

  req_tools=("${tool_11}")
  ext_paths=("${folder_1}")

  path_before="${PATH}"
  extend_path req_tools ext_paths
  path_after="${PATH}"

  # printing cleanly (i.e. ungarbled) from within test function
  # works a lot better when running bats with --tap:
  # https://github.com/bats-core/bats-core#printing-to-the-terminal

  # echo "# path_before : ${path_before}" >&3
  # echo "# path_after  : ${path_after}"  >&3

  # NOTE: not using 'run', so output is not set
  # echo '# output:'$'\n'"${output}" >&3

  [ "${path_after}" = "${path_before}:${folder_1}" ]
}

@test '#31 - extend_path with existing tool and existing path succeeds, prints expected output' {

  req_tools=("${tool_11}")
  ext_paths=("${folder_1}")

  run extend_path req_tools ext_paths

  exp_line_2="  ${tool_11}: FAIL"

  [ "${status}" -eq 0 ]

  exp_out="${exp_line_2}"

  [ "${output}" = "${exp_out}" ]
}

@test '#32 - extend_path with two existing tools and existing path succeeds, changes PATH' {

  req_tools=("${tool_11}" "${tool_12}")
  ext_paths=("${folder_1}")

  path_before="${PATH}"
  extend_path req_tools ext_paths
  path_after="${PATH}"

  [ "${path_after}" = "${path_before}:${folder_1}" ]
}

@test '#33 - extend_path with two existing tools and existing path succeeds, prints expected output' {

  req_tools=("${tool_11}" "${tool_12}")
  ext_paths=("${folder_1}")

  run extend_path req_tools ext_paths

  # TODO: using read in here fails
  exp_line_2="  ${tool_11}: FAIL"
  exp_line_3="  ${tool_12}: FAIL"

  [ "${status}" -eq 0 ]

  exp_out="${exp_line_2}"$'\n'"${exp_line_3}"

  [ "${output}" = "${exp_out}" ]
}

@test '#34 - extend_path with two existing tools in two existing path succeeds, changes PATH' {

  req_tools=("${tool_11}" "${tool_21}")
  ext_paths=("${folder_1}" "${folder_2}")

  path_before="${PATH}"
  extend_path req_tools ext_paths
  path_after="${PATH}"

  [ "${path_after}" = "${path_before}:${folder_1}:${folder_2}" ]
}

@test '#35 - extend_path with two existing tools in two existing path succeeds, prints expected output' {

  # shellcheck disable=SC2034
  req_tools=("${tool_11}" "${tool_21}")
  # shellcheck disable=SC2034
  ext_paths=("${folder_1}" "${folder_2}")

  run extend_path req_tools ext_paths

  # TODO: using read in here fails
  exp_line_2="  ${tool_11}: FAIL"
  exp_line_3="  ${tool_21}: FAIL"
  exp_line_6="  ${tool_21}: FAIL"

  [ "${status}" -eq 0 ]

  exp_out="${exp_line_2}"$'\n'"${exp_line_3}"$'\n'"${exp_line_6}"

  [ "${output}" = "${exp_out}" ]
}
