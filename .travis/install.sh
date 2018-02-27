#!/bin/bash

if [[ $TRAVIS_OS_NAME == 'linux' ]]; then

  sudo add-apt-repository ppa:ubuntugis/ubuntugis-unstable --yes
  sudo apt-get --yes --force-yes update -qq

  # install tmap dependencies
  sudo apt-get install --yes libprotobuf-dev protobuf-compiler libv8-3.14-dev

  # install tmap dependencies; for 16.04 libjq-dev this ppa is needed:
  sudo add-apt-repository -y ppa:opencpu/jq
  sudo apt-get --yes --force-yes update -qq
  sudo apt-get install libjq-dev

  # units/udunits2 dependency:
  sudo apt-get install --yes libudunits2-dev

  # sf dependencies:
  sudo apt-get install --yes libproj-dev libgeos-dev libgdal-dev

  # postgis source compile dependencies:
  sudo apt-get --yes install libjson-c-dev postgresql-server-dev-9.6

  # install postgis from source:
  wget http://download.osgeo.org/postgis/source/postgis-2.3.2.tar.gz
  (mv postgis* /tmp; cd /tmp; tar xzf postgis-2.3.2.tar.gz)
  (cd /tmp/postgis-2.3.2 ; ./configure; make; sudo make install)

  # create postgis databases:
  sudo service postgresql restart
  createdb postgis
  psql -d postgis -c "CREATE EXTENSION postgis;"
  psql -d postgis -c "GRANT CREATE ON DATABASE postgis TO travis"
  createdb empty
  psql -d empty -c "CREATE EXTENSION postgis;"

fi
