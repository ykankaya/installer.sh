#!/bin/bash

{ # This ensures the entire script is downloaded

  php_main() {
    debug "Install php $DISTRO $RELEASE"
    super -v+ $PACKAGE install php5 php5-dev php5-mcrypt php5-common php5-curl php5-cli php5-gd php5-json php5-xml libapache2-mod-php5 php5-zip php-pear build-essential
    super -v+ a2enmod rewrite
  }

  php_main "${@}"

} # This ensures the entire script is downloaded