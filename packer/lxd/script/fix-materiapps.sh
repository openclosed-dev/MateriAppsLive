#!/bin/bash
set -eu

# Fix URL scheme for MatNavi
sed -i 's/http:/https:/g' /usr/share/applications/database-matnavi.desktop
