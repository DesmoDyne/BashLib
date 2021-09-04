#!/usr/bin/env bats

# logging_e2e.bats
#
# bats end to end tests for logging functions from dd-bash-lib.sh
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

@test '#01    - log with default level, increase level, log again' {

  run log_critical 'critical message'

  [ "${status}" -eq 0 ]
  [ "${output}" = 'critical message' ]

  run log_error 'error message'

  [ "${status}" -eq 0 ]
  [ "${output}" = 'error message' ]

  run log_warning 'warning message'

  [ "${status}" -eq 0 ]
  [ "${output}" = 'warning message' ]

  run log_info 'info message'

  [ "${status}" -eq 0 ]
  [ "${output}" = '' ]

  run log_debug 'debug message'

  [ "${status}" -eq 0 ]
  [ "${output}" = '' ]


  set_log_level DEBUG


  run log_critical 'critical message'

  [ "${status}" -eq 0 ]
  [ "${output}" = 'critical message' ]

  run log_error 'error message'

  [ "${status}" -eq 0 ]
  [ "${output}" = 'error message' ]

  run log_warning 'warning message'

  [ "${status}" -eq 0 ]
  [ "${output}" = 'warning message' ]

  run log_info 'info message'

  [ "${status}" -eq 0 ]
  [ "${output}" = 'info message' ]

  run log_debug 'debug message'

  [ "${status}" -eq 0 ]
  [ "${output}" = 'debug message' ]
}

@test '#01    - log with default level, decrease level, log again' {

  run log_critical 'critical message'

  [ "${status}" -eq 0 ]
  [ "${output}" = 'critical message' ]

  run log_error 'error message'

  [ "${status}" -eq 0 ]
  [ "${output}" = 'error message' ]

  run log_warning 'warning message'

  [ "${status}" -eq 0 ]
  [ "${output}" = 'warning message' ]

  run log_info 'info message'

  [ "${status}" -eq 0 ]
  [ "${output}" = '' ]

  run log_debug 'debug message'

  [ "${status}" -eq 0 ]
  [ "${output}" = '' ]


  set_log_level CRITICAL


  run log_critical 'critical message'

  [ "${status}" -eq 0 ]
  [ "${output}" = 'critical message' ]

  run log_error 'error message'

  [ "${status}" -eq 0 ]
  [ "${output}" = '' ]

  run log_warning 'warning message'

  [ "${status}" -eq 0 ]
  [ "${output}" = '' ]

  run log_info 'info message'

  [ "${status}" -eq 0 ]
  [ "${output}" = '' ]

  run log_debug 'debug message'

  [ "${status}" -eq 0 ]
  [ "${output}" = '' ]
}
