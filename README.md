# RPISimonAssembly

### Requierements

  - [WiringPi][1]
  - Raspberry pi
  - Breadboard, leds, ressistances, buttons and buzzer

### Usage
For compile and link with all the libraries you can use compileAndLink.sh. The script will create the dicerollSimulator.o and will link it to libberry.o and wiringPi. 
```bash
./compileAndLink.sh dicerollSimulator
```
Make run the program with high priority:

```bash
chrt —rr 99./dicerollSimulator
```
  
 


  [1]: http://wiringpi.com
