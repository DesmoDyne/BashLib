#!/usr/bin/env bats

# log_warning.bats
#
# bats unit tests for log_warning function from dd-bash-lib.sh
#
# author  : stefan schablowski
# contact : stefan.schablowski@desmodyne.com
# created : 2021-09-01


# NOTE: see also ./extend_path.bats and ./log_critical.bats


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

    # log message 1
    log_msg_1='some log message'

    # array to log
    log_array=('some' 'log' 'message')

    # hash to log; need to use -g, see comments in log_warning
    # shellcheck disable=SC2034
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
# test actual actual function behavior

@test '#01    - log_warning without arguments succeeds, prints nothing' {

  run log_warning

  [ "${status}" -eq 0 ]
  [ "${output}" = '' ]
}

@test '#02    - log_warning with integer log value succeeds, prints integer' {

  log_value=1

  run log_warning ${log_value}

  [ "${status}" -eq 0 ]
  [ "${output}" = ${log_value} ]
}

@test '#03    - log_warning with float log value succeeds, prints float' {

  log_value=42.23

  run log_warning ${log_value}

  [ "${status}" -eq 0 ]
  [ "${output}" = ${log_value} ]
}

@test '#04    - log_warning with string log value succeeds, prints string' {

  run log_warning "${log_msg_1}"

  [ "${status}" -eq 0 ]
  [ "${output}" = "${log_msg_1}" ]
}

@test '#05    - log_warning with array log value succeeds, prints array' {

  run log_warning log_array

  [ "${status}" -eq 0 ]
  [ "${output}" = "${log_array[*]}" ]
}

@test '#06    - log_warning with hash log message succeeds, prints hash' {

  run log_warning log_hash_1

  [ "${status}" -eq 0 ]
  [ "${output}" = '"key 1" "some" "key 2" "log" "key 3" "message"' ]
}
