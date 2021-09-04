#!/usr/bin/env bats

# get_attrs_from_yaml_file.bats
#
# bats unit tests for get_attrs_from_yaml_file function from dd-bash-lib.sh
#
# author  : stefan schablowski
# contact : stefan.schablowski@desmodyne.com
# created : 2018-10-03


# NOTE: see also extend_path.bats
# NOTE: this somewhat duplicates get_attrs_from_json.bats


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
    line_01='load YAML file and convert to JSON: OK'

    # second line: function under test prints this if successful
    line_02='verify input string is valid JSON: OK'

    # third line: function under test prints this if successful
    line_03='extract mandatory attributes from JSON string: OK'

    # fourth line: function under test prints this if successful
    line_04='extract optional attributes from JSON string: OK'

    # error message 1
    err_msg_1='ERROR: wrong number of arguments'

    # error message 2
    err_msg_2='load YAML file and convert to JSON: ERROR'

    # error message 3
    err_msg_3='no such file or directory'

    # error message 4
    # TODO: this is no longer needed; not removing for now as that would
    # require re-numbering loads of error messages that follow this one
    # shellcheck disable=SC2034
    err_msg_4='input YAML file is empty'

    # error message 5
    err_msg_5='permission denied'

    # error message 6
    err_msg_6='Error: yaml: found character that cannot start any token'

    # error message 7
    err_msg_7='ERROR: <attrs> argument is not an array'

    # error message 8
    err_msg_8='ERROR: <opt_attrs> argument is not an array'

    # error message 9
    err_msg_9='extract mandatory attributes from JSON string: ERROR'

    # last error line: printed after error message
    last_err='please see function code for usage and sample code'

    # nonexistent test file
    non_exist_filename='does_not_exist.yaml'

    # empty test file
    empty_file="${BATS_TMPDIR:?}/empty_file.yaml"

    # non-readable test file
    write_only_file="${BATS_TMPDIR:?}/write_only_file.yaml"

    # invalid test file
    invalid_file="${BATS_TMPDIR:?}/invalid_file.yaml"

    # valid test file 01
    valid_file_01="${BATS_TMPDIR:?}/valid_file_01.yaml"

    # valid test file 02
    valid_file_02="${BATS_TMPDIR:?}/valid_file_02.yaml"

    # valid test file 03
    valid_file_03="${BATS_TMPDIR:?}/valid_file_03.yaml"

    # invalid sample yaml
    inv_yaml='@'

    # valid sample yaml 01
    yaml_01='---'

    # valid sample yaml 02
    yaml_02='key_01: value 01'

    # valid sample yaml 03
    yaml_03='---'$'\n''key_01: value 01'$'\n''key_02: value 02'$'\n''key_03: value 03'

    # expected output 01
    exp_out_01="${line_01}"$'\n'"${line_02}"$'\n'"${err_msg_7}"$'\n'"${last_err}"

    # expected output 02
    exp_out_02="${line_01}"$'\n'"${line_02}"$'\n'"${err_msg_8}"$'\n'"${last_err}"

    # expected output 03
    exp_out_03="${line_01}"$'\n'"${line_02}"$'\n'"${line_03}"

    # expected output 04
    exp_out_04="${line_01}"$'\n'"${line_02}"$'\n'"${line_03}"$'\n'"${line_04}"

    # shellcheck disable=SC1090
    if output="$(source "${path_to_library}" 2>&1)"
    then
        source "${path_to_library}"
    else
        echo "${output}"
        return 1
    fi

    # create test environment

    if ! output="$(touch     "${empty_file}"      && \
                   touch     "${write_only_file}" && \
                   chmod a-r "${write_only_file}" && \
                   echo "${inv_yaml}" > "${invalid_file}"  && \
                   echo "${yaml_01}"  > "${valid_file_01}" && \
                   echo "${yaml_02}"  > "${valid_file_02}" && \
                   echo "${yaml_03}"  > "${valid_file_03}")"
    then
        echo "${output}"
        return 1
    fi

    return 0
}

