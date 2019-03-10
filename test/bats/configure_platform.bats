#!/usr/bin/env bats

# configure_platform.bats
#
# bats unit tests for configure_platform function from bashlib.sh
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

    # log output message 1
    # shellcheck disable=SC2034
    out_msg_1='configure platform: OK'

    # error message 1
    # shellcheck disable=SC2034
    err_msg_1='configure platform: ERROR'

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


# ------------------------------------------------------------------------------
# test supported operating systems

@test '#01 - configure_platform on unsupported OS fails, prints an error' {

  OLD_OSTYPE="${OSTYPE}" && OSTYPE='this_os_does_not_exist'
  run configure_platform
  OSTYPE="${OLD_OSTYPE}"

  exp_line_2='unsupported operating system: this_os_does_not_exist'

  # shellcheck disable=SC2154
  [ "${status}" -eq 1 ]

  exp_out="${err_msg_1}"$'\n'"${exp_line_2}"

  # NOTE: this is only displayed if test fails
  echo 'expected output:'$'\n'"${exp_out}"
  echo 'actual output:'$'\n'"${output}"

  # shellcheck disable=SC2154
  [ "${output}" = "${exp_out}" ]
}

@test '#02 - configure_platform on supported OS succeeds, prints expected output' {

  run configure_platform

  # shellcheck disable=SC2154
  [ "${status}" -eq 0 ]

  exp_out="${out_msg_1}"

  # shellcheck disable=SC2154
  [ "${output}" = "${exp_out}" ]
}

# ------------------------------------------------------------------------------
# test tool name variables are set

# NOTE: see extend_path.bats on running tests with or without 'run'

@test '#03 - configure_platform on supported OS succeeds, sets tool name variables' {

  configure_platform

  [ -n "${grep}"  ]
  [ -n "${sed}"   ]
  [ -n "${xargs}" ]
}

@test '#04 - configure_platform on supported OS succeeds, sets tool name variables per OS' {

  configure_platform

  # TODO: (globally) verify OS is supported before running tests ?
  # TODO: actually run this on an unsupported OS

  case "${OSTYPE}" in
      darwin*)
          [ "${grep}"  =  'ggrep' ]
          [ "${sed}"   =   'gsed' ]
          [ "${xargs}" = 'gxargs' ]
          ;;
      linux-*)
          [ "${grep}"  =   'grep' ]
          [ "${sed}"   =    'sed' ]
          [ "${xargs}" =  'xargs' ]
          ;;
      *)
          echo 'ERROR'
          echo "unsupported operating system: ${OSTYPE}"
          [ false ]
          ;;
  esac
}
