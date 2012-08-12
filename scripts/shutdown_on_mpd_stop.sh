#!/bin/bash

echo 'WARNING: This script will shutdown the computer when the music stops'
while mpc | grep -Fqso 'playing'; do
    :
done

shutdown -h now