function teardown
{
    # destroy test environment
    if ! output="$(rm "${empty_file}"       \
                      "${write_only_file}"  \
                      "${invalid_file}"     \
                      "${valid_file_01}"    \
                      "${valid_file_02}" 2>&1)"
    then
        echo "${output}"
        return 1
    fi

    return 0
}


# ------------------------------------------------------------------------------
# test wrong number of arguments

@test '#01    - get_attrs_from_yaml_file without arguments fails, prints an error' {

  run get_attrs_from_yaml_file

  # NOTE: this is only displayed if test fails
  echo
  echo 'expected output:'$'\n'"${err_msg_1}"
  echo
  echo 'actual output:'$'\n'"${output}"

  [ "${status}" -eq 1 ]
  [ "${output}" = "${err_msg_1}"$'\n'"${last_err}" ]
}

@test '#02    - get_attrs_from_yaml_file with one argument fails, prints an error' {

  run get_attrs_from_yaml_file 'first_arg'

  [ "${status}" -eq 1 ]
  [ "${output}" = "${err_msg_1}"$'\n'"${last_err}" ]
}

@test '#03    - get_attrs_from_yaml_file with four arguments fails, prints an error' {

  run get_attrs_from_yaml_file 'first_arg' 'second_arg' 'third_arg' 'fourth_arg'

  [ "${status}" -eq 1 ]
  [ "${output}" = "${err_msg_1}"$'\n'"${last_err}" ]
}

# ------------------------------------------------------------------------------
# test invalid YAML file as first argument

@test '#04    - get_attrs_from_yaml_file with nonexistent YAML file as first argument fails, prints an error' {

  run get_attrs_from_yaml_file "${non_exist_filename}" 'second_arg' 'third_arg'

  [ "${status}" -eq 1 ]
  [ "${output}" = "${err_msg_2}"$'\n'"${non_exist_filename}: ${err_msg_3}" ]
}

@test '#05    - get_attrs_from_yaml_file with inaccessible YAML file as first argument fails, prints an error' {

  run get_attrs_from_yaml_file "${write_only_file}" 'second_arg' 'third_arg'

  [ "${status}" -eq 1 ]
  [ "${output}" = "${err_msg_2}"$'\n'"${write_only_file}: ${err_msg_5}" ]
}

@test '#06    - get_attrs_from_yaml_file with invalid YAML file as first argument fails, prints an error' {

  run get_attrs_from_yaml_file "${invalid_file}" 'second_arg' 'third_arg'

  [ "${status}" -eq 1 ]
  [ "${output}" = "${err_msg_2}"$'\n'"${err_msg_6}" ]
}


# ------------------------------------------------------------------------------
# test wrong type of second argument

@test '#07/01 - get_attrs_from_yaml_file with string as second argument fails, prints an error' {

  run get_attrs_from_yaml_file "${valid_file_01}" 'second_arg' 'third_arg'

  [ "${status}" -eq 1 ]
  [ "${output}" = "${err_msg_7}"$'\n'"${last_err}" ]
}

@test '#07/02 - get_attrs_from_yaml_file with string as second argument fails, prints an error with elevated log level' {

  set_log_level INFO

  run get_attrs_from_yaml_file "${valid_file_01}" 'second_arg' 'third_arg'

  set_log_level WARNING

  [ "${status}" -eq 1 ]
  [ "${output}" = "${exp_out_01}" ]
}

@test '#08/01 - get_attrs_from_yaml_file with integer as second argument fails, prints an error' {

  run get_attrs_from_yaml_file "${valid_file_01}" 42 'third_arg'

  [ "${status}" -eq 1 ]
  [ "${output}" = "${err_msg_7}"$'\n'"${last_err}" ]
}

@test '#08/02 - get_attrs_from_yaml_file with integer as second argument fails, prints an error with elevated log level' {

  set_log_level INFO

  run get_attrs_from_yaml_file "${valid_file_01}" 42 'third_arg'

  set_log_level WARNING

  [ "${status}" -eq 1 ]
  [ "${output}" = "${exp_out_01}" ]
}

