# RPISimonAssembly

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
If not using any library, is requiered to use the script build.sh. Also you will need gcc-arm for ArchLinux

Compile the project with ./build.sh and an image will appear in $(pwd).



  [1]: http://wiringpi.com
  [2]: https://aur.archlinux.org/packages/gcc-arm-none-eabi-bin/
