#!/usr/bin/env bash

DIR="$( cd "$( dirname "$0" )" && pwd )"

# Accept all licences.
(while :
do
  echo 'y'
  sleep 2
done) | $DIR/../dependencies/android-sdk/tools/android update sdk -u --filter platform-tools,android-8,android-16,extra-android-support,37,2
