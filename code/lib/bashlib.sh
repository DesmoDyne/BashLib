# shellcheck shell=bash

# bashlib.sh
#
# DesmoDyne library of generic bash functions
#
# author  : stefan schablowski
# contact : stefan.schablowski@desmodyne.com
# created : 2018-07-16


# NOTE: this library is not meant to be executed;
# instead use functions in own scripts with e.g.
#   source <path to this library>/bashlib.sh

# no shell she-bang, but a shellcheck shell directive:
# https://github.com/koalaman/shellcheck/issues/581

# basic styleguide convention:
# https://google.github.io/styleguide/shell.xml
# styleguide exception: 'do' and 'then' are placed on new lines:
# https://google.github.io/styleguide/shell.xml?showone=Loops#Loops


# TODO: fix shellcheck issues
# TODO: do not use global variables, but function parameters
# TODO: document parameters and return values
# TODO: really set variables in here and use them elsewhere ?
# TODO: review function names, most of them do more than the name suggests
# TODO: use named parameters ? https://stackoverflow.com/a/30033822
# TODO: use Bash Infinity Framework ?
#       https://invent.life/project/bash-infinity-framework
# TODO: add code location indicator to log messages ?
# TODO: add unit-tests
# TODO: review using 'local' for variable declaration
# TODO: (globally) redirect error messages to stderr using >&2
# TODO: align / indent output / review log output in general


# treat unset variables and parameters as error for parameter expansion:
# https://www.gnu.org/software/bash/manual/html_node/The-Set-Builtin.html
# NOTE: this is a backup safety measure; globals set externally (i.e. by
# scripts using this library) are tested individually before they are used
set -o nounset


# define functions: http://stackoverflow.com/a/6212408


# -----------------------------------------------------------------------------
# extend path to other scripts or executables
#
# Test if all executables in <req_tools> are found in PATH; if not,
# successively append paths in <ext_paths> to PATH and try again.
#
# This functions is most useful to automatically handle different PATHs during
# development vs. production: In production, any scripts or executables used
# by a superscript are typically installed using a distribution package
# and (project or other, e.g. Linux / macOS system) tools are found in PATH.
# During development, this is not necessarily the case; e.g. subscripts used
# by a superscript might reside in the same folder as the superscript itself,
# where they are not found unless the path is extended by that folder.
#
# WARNING to developers: It is generally a bad practice to mix production
# and development environments on the same host: DO NOT install a production
# version of anything you are currently developing; the exact executables
# being used depend on the order of paths in PATH; this is a source of error.
#
# Globals:
#   possibly extends PATH by paths in <ext_paths>
# Arguments:
#   req_tools - string array with tool names required in PATH
#   ext_paths - string array with paths to add to PATH: paths already in PATH
#               won't be re-added and a message will be displayed; paths that
#               don't exist or are not folders will be ignored with a warning
# Returns:
#   0 if all tools were found in (possibly extended) PATH; 1 otherwise
#
# Sample code:
#   req_tools=('my_helper_script' 'vagrant' 'javac')
#   ext_paths=('/usr/local/bin' '<path to my scripts>' '/opt/vagrant/bin')
#   extend_path req_tools ext_paths
#
# TODO: does changing PATH have any side effects to calling script ?

