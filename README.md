# uno-make
A barebones Makefile to develop quickly for the Arduino Uno.

The project also includes the source code for the Arduino library which is built on first compile automatically. The library is taken from the arduino library shipped with version 1.6.7 of the IDE. This Makefile is adapted from the tutorial presented here: https://www.ashleymills.com/node/327.

The Makefile assumes that the avr-gcc tools and avrdude are setup on your system and that you have permissions to access the relevant port for the Uno, /dev/ttyACM0 for Linux and /dev/cuaU0 on FreeBSD.

Invoking the Makefile will build and upload to the device itself. The build recipe can be used to just build the code into a hex file for uploading to the device. The upload recipe will upload main.hex to the device.

The Makefile will expect all source code to be in the src directory with corresponding .cpp or .c extensions, everything else will be ignored. It will create a matching obj and dep tree for objects and include dependancies, respectively.

The sample code talks to through the USB back to the computer. When 'r' is pressed, the LED at pin 13 will turn on. If any other key is pressed, the LED will turn off. You will need a program to talk to the Arduino. minicomp can be used on ubuntu. On my machine, sudo minicom -D /dev/ttyACM0, will start the communication. 
