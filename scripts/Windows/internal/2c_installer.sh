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

# Make nsis script

cp $RESOURCES_PATH/windows/rst.nsi $RESOURCES_PATH/windows/rst_final.nsi
sed -i "s%DISTRIB_PATH%.%g" $RESOURCES_PATH/windows/rst_final.nsi

mv $RESOURCES_PATH/windows/rst_final.nsi $INSTALL_PATH/
cp $RESOURCES_PATH/windows/ExecWaitJob.nsh $INSTALL_PATH/
cp $RESOURCES_PATH/windows/FileAssociation.nsh $INSTALL_PATH/

# Make Installer

makensis.exe $INSTALL_PATH/rst_final.nsi

rm $INSTALL_PATH/rst_final.nsi
rm $INSTALL_PATH/ExecWaitJob.nsh
rm $INSTALL_PATH/FileAssociation.nsh

mkdir $PACKAGES_PATH

# get the name of the installer file, without the path
INSTALLER_NAME=$(basename $INSTALL_PATH/ReleaseSigningTester*-windows.exe)

# get the name of the installer without the extension
INSTALLER_NAME=${INSTALLER_NAME%.*}

# get running architecture
ARCH=$(uname -m)

# append the architecture and extension to the installer name
INSTALLER_NAME=${INSTALLER_NAME}_$ARCH.exe

# rename the installer and move it to the packages folder
mv $INSTALL_PATH/ReleaseSigningTester*-windows.exe $INSTALL_PATH/$INSTALLER_NAME
mv $INSTALL_PATH/$INSTALLER_NAME $PACKAGES_PATH




