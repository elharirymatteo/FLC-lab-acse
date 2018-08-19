# Acse version: acse_1.1.2

.PHONY : all clean patch_compile_execute patch_apply patch_create_new \
compile_compiler compile_program execute_program restore_acse clean_all_ex \
check_arg_ex


ifndef ACSE_DIR
$(error ACSE_DIR is not set)
endif


# by default compile compiler, compile program and execute it
all: compile_compiler compile_program execute_program

# apply the exercise patch before the the default
patch_compile_execute: patch_apply all


patch_apply: check_arg_ex
	patch --no-backup-if-mismatch -Np1 -d ${ACSE_DIR} -i ../${ex}/${ex}.patch
	@echo Patch applied
	@echo


.ONESHELL:
patch_create_new: check_arg_ex
	mkdir -p ${ex}
	git diff > ${ex}/${ex}.patch

compile_compiler:
	$(MAKE) -C ${ACSE_DIR}


.ONESHELL:
compile_program: check_arg_ex
	cd ${ex}
	../${ACSE_DIR}/bin/acse program.src
	../${ACSE_DIR}/bin/asm output.asm


.ONESHELL:
execute_program: check_arg_ex
	cd ${ex}
	../${ACSE_DIR}/bin/mace output.o


clean: clean_acse clean_all_ex
	$(MAKE) -C ${ACSE_DIR} clean


clean_acse:
	rm */**/*.rej
	git ck -- ${ACSE_DIR}
	@echo Acse dir restored
	@echo

clean_all_ex:
	rm -f **/*.o
	rm -f **/*.cfg
	rm -f **/*.asm
	rm -f **/*.out


check_arg_ex:
ifndef ex
	$(error ex= argument not passed. E.g. ex=01-smthg)
endif

