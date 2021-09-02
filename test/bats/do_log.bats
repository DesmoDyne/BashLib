#!/usr/bin/env bats

# do_log.bats
#
# bats unit tests for do_log function from dd-bash-lib.sh
#
# author  : stefan schablowski
# contact : stefan.schablowski@desmodyne.com
# created : 2021-09-01


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

    # error message 1
    err_msg_1='ERROR: wrong number of arguments'

    # error message 2
    err_msg_2='ERROR: invalid log level'

    # error message 3
    err_msg_3='ERROR: can not log arrays, please use "${array[*]}"'

    # error message 4
    err_msg_4='ERROR: can not log hashes, please use "${array[@]@K}"'

    # last error line: printed after error message
    last_err='please see function code for usage and sample code'

    # log message 1
    log_msg_1='some log message'

    # array to log
    log_array=('some' 'log' 'message')

    # hash to log; need to use -g, see comments in do_log
    declare -A -g log_hash=(['key 1']='some' ['key 2']='log' ['key 3']='message')

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

@test '#01 - do_log without arguments fails, prints an error' {

  run do_log

  [ "${status}" -eq 1 ]
  [ "${output}" = "${err_msg_1}"$'\n'"${last_err}" ]
}

@test '#02 - do_log with one argument fails, prints an error' {

  run do_log 'first_arg'

  [ "${status}" -eq 1 ]
  [ "${output}" = "${err_msg_1}"$'\n'"${last_err}" ]
}

@test '#03 - do_log with three arguments fails, prints an error' {

  run do_log 'first_arg' 'second_arg' 'third_arg' 'fourth_arg'

  [ "${status}" -eq 1 ]
  [ "${output}" = "${err_msg_1}"$'\n'"${last_err}" ]
}

# ------------------------------------------------------------------------------
# test wrong type and invalid value as first argument: log level

@test '#04 - do_log with integer log level fails, prints an error' {

  log_level=1

  # NOTE: no quotes
  run do_log ${log_level} "${log_msg_1}"

  [ "${status}" -eq 1 ]
  [ "${output}" = "${err_msg_2} '${log_level}'" ]
}

@test '#05 - do_log with float log level fails, prints an error' {

  skip 'bash fails upon float hash key'

  log_level=42.23

  # NOTE: this fails with .../code/lib/dd-bash-lib.sh: line 98:
  #   42.23: syntax error: invalid arithmetic operator (error token is ".23")
  # dd-bash-lib.sh@98: if [ ! -v dd_bashlib_log_levels["${log_level}"] ]
  # --> seems like a bash failure to deal with floats used as hash keys

  run do_log ${log_level} "${log_msg_1}"

  [ "${status}" -eq 1 ]
  [ "${output}" = "${err_msg_2} '${log_level}'" ]
}

@test '#06 - do_log with invalid log level string fails, prints an error' {

  log_level='INVALID_LOG_LEVEL'

  run do_log ${log_level} "${log_msg_1}"

  [ "${status}" -eq 1 ]
  [ "${output}" = "${err_msg_2} '${log_level}'" ]
}


# ------------------------------------------------------------------------------
# test unsupported type as second argument: log value

@test '#07 - do_log with array log value fails, prints an error' {

  log_level=WARNING

  run do_log ${log_level} log_array

  [ "${status}" -eq 1 ]
  [ "${output}" = "${err_msg_3}" ]
}

@test '#08 - do_log with hash log value fails, prints an error' {

  log_level=WARNING

  run do_log ${log_level} log_hash

  [ "${status}" -eq 1 ]
  [ "${output}" = "${err_msg_4}" ]
}


# ------------------------------------------------------------------------------
# test actual actual function behavior

@test '#09 - do_log with log level CRITICAL succeeds, prints log message' {

  log_level=CRITICAL

  run do_log ${log_level} "${log_msg_1}"

  [ "${status}" -eq 0 ]
  [ "${output}" = "${log_msg_1}" ]
}

@test '#10 - do_log with log level ERROR succeeds, prints log message' {

  log_level=ERROR

  run do_log ${log_level} "${log_msg_1}"

  [ "${status}" -eq 0 ]
  [ "${output}" = "${log_msg_1}" ]
}

@test '#11 - do_log with log level WARNING succeeds, prints log message' {

  log_level=WARNING

  run do_log ${log_level} "${log_msg_1}"

  [ "${status}" -eq 0 ]
  [ "${output}" = "${log_msg_1}" ]
}

@test '#12 - do_log with log level INFO succeeds, prints nothing' {

  log_level=INFO

  run do_log ${log_level} "${log_msg_1}"

  [ "${status}" -eq 0 ]
  [ "${output}" = '' ]
}

@test '#13 - do_log with log level DEBUG succeeds, prints nothing' {

  log_level=DEBUG

  run do_log ${log_level} "${log_msg_1}"

  [ "${status}" -eq 0 ]
  [ "${output}" = '' ]
}

@test '#14 - do_log with log level NOTSET succeeds, prints nothing' {

  log_level=NOTSET

  run do_log ${log_level} "${log_msg_1}"

  [ "${status}" -eq 0 ]
  [ "${output}" = '' ]
}

@test '#15 - do_log with array as string succeeds, prints array' {

  log_level=WARNING

  # TODO: pass array verbatim, e.g.
  # run do_log ${log_level} log_array
  run do_log ${log_level} "${log_array[*]}"

  [ "${status}" -eq 0 ]
  [ "${output}" = "${log_array[*]}" ]
}

@test '#16 - do_log with hash as string succeeds, prints hash' {

  log_level=WARNING

  run do_log ${log_level} "${log_hash[@]@K}"

  # NOTE: this is only displayed if test fails
  echo
  echo "status: ${status}"
  echo
  echo 'expected output:'$'\n'"${log_msg_1}"$'\n'
  echo
  echo 'actual output:'$'\n'"${output}"

  [ "${status}" -eq 0 ]
  [ "${output}" = "${log_hash[@]@K}" ]
}
