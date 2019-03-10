#!/usr/bin/env bats

# proc_cmd_line_args.bats
#
# bats unit tests for proc_cmd_line_args function from bashlib.sh
#
# author  : stefan schablowski
# contact : stefan.schablowski@desmodyne.com
# created : 2018-10-03


# NOTE: see also extend_path.bats


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

    # test file 1
    # shellcheck disable=SC2034
    file_1="${BATS_TMPDIR:?}/file_1"

    # test file 2
    # shellcheck disable=SC2034
    file_2="${BATS_TMPDIR:?}/file_2"

    # test folder 1
    # shellcheck disable=SC2034
    folder_1="${BATS_TMPDIR:?}/folder_1"

    # function output with bats executable
    # NOTE: bats does not seem to allow heredocs using e.g.
    # read -r -d '' err_msg << EOT
    #   ... (variable multi-line contents)
    #EOT

    err_msg_1='process command line arguments: ERROR'$'\n'
    err_msg_1+='wrong number of arguments'$'\n'
    err_msg_1+=$'\n'
    err_msg_1+='Usage: bats-exec-test <config file>'$'\n'
    err_msg_1+=$'\n'
    err_msg_1+='mandatory arguments:'$'\n'
    err_msg_1+='  config file           absolute path to configuration file'$'\n'
    err_msg_1+=$'\n'
    err_msg_1+='optional arguments:'$'\n'
    err_msg_1+='  -?, --help            print this help message'

    # create test environment

    if ! output="$(mkdir "${folder_1}" 2>&1)"
    then
        echo "${output}"
        return 1
    fi

    if ! output="$(touch     "${file_1}" 2>&1 && \
                   chmod a-r "${file_1}" 2>&1 && \
                   touch     "${file_2}" 2>&1)"
    then
        echo "${output}"
        return 1
    fi

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

function teardown
{
    # destroy test environment
    if ! output="$(rm -r "${folder_1}" "${file_1}" "${file_2}" 2>&1)"
    then
        echo "${output}"
        return 1
    fi

    # TODO: unset variables defined in setup function ?

    return 0
}

# ------------------------------------------------------------------------------
# test wrong number of arguments

@test '#01 - proc_cmd_line_args without arguments fails, prints an error' {

  run proc_cmd_line_args

  # NOTE: this is only displayed if test fails
  echo
  echo 'expected output:'$'\n'"${err_msg_1}"
  echo
  echo 'actual output:'$'\n'"${output}"

  # shellcheck disable=SC2154
  [ "${status}" -eq 1 ]
  # shellcheck disable=SC2154
  [ "${output}" = "${err_msg_1}" ]
}

@test '#02 - proc_cmd_line_args with two arguments fails, prints an error' {

  run proc_cmd_line_args 'first_arg' 'second_arg'

  # shellcheck disable=SC2154
  [ "${status}" -eq 1 ]
  # shellcheck disable=SC2154
  [ "${output}" = "${err_msg_1}" ]
}

# ------------------------------------------------------------------------------
# test actual actual function behavior

@test '#03 - proc_cmd_line_args with empty path fails, prints an error' {

  run proc_cmd_line_args ''

  # shellcheck disable=SC2154
  [ "${status}" -eq 1 ]
  # shellcheck disable=SC2154
  [ "${output}" = "${err_msg_1}" ]
}

@test '#04 - proc_cmd_line_args with nonexistent path fails, prints an error' {

  run proc_cmd_line_args 'this_path_does_not_exist'

  exp_out='process command line arguments: ERROR'$'\n'
  exp_out+='this_path_does_not_exist: Path not found'

  # shellcheck disable=SC2154
  [ "${status}" -eq 1 ]
  # shellcheck disable=SC2154
  [ "${output}" = "${exp_out}" ]
}

@test '#05 - proc_cmd_line_args with unreadable file fails, prints an error' {

  run proc_cmd_line_args "${file_1}"

  exp_out='process command line arguments: ERROR'$'\n'
  exp_out+="${file_1}: File is not readable"

  # shellcheck disable=SC2154
  [ "${status}" -eq 1 ]
  # shellcheck disable=SC2154
  [ "${output}" = "${exp_out}" ]
}

@test '#06 - proc_cmd_line_args with folder path fails, prints an error' {

  run proc_cmd_line_args "${folder_1}"

  exp_out='process command line arguments: ERROR'$'\n'
  exp_out+="${folder_1}: Path is not a file"

  # shellcheck disable=SC2154
  [ "${status}" -eq 1 ]
  # shellcheck disable=SC2154
  [ "${output}" = "${exp_out}" ]
}

@test '#07 - proc_cmd_line_args with valid file succeeds, prints expected output' {

  run proc_cmd_line_args "${file_2}"

  exp_out='process command line arguments: OK'

  # shellcheck disable=SC2154
  [ "${status}" -eq 0 ]
  # shellcheck disable=SC2154
  [ "${output}" = "${exp_out}" ]
}

# NOTE: see extend_path.bats on running tests with or without 'run'

@test '#08 - proc_cmd_line_args with valid file succeeds, sets conf_file global variable' {

  # make sure global variable is not already set
  # shellcheck disable=SC2154
  [ -z "${conf_file}" ]

  proc_cmd_line_args "${file_2}"

  # shellcheck disable=SC2154
  [ -n "${conf_file}" ]
}

@test '#09 - proc_cmd_line_args with valid file succeeds, sets conf_file to argument' {

  # shellcheck disable=SC2154
  [ -z "${conf_file}" ]

  proc_cmd_line_args "${file_2}"

  # shellcheck disable=SC2154
  [ "${conf_file}" = "${file_2}" ]
}
