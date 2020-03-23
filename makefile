# Makefile
# Useful info (PL): https://cpp-polska.pl/post/potwor-przeszlosci-makefile-cz-1
# Suppress output: https://stackoverflow.com/a/11872095
# Don't output commands from makefile to shell: https://stackoverflow.com/a/18363477

BIN_DIR = ./bin
CA65 = ${BIN_DIR}/ca65.exe
LD65 = ${BIN_DIR}/ld65.exe
SRC_DIR = ./PRG
OBJ_DIR = ${BIN_DIR}/obj
OBJS = $(patsubst %, ${OBJ_DIR}/%.o, ${TARGET})
TARGET = main title_zp
PRG_NAME = demo
ROM_NAME = ${PRG_NAME}.nes
ROM_DIR = ./${ROM_NAME}
DBG_NAME = {$PRG_NAME}.dbg
DBG_DIR = ${BIN_DIR}/${DBG_NAME}
CFG_DIR = ${BIN_DIR}

NO_COLOR = \033[0m
RED_COLOR = \033[31;01m
GREEN_COLOR = \033[32;01m

COMPILATION_STRING = ${GREEN_COLOR}[$@.s]${NO_COLOR} Compiling...
COMPILATION_FAILED = ${RED_COLOR}[$@.s] ca65 failed, error $$?${NO_COLOR}
COMPILATION_SUCCESS = ${GREEN_COLOR}ROM successfully assembled!${NO_COLOR}
LINKING_FAILED = ${RED_COLOR}ld65 failed, error $$?${NO_COLOR}

make: ${TARGET}
# Use nes.cfg to map memory, output demo.nes (with iNES header) by linking main.o
#@echo OBJS: ${OBJS}
	@./bin/ld65.exe -t nes --cfg-path ${CFG_DIR} --dbgfile {DBG_DIR} -o ${ROM_DIR} ${OBJS} || (echo -e "${LINKING_FAILED}"; exit 2)
	@echo -e "${COMPILATION_SUCCESS}"
	
${TARGET}: %: ${SRC_DIR}/%.s
# Take ca65 source code, make main.o from it
	@echo -e "${COMPILATION_STRING}"
	@${CA65} -W2 -l ${BIN_DIR}/$@.lst -g $< -o ${OBJ_DIR}/$@.o || (echo -e "${COMPILATION_FAILED}"; exit 1)
	
clean:
	rm ${OBJ_DIR}/main.o
	rm ${OBJ_DIR}/title_zp.o
	rm ${BIN_DIR}/main.lst
	rm ${BIN_DIR}/title_zp.lst
	rm ./demo.nes
	
# Silent make execution: https://www.gnu.org/software/make/manual/html_node/Echoing.html
run:
	@make -s
	@echo "Wait for emulator to open and run ROM file"
	@./Mesen demo.nes