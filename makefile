# Makefile
# Useful info (PL): https://cpp-polska.pl/post/potwor-przeszlosci-makefile-cz-1
# Suppress output: https://stackoverflow.com/a/11872095
# Don't output commands from makefile to shell: https://stackoverflow.com/a/18363477
main:
# Take ca65 source code, make main.o from it
	@./ca65.exe -W2 -l main.lst -g main.s || (echo "ca65 failed, error $$?"; exit 1)
	@echo Object file generated!
# Use nes.cfg to map memory, output demo.nes (with iNES header) by linking main.o
	@./ld65.exe -t nes --dbgfile demo.dbg -o demo.nes main.o || (echo "ld65 failed, error $$?"; exit 2)
	@echo ROM successfully assembled!
	
clean:
	rm main.o
	rm main.lst
	rm demo.nes
	
# Silent make execution: https://www.gnu.org/software/make/manual/html_node/Echoing.html
run:
	@make -s
	@echo "Wait for emulator to open and run ROM file"
	@./Mesen demo.nes