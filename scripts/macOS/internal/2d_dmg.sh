#!/bin/bash

SCRIPTS_PATH="$(dirname "$(realpath "$0")")"/..
RESOURCES_PATH=$SCRIPTS_PATH/../../resources
INSTALL_PATH=$SCRIPTS_PATH/../../install
PACKAGES_PATH=$SCRIPTS_PATH/../../packages

#checking for parameters
for i in "$@"
do
case $i in
    -i=*|--install_path=*)
        INSTALL_PATH="${i#*=}"
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

if ! [ -e $INSTALL_PATH/ReleaseSigningTester.app -a -d $INSTALL_PATH/ReleaseSigningTester.app ]
then
    echo "Started in the wrong dir: I have not found the ReleaseSigningTester.app"
    exit -1
fi

# final step create the dmg using appdmg
# appdmg is installed with 'npm install -g appdmg'",
sed "s%DISTRIB_PATH%$INSTALL_PATH%g" $RESOURCES_PATH/macos/rst_dmg_latest.json > $RESOURCES_PATH/macos/rst_dmg_final.json
sed -i '' "s%RESOURCES_PATH%$RESOURCES_PATH%g" $RESOURCES_PATH/macos/rst_dmg_final.json

rm -f $INSTALL_PATH/*.dmg

mkdir $PACKAGES_PATH

# get running architecture
ARCH=$(uname -m)

appdmg $RESOURCES_PATH/macos/rst_dmg_final.json $PACKAGES_PATH/ReleaseSigningTester-macos_$ARCH.dmg

rm $RESOURCES_PATH/macos/rst_dmg_final.json