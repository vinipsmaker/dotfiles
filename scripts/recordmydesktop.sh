#!/usr/bin/env bash

OUT="$1"

if [ -z "$OUT" ]; then
    echo 'Output file will be out.mkv'
    OUT='out.mkv'
else
    echo "${OUT}" | grep '\.mkv$'
    if [ "$?" != 0 ]; then
        OUT="${OUT}.mkv"
    fi
fi

gst-launch-0.10 matroskamux name=mux ! filesink location="$OUT" \
    ximagesrc ! video/x-raw-rgb,framerate=10/1 ! ffmpegcolorspace ! theoraenc ! queue leaky=2 ! mux. \
    pulsesrc ! vorbisenc ! queue leaky=2 ! audio/x-vorbis ! mux.
