#!/usr/bin/env bats

# usage.bats
#
# bats unit tests for usage function from dd-bash-lib.sh
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

    # function output with bats executable
    # NOTE: bats does not seem to allow heredocs using e.g.
    # read -r -d '' out_msg << EOT
    #   ... (variable multi-line contents)
    #EOT

    out_msg='Usage: bats-exec-test <config file>'$'\n'
    out_msg+=$'\n'
    out_msg+='mandatory arguments:'$'\n'
    out_msg+='  config file           absolute path to configuration file'$'\n'
    out_msg+=$'\n'
    out_msg+='optional arguments:'$'\n'
    out_msg+='  -?, --help            print this help message'

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


# ------------------------------------------------------------------------------
# test actual actual function behavior

@test '#01 - usage succeeds, prints expected output' {

  run usage

  [ "${status}" -eq 0 ]

  exp_out="${out_msg}"

  # NOTE: this is only displayed if test fails
  echo
  echo 'expected output:'$'\n'"${exp_out}"
  echo
  echo 'actual output:'$'\n'"${output}"

  [ "${output}" = "${exp_out}" ]
}
