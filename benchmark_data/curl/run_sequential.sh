#! /bin/bash

INPUTFILE=$1
time parallel -j1 -a ${INPUTFILE} bash -c
