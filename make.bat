REM Delete previous build files
del main.o
del demo.nes
REM Take ca65 source code, make main.o from it
ca65 main.s
REM use nes.cfg to map memory, output demo.nes (with iNES header) by linking main.o
ld65 -t nes -o demo.nes main.o 
