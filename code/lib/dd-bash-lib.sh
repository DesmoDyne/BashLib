# shellcheck shell=bash

# dd-bash-lib.sh
#
# DesmoDyne library of generic bash functions
#
# author  : stefan schablowski
# contact : stefan.schablowski@desmodyne.com
# created : 2018-07-16


# NOTE: this library is not meant to be executed;
# instead use functions in own scripts with e.g.
#   source <path to this library>/dd-bash-lib.sh
# if BashLib is installed using brew with custom tap:
#   source /usr/local/lib/dd-bash-lib.sh
# see also https://github.com/desmodyne/homebrew-tools

# no shell she-bang, but a shellcheck shell directive:
# https://github.com/koalaman/shellcheck/issues/581

# basic styleguide convention:
# https://google.github.io/styleguide/shell.xml
# styleguide exception: 'do' and 'then' are placed on new lines:
# https://google.github.io/styleguide/shell.xml?showone=Loops#Loops


# TODO: use named parameters ? https://stackoverflow.com/a/30033822
# TODO: use Bash Infinity Framework ?
#       https://invent.life/project/bash-infinity-framework
# TODO: add code location indicator to log messages ?
# TODO: review using 'local' for variable declaration
# TODO: be quiet unless --verbose / -v is passed
#       or set in ~/.dd-bash-lib.conf or DD_BASH_LIB_OPTIONS
# TODO: global flag to determine if BashLib was already sourced ?
# TODO: add color to output ? green OK, red ERROR, yellow FAIL / WARNING ?
# TODO: in all func doc, rename arguments to parameters
# TODO: in all func doc, review/align $1, $2, etc. ./. parameter names


# treat unset variables and parameters as error for parameter expansion:
# https://www.gnu.org/software/bash/manual/html_node/The-Set-Builtin.html
# NOTE: this is a backup safety measure; globals set externally (i.e. by
# scripts using this library) are tested individually before they are used
set -o nounset


# -----------------------------------------------------------------------------
# define global constants

# string to indicate the line before relevant output on stdout
dd_bashlib_marker_start='dd_bashlib_marker_start'

# string to indicate the line after relevant output on stdout
dd_bashlib_marker_end='dd_bashlib_marker_end'


# -----------------------------------------------------------------------------
# define functions: http://stackoverflow.com/a/6212408


# -----------------------------------------------------------------------------
# test operating system is supported and configure various commonly used tools
#
# This functions restricts the supported environments to Linux and macOS and
# makes the GNU version of commonly used command line tools (grep, sed, etc.)
# available to BashLib users under unified global variables; on macOS, this is
# in addition to the BSD tool variants.
# It is most useful when features are required that GNU tools provide, but are
# not supported by their BSD version, especially extended regular expressions.
# In practice, this means calling e.g. grep from a shell script still resolves
# to the 'native' tool, i.e. GNU grep on Linux and BSD grep on macOS; however,
# using e.g. "${grep}" resolves to GNU grep on both Linux and macOS.
#
# NOTE: at this stage, this function does not test if any of the cmd line tools
# are actually available, neither the native version nor GNU tools on macOS;
# on macOS, you may install GNU command line tools using Homebrew with e.g.
#   brew install coreutils findutils grep gnu-sed
# under their usual names with a 'g' prefixed to each name; see also e.g.
#   https://brew.sh/
#   https://apple.stackexchange.com/a/88812
#
# Prerequisites:
#   operating system is Linux or macOS
# Globals:
#   OSTYPE - evaluated to determine current OS
#   grep   - set to  'grep' on Linux,  'ggrep' on macOS
#   sed    - set to   'sed' on Linux,   'gsed' on macOS
#   xargs  - set to 'xargs' on Linux, 'gxargs' on macOS
#   (plus many other similar command line tools)
# Arguments:
#   None  - any arguments passed are silently ignored
# Returns:
#   0 if platform is supported, 1 otherwise
#
# Sample code:
#   # call the function without any parameters
#   configure_platform
#   # use -E to enable extended regular expressions
#   "${sed}" -E ...

# TODO: test if command line tools are actually available, fail if not ?

