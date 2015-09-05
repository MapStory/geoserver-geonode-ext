#!/bin/bash
# exit if anything returns failure
set -e

rm -rf temp-build-dir
mkdir temp-build-dir
cd temp-build-dir
REPOS_DIR=`pwd`

git clone -b mapstory-2.6.x https://github.com/mapstory/geoserver-geonode-ext.git
cd geoserver-geonode-ext
# only run clean, do not run install yet
mvn clean -DskipTests
cd ${REPOS_DIR}

# adds support for xdate needed for importing layers with time attrib
git clone -b postgis-xdate-udt-12.x https://github.com/mapstory/geotools.git
cd geotools 
mvn install -DskipTests
cd ${REPOS_DIR}

# gets latest geogig to fix a transaction end bug. check for nightly builds can drop this if up-to-date
git clone -b master https://github.com/locationtech/geogig.git
cd geogig/src/parent
mvn install -DskipTests
cd ${REPOS_DIR}

# has a date fix which allows importing layers with time attrib into geogig
git clone -b 2.6.x https://github.com/rogue-jctd/geoserver.git
cd geoserver/src/extension/importer
mvn install -DskipTests
cd ${REPOS_DIR}

# build latest 2.6.x geogig rest api, no nightly snapshots available. 
# pull it in from rogue since needed a build fix for jline
git clone -b 2.6.x https://github.com/rogue-jctd/geoserver-exts.git
cd geoserver-exts/geogig
mvn install -DskipTests
cd ${REPOS_DIR}

cd geoserver-geonode-ext
mvn install -DskipTests
mvn war:war

