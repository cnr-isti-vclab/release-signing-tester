#!/bin/bash

SCRIPTS_PATH="$(dirname "$(realpath "$0")")"/..

INSTALL_PATH=$SCRIPTS_PATH/../../install
APPNAME="ReleaseSigningTester.app"

#checking for parameters
for i in "$@"
do
case $i in
    -i=*|--install_path=*)
        INSTALL_PATH="${i#*=}"
        shift # past argument=value
        ;;
    --use_brew_qt)
        QT_DIR=$(brew --prefix qt@5)
        shift # past argument=value
        ;;
    *)
        # unknown option
        ;;
esac
done

ARGUMENTS=""

QT_BASE_DIR=""

# save in message the output of macdeployqt
message=$(${QT_BASE_DIR}macdeployqt $INSTALL_PATH/$APPNAME \
    $ARGUMENTS 2>&1)

# if message contains "ERROR" then macdeployqt failed
if [[ $message == *"ERROR"* ]]; then
    echo "macdeployqt failed."
    echo "macdeployqt output:"
    echo $message
    exit 1
fi

# remove everything from install path, except the appbundle
cd $INSTALL_PATH
ls | grep -xv "${APPNAME}" | xargs rm

echo "$INSTALL_PATH is now a self contained ReleaseSigningTester application"
