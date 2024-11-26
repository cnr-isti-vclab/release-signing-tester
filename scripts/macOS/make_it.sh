#!/bin/bash

SCRIPTS_PATH=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
SOURCE_PATH=$SCRIPTS_PATH/../..
BUILD_PATH=$SOURCE_PATH/build
INSTALL_PATH=$SOURCE_PATH/install
PACKAGES_PATH=$SOURCE_PATH/packages

#check parameters
for i in "$@"
do
case $i in
    -b=*|--build_path=*)
        BUILD_PATH="${i#*=}"
        shift # past argument=value
        ;;
    -i=*|--install_path=*)
        INSTALL_PATH="${i#*=}"/usr/
        shift # past argument=value
        ;;
    -p=*|--packages_path=*)
        PACKAGES_PATH="${i#*=}"
        shift # past argument=value
        ;;
    *)
        # unknown option
        ;;
esac
done

bash $SCRIPTS_PATH/1_build.sh -b=$BUILD_PATH -i=$INSTALL_PATH
bash $SCRIPTS_PATH/2_deploy.sh -i=$INSTALL_PATH -p=$PACKAGES_PATH

