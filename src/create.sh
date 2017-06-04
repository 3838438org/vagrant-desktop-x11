#!/bin/bash
#=============================================================================
#
#          FILE:  create.sh
#
#         USAGE:  ./create.sh
#
#   DESCRIPTION: Constructs the vagrant environment with provided arguments.
#
#       OPTIONS:  ---
#  REQUIREMENTS:  ---
#         NOTES:  ---
#        AUTHOR:  jrbeverly
#
#==============================================================================
set -e

# 
# Variables
# 
SCRIPT=$(readlink -f "$0")
DIR="$(dirname $SCRIPT)"
ROOT_DIR="$(dirname $DIR)"
ENVIRONMENT_DIR="${DIR}/packaging/environments"

NAME=""
DESKTOP=""

# Options
#
# Parses the options provided to the script.
while getopts "h?:n:d:" opt; do
    case $opt in
        h|\?)
            echo "Usage: $0 -n NAME -d DESKTOP"
            echo
            echo "Starts the vagrant environment with provided arguments." 
            exit 0
        ;;
        n) NAME=$OPTARG
        ;;
        d) DESKTOP=$OPTARG
        ;;
    esac
done

if [[ -z "$NAME" ]]; then
    echo "The argument '-n NAME' was not provided."
    exit 1
fi

if [[ -z "$DESKTOP" ]]; then
    echo "The argument '-d DESKTOP' was not provided."
    exit 1
fi

DESKTOP_SCRIPT="$ENVIRONMENT_DIR/$DESKTOP.sh"
if [ ! -f "$DESKTOP_SCRIPT" ]
then
    echo "The argument '-d DESKTOP' does not match any of the environments available in 'environments/'."
    exit 1
fi

#
# Vagrant
#
cd $DIR

echo "Preparing the environment, this will take a while."
vagrant --name=$NAME --desktop=$DESKTOP up
sleep 10

echo "Shutdowning the newly created environment"
vagrant halt
sleep 5

echo "The environment is ready!"
vagrant up