#!/usr/bin/env bash
###
 # @Author: error: git config user.name & please set dead value or install git
 # @Email: error: git config user.email & please set dead value or install git
 # @Date: 2026-02-25 10:29:30
 # @LastEditors: error: git config user.name & please set dead value or install git
 # @LastEditTime: 2026-02-26 10:39:56
 # @LastEditors_Email: error: git config user.email & please set dead value or install git
 # @FilePath: /shadow/vendor/Modulous.framework/build.sh
 # @Description: 
 # 
 # Copyright (c) 2026 by ${git_name_email}, All Rights Reserved. 
### 
###
 # @Author: error: git config user.name & please set dead value or install git
 # @Email: error: git config user.email & please set dead value or install git
 # @Date: 2026-02-25 10:29:30
 # @LastEditors: error: git config user.name & please set dead value or install git
 # @LastEditTime: 2026-02-25 16:04:05
 # @LastEditors_Email: error: git config user.email & please set dead value or install git
 # @FilePath: /shadow/vendor/Modulous.framework/build.sh
 # @Description: 
 # 
 # Copyright (c) 2026 by ${git_name_email}, All Rights Reserved. 
### 
set -e

PWD=$(dirname -- "$0")
cd $PWD

# create fresh build directory
rm -rf $PWD/build
mkdir -p $PWD/build

rm -rf $THEOS/lib/Modulous.framework

# build main project (rootless ver.)
make clean &&
THEOS_PACKAGE_SCHEME=rootless ARCHS="arm64 arm64e" TARGET=iphone:clang:16.4:14.0 make package FINALPACKAGE=1 &&
cp -p "`ls -dtr1 packages/* | tail -1`" $PWD/build/

# build main project (rooted ver.)
make clean &&
make package FINALPACKAGE=1 &&
cp -p "`ls -dtr1 packages/* | tail -1`" $PWD/build/
