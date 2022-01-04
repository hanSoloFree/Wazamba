#!/bin/bash

set -eo pipefail

xcodebuild -workspace "$NAME".xcworkspace \
            -scheme "$NAME" \
            -sdk iphoneos \
            -configuration AppStoreDistribution \
            -archivePath $PWD/build/"$NAME".xcarchive \
            clean archive | xcpretty