@test '#09/01 - get_attrs_from_yaml_file with float as second argument fails, prints an error' {

  run get_attrs_from_yaml_file "${valid_file_01}" 42.23 'third_arg'

  [ "${status}" -eq 1 ]
  [ "${output}" = "${err_msg_7}"$'\n'"${last_err}" ]
}

@test '#09/02 - get_attrs_from_yaml_file with float as second argument fails, prints an error with elevated log level' {

  set_log_level INFO

  run get_attrs_from_yaml_file "${valid_file_01}" 42.23 'third_arg'

  set_log_level WARNING

  [ "${status}" -eq 1 ]
  [ "${output}" = "${exp_out_01}" ]
}

# ------------------------------------------------------------------------------
# test wrong type of third argument

@test '#10/01 - get_attrs_from_yaml_file with string as third argument fails, prints an error' {

  attrs=()

  run get_attrs_from_yaml_file "${valid_file_01}" attrs 'third_arg'

  [ "${status}" -eq 1 ]
  [ "${output}" = "${err_msg_8}"$'\n'"${last_err}" ]
}

@test '#10/02 - get_attrs_from_yaml_file with string as third argument fails, prints an error with elevated log level' {

  attrs=()

  set_log_level INFO

  run get_attrs_from_yaml_file "${valid_file_01}" attrs 'third_arg'

  set_log_level WARNING

  [ "${status}" -eq 1 ]
  [ "${output}" = "${exp_out_02}" ]
}

@test '#11/01 - get_attrs_from_yaml_file with integer as third argument fails, prints an error' {

  attrs=()

  run get_attrs_from_yaml_file "${valid_file_01}" attrs 42

  [ "${status}" -eq 1 ]
  [ "${output}" = "${err_msg_8}"$'\n'"${last_err}" ]
}

@test '#11/02 - get_attrs_from_yaml_file with integer as third argument fails, prints an error with elevated log level' {

  attrs=()

  set_log_level INFO

  run get_attrs_from_yaml_file "${valid_file_01}" attrs 42

  set_log_level WARNING

  [ "${status}" -eq 1 ]
  [ "${output}" = "${exp_out_02}" ]
}

@test '#12/01 - get_attrs_from_yaml_file with float as third argument fails, prints an error' {

  attrs=()

  run get_attrs_from_yaml_file "${valid_file_01}" attrs 42.23

  [ "${status}" -eq 1 ]
  [ "${output}" = "${err_msg_8}"$'\n'"${last_err}" ]
}

@test '#12/02 - get_attrs_from_yaml_file with float as third argument fails, prints an error with elevated log level' {

  attrs=()

  set_log_level INFO

  run get_attrs_from_yaml_file "${valid_file_01}" attrs 42.23

  set_log_level WARNING

  [ "${status}" -eq 1 ]
  [ "${output}" = "${exp_out_02}" ]
}

# ------------------------------------------------------------------------------
# test actual actual function behavior

@test '#13/01 - get_attrs_from_yaml_file with empty YAML file as first argument succeeds, prints nothing' {

  attrs=()
  opt_attrs=()

  run get_attrs_from_yaml_file "${empty_file}" attrs opt_attrs

  [ "${status}" -eq 0 ]
  [ "${output}" = '' ]
}

@test '#13/02 - get_attrs_from_yaml_file with empty YAML file as first argument succeeds, prints expected output with elevated log level' {

  attrs=()
  opt_attrs=()

  set_log_level INFO

  run get_attrs_from_yaml_file "${empty_file}" attrs opt_attrs

  set_log_level WARNING

  [ "${status}" -eq 0 ]
  [ "${output}" = "${exp_out_04}" ]
}

@test '#14/01 - get_attrs_from_yaml_file with empty arguments succeeds, prints nothing' {

  attrs=()
  opt_attrs=()

  run get_attrs_from_yaml_file "${valid_file_01}" attrs opt_attrs

  [ "${status}" -eq 0 ]
  [ "${output}" = '' ]
}

