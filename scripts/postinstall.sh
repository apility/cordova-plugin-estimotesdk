#!/bin/bash

rootDir=`pwd`
targetDir=$rootDir/platforms/ios

cd $targetDir
pod install
cd $rootDir

exit 0