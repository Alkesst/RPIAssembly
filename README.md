# RPIAssembly

### Requierements

  - [WiringPi][1]
  - Raspberry pi
  - Breadboard, leds, ressistances, buttons and buzzer
  - [gcc-arm][2]

### Usage
Using the WiringPi library is requiered compiling as follows:
For compile and link with all the libraries you can use compileAndLink.sh. The script will create the dicerollSimulator.o and will link it to libberry.o and wiringPi.
```bash
./compileAndLink.sh dicerollSimulator
```
Make run the program with high priority:

```bash
chrt —rr 99./dicerollSimulator
```
If no libraries are being used, it is requiered to use the script build.sh. You will also need gcc-arm for ArchLinux

Compile the project like this:
```bash
./build.sh *sourceFile*
```
If a second argument is given, the script will automaticaly copy the generated image into the path given as second argument.

Base.inc stores all the macros referring to memory positions in the raspberry, thus avoiding having to define them in all the headers.



Special thanks to: [Melchor Garau][3] and [Atanasio Rubio][4]

  [1]: http://wiringpi.com
  [2]: https://aur.archlinux.org/packages/gcc-arm-none-eabi-bin/
  [3]: http://github.com/Melchor629
  [4]: http://github.com/TaxoRubio
