#!/bin/bash

retval=1

function ifExists(){
    echo "checking existence for $1"
    # check via other methods too
    $1 --version 
    if [ $? -eq 0 ]
    then
        echo "$1 present."
        retval=0
    else
        echo "$1 : Not present"
        retval=1
    fi
}

function awscliInstall(){
    pip3 install awscli --upgrade --user
}


ifExists aws
if [ $retval -ne 0 ]
then
    echo "installing aws cli"
    awscliInstall
else
    echo "aws cli already installed!"
fi