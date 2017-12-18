#!/bin/bash
# made by @Melchor629
as=/home/alkesst/ARMCompiler/gcc-arm/bin/arm-none-eabi-as
ld=/home/alkesst/ARMCompiler/gcc-arm/bin/arm-none-eabi-ld
objcopy=/home/alkesst/ARMCompiler/gcc-arm/bin/arm-none-eabi-objcopy

if [[ ! -f "$1" ]]; then
    echo "El archivo \`$1' no existe"
    exit 1
fi

$as -o tmp.o "$1"
if [ "$?" -ne "0" ]; then exit 1; fi
$ld -e 0 -Ttext=0x8000 tmp.o
if [ "$?" -ne "0" ]; then rm tmp.o; exit 1; fi
$objcopy a.out -O binary "${1:0:-2}.img"
rm a.out tmp.o

if [[ -d "$2" ]]; then
    cp "${1:0:-2}.img" "$2/kernel.img"
fi
