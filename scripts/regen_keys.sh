#!/usr/bin/env bash

DIR="$( cd "$( dirname "$0" )" && pwd )"

if [ -f $DIR/../apps/example/debug.keystore ] ; then
  rm $DIR/../apps/example/debug.keystore
fi

keytool -genkey -noprompt \
 -keystore $DIR/../apps/example/debug.keystore \
 -alias      buckexample \
 -dname "CN=www.roonster.net, O=Thomas Rooney, C=GB" \
 -storepass buckexamplepassword \
 -keypass buckexamplepassword \
 -keyalg RSA -keysize 2048 -validity 10000