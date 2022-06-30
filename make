#!/bin/bash

set -e

build_number=`cat build_number.txt`
build_number=$((${build_number}+1))
echo "${build_number}" > build_number.txt
sed "s/buildNumber=.*/buildNumber=${build_number}/" source/pdxinfo > source/pdxinfo

pdc source build/nightcrawlers.pdx
open build/nightcrawlers.pdx
