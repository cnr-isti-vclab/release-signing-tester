#!/bin/bash

#default paths wrt the script folder
SCRIPTS_PATH="$(dirname "$(realpath "$0")")"
SOURCE_PATH=$SCRIPTS_PATH/../..
BUILD_PATH=$SOURCE_PATH/build
INSTALL_PATH=$SOURCE_PATH/install/usr/
NIGHTLY_OPTION=""
QT_DIR=""
CCACHE=""

#check parameters
for i in "$@"
do
case $i in
    -s=*|--source_path=*)
        SOURCE_PATH="${i#*=}"
        shift # past argument=value
        ;;
    -b=*|--build_path=*)
        BUILD_PATH="${i#*=}"
        shift # past argument=value
        ;;
    -i=*|--install_path=*)
        INSTALL_PATH="${i#*=}"/usr/
        shift # past argument=value
        ;;
    *)
        # unknown option
        ;;
esac
done

#create build path if necessary
if ! [ -d $BUILD_PATH ]
then
    mkdir -p $BUILD_PATH
fi

#create install path if necessary
if ! [ -d $INSTALL_PATH ]
then
    mkdir -p $INSTALL_PATH
fi

BUILD_PATH=$(realpath $BUILD_PATH)
INSTALL_PATH=$(realpath $INSTALL_PATH)

cd $BUILD_PATH
export NINJA_STATUS="[%p (%f/%t) ] "
cmake -GNinja -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$INSTALL_PATH $SOURCE_PATH
ninja
ninja install