function extend_path
{
    echo 'verify required executables are available in PATH:'

    if [ "$#" -ne 2 ]
    then
        msg='ERROR: wrong number of arguments'$'\n'
        msg+='please see function code for usage and sample code'
        echo "${msg}" >&2
        return 1
    fi

    # test if first argument is an array:
    # https://stackoverflow.com/a/27254437
    # https://stackoverflow.com/a/26287272
    # http://fvue.nl/wiki/Bash:_Detect_if_variable_is_an_array
    if ! [[ "$(declare -p "${1}" 2> /dev/null)" =~ "declare -a" ]]
    then
        msg='ERROR: <req_tools> argument is not an array'$'\n'
        msg+='please see function code for usage and sample code'
        echo "${msg}" >&2
        return 1
    fi

    if ! [[ "$(declare -p "${2}" 2> /dev/null)" =~ "declare -a" ]]
    then
        msg='ERROR: <ext_paths> argument is not an array'$'\n'
        msg+='please see function code for usage and sample code'
        echo "${msg}" >&2
        return 1
    fi

    # pass arrays as function arguments:
    # https://stackoverflow.com/a/29379084
    #
    # there is plenty confusion around arrays
    # and function arguments in bash in general:
    # https://stackoverflow.com/q/16461656
    #
    # NOTE: underscore appended to variable name
    # to reduce the chance of bash warning
    #   local: warning: req_tools: circular name reference
    # that occurs when client code also uses
    # 'req_tools' as name for the variable
    # passed as argument to this function
    local -n req_tools_=${1}
    local -n ext_paths_=${2}

    # test if req tools array is empty
    if [ -z "${req_tools_[*]}" ]
    then
        return 0
    fi

    # add a dummy element to beginning of array for first loop
    # https://unix.stackexchange.com/a/395103
    ext_paths_=('dummy' "${ext_paths_[@]}")

    # associative array with key = tool name and
    # value = true if tool found, false otherwise
    declare -A found_tools_map=()

    # https://stackoverflow.com/a/8880633
    for ext_path in "${ext_paths_[@]}"
    do
        # test if first loop iteration
        if [ "${ext_path}" != 'dummy' ]
        then
            # test if path is already in PATH
            if [[ "${PATH}" = *"${ext_path}"* ]]
            then
                echo "  WARNING: path ${ext_path} is already in PATH; skip"
                continue
            fi

            # TODO: test if readable / executable ?
            if [ ! -d "${ext_path}" ]
            then
                echo "  WARNING: folder ${ext_path} does not exist; skip"
                continue
            fi

            echo "  append ${ext_path} to PATH and retry:"
            PATH="${PATH}:${ext_path}"
        fi

        for req_tool in "${req_tools_[@]}"
        do
            # test if req_tool is in array keys and its value is true
            # NOTE: due to set -o nounset, need
            # to work around key not existing:
            # https://stackoverflow.com/a/35353851
            # TODO: review this for one toolname being part of another
            if [[ "${!found_tools_map[*]}" == *"${req_tool}"* ]] &&
               [  "${found_tools_map[${req_tool}]}" = true ]
            then
                continue
            fi

            # https://stackoverflow.com/a/677212
            # https://github.com/koalaman/shellcheck/wiki/SC2230
            # https://linux.die.net/man/1/bash
            # search for 'command [-pVv] command'
            echo -n "  ${req_tool}: "
            if [ -x "$(command -v "${req_tool}")" ]
            then
                echo 'OK'
                found_tools_map["${req_tool}"]=true
            else
                echo 'FAIL'
                found_tools_map["${req_tool}"]=false
            fi
        done

        all_tools_found=true

        # https://stackoverflow.com/a/3113285
        for req_tool in "${!found_tools_map[@]}"
        do
            if [ "${found_tools_map[${req_tool}]}" = false ]
            then
                all_tools_found=false
            fi
        done

        if [ "${all_tools_found}" = true ]
        then
            return 0
        fi
    done

    echo

    return 1
}


# -----------------------------------------------------------------------------
function determine_platform
{
    echo -n 'determine platform: '

    # http://stackoverflow.com/a/18434831

    # TODO: strictly speaking, setting variables in here is a side effect

    case "${OSTYPE}" in
        darwin*)
            echo 'OK'
            grep='ggrep'
            sed='gsed'
            xargs='gxargs'
            ;;
        linux-*)
            echo 'OK'
            grep='grep'
            sed='sed'
            xargs='xargs'
            ;;
        *)
            echo 'ERROR'
            echo "unsupported operating system: ${OSTYPE}"
            return 1
            ;;
    esac
}

