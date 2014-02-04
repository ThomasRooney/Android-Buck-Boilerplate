#!/usr/bin/env bash

DIR="$( cd "$( dirname "$0" )" && pwd )"


if [ "$(uname)" == "Darwin" ] ; then
    OS="OSX"
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ] ; then
    OS="Linux"
elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ] ; then
    OS="Cygwin"
fi


mkdir -p $DIR/../dependencies/

if [ ! -d $DIR/../dependencies/android-sdk ] ; then
	(
		cd $DIR
		if [ ${OS} == "Linux" ] ; then
			wget http://dl.google.com/android/android-sdk_r22.2-linux.tgz
			tar -xf android-sdk_r22.2-linux.tgz
			mv android-sdk-linux ../dependencies/android-sdk
		elif [ ${OS} == "OSX" ] ; then
			wget http://dl.google.com/android/android-sdk_r22.2-macosx.zip
			unzip android-sdk_r22.2-macosx.zip
			mv android-sdk-macosx ../dependencies/android-sdk
		else
			echo "Unsupported Operating System Detected: ${OS}"
		fi
	)
else
	echo "android-sdk already exists!"
fi

