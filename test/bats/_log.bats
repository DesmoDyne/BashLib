#!/usr/bin/env bats

# _log.bats
#
# bats unit tests for _log function from dd-bash-lib.sh
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

    # last error line: printed after error message
    last_err='please see function code for usage and sample code'

    # log message 1
    log_msg_1='some log message'

    # array to log
    log_array=('some' 'log' 'message')

    # hash to log; need to use -g, see comments in _log
    declare -A -g log_hash_1=(['key 1']='some'
                              ['key 2']='log'
                              ['key 3']='message')

    # hash with entries in random order
    # shellcheck disable=SC2034
    declare -A -g log_hash_2=(['key 3']='log'
                              ['key 1']='another'
                              ['key 4']='message'
                              ['key 2']='test')

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

@test '#01 - _log without arguments fails, prints an error' {

  run _log

  [ "${status}" -eq 1 ]
  [ "${output}" = "${err_msg_1}"$'\n'"${last_err}" ]
}

@test '#02 - _log with one argument fails, prints an error' {

  run _log 'first_arg'

  [ "${status}" -eq 1 ]
  [ "${output}" = "${err_msg_1}"$'\n'"${last_err}" ]
}

@test '#03 - _log with three arguments fails, prints an error' {

  run _log 'first_arg' 'second_arg' 'third_arg' 'fourth_arg'

  [ "${status}" -eq 1 ]
  [ "${output}" = "${err_msg_1}"$'\n'"${last_err}" ]
}

# ------------------------------------------------------------------------------
# test wrong type and invalid value as first argument: log level

@test '#04 - _log with integer log level fails, prints an error' {

  log_level=1

  # NOTE: no quotes
  run _log ${log_level} "${log_msg_1}"

  [ "${status}" -eq 1 ]
  [ "${output}" = "${err_msg_2} '${log_level}'" ]
}

@test '#05 - _log with float log level fails, prints an error' {

  skip 'bash fails upon float hash key'

  log_level=42.23

  # NOTE: this fails with .../code/lib/dd-bash-lib.sh: line 98:
  #   42.23: syntax error: invalid arithmetic operator (error token is ".23")
  # dd-bash-lib.sh@98: if [ ! -v _dd_bashlib_log_levels["${log_level}"] ]
  # --> seems like a bash failure to deal with floats used as hash keys

  run _log ${log_level} "${log_msg_1}"

  [ "${status}" -eq 1 ]
  [ "${output}" = "${err_msg_2} '${log_level}'" ]
}

@test '#06 - _log with invalid log level string fails, prints an error' {

  log_level='INVALID_LOG_LEVEL'

  run _log ${log_level} "${log_msg_1}"

  [ "${status}" -eq 1 ]
  [ "${output}" = "${err_msg_2} '${log_level}'" ]
}


# NOTE: there aren't really any invalid second argument data types


# ------------------------------------------------------------------------------
# test actual actual function behavior

@test '#07 - _log with log level CRITICAL succeeds, prints log message' {

  log_level=CRITICAL

  run _log ${log_level} "${log_msg_1}"

  [ "${status}" -eq 0 ]
  [ "${output}" = "${log_msg_1}" ]
}

@test '#08 - _log with log level ERROR succeeds, prints log message' {

  log_level=ERROR

  run _log ${log_level} "${log_msg_1}"

  [ "${status}" -eq 0 ]
  [ "${output}" = "${log_msg_1}" ]
}

@test '#09 - _log with log level WARNING succeeds, prints log message' {

  log_level=WARNING

  run _log ${log_level} "${log_msg_1}"

  [ "${status}" -eq 0 ]
  [ "${output}" = "${log_msg_1}" ]
}

@test '#10 - _log with log level INFO succeeds, prints nothing' {

  log_level=INFO

  run _log ${log_level} "${log_msg_1}"

  [ "${status}" -eq 0 ]
  [ "${output}" = '' ]
}

@test '#11 - _log with log level DEBUG succeeds, prints nothing' {

  log_level=DEBUG

  run _log ${log_level} "${log_msg_1}"

  [ "${status}" -eq 0 ]
  [ "${output}" = '' ]
}

@test '#12 - _log with log level NOTSET succeeds, prints nothing' {

  log_level=NOTSET

  run _log ${log_level} "${log_msg_1}"

  [ "${status}" -eq 0 ]
  [ "${output}" = '' ]
}

@test '#13 - _log with array as string succeeds, prints array' {

  log_level=WARNING

  run _log ${log_level} "${log_array[*]}"

  [ "${status}" -eq 0 ]
  [ "${output}" = "${log_array[*]}" ]
}

@test '#14 - _log with hash as string succeeds, prints hash' {

  log_level=WARNING

  run _log ${log_level} "${log_hash_1[@]@K}"

  [ "${status}" -eq 0 ]
  [ "${output}" = "${log_hash_1[*]@K}" ]
}

@test '#15 - _log with array log value succeeds, prints array' {

  log_level=WARNING

  run _log ${log_level} log_array

  [ "${status}" -eq 0 ]
  [ "${output}" = "${log_array[*]}" ]
}

@test '#16 - _log with hash log value succeeds, prints hash' {

  log_level=WARNING

  run _log ${log_level} log_hash_1

  [ "${status}" -eq 0 ]
  [ "${output}" = '"key 1" "some" "key 2" "log" "key 3" "message"' ]
}

@test '#17 - _log with unsorted hash log value succeeds, prints hash' {

  log_level=WARNING

  run _log ${log_level} log_hash_2

  # NOTE: this is only displayed if test fails
  # TODO: bats should do print this automatically
  printf '\n'
  printf 'status: %s\n'  "${status}"
  printf 'output:\n%s\n' "${output}"
  printf '\n'

  [ "${status}" -eq 0 ]
  [ "${output}" = '"key 1" "another" "key 2" "test" "key 3" "log" "key 4" "message"' ]
}

@test '#18 - _log with trailing newline succeeds, prints newline' {

  log_level=WARNING

  run _log ${log_level} "${log_msg_1}"$'\n'

  # NOTE: this is only displayed if test fails
  # TODO: bats should do print this automatically
  printf '\n'
  printf 'status:   %b\n'  "${status}"
  printf '\n---\n\n'
  printf 'output:   |%b|\n' "${output}"
  printf '\n---\n\n'
  printf 'lines:\n'
  printf '%s\n' "${lines[@]}"
  printf '(end of lines output)\n'
  printf '\n---\n\n'
  printf 'lines[1]: |%s|\n' "${lines[1]}"
  printf 'lines[2]: |%s|\n' "${lines[2]}"
  printf '\n---\n\n'
  printf 'expected: |%b|' "${log_msg_1}"$'\n'
  printf '\n'

  # trigger output above even if test succeeds
  # [ 1 -eq 2 ]

  [ "${status}" -eq 0 ]

  # TODO: bats output seems to drop trailing newlines; possibly related:
  # https://github.com/bats-core/bats-core/issues/145

  # this succeeds:
  [ "${output}"   = "${log_msg_1}" ]
  # however, output should contain the trailing newline,
  # but this fails:
  # [ "${output}"   = "${log_msg_1}"$'\n' ]

  # NOTE: use lines for a possibly better way to verify:
  [ "${lines[0]}" = "${log_msg_1}" ]
  # along the same lines as above, this succeeds:
  [ "${#lines[@]}" -eq 1 ]
  # and this fails:
  # [ "${#lines[@]}" -eq 2 ]
}
