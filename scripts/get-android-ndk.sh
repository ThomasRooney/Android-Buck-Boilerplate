#!/usr/bin/env bash

DIR="$( cd "$( dirname "$0" )" && pwd )"
# Download URLs


NDK_VERSION=r8e

NDK_URL_BASE="http://dl.google.com/android/ndk/"

NDK_URL_LINUX="android-ndk-${NDK_VERSION}-linux-x86_64.tar.bz2"
NDK_URL_MAC="android-ndk-${NDK_VERSION}-darwin-x86_64.tar.bz2"

# Work out what OS we're on

if [ "$(uname)" == "Darwin" ] ; then

    OS="OSX"
    NDK_FILE_NAME=${NDK_URL_MAC}

elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ] ; then

    OS="Linux"
    NDK_FILE_NAME=${NDK_URL_LINUX}

elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ] ; then

    OS="Cygwin"
fi

mkdir -p $DIR/../dependencies/

# Download the NDK for our system from Google

if [ ! -d $DIR/../dependencies/android-ndk ] ; then
    (
        cd $DIR
        if [ ! -f ${NDK_FILE_NAME} ] ; then
            wget ${NDK_URL_BASE}${NDK_FILE_NAME}
        else
            echo "Android NDK tarball already exists."
        fi
        tar -xvf ${NDK_FILE_NAME}
        mv android-ndk-${NDK_VERSION} $DIR/../dependencies/android-ndk

        # Build a standalone toolchain if that's required
        # bash ./build/tools/make-standalone-toolchain.sh --platform=android-5 \
        #                                                 --install-dir=`pwd`/standalone-toolchain-4.7 \
        #                                                 --toolchain=arm-linux-androideabi-4.7
        #                                                 --system=linux-x86_64

    )
else
    echo "Android NDK already installed."
fi
