#!/bin/bash

# IPv6 Keygen Helper
KEYFILE="pureipv6_save"


# find myself and start from a known location
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd $SCRIPT_DIR

if [ ! -d ${SCRIPT_DIR}/terraform ] ; then
    echo "Cannot find ${SCRIPT_DIR}/terraform, aborting"
    exit 10
fi

if [ ! type ssh-keygen ] ; then
    echo "Cannot find ssh-keygen, aborting"
    exit 11
fi

ssh-keygen -t rsa -b 2048 -N "" -f ${KEYFILE}
mv ${KEYFILE}.pub terraform