@test '#14/02 - get_attrs_from_yaml_file with empty arguments succeeds, prints expected output with elevated log level' {

  attrs=()
  opt_attrs=()

  set_log_level INFO

  run get_attrs_from_yaml_file "${valid_file_01}" attrs opt_attrs

  set_log_level WARNING

  [ "${status}" -eq 0 ]
  [ "${output}" = "${exp_out_04}" ]
}

@test '#15/01 - get_attrs_from_yaml_file with two valid arguments succeeds, prints nothing' {

  attrs=('key_01' 'key_02')

  run get_attrs_from_yaml_file "${valid_file_03}" attrs

  [ "${status}" -eq 0 ]
  [ "${output}" = '' ]
}

@test '#15/02 - get_attrs_from_yaml_file with two valid arguments succeeds, prints expected output with elevated log level' {

  attrs=('key_01' 'key_02')

  set_log_level INFO

  run get_attrs_from_yaml_file "${valid_file_03}" attrs

  set_log_level WARNING

  [ "${status}" -eq 0 ]
  [ "${output}" = "${exp_out_03}" ]
}

@test '#16/01 - get_attrs_from_yaml_file with three valid arguments succeeds, prints nothing' {

  attrs=('key_01' 'key_02')
  opt_attrs=('key_03')

  run get_attrs_from_yaml_file "${valid_file_03}" attrs opt_attrs

  [ "${status}" -eq 0 ]
  [ "${output}" = '' ]
}

@test '#16/02 - get_attrs_from_yaml_file with three valid arguments succeeds, prints expected output with elevated log level' {

  attrs=('key_01' 'key_02')
  opt_attrs=('key_03')

  set_log_level INFO

  run get_attrs_from_yaml_file "${valid_file_03}" attrs opt_attrs

  set_log_level WARNING

  [ "${status}" -eq 0 ]
  [ "${output}" = "${exp_out_04}" ]
}

@test '#17    - get_attrs_from_yaml_file with two valid arguments succeeds, sets variables' {

  attrs=('key_01' 'key_02')

  # NOTE: no 'run'
  get_attrs_from_yaml_file "${valid_file_03}" attrs

  # shellcheck disable=SC2154
  [ "${key_01}" = 'value 01' ]
  # shellcheck disable=SC2154
  [ "${key_02}" = 'value 02' ]
}

@test '#18    - get_attrs_from_yaml_file with three valid arguments succeeds, sets variables' {

  attrs=('key_01' 'key_02')
  opt_attrs=('key_03')

  get_attrs_from_yaml_file "${valid_file_03}" attrs opt_attrs

  [ "${key_01}" = 'value 01' ]
  [ "${key_02}" = 'value 02' ]
  # shellcheck disable=SC2154
  [ "${key_03}" = 'value 03' ]
}

@test '#19/01 - get_attrs_from_yaml_file with missing attribute fails, prints expected output' {

  # shellcheck disable=SC2034
  attrs=('key_01' 'key_04')
  # shellcheck disable=SC2034
  opt_attrs=('key_03')

  run get_attrs_from_yaml_file "${valid_file_02}" attrs opt_attrs

  err_msg='Failed to get key_04 attribute from JSON string'

  # NOTE: this is only displayed if test fails
  echo
  echo 'expected output:'$'\n'"${line_01}"$'\n'"${line_02}"$'\n'"${err_msg_9}"$'\n'"${err_msg}"
  echo
  echo 'actual output:'$'\n'"${output}"

  [ "${status}" -eq 1 ]
  [ "${output}" = "${err_msg_9}"$'\n'"${err_msg}" ]
}

@test '#19/02 - get_attrs_from_yaml_file with missing attribute fails, prints expected output with elevated log level' {

  # shellcheck disable=SC2034
  attrs=('key_01' 'key_04')
  # shellcheck disable=SC2034
  opt_attrs=('key_03')

  set_log_level INFO

  run get_attrs_from_yaml_file "${valid_file_02}" attrs opt_attrs

  set_log_level WARNING

  err_msg='Failed to get key_04 attribute from JSON string'

  [ "${status}" -eq 1 ]
  [ "${output}" = "${line_01}"$'\n'"${line_02}"$'\n'"${err_msg_9}"$'\n'"${err_msg}" ]
}