function configure_platform
{
    # http://stackoverflow.com/a/18434831

    # TODO: shellcheck reports SC2034 on macOS in the linux-*) case,
    # but not for the darwin*) case; review disabling and situation on Linux

    case "${OSTYPE}" in
        darwin*)
            echo 'configure platform: OK'
            date='gdate'
            grep='ggrep'
            readlink='greadlink'
            sed='gsed'
            xargs='gxargs'
            ;;
        linux-*)
            echo 'configure platform: OK'
            # shellcheck disable=SC2034
            date='date'
            # shellcheck disable=SC2034
            grep='grep'
            # shellcheck disable=SC2034
            readlink='readlink'
            # shellcheck disable=SC2034
            sed='sed'
            # shellcheck disable=SC2034
            xargs='xargs'
            ;;
        *)
            msg='configure platform: ERROR'$'\n'
            msg+="unsupported operating system: ${OSTYPE}"
            echo "${msg}" >&2
            return 1
            ;;
    esac

    return 0
}


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
# Prerequisites:
#   Bash 4.0 or later, uses arrays not available in earlier versions
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

# TODO: does changing PATH have any side effects to calling script ?

function extend_path
{
    echo 'verify required executables are available in PATH:'

    if [ "${#}" -ne 2 ]
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
    # https://www.gnu.org/software/bash/manual/html_node/Shell-Parameters.html
    # search for 'nameref'
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
    local -n req_tools_="${1}"
    local -n ext_paths_="${2}"

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
            # TODO: align OK / FAIL in output over all lines
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
# extract attributes from JSON string
#
# This function sets global variables for all mandatory or optional attributes
# it extracts from JSON string; for optional attributes that are not found,
# global variables are set to empty strings, so they can be tested with -n.
#
# TODO: research set / unset / defined / undefined / empty variables in bash
# and review if optional attributes not found can be not set / defined / etc.
# TODO: make opt_attrs optional so it must only be passed if actually used
#
# Prerequisites:
#   Bash 4.2+, uses arrays and declare -g not available in earlier versions
# Globals:
#   ${#}, ${1}, ${2}, ${3} - evaluated to get function arguments
#   sets global variables corresponding to attributes extracted from JSON string
# Arguments:
#   json      - JSON string to extract attributes from
#   attrs     - string array with names of mandatory attributes to extract
#   opt_attrs - string array with names of optional attributes to extract
# Returns:
#   0 if all mandatory (and no, some or all optional) attributes
#   were extracted from JSON string into global variables; 1 otherwise
#
# Sample code:
#   json="{ 'key_01': 'value 01', 'key_02': 'value 02', 'key_03': 'value 03' }"
#   attrs=('key_01' 'key_02')
#   opt_attrs=('key_03')
#   get_attrs_from_json json attrs opt_attrs

function get_attrs_from_json
{
    if [ "${#}" -ne 3 ]
    then
        msg='ERROR: wrong number of arguments'$'\n'
        msg+='please see function code for usage and sample code'
        echo "${msg}" >&2
        return 1
    fi

    echo -n 'verify input string is valid JSON: '
    # https://unix.stackexchange.com/a/76407
    if output="$(jq '.' <<< "${1}" 2>&1)"
    then
        echo 'OK'
    else
        echo 'ERROR'
        echo "${output}"
        return 1
    fi

    # test if second and third arguments are arrays
    if ! [[ "$(declare -p "${2}" 2> /dev/null)" =~ "declare -a" ]]
    then
        msg='ERROR: <attrs> argument is not an array'$'\n'
        msg+='please see function code for usage and sample code'
        echo "${msg}" >&2
        return 1
    fi

    if ! [[ "$(declare -p "${3}" 2> /dev/null)" =~ "declare -a" ]]
    then
        msg='ERROR: <opt_attrs> argument is not an array'$'\n'
        msg+='please see function code for usage and sample code'
        echo "${msg}" >&2
        return 1
    fi

    json_="${1}"
    local -n attrs_="${2}"
    local -n opt_attrs_="${3}"

    # NOTE: declare -g: https://stackoverflow.com/q/9871458/217844
    # TODO: in case of error, this should either set all variables or none
    echo -n 'extract mandatory attributes from JSON string: '
    for attr in "${attrs_[@]}"
    do
        output="$(jq -r ".${attr}" <<< "${json_}")"
        # https://unix.stackexchange.com/a/68349
        # https://unix.stackexchange.com/a/41418
        if [ -n "${output}" ] && [ "${output}" != 'null' ]
        then
            declare -g "${attr}"="${output}"
        else
            echo 'ERROR'
            echo "Failed to get ${attr} attribute from JSON string"
            return 1
        fi
    done
    echo 'OK'

    echo -n 'extract optional attributes from JSON string: '
    # NOTE: for now, set conf attributes to '' if not found
    # so check if set later in this script can be done with -n
    # TODO: set / unset / null vars in bash:
    # https://stackoverflow.com/a/16753536
    for attr in "${opt_attrs_[@]}"
    do
        output="$(jq -r ".${attr}" <<< "${json_}")"
        if [ -n "${output}" ] && [ "${output}" != 'null' ]
        then
            declare -g "${attr}"="${output}"
        else
            declare -g "${attr}"=''
        fi
    done
    echo 'OK'
}


# -----------------------------------------------------------------------------
# extract attributes from YAML file
#
# This function loads the YAML file passed as argument, converts its contents
# into JSON and then internally uses get_attrs_from_json to extract attributes.
#
# TODO: support command line argument to specify custom conf file
#
# Prerequisites:
#   see get_attrs_from_json
# Globals:
#   see get_attrs_from_json
# Arguments:
#   yaml_file - absolute or relative path to YAML file to extract from
#   attrs     - string array with names of mandatory attributes to extract
#   opt_attrs - string array with names of optional attributes to extract
# Returns:
#   0 if all mandatory (and no, some or all optional) attributes
#   were extracted from YAML file into global variables; 1 otherwise
#
# Sample code:
#   yaml_file='path/to/file.yaml'
#   attrs=('key_01' 'key_02')
#   opt_attrs=('key_03')
#   get_attrs_from_yaml_file yaml_file attrs opt_attrs

function get_attrs_from_yaml_file
{
    if [ "${#}" -ne 3 ]
    then
        msg='ERROR: wrong number of arguments'$'\n'
        msg+='please see function code for usage and sample code'
        echo "${msg}" >&2
        return 1
    fi

    yaml_file_="${1}"

    # NOTE: yq does not handle errors nor log output upon errors very well:
    # for example, if the YAML file to load does not exist, it prints e.g.
    #   Error: open <filename>: no such file or directory
    # as the first line to stdout, followed by a long usage message and e.g.
    #   11:29:42 main [ERRO] open <filename>: no such file or directory
    # as the last line to stderr; none of these can be easily picked up;
    # also, upon certain characters in keys or values, it panics and prints
    # an entirely useless Go stack trace without any meaningful information;
    # need to examine error output to create a somewhat meaningful error message

    # map with first line of yq error message and displayed error message
    # NOTE: bash fails miserably at supporting wrapping long lines
    declare -A map_err_msg=(
        ['Error: asked to process document index 0 but there are only 0 document(s)']="${yaml_file_}: input YAML file is empty"
        ['Error: Must provide filename']='no input YAML file provided'
        ["Error: open ${yaml_file_}: no such file or directory"]="${yaml_file_}: no such file or directory"
        ["Error: open ${yaml_file_}: permission denied"]="${yaml_file_}: permission denied"
        ['panic: attempted to parse unknown event: none [recovered]']="${yaml_file_}: input YAML file contents is invalid"
    )

    # NOTE: this essentially converts YAML to JSON
    echo -n 'load YAML file and convert to JSON: '
    # shellcheck disable=SC2154
    if output="$(yq read "${yaml_file_}" --tojson 2>&1)"
    then
        echo 'OK'
        json_="${output}"
    else
        echo 'ERROR'
        first_line="$(head -n 1 <<< "${output}")"

        # look up error message to display by first line of yq error message
        for yq_err_msg in "${!map_err_msg[@]}"
        do
            if [ "${first_line}" = "${yq_err_msg}" ]
            then
                echo "${map_err_msg[${yq_err_msg}]}"
                return 1
            fi
        done

        # if first line of yq error message is not found in map, display output
        echo "${output}"
        return 1
    fi

    get_attrs_from_json "${json_}" "${2}" "${3}"

    return $?
}


# -----------------------------------------------------------------------------
# get path to script configuration file from command line arguments
#
# NOTE: this function is only useful if the main script follows the convention
# to take a single parameter, the path to a main script configuration file
#
# Dependencies:
#   uses 'usage' function
# Globals:
#   ${#}, ${1} - evaluated to get arguments passed by script using this function
#   conf_file  - set to path to configuration file after function succeeds
# Arguments:
#   conf_file  - path to configuration file
# Returns:
#   0 if conf_file is a valid path to configuration file, 1 otherwise
#
# Sample code:
#   # pass all arguments to main script on to this function
#   get_conf_file_arg "${@}"

# TODO: support more than one argument, pass on any further arguments ?
# TODO: try to use ~/.<script_name>.yaml or so if no config file is passed ?
# TODO: support symbolic link to configuration file

function get_conf_file_arg
{
    echo -n 'get configuration file command line argument: '

    if [ "${#}" -ne 1 ]
    then
        msg='ERROR'$'\n''wrong number of arguments'$'\n'$'\n'
        msg+="$(usage)"
        echo "${msg}" >&2
        return 1
    fi

    # http://stackoverflow.com/a/14203146
    # NOTE: this code seems overly complex for a single argument,
    # but easily be extended to support an arbitrary number of arguments
    while [ ${#} -gt 0 ]
    do
        key="$1"

        case "${key}" in
            # NOTE: must escape -?, seems to act as wildcard otherwise
            -\?|--help)
            echo 'HELP'; echo; usage; return 1 ;;

            *)
            if [ -z "${conf_file}" ]
            then
                conf_file="${1}"
            else
                msg='ERROR'$'\n''wrong number of arguments'$'\n'$'\n'
                msg+="$(usage)"
                echo "${msg}" >&2
                return 1
            fi
        esac

        # move past argument or value
        shift
    done

    # config file is a mandatory command line argument
    if [ -z "${conf_file}" ]
    then
        msg='ERROR'$'\n''wrong number of arguments'$'\n'$'\n'
        msg+="$(usage)"
        echo "${msg}" >&2
        return 1
    fi

    # http://tldp.org/LDP/Bash-Beginners-Guide/html/sect_07_01.html

    if [ ! -e "${conf_file}" ]
    then
        msg='ERROR'$'\n'"${conf_file}: Path not found"$'\n'
        echo "${msg}" >&2
        return 1
    fi

    if [ ! -f "${conf_file}" ]
    then
        msg='ERROR'$'\n'"${conf_file}: Path is not a file"$'\n'
        echo "${msg}" >&2
        return 1
    fi

    if [ ! -r "${conf_file}" ]
    then
        msg='ERROR'$'\n'"${conf_file}: File is not readable"$'\n'
        echo "${msg}" >&2
        return 1
    fi

    echo 'OK'

    return 0
}


# -----------------------------------------------------------------------------
# determine if client is running in development or production environment
#
# NOTE: testing well-known brew installation bin paths works for *Tools
# scripts installed (or symlinked) to those paths, but does not work for
# project scripts which are installed to e.g. /opt/MailFlow/bin;
# those projects need to pass a suitable folder as second optional parameter
#
# Globals:
#   dd_bashlib_marker_start - global BashLib constant to mark start of output
#   dd_bashlib_marker_end   - global BashLib constant to mark end of output
# Arguments:
#   ${1} / here - folder that client project is calling this function from
#   ${2} / path - (optional) folder to consider in test for production paths
# Prints to stdout:
#   json object, wrapped in start and end marker lines, with properties
#     environment: development|production|UNKNOWN
#   sample output:
#      ... (other output) ...
#     dd_bashlib_marker_start
#     {
#       "environment": "development",
#     }
#     dd_bashlib_marker_end
#      ... (other output) ...
# Returns:
#   0 if function succeeded, 1 otherwise, e.g. when environment is UNKNOWN
#
# Sample code:
#   # call the function with current folder as ${here} argument
#   $ output="$(get_environment "$(pwd)")"
#   # use sed to extract relevant output:
#   # https://unix.stackexchange.com/a/180729
#   # NOTE: when running this in interactive bash session,
#   # history expansion (the '!d' bit) must be disabled
#   # using 'set +H': https://unix.stackexchange.com/a/384867;
#   # alternate, more descriptive syntax: 'set +o histexpand':
#   # https://superuser.com/a/133782
#   # not required when running in a bash script
#   $ set +o histexpand
#   # use temporary variables for shorter code, so line fits in here:
#   $ start="${dd_bashlib_marker_start}"
#   $ end="${dd_bashlib_marker_end}"
#   $ output="$(sed "/${start}/,/${end}/!d;/${end}/q" <<< "${output}")"
#   # remove first and last lines, the markers themselves:
#   # https://unix.stackexchange.com/a/264972
#   $ sed '1d;$d' <<< "${output}"

# TODO: merge this with configure_platform ? renamed to get_platform ?
# TODO: test this - presumably requires some fake/mock dev/prod test env

function get_environment
{
    echo
    echo 'get environment:'

    # TODO: align this with get_conf_file_arg / usage
    # TODO: merge this with -z "${path}" below

    if [ $# -ne 1 ] && [ ${#} -ne 2 ]
    then
        # get function name: https://stackoverflow.com/a/1835958
        echo "Usage: ${FUNCNAME[0]} <here> [<path>]" 2>&1
        return 1
    fi

    # TODO: validate arguments
    # TODO: get dev path as arg ?

    # path to client tool folder:
    # "here" from client perspective
    here="${1}"

    # (optional) client production path
    path="${2:-}"

    if [ -z "${here}" ]
    then
        echo "Usage: ${FUNCNAME[0]} <here>" 2>&1
        return 1
    fi

    echo "here: ${here}"
    # NOTE: sample output when run in different environments:
    # run on a macOS host, *Tools client project installed as brew package:
    #   here: /usr/local/bin
    # run on linux host, *Tools client project inst'd as (linux) brew package:
    #   here: /home/linuxbrew/.linuxbrew/bin
    # run on a linux host, MailFlow Backend installed in Docker container:
    #   here: /opt/MailFlow/bin
    # run on a macOS host, client project run in development project space:
    #   here: <home>/<dev root>/<project path>/code/bin
    #   where <home> is the developer's ${HOME} folder,
    #   <dev root> is the root folder of all development project spaces
    #   (~/DevBase as per DesmoDyne Development Project Space Convention)
    #   and <project path> is the root folder of the client project space

    # NOTE: should get this from conf, but loading conf requires environment...
    # NOTE: Homebrew sets env vars, e.g. HOMEBREW_PREFIX: /usr/local on macOS
    # or HOMEBREW_PREFIX=/home/linuxbrew/.linuxbrew on linux, but those env vars
    # are only an indicator, not definitive proof of where tools are run...

    # regex for path that indicates a project space / development context
    # NOTE: this assumes DesmoDyne Development Project Space Convention
    # NOTE: this must work with a variety of client locations, e.g.
    #   ${HOME}/DevBase/DesmoDyne/Infrastructure/Services/ ... /cicd/bin
    #   ${HOME}/DevBase/DesmoDyne/Infrastructure/Services/ ... /code/bin
    #   ${HOME}/DevBase/DesmoDyne/Projects/<project name>/cicd/bin
    #   ${HOME}/DevBase/DesmoDyne/Projects/<project name>/code/bin
    #   ${HOME}/DevBase/DesmoDyne/Tools/<project name>/cicd/bin
    #   ${HOME}/DevBase/DesmoDyne/Tools/<project name>/code/bin
    # TODO: support clients calling with here = their project root ?
    re_dev="${HOME}/DevBase/DesmoDyne/.*/(cicd|code)/bin"

    # paths that indicate a production context
    # TODO: use ${HOMEBREW_PREFIX} with these ?
    paths_to_prod=('/home/linuxbrew/.linuxbrew/bin' '/usr/local/bin')

    # add path if passed
    if [ -n "${path}" ]
    then
        paths_to_prod+=("${path}")
    fi

    # TODO: establish this as conv to
    # print arrays in log output in dev
    echo 'paths_to_prod:'
    printf '  %s\n' "${paths_to_prod[@]}"

    # NOTE: test if string in array:
    # https://stackoverflow.com/a/47541882
    # shellcheck disable=SC2154
    if printf '%s\n' "${paths_to_prod[@]}"  | grep -q "^${here}$"
    then
        environment='production'
        exit_code=0

    elif grep -qE "${re_dev}" <<< "${here}"
    then
        environment='development'
        exit_code=0

    else
        # TODO: introduce convention on unset json props:
        # null ? empty string ? not present at all ?
        environment='UNKNOWN'
        exit_code=1
    fi

    # TODO: are extra empty lines and | jq '.' really always helpful ?
    echo
    echo "${dd_bashlib_marker_start}"
    jo environment="${environment}" | jq '.'
    echo "${dd_bashlib_marker_end}"
    # TODO: this seems to be ignored
    echo

    return "${exit_code}"
}


# -----------------------------------------------------------------------------
# print help message with information on how to use a script
#
# NOTE: this function is only useful if the main script follows the convention
# to take a single parameter, the path to a main script configuration file
#
# Globals:
#   ${0} - evaluated to set name of main script in message
# Arguments:
#   None  - any arguments passed are silently ignored
# Returns:
#   always succeeds, returns 0
#
# Sample code:
#   usage

function usage
{
    # https://stackoverflow.com/q/192319
    # https://stackoverflow.com/a/965072
    script_name="${0##*/}"

    # NOTE: indentation added here for improved readability
    # is stripped by sed when message is printed
    read -r -d '' msg_tmpl << EOT
    Usage: %s <config file>

    mandatory arguments:
      config file           absolute path to configuration file

    optional arguments:
      -?, --help            print this help message
EOT

    # NOTE: printf strips trailing newlines
    # shellcheck disable=SC2059
    msg="$(printf "${msg_tmpl}" "${script_name}" | sed -e 's|^    ||g')"$'\n'

    echo "${msg}"

    return 0
}


# undo bash option changes so this library can be sourced
# from a live shell with changing the shell's configuration
# TODO: test if this works as expected
set +o nounset
