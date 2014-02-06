#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
(cd $DIR/.. ; git archive --format tar.gz HEAD > android-example-src.tar.gz)
