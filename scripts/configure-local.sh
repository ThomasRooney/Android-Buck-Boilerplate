#!/usr/bin/env bash

DIR="$( cd "$( dirname "$0" )" && pwd )"

(
	cd $DIR/../
	echo sdk.dir=`pwd`/dependencies/android-sdk/ > local.properties
	if [ -d `pwd`/dependencies/android-ndk ] ; then
		echo ndk.home=`pwd`/dependencies/android-ndk/ >> local.properties
		echo ndk.dir=`pwd`/dependencies/android-ndk/ >> local.properties
	fi
	echo jni.loglevel=info >> local.properties
)