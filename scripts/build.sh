#!/usr/bin/env bash

DIR="$( cd "$( dirname "$0" )" && pwd )"

(
	cd $DIR/../
	buck build apps/example:app
)