#!/usr/bin/env bash

DIR="$( cd "$( dirname "$0" )" && pwd )"

mkdir -p $DIR/../dependencies
(
	cd $DIR/../dependencies
	git clone https://github.com/facebook/buck.git
	cd buck
	ant
	sudo ln -s ${DIR}/bin/buck /usr/bin/buck
)
