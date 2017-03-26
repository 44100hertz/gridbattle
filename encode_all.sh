#!/bin/bash
mkdir out

ffmpeg -loglevel error -framerate 60 -i $1/%0d.tga -lavfi "scale=iw*8:ih*8:flags=neighbor,fps=30" -pix_fmt yuv420p out/twitter.mp4

ffmpeg -loglevel error -framerate 60 -i $1/%0d.tga -lavfi "scale=iw*8:ih*8:flags=neighbor" -pix_fmt yuv420p out/ideal.mkv

