function _zpm::configuration_path()
{
  if [[ -n ${ZPM_CONFIGURATION_PATH} ]]
  then
    echo -n ${ZPM_CONFIGURATION_PATH}
  else
    echo ${HOME}/.config/zpm/plugin.conf
  fi

  return $?
}

function _zpm::is_configuration_available()
{
  [[ -f $(_zpm::configuration_path) ]]

  return $?
}

function _zpm::is_zcl_available()
{
  which zcl 1>/dev/null 2>/dev/null

  return $?
}

function _zpm::show_error_message()
{
  # Color definition is for remove dependency of colors native module.
  local -A term_colors=(red '\e[1;31m' magenta '\e[1;35m' reset '\e[0;0m')

  local message=${*}

  echo "${term_colors[red]}Error${term_colors[reset]} : ${message}" 1>&2
}

function _zpm::install_plugin()
{
  local -A config=(repository_name ${1} repository_url ${2} install_base_path ${3})
  local install_path=${config[install_base_path]}/${config[repository_name]}

  # Color definition is for remove dependency of colors native module.
  local -A term_colors=(red '\e[1;31m' magenta '\e[1;35m' cyan '\e[1;36m' reset '\e[0;0m')

  mkdir -p ${config[install_base_path]}

  if [[ -d ${install_path} ]]
  then
    echo "-> ${term_colors[magenta]}Skip (Installed)${term_colors[reset]} : ${config[repository_name]} (${config[repository_url]})"

  else
    echo "-> ${term_colors[cyan]}Installing${term_colors[reset]} : ${config[repository_name]} (${config[repository_url]}) -> ${install_path}"

    echo -n ${term_colors[magenta]}
    git clone ${config[repository_url]} ${install_path}
    echo ${term_colors[reset]}
  fi
}

function _zpm::update_plugin()
{
  local -A config=(repository_name ${1} repository_url ${2} install_base_path ${3})
  local install_path=${config[install_base_path]}/${config[repository_name]}

  # Color definition is for remove dependency of colors native module.
  local -A term_colors=(red '\e[1;31m' magenta '\e[1;35m' cyan '\e[1;36m' reset '\e[0;0m')

  if [[ -d ${install_path} ]]
  then
    echo "${term_colors[cyan]}Updating${term_colors[reset]} : ${config[repository_name]}"

    pushd ${install_path} 1>/dev/null

    echo -n ${term_colors[magenta]}
    git pull --ff-only
    echo ${term_colors[reset]}

    popd 1>/dev/null
  fi
}

function _zpm::show_plugin()
{
  # Color definition is for remove dependency of colors native module.
  local -A term_colors=(red '\e[1;31m' yellow '\e[1;33m' magenta '\e[1;35m' cyan '\e[1;36m' reset '\e[0;0m')

  local -A config=(repository_name ${1} repository_url ${2} install_base_path ${3})
  local install_path=${config[install_base_path]}/${config[repository_name]}

  local install_status_message
  if [[ -d ${install_path} ]]
  then
    install_status_message="${term_colors[cyan]}[Installed]${term_colors[reset]}"
  else
    install_status_message="${term_colors[yellow]}[Not installed]${term_colors[reset]}"
  fi

  echo "${install_status_message} ${config[repository_name]}"
  echo "    URL: ${config[repository_url]}"
  echo "    Base path : ${install_path}"
  echo ""
}

function _zpm::help()
{
  # Color definition is for remove dependency of colors native module.
  local -A term_colors=(red '\e[1;31m' green '\e[1;32m' magenta '\e[1;35m' cyan '\e[1;36m' reset '\e[0;0m')

  echo "# ${term_colors[cyan]}zpm help${term_colors[reset]}"
  echo ""

  echo "${term_colors[green]}NAME${term_colors[reset]}"
  echo "    zpm -- zsh package manager"
  echo ""

  echo "${term_colors[green]}SYNOPSIS${term_colors[reset]}"
  echo "    zpm [--install|--update|--list|--help]"
  echo ""

  echo "${term_colors[green]}DESCRIPTION${term_colors[reset]}"
  echo "    --install"
  echo "        Install plugins defined in configuration file."
  echo "        e.g.) ${term_colors[magenta]}zpm --install${term_colors[reset]}"
  echo ""
  echo "    --update"
  echo "        Update plugins defined in configuration file."
  echo "        e.g.) ${term_colors[magenta]}zpm --update${term_colors[reset]}"
  echo ""
  echo "    --list"
  echo "        List plugins status."
  echo "        e.g.) ${term_colors[magenta]}zpm --list${term_colors[reset]}"
  echo ""
  echo "    --help"
  echo "        Show this message."
  echo "        e.g.) ${term_colors[magenta]}zpm --help${term_colors[reset]}"
  echo ""
}

function zpm()
{
  #
  # Verifies requirements
  #
  if ! _zpm::is_configuration_available
  then
    _zpm::show_error_message 'Configuration file was not found.'

    return 1
  fi

  if ! _zpm::is_zcl_available
  then
    _zpm::show_error_message 'zcl command was not found.'

    return 1
  fi

  local mode=${1}
  case ${mode} in
    --install) # Runs install task
      zcl $(_zpm::configuration_path) _zpm::install_plugin :name :url :base_path
      ;;

    --update) # Runs update task
      zcl $(_zpm::configuration_path) _zpm::update_plugin :name :url :base_path
      ;;

    --list)
      zcl $(_zpm::configuration_path) _zpm::show_plugin :name :url :base_path
      ;;

    --help)
      _zpm::help
      ;;

    *)
      _zpm::help
      ;;

  esac

  return 0
}
