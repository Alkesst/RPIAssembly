# RPISimonAssembly
We're making some programs on Assembly code for ARM architecture, we'll use the WiringPi library found at http://wiringpi.com, and a custom library called libberry. Libberry is found at this rep.

You will need to compile first the libberry.o:
```bash
    as libberry.s -o libberry.o
```
Then, when you got you'r library compiled, you'll need to link with the "main" file:
```bash
    gcc 
```
