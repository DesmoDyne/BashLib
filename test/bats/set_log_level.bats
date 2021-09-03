#!/usr/bin/env bats

# set_log_level.bats
#
# bats unit tests for set_log_level function from dd-bash-lib.sh
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

@test '#01 - set_log_level without arguments fails, prints an error' {

  run set_log_level

  [ "${status}" -eq 1 ]
  [ "${output}" = "${err_msg_1}"$'\n'"${last_err}" ]
}

@test '#02 - set_log_level with two argument fails, prints an error' {

  run set_log_level 'first_arg' 'second_arg'

  [ "${status}" -eq 1 ]
  [ "${output}" = "${err_msg_1}"$'\n'"${last_err}" ]
}

# ------------------------------------------------------------------------------
# test wrong type and invalid value as first argument: log level

@test '#04 - set_log_level with integer log level fails, prints an error' {

  log_level=1

  # NOTE: no quotes
  run set_log_level ${log_level}

  [ "${status}" -eq 1 ]
  [ "${output}" = "${err_msg_2} '${log_level}'" ]
}

@test '#05 - set_log_level with float log level fails, prints an error' {

  skip 'bash fails upon float hash key'

  log_level=42.23

  # NOTE: see _log.bats > @test '#05 ... '

  run set_log_level ${log_level}

  [ "${status}" -eq 1 ]
  [ "${output}" = "${err_msg_2} '${log_level}'" ]
}

@test '#06 - set_log_level with invalid log level string fails, prints an error' {

  log_level='INVALID_LOG_LEVEL'

  run set_log_level ${log_level}

  [ "${status}" -eq 1 ]
  [ "${output}" = "${err_msg_2} '${log_level}'" ]
}


# ------------------------------------------------------------------------------
# test actual actual function behavior

@test '#07 - set_log_level with log level CRITICAL succeeds, sets log level' {

  log_level=CRITICAL

  # NOTE: see ./extend_path.bats >  @test '#30 ...'

  set_log_level ${log_level}

  # shellcheck disable=SC2154
  [ "${_dd_bashlib_log_level}" = "${_dd_bashlib_log_levels[CRITICAL]}" ]
}

@test '#08 - set_log_level with log level ERROR succeeds, sets log level' {

  log_level=ERROR

  set_log_level ${log_level}

  [ "${_dd_bashlib_log_level}" = "${_dd_bashlib_log_levels[ERROR]}" ]
}

@test '#09 - set_log_level with log level WARNING succeeds, sets log level' {

  log_level=WARNING

  set_log_level ${log_level}

  [ "${_dd_bashlib_log_level}" = "${_dd_bashlib_log_levels[WARNING]}" ]
}

@test '#10 - set_log_level with log level INFO succeeds, sets log level' {

  log_level=INFO

  set_log_level ${log_level}

  [ "${_dd_bashlib_log_level}" = "${_dd_bashlib_log_levels[INFO]}" ]
}

@test '#11 - set_log_level with log level DEBUG succeeds, sets log level' {

  log_level=DEBUG

  set_log_level ${log_level}

  [ "${_dd_bashlib_log_level}" = "${_dd_bashlib_log_levels[DEBUG]}" ]
}

@test '#12 - set_log_level with log level NOTSET succeeds, sets log level' {

  log_level=NOTSET

  set_log_level ${log_level}

  [ "${_dd_bashlib_log_level}" = "${_dd_bashlib_log_levels[NOTSET]}" ]
}
