#!/bin/bash

SCRIPTS_PATH="$(dirname "$(realpath "$0")")"/..
RESOURCES_PATH=$SCRIPTS_PATH/../../resources
INSTALL_PATH=$SCRIPTS_PATH/../../install

#checking for parameters
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

${QT_DIR}windeployqt $INSTALL_PATH/ReleaseSigningTester.exe

cp $RESOURCES_PATH/LICENSE.txt $INSTALL_PATH/
cp $RESOURCES_PATH/privacy.txt $INSTALL_PATH/

# remove all .lib files
for file in $(find $INSTALL_PATH -name '*.lib');
do
    rm $file
done

if [ ! -f $INSTALL_PATH/vc_redist.x64.exe ]
then
    echo "Downloading vc_redist because it was missing..."
    wget https://aka.ms/vs/17/release/vc_redist.x64.exe --output-document=$INSTALL_PATH/vc_redist.x64.exe
fi