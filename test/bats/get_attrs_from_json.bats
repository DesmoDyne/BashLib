#!/usr/bin/env bats

# get_attrs_from_json.bats
#
# bats unit tests for get_attrs_from_json function from dd-bash-lib.sh
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

    # first line: function under test prints this if successful
    line_01='get attributes from JSON:'

    # second line: function under test prints this if successful
    line_02='verify input string is valid JSON: OK'

    # third line: function under test prints this if successful
    line_03='extract mandatory attributes from JSON string: OK'

    # fourth line: function under test prints this if successful
    line_04='extract optional attributes from JSON string: OK'

    # error message 1
    err_msg_1='ERROR: wrong number of arguments'

    # error message 2
    err_msg_2='verify input string is valid JSON: ERROR'

    # error message 3
    err_msg_3='ERROR: <attrs> argument is not an array'

    # error message 4
    err_msg_4='ERROR: <opt_attrs> argument is not an array'

    # error message 5
    err_msg_5='extract mandatory attributes from JSON string: ERROR'

    # last error line: printed after error message
    last_err='please see function code for usage and sample code'

    # sample json 01
    json_01='{ "key_01": "value 01" }'

    # sample json 02
    json_02='{ "key_01": "value 01", "key_02": "value 02", "key_03": "value 03" }'

    # shellcheck disable=SC1090
    if output="$(source "${path_to_library}" 2>&1)"
    then
        source "${path_to_library}"
    else
        echo "${output}"
        return 1
    fi

    return 0
}


# ------------------------------------------------------------------------------
# test wrong number of arguments

@test '#01    - get_attrs_from_json without arguments fails, prints an error' {

  run get_attrs_from_json

  # NOTE: this is only displayed if test fails
  echo
  echo 'expected output:'$'\n'"${err_msg_1}"
  echo
  echo 'actual output:'$'\n'"${output}"

  [ "${status}" -eq 1 ]
  [ "${output}" = "${err_msg_1}"$'\n'"${last_err}" ]
}

@test '#02    - get_attrs_from_json with one argument fails, prints an error' {

  run get_attrs_from_json 'first_arg'

  [ "${status}" -eq 1 ]
  [ "${output}" = "${err_msg_1}"$'\n'"${last_err}" ]
}

@test '#03    - get_attrs_from_json with four arguments fails, prints an error' {

  run get_attrs_from_json 'first_arg' 'second_arg' 'third_arg' 'fourth_arg'

  [ "${status}" -eq 1 ]
  [ "${output}" = "${err_msg_1}"$'\n'"${last_err}" ]
}

# ------------------------------------------------------------------------------
# test invalid JSON as first argument

@test '#04    - get_attrs_from_json with invalid JSON as first argument fails, prints an error' {

  run get_attrs_from_json '{ "key": ' 'second_arg' 'third_arg'

  # NOTE: jq error message on invalid JSON varies depending on what is invalid

  [ "${status}" -eq 1 ]
  [[ "${output}" =~ "${err_msg_2}"$'\n'.* ]]
}

# ------------------------------------------------------------------------------
# test wrong type of second argument

@test '#05/01 - get_attrs_from_json with string as second argument fails, prints an error' {

  run get_attrs_from_json "${json_01}" 'second_arg' 'third_arg'

  [ "${status}" -eq 1 ]
  [ "${output}" = "${err_msg_3}"$'\n'"${last_err}" ]
}

@test '#05/02 - get_attrs_from_json with string as second argument fails, prints an error with elevated log level' {

  set_log_level INFO

  run get_attrs_from_json "${json_01}" 'second_arg' 'third_arg'

  set_log_level WARNING

  [ "${status}" -eq 1 ]
  [ "${output}" = "${line_01}"$'\n'"${line_02}"$'\n'"${err_msg_3}"$'\n'"${last_err}" ]
}

@test '#06/01 - get_attrs_from_json with integer as second argument fails, prints an error' {

  run get_attrs_from_json "${json_01}" 42 'third_arg'

  [ "${status}" -eq 1 ]
  [ "${output}" = "${err_msg_3}"$'\n'"${last_err}" ]
}

