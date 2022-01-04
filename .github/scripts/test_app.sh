#!/bin/bash

set -eo pipefail

xcodebuild -workspace "$NAME".xcworkspace \
            -scheme "$NAME"\ iOS \
            -destination platform=iOS\ Simulator,OS=13.3,name=iPhone\ 11 \
            clean test | xcpretty
