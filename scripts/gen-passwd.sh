#!/bin/bash

NUM=8
[ $1 ] && NUM=$1

tr -c -d '[:graph:]' < /dev/urandom | dd count=$NUM bs=1 2>/dev/null  ; echo
