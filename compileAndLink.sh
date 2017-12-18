#!/bin/bash

if [ ! -f "$1.s" ]; then
    echo ERROR: File not found.
    exit 1
fi
if [ ! -f "libberry.o" ]; then
    echo libberry.o not found...
    echo Compiling libberry.o...
    as libberry.s -o libberry.o
fi
echo Compiling $1.o...
as $1.s -o $1.o || exit 2
echo Linking to libberry and wiringPi...
gcc $1.o libberry.o -o $1 -lwiringPi -lm -lpthread -lcrypt -lrt || exit 3
echo Process done
rm $1.o
