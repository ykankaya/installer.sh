#!/bin/bash

{ # This ensures the entire script is downloaded

  VERSION="1.1.0"
  LOCAL_RAW=http://localhost/installer.sh
  REMOTE_RAW=https://raw.github.com/rbarros/installer.sh/master
  ROOT_UID=0
  ARRAY_SEPARATOR="#"
  OS=""
  OS_VERSION=""
  PLATFORM=""
  ARCH=""
  PROJECT=""
  PACKAGE=""
  UPDATE="false"
  HTTPD_ROOT=""
  SERVER=""

  ##
  # Run local
  ##
  if [ "${1}" = "--local" ]; then
    URL=$LOCAL_RAW
  else
    URL=$REMOTE_RAW
  fi

  ##
  # Main
  ##
  main() {
    welcome
    clean
    download_utils
    check_plataform
  }

  ##
  # Welcome
  ##
  welcome() {
    GREEN="$(tput setaf 2)"
    printf '%s' "$GREEN"
    printf '%s\n' '.__                 __         .__  .__                          .__     '
    printf '%s\n' '|__| ____   _______/  |______  |  | |  |   ___________      _____|  |__  '
    printf '%s\n' '|  |/    \ /  ___/\   __\__  \ |  | |  | _/ __ \_  __ \    /  ___/  |  \ '
    printf '%s\n' '|  |   |  \\___ \  |  |  / __ \|  |_|  |_\  ___/|  | \/    \___ \|   Y  \'
    printf '%s\n' '|__|___|  /____  > |__| (____  /____/____/\___  >__|    /\/____  >___|  /'
    printf '%s\n' '        \/     \/            \/               \/        \/     \/     \/ '
    printf '%s\n' "                                                                v$VERSION"
    #printf '%s\n' 'Please look over the ~/.installerrc file to select plugins and options.'
    printf '%s\n'
    printf '%s\n' 'p.s. Follow us at http://github.com/rbarros/installer.sh'
    printf '%s\n' '------------------------------------------------------------------'
  }

  ##
  # Clean a scripts downloaded in temporary diretory
  ##
  clean() {
    GREEN="$(tput setaf 2)"
    printf '%s' "$GREEN"
    printf '%s\n' 'Clean scripts downloaded...'
    rm /tmp/installer-*.sh
    printf '%s\n'
  }

  ##
  # Check plataform run
  ##
  check_plataform() {
    step "Checking platform"

    # Detecting PLATFORM and ARCH
    UNAME="$(uname -a)"
    case "$UNAME" in
      Linux\ *)   PLATFORM=linux ;;
      Darwin\ *)  PLATFORM=darwin ;;
      SunOS\ *)   PLATFORM=sunos ;;
      FreeBSD\ *) PLATFORM=freebsd ;;
    esac
    case "$UNAME" in
      *x86_64*) ARCH=x64 ;;
      *i*86*)   ARCH=x86 ;;
      *armv6l*) ARCH=arm-pi ;;
    esac

    if [ -z $PLATFORM ] || [ -z $ARCH ]; then
      step_fail
      add_report "Cannot detect the current platform."
      fail
    fi

    step_done
    debug "Detected platform: $PLATFORM, $ARCH"

    if [ "$PLATFORM" = "linux" ]; then
      download_run
    else
      warn "Sorry, we're working..."
    fi
  }

  ##
  # Download a script utils
  ##
  download_utils() {
    echo -e "|   Downloading installer-utils.sh to /tmp/installer-utils.sh\n|\n|   + $(curl_or_wget $URL/utils.sh /tmp/installer-utils.sh)"

    if [ -f /tmp/installer-utils.sh ]; then
        . /tmp/installer-utils.sh
    else
        # Show error
        echo -e "|\n|   Error: The utils.sh could not be downloaded\n|"
    fi
  }

  ##
  # Download script the plataform
  ##
  download_run() {
    download "$PLATFORM-run" "$PLATFORM/run"

    if [ -f /tmp/installer-$PLATFORM-run.sh ]; then
        . /tmp/installer-$PLATFORM-run.sh
        run
    else
        # Show error
        echo -e "|\n|   Error: The script could not be downloaded\n|"
    fi
  }

  curl_or_wget() {
    CURL_BIN="curl"; WGET_BIN="wget"
    if command_exists ${CURL_BIN}; then
      $CURL_BIN -SL "$1" > "$2"
    elif command_exists ${WGET_BIN}; then
      $WGET_BIN -v -O- -t 2 -T 10 "$1" > "$2"
    fi
  }

  command_exists() {
    command -v "${@}" > /dev/null 2>&1
  }

  main "${@}"

} # This ensures the entire script is downloaded
