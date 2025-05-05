#!/bin/bash -eux

SCRIPT_DIR=$(cd "$(dirname $0)/.."; pwd)
echo "SCRIPT_DIR=$SCRIPT_DIR"

. $SCRIPT_DIR/../config/version.sh
. $SCRIPT_DIR/../config/package.sh

ARCH=$(arch)
if [ "$ARCH" = "x86_64" ]; then
	arch="amd64"
else
	arch="arm64"
fi

sed -e "s|@PACKAGES_DEVELOPMENT@|${PACKAGES_DEVELOPMENT}|g" \
    -e "s|@PACKAGES_PYTHON@|${PACKAGES_PYTHON}|g" \
    -e "s|@PACKAGES_APPLICATION@|${PACKAGES_APPLICATION_MA5}|g" \
    -e "s|@PACKAGES_APPLICATION_GUI@|${PACKAGES_APPLICATION_GUI_MA5}|g" \
    ${SCRIPT_DIR}/script/materiapps.sh.in > ${SCRIPT_DIR}/script/materiapps-ma5.sh