@test '#06/02 - get_attrs_from_json with integer as second argument fails, prints an error with elevated log level' {

  set_log_level INFO

  run get_attrs_from_json "${json_01}" 42 'third_arg'

  set_log_level WARNING

  [ "${status}" -eq 1 ]
  [ "${output}" = "${line_01}"$'\n'"${line_02}"$'\n'"${err_msg_3}"$'\n'"${last_err}" ]
}

@test '#07/01 - get_attrs_from_json with float as second argument fails, prints an error' {

  run get_attrs_from_json "${json_01}" 42.23 'third_arg'

  [ "${status}" -eq 1 ]
  [ "${output}" = "${err_msg_3}"$'\n'"${last_err}" ]
}

@test '#07/02 - get_attrs_from_json with float as second argument fails, prints an error with elevated log level' {

  set_log_level INFO

  run get_attrs_from_json "${json_01}" 42.23 'third_arg'

  set_log_level WARNING

  [ "${status}" -eq 1 ]
  [ "${output}" = "${line_01}"$'\n'"${line_02}"$'\n'"${err_msg_3}"$'\n'"${last_err}" ]
}

# ------------------------------------------------------------------------------
# test wrong type of third argument

@test '#08/01 - get_attrs_from_json with string as third argument fails, prints an error' {

  attrs=()

  run get_attrs_from_json "${json_01}" attrs 'third_arg'

  [ "${status}" -eq 1 ]
  [ "${output}" = "${err_msg_4}"$'\n'"${last_err}" ]
}

@test '#08/02 - get_attrs_from_json with string as third argument fails, prints an error with elevated log level' {

  attrs=()

  set_log_level INFO

  run get_attrs_from_json "${json_01}" attrs 'third_arg'

  set_log_level WARNING

  [ "${status}" -eq 1 ]
  [ "${output}" = "${line_01}"$'\n'"${line_02}"$'\n'"${err_msg_4}"$'\n'"${last_err}" ]
}

@test '#09/01 - get_attrs_from_json with integer as third argument fails, prints an error' {

  attrs=()

  run get_attrs_from_json "${json_01}" attrs 42

  [ "${status}" -eq 1 ]
  [ "${output}" = "${err_msg_4}"$'\n'"${last_err}" ]
}

@test '#09/02 - get_attrs_from_json with integer as third argument fails, prints an error with elevated log level' {

  attrs=()

  set_log_level INFO

  run get_attrs_from_json "${json_01}" attrs 42

  set_log_level WARNING

  [ "${status}" -eq 1 ]
  [ "${output}" = "${line_01}"$'\n'"${line_02}"$'\n'"${err_msg_4}"$'\n'"${last_err}" ]
}

@test '#10/01 - get_attrs_from_json with float as third argument fails, prints an error' {

  attrs=()

  run get_attrs_from_json "${json_01}" attrs 42.23

  [ "${status}" -eq 1 ]
  [ "${output}" = "${err_msg_4}"$'\n'"${last_err}" ]
}

@test '#10/02 - get_attrs_from_json with float as third argument fails, prints an error with elevated log level' {

  attrs=()

  set_log_level INFO

  run get_attrs_from_json "${json_01}" attrs 42.23

  set_log_level WARNING

  [ "${status}" -eq 1 ]
  [ "${output}" = "${line_01}"$'\n'"${line_02}"$'\n'"${err_msg_4}"$'\n'"${last_err}" ]
}


# TODO: test non-strings in array as second and third argument
# TODO: test not passing opt attrs as thrid argument


# ------------------------------------------------------------------------------
# test actual actual function behavior

@test '#11/01 - get_attrs_from_json with empty arguments succeeds, prints nothing' {

  # NOTE: empty string is not recognized
  # as function argument, so use single space
  json=' '
  attrs=()
  opt_attrs=()

  run get_attrs_from_json "${json}" attrs opt_attrs

  [ "${status}" -eq 0 ]
  [ "${output}" = '' ]
}

