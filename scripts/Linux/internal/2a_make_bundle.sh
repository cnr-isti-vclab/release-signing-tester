#!/bin/bash

SCRIPTS_PATH="$(dirname "$(realpath "$0")")"/../
RESOURCES_PATH=$SCRIPTS_PATH/../../resources
SOURCE_PATH=$SCRIPTS_PATH/../../src
INSTALL_PATH=$SOURCE_PATH/../install

#check parameters
for i in "$@"
do
case $i in
    -i=*|--install_path=*)
        INSTALL_PATH="${i#*=}"
        shift # past argument=value
        ;;
    *)
        # unknown option
        ;;
esac
done

#check if we have an exec in distrib
if ! [ -f $INSTALL_PATH/usr/bin/ReleaseSigningTester ]
then
    echo "ERROR: ReleaseSigningTester bin not found inside $INSTALL_PATH/usr/bin/"
    exit 1
fi

mkdir -p $INSTALL_PATH/usr/share/doc/rst
mkdir -p $INSTALL_PATH/usr/share/icons/Yaru/256x256@2x/apps/
mkdir -p $INSTALL_PATH/usr/share/icons/Yaru/256x256/apps/

cp $RESOURCES_PATH/linux/rst.desktop $INSTALL_PATH/usr/share/applications/rst.desktop
cp $RESOURCES_PATH/icons/rst512.png $INSTALL_PATH/usr/share/icons/Yaru/256x256@2x/apps/rst.png
cp $RESOURCES_PATH/icons/rst256.png $INSTALL_PATH/usr/share/icons/Yaru/256x256/apps/rst.png
cp $RESOURCES_PATH/LICENSE.txt $INSTALL_PATH/usr/share/doc/rst/
cp $RESOURCES_PATH/privacy.txt $INSTALL_PATH/usr/share/doc/rst/
cp $RESOURCES_PATH/readme.txt $INSTALL_PATH/usr/share/doc/rst/

chmod +x $INSTALL_PATH/usr/bin/ReleaseSigningTester