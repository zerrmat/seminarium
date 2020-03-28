# Makefile
# Useful info (PL): https://cpp-polska.pl/post/potwor-przeszlosci-makefile-cz-1
# Suppress output: https://stackoverflow.com/a/11872095
# Don't output commands from makefile to shell: https://stackoverflow.com/a/18363477

BIN_DIR = ./bin
SRC_DIR = ./PRG
OBJ_DIR = ${BIN_DIR}/obj
ROM_DIR = .
DBG_DIR = ${BIN_DIR}
CFG_DIR = ${BIN_DIR}
LST_DIR = ./bin/lst

CA65 = ${BIN_DIR}/ca65.exe
LD65 = ${BIN_DIR}/ld65.exe

TARGET = main prg_zp title_bss registers romheader title_main title_nmi \
		title_subs title_data warmup init_subs prg_bss prg_subs
OBJ = $(patsubst %, ${OBJ_DIR}/%.o, ${TARGET})
SRCNAMES = $(patsubst %, ${SRC_DIR}/%.s, ${TARGET})

PRG_NAME = demo
ROM_NAME = ${PRG_NAME}.nes
DBG_NAME = ${PRG_NAME}.dbg

DBG_FILE = ${DBG_DIR}/${DBG_NAME}

NO_COLOR = \033[0m
RED_COLOR = \033[31;01m
GREEN_COLOR = \033[32;01m

COMPILATION_FILENAME = $(patsubst bin/obj/%.o,%.s, $@)
COMPILATION_STRING = ${GREEN_COLOR}[${COMPILATION_FILENAME}]${NO_COLOR} Compiling...
COMPILATION_FAILED = ${RED_COLOR}[$@.s] ca65 failed, error $$?${NO_COLOR}
COMPILATION_SUCCESS = ${GREEN_COLOR}ROM successfully assembled!${NO_COLOR}
LINKING_FAILED = ${RED_COLOR}ld65 failed, error $$?${NO_COLOR}
LINKING_STRING = Linking files...
	
make: ${OBJ}
#@echo OBJ: ${OBJ}
	@echo -e "${LINKING_STRING}"
	@${LD65} -t nes --cfg-path ${CFG_DIR} --dbgfile ${DBG_FILE} -o ${ROM_DIR}/${ROM_NAME} $^ || (echo -e "${LINKING_FAILED}"; exit 2)
	@echo -e "${COMPILATION_SUCCESS}"
	
${OBJ_DIR}/%.o: ${SRC_DIR}/%.s 
	@echo -e "${COMPILATION_STRING}"
	@${CA65} -W1 -g -l $@.lst -o $@ $< || (echo -e "${COMPILATION_FAILED}"; exit 1)
	
clean:
	rm ${OBJ_DIR}/main.o
	rm ${OBJ_DIR}/registers.o
	rm ${OBJ_DIR}/romheader.o
	rm ${OBJ_DIR}/title_bss.o
	rm ${OBJ_DIR}/title_data.o
	rm ${OBJ_DIR}/title_main.o
	rm ${OBJ_DIR}/title_nmi.o
	rm ${OBJ_DIR}/title_subs.o
	rm ${OBJ_DIR}/prg_zp.o
	rm ${OBJ_DIR}/warmup.o
	rm ${OBJ_DIR}/init_subs.o
	rm ${OBJ_DIR}/prg_bss.o
	rm ${OBJ_DIR}/prg_subs.o
	
	rm ${OBJ_DIR}/main.o.lst
	rm ${OBJ_DIR}/registers.o.lst
	rm ${OBJ_DIR}/romheader.o.lst
	rm ${OBJ_DIR}/title_bss.o.lst
	rm ${OBJ_DIR}/title_data.o.lst
	rm ${OBJ_DIR}/title_main.o.lst
	rm ${OBJ_DIR}/title_nmi.o.lst
	rm ${OBJ_DIR}/title_subs.o.lst
	rm ${OBJ_DIR}/prg_zp.o.lst
	rm ${OBJ_DIR}/warmup.o.lst
	rm ${OBJ_DIR}/init_subs.o.lst
	rm ${OBJ_DIR}/prg_bss.o.lst
	rm ${OBJ_DIR}/prg_subs.o.lst
	rm ${DBG_FILE}
	rm ./demo.nes
	
# Silent make execution: https://www.gnu.org/software/make/manual/html_node/Echoing.html
run:
	@make -s
	@echo "Wait for emulator to open and run ROM file"
	@./Mesen demo.nes