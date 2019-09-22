#!/usr/bin/env bats

# get_conf_file_arg.bats
#
# bats unit tests for get_conf_file_arg function from dd-bash-lib.sh
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
    file_1="${BATS_TMPDIR:?}/file_1"

    # test file 2
    file_2="${BATS_TMPDIR:?}/file_2"

    # test folder 1
    folder_1="${BATS_TMPDIR:?}/folder_1"

    # function output with bats executable
    # NOTE: bats does not seem to allow heredocs using e.g.
    # read -r -d '' err_msg << EOT
    #   ... (variable multi-line contents)
    #EOT

    err_msg_1='get configuration file command line argument: ERROR'$'\n'
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
    if output="$(source "${path_to_library}" 2>&1)"
    then
        # shellcheck disable=SC1090
        source "${path_to_library}"
    else
        echo "${output}"
        return 1
    fi

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

@test '#01 - get_conf_file_arg without arguments fails, prints an error' {

  run get_conf_file_arg

  # NOTE: this is only displayed if test fails
  echo
  echo 'expected output:'$'\n'"${err_msg_1}"
  echo
  echo 'actual output:'$'\n'"${output}"

  [ "${status}" -eq 1 ]
  [ "${output}" = "${err_msg_1}" ]
}

@test '#02 - get_conf_file_arg with two arguments fails, prints an error' {

  run get_conf_file_arg 'first_arg' 'second_arg'

  [ "${status}" -eq 1 ]
  [ "${output}" = "${err_msg_1}" ]
}

# ------------------------------------------------------------------------------
# test actual actual function behavior

@test '#03 - get_conf_file_arg with empty path fails, prints an error' {

  run get_conf_file_arg ''

  [ "${status}" -eq 1 ]
  [ "${output}" = "${err_msg_1}" ]
}

@test '#04 - get_conf_file_arg with nonexistent path fails, prints an error' {

  run get_conf_file_arg 'this_path_does_not_exist'

  exp_out='get configuration file command line argument: ERROR'$'\n'
  exp_out+='this_path_does_not_exist: Path not found'

  [ "${status}" -eq 1 ]
  [ "${output}" = "${exp_out}" ]
}

@test '#05 - get_conf_file_arg with unreadable file fails, prints an error' {

  run get_conf_file_arg "${file_1}"

  exp_out='get configuration file command line argument: ERROR'$'\n'
  exp_out+="${file_1}: File is not readable"

  [ "${status}" -eq 1 ]
  [ "${output}" = "${exp_out}" ]
}

@test '#06 - get_conf_file_arg with folder path fails, prints an error' {

  run get_conf_file_arg "${folder_1}"

  exp_out='get configuration file command line argument: ERROR'$'\n'
  exp_out+="${folder_1}: Path is not a file"

  [ "${status}" -eq 1 ]
  [ "${output}" = "${exp_out}" ]
}

@test '#07 - get_conf_file_arg with valid file succeeds, prints expected output' {

  run get_conf_file_arg "${file_2}"

  exp_out='get configuration file command line argument: OK'

  [ "${status}" -eq 0 ]
  [ "${output}" = "${exp_out}" ]
}

# NOTE: see extend_path.bats on running tests with or without 'run'

@test '#08 - get_conf_file_arg with valid file succeeds, sets conf_file global variable' {

  # make sure global variable is not already set
  # shellcheck disable=SC2154
  [ -z "${conf_file}" ]

  get_conf_file_arg "${file_2}"

  [ -n "${conf_file}" ]
}

@test '#09 - get_conf_file_arg with valid file succeeds, sets conf_file to argument' {

  [ -z "${conf_file}" ]

  get_conf_file_arg "${file_2}"

  [ "${conf_file}" = "${file_2}" ]
}