@test '#11/02 - get_attrs_from_json with empty arguments succeeds, prints expected output with elevated log level' {

  # NOTE: empty string is not recognized
  # as function argument, so use single space
  json=' '
  attrs=()
  opt_attrs=()

  set_log_level INFO

  run get_attrs_from_json "${json}" attrs opt_attrs

  set_log_level WARNING

  [ "${status}" -eq 0 ]
  [ "${output}" = "${line_01}"$'\n'"${line_02}"$'\n'"${line_03}"$'\n'"${line_04}" ]
}

@test '#12/01 - get_attrs_from_json with two valid arguments succeeds, prints nothing' {

  attrs=('key_01' 'key_02')

  run get_attrs_from_json "${json_02}" attrs

  [ "${status}" -eq 0 ]
  [ "${output}" = '' ]
}

@test '#12/02 - get_attrs_from_json with two valid arguments succeeds, prints expected output with elevated log level' {

  attrs=('key_01' 'key_02')

  set_log_level INFO

  run get_attrs_from_json "${json_02}" attrs

  set_log_level WARNING

  [ "${status}" -eq 0 ]
  [ "${output}" = "${line_01}"$'\n'"${line_02}"$'\n'"${line_03}" ]
}

@test '#13/01 - get_attrs_from_json with three valid arguments succeeds, prints nothing' {

  attrs=('key_01' 'key_02')
  opt_attrs=('key_03')

  run get_attrs_from_json "${json_02}" attrs opt_attrs

  [ "${status}" -eq 0 ]
  [ "${output}" = '' ]
}

@test '#13/02 - get_attrs_from_json with three valid arguments succeeds, prints expected output with elevated log level' {

  attrs=('key_01' 'key_02')
  opt_attrs=('key_03')

  set_log_level INFO

  run get_attrs_from_json "${json_02}" attrs opt_attrs

  set_log_level WARNING

  [ "${status}" -eq 0 ]
  [ "${output}" = "${line_01}"$'\n'"${line_02}"$'\n'"${line_03}"$'\n'"${line_04}" ]
}

@test '#14    - get_attrs_from_json with two valid arguments succeeds, sets variables' {

  attrs=('key_01' 'key_02')

  # NOTE: no 'run'
  get_attrs_from_json "${json_02}" attrs

  # shellcheck disable=SC2154
  [ "${key_01}" = 'value 01' ]
  # shellcheck disable=SC2154
  [ "${key_02}" = 'value 02' ]
}

@test '#15    - get_attrs_from_json with three valid arguments succeeds, sets variables' {

  attrs=('key_01' 'key_02')
  opt_attrs=('key_03')

  get_attrs_from_json "${json_02}" attrs opt_attrs

  [ "${key_01}" = 'value 01' ]
  [ "${key_02}" = 'value 02' ]
  # shellcheck disable=SC2154
  [ "${key_03}" = 'value 03' ]
}

@test '#16/01 - get_attrs_from_json with missing attribute fails, prints expected output' {

  # TODO: why does shellcheck report these here, but not above ?

  # shellcheck disable=SC2034
  attrs=('key_01' 'key_04')
  # shellcheck disable=SC2034
  opt_attrs=('key_03')

  run get_attrs_from_json "${json_02}" attrs opt_attrs

  err_msg='Failed to get key_04 attribute from JSON string'

  # NOTE: this is only displayed if test fails
  echo
  echo 'expected output:'$'\n'"${err_msg_5}"$'\n'"${err_msg}"
  echo
  echo 'actual output:'$'\n'"${output}"

  [ "${status}" -eq 1 ]
  [ "${output}" = "${err_msg_5}"$'\n'"${err_msg}" ]
}

@test '#16/02 - get_attrs_from_json with missing attribute fails, prints expected output with elevated log level' {

  attrs=('key_01' 'key_04')
  opt_attrs=('key_03')

  set_log_level INFO

  run get_attrs_from_json "${json_02}" attrs opt_attrs

  set_log_level WARNING

  err_msg='Failed to get key_04 attribute from JSON string'

  [ "${status}" -eq 1 ]
  [ "${output}" = "${line_01}"$'\n'"${line_02}"$'\n'"${err_msg_5}"$'\n'"${err_msg}" ]
}
