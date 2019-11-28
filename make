ca65 main.s # Take ca65 source code, make main.o from it
ld65 -t nes -o demo.nes main.o # use nes.cfg to map memory, output demo.nes (with iNES header) by linking main.o