# -----------------------------------------------------------------------------
function proc_cmd_line_args
{
    echo -n 'process command line arguments: '

    # NOTE: for some reason, if no parameters are passed,
    # "$#" is 0, but "$0" still returns the name of the script being run

    # name of the script being run:
    # http://stackoverflow.com/q/192319
    script_name="$(basename "$0")"

    # TODO: this fails as this function
    # is called with no parameters
    if [ $# -ne 1 ]
    then
        echo 'ERROR'
        echo "wrong number of arguments: $#"
        echo
        usage
        return 1
    fi

    # http://stackoverflow.com/a/14203146
    while [ $# -gt 0 ]
    do
        key="$1"

        case "${key}" in
          # NOTE: must escape -?, seems to act as wildcard otherwise
          -\?|--help) echo 'HELP'; echo; usage; return 1 ;;

          *)  if [ -z "${config_file}" ]
              then
                  config_file="$1"
              else
                  echo 'ERROR'
                  echo 'wrong number of arguments'
                  echo
                  usage
                  return 1
              fi
        esac

        # move past argument or value
        shift
    done

    # TODO: try to use ~/.<script_name>.yaml or so if no config file is passed ?
    # TODO: use absolute path to config file in output ?

    # config file is a mandatory command line argument
    if [ -z "${config_file}" ]
    then
        echo 'ERROR'
        echo 'wrong number of arguments'
        echo
        usage
        return 1
    fi

    # http://tldp.org/LDP/Bash-Beginners-Guide/html/sect_07_01.html
    if [ ! -e "${config_file}" ]
    then
        echo 'ERROR'
        echo "${config_file}: No such file or directory"
        return 1
    fi

    if [ ! -r "${config_file}" ]
    then
        echo 'ERROR'
        echo "${config_file}: File is not readable"
        return 1
    fi

    echo 'OK'
}

# -----------------------------------------------------------------------------
function usage
{
    # TODO: space between << and 'EOT' makes a
    # difference for atom syntax highlighting
    # TODO: align properly and remove leading space when printing ?

    read -r -d '' msg_tmpl <<'EOT'
Usage: %s <config file>

mandatory arguments:
  config file           absolute path to configuration file

optional arguments:
  -?, --help            print this help message
EOT

    # shellcheck disable=SC2059
    printf "${msg_tmpl}\\n" "${script_name}"
}

# -----------------------------------------------------------------------------
function validate_config_settings
{
    echo -n 'validate configuration settings: '

    # TODO: verify path_to_sec_loc is an absolute path ?
    # TODO: resolve symbolic links into real path ?

    if [ -e "${path_to_sec_loc}" ]
    then
        if [ -d "${path_to_sec_loc}" ]
        then
            echo 'OK'
        else
            echo 'ERROR'
            echo 'path exists, but is not a directory:'
            echo "${path_to_sec_loc}"
            return 1
        fi
    else
        # split paths into its components
        # https://askubuntu.com/a/600252
        # TODO: this fails with whitespace in path
        comps="$("${xargs}" -n 1 -d '/' <<< "${path_to_sec_loc}" | "${xargs}")"

        # turn path components into array
        # https://stackoverflow.com/a/13402368
        # NOTE: word splitting is intended here
        # shellcheck disable=SC2206
        array=(${comps})

        # NOTE: alternate / shorter approach:
        # https://github.com/koalaman/shellcheck/wiki/SC2207
        # mapfile -t array < \
        #     <("${xargs}" -n 1 -d '/' <<< "${path_to_sec_loc}" | "${xargs}")

        # if at least the first two path components exist,
        # they are considered a solid base for the rest
        # TODO: this is specific to local secure location
        # TODO: this assumes at least two comps in path
        if [ -d "/${array[0]}/${array[1]}" ]
        then
            echo 'OK'
        else
            echo 'ERROR'
            echo 'path to secure location is not mounted:'
            echo "${path_to_sec_loc}"
            return 1
        fi
    fi
}


# undo bash option changes so this library can be sourced
# from a live shell with changing the shell's configuration
# TODO: test if this works as expected
set +o nounset
