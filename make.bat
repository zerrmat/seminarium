@echo off
REM Delete previous build files
del main.o
del demo.nes
echo Previous files deleted!
REM Take ca65 source code, make main.o from it
REM Also check for assembler error according to: https://stackoverflow.com/questions/734598/how-do-i-make-a-batch-file-terminate-upon-encountering-an-error/8965092#8965092
ca65 main.s || goto :error
echo Object file generated!
REM Use nes.cfg to map memory, output demo.nes (with iNES header) by linking main.o
REM Also check for linker error according to: https://stackoverflow.com/questions/734598/how-do-i-make-a-batch-file-terminate-upon-encountering-an-error/8965092#8965092
ld65 -t nes -o demo.nes main.o || goto :error
echo ROM successfully assembled!
goto :EOF

:error
echo.
echo !!!!!!!!!!!!!!!!!!!!Script failed!!!!!!!!!!!!!!!!!!
exit /b %errorlevel%

:EOF

