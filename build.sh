#!/bin/bash

PROGRAM_NAME=$1
BIN_NAME="main"

if [ -f "$PROGRAM_NAME" ]
then
  clang -Wall -Werror -o $BIN_NAME $PROGRAM_NAME
else
  if [ "$PROGRAM_NAME" = "" ]
  then
    echo "ERROR: target not specified"
  else
    echo "ERROR: $PROGRAM_NAME not found"
  fi
  exit 1
fi
