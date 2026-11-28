# ==============================================================================
# External ip
# ==============================================================================
EXT = ext

# #CHK
# CHK = $(EXT)/apb-checker
# CHK_PKG = $(CHK)/pkg/apb_rules_pkg.sv
# CHK_INC = $(CHK)/chk/rules
# CHK_SRC = $(wildcard $(CHK)/chk/*.sv)

# FIFO
FF = $(EXT)/sync_fifo
FF_SRC= $(FF)/rtl/sync_fifo.sv

#AGT
AGT = $(EXT)/apb_agent
AGT_INC = $(AGT)/tb $(AGT)/src
AGT_PKG = $(AGT)/pkg/apb_01_pkg.sv $(AGT)/pkg/apb_agt_pkg.sv
AGT_SRC = $(wildcard $(AGT)/src/*.sv)

#UART
UART = $(EXT)/uart
UART_PKG = $(UART)/pkg/uart_pkg.sv
UART_SRC = $(wildcard $(UART)/if/*.sv)  $(wildcard $(UART)/rtl/*.sv)

#APB_UART
PRJ := 
PRJ_INC := tb/
PRJ_PKG := pkg/apb_uart_uvm_pkg.sv
PRJ_SRC := $(wildcard rtl/*.sv)




#----------------------------------------------------------------------
# 허용 모드 목록과 모드별 READY_MODE 값 (enum: RANDOM=0, ALWAYS=1)
ALL_MODES    := ALWAYS RANDOM
READY_ALWAYS := 1
READY_RANDOM := 0

MODE   ?= ALWAYS

#----------------------------------------------------------------------
SHELL    := /bin/bash
TOP      := tb_top
TEST     := base_test
REGSEQ      := seq_reg_base
ifeq ($(TEST), reg_test)
	BUILD    := build/$(TEST)_$(REGSEQ)
else 
	BUILD    := build/$(TEST)
endif
COV := cov_report

SNAP   := $(TOP)_snap
SIMLOG := xsim.log

SRCS     := $(UART_PKG) $(FF_SRC) $(UART_SRC) $(AGT_PKG) $(AGT_SRC) $(PRJ_PKG) $(PRJ_SRC) tb/$(TOP).sv
INCDIRS  := $(AGT_INC) $(PRJ_INC)
#
# DEFS :=
# ifeq ($(BUG),1)
#   DEFS += -d BUG_INJ
# endif

VLG_OPTS := -sv -L uvm -log xvlog.log #$(DEFS)  
ELP_OPTS := -L uvm -log xelab.log
SIM_OPTS := -testplusarg UVM_TESTNAME=$(TEST) -testplusarg REGSEQ=$(REGSEQ) -R -log $(SIMLOG) # --cov_db_dir ../

.PHONY: all check compile sim run both clean wave
all: run

# MODE가 목록에 없으면 여기서 중단
# check:
# 	$(if $(filter $(MODE),$(ALL_MODES)),,$(error MODE='$(MODE)' 은 허용되지 않음. 가능한 값: $(ALL_MODES)))

compile: #check
	mkdir -p $(BUILD)
	cd $(BUILD) && xvlog $(VLG_OPTS) $(addprefix -i ../../, $(INCDIRS)) $(addprefix ../../,$(SRCS)) # > /dev/null
	cd $(BUILD) && xelab $(ELP_OPTS) -debug typical -s $(SNAP) work.$(TOP) # > /dev/null

sim: 
	@echo Simulation Start, TEST: $(TEST) MODE: $(MODE)
	@cd $(BUILD) && xsim $(SNAP) $(SIM_OPTS) # > /dev/null
	@grep -E '\[(PASS|FAIL)\]|MISMATCH|ERROR|RESULT|COVER|DEBUG|INFO' $(BUILD)/$(SIMLOG) || true

run: compile sim

both:
	@for m in $(ALL_MODES); do $(MAKE) --no-print-directory run MODE=$$m || exit 1; done

clean:
	rm -rf $(BUILD)/*

wave:
	gtkwave $(BUILD)/*.vcd &

cov:
	mkdir -p build/$(COV)
	cd build && xcrg -dir ./xsim.covdb -report_dir $(COV) -report_format html
	cd build && firefox ./cov_report/*.html &
