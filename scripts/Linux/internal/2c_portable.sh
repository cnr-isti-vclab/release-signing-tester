#!/bin/bash

shopt -s extglob

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

# Make sure that deploy succeeds before we start deleting files
if $RESOURCES_PATH/linux/x86_64/linuxdeploy --appdir=$INSTALL_PATH --plugin qt; then

  echo "$INSTALL_PATH is now a self contained ReleaseSigningTester application"

else
  echo "linuxdeploy failed with error code $?. Script was not completed successfully."
  exit 1
fi
