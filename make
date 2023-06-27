#!/bin/bash

set -e

build_number=`cat build_number.txt`
build_number=$((${build_number}+1))
echo "${build_number}" > build_number.txt

# For macOS -- don't have a good way to run sed in-place without creating a backup file, so delete it after
sed -i".bak" -e "s/buildNumber=.*/buildNumber=${build_number}/" source/pdxinfo
rm source/pdxinfo.bak

pdc source build/nightcrawlers.pdx
open build/nightcrawlers.pdx
