PROJ = main
PIN_DEF = constrains/$(PROJ).pcf
FPGA_PKG = sg48
FPGA_TYPE = up5k
STOP_TIME = 500ns

WORK_DIR = work
LIB_DIR = lib
TEST_DIR = test
SRC_DIR = src
SIM_DIR = simulation

STD = 08

SRC_FILES := $(wildcard $(SRC_DIR)/*.vhd) $(wildcard $(SRC_DIR)/**/*.vhd)
LIB_VHD_FILES := $(wildcard $(LIB_DIR)/*.vhd)
LIB_FILES := $(LIB_VHD_FILES:.vhd=-obj$(STD).cf)
WORK_FILE := $(WORK_DIR)/work-obj$(STD).cf
TEST_VHD_FILES := $(wildcard $(TEST_DIR)/*.vhd)
TEST_FILES := $(subst $(TEST_DIR),$(SIM_DIR),$(TEST_VHD_FILES:.vhd=))
WAVE_FILES := $(subst $(TEST_DIR),$(SIM_DIR),$(TEST_VHD_FILES:.vhd=.vcdgz))

#GHDL CONFIG
GHDL_CMD = ghdl
WAVEFORM_VIEWER = gtkwave
GHDL_FLAGS  = --std=$(STD) --ieee=synopsys --warn-no-vital-generic
GHDL_SIM_OPT = --stop-time=$(STOP_TIME)

all: clean test $(PROJ).bin 

# Libary
$(LIB_DIR)/%-obj$(STD).cf: $(LIB_DIR)/%.vhd
	@$(GHDL_CMD) -a $(GHDL_FLAGS) --workdir=$(LIB_DIR) --work=$(notdir $(basename $^)) $^

# Test
$(SIM_DIR)/tb_% : $(TEST_DIR)/tb_%.vhd
	@echo "Create: $^ -> $@" 
	@$(GHDL_CMD) -i $(GHDL_FLAGS) --workdir=$(SIM_DIR) --work=work $^ $(SRC_FILES)
	@$(GHDL_CMD) -m  $(GHDL_FLAGS) --workdir=$(SIM_DIR) -P=$(LIB_DIR) -o $(SIM_DIR)/$(notdir $(basename $^)) --work=work  $(notdir $(basename $^))

$(SIM_DIR)/tb_%.vcdgz : $(SIM_DIR)/tb_%
	@echo "Run: $^ -> $@" 
	@$^ $(GHDL_SIM_OPT) --vcdgz=$@

# Bin-File
$(WORK_FILE): $(SRC_FILES)
	$(GHDL_CMD) -i --std=$(STD) --workdir=$(WORK_DIR) $(SRC_FILES)

%.build.json: compile_lib $(WORK_FILE)
	yosys -m ghdl -p '$(GHDL_CMD) $(GHDL_FLAGS) --latches --workdir=$(WORK_DIR) -P=$(LIB_DIR) $(SRC_FILES) -e  $(PROJ); synth_ice40 -json $@'

%.asc: %.build.json $(PIN_DEF)
	nextpnr-ice40 --ignore-loops --$(FPGA_TYPE) --package $(FPGA_PKG) --pcf $(PIN_DEF) --json $< --asc $@

%.bin: %.asc
	icepack $< $@

compile_lib: create_folder $(LIB_FILES)

compile_test: clean create_folder compile_lib $(TEST_FILES)

test: compile_test $(WAVE_FILES)

create_folder:
	@mkdir -p $(SIM_DIR)

view: compile_test
	@gunzip --stdout $(SIM_DIR)/$(VIEW).vcdgz | $(WAVEFORM_VIEWER) --vcd

clean:
	rm -f $(LIB_DIR)/*.cf $(LIB_DIR)/*.o 
	rm -f $(SIM_DIR)/*
	rm -f *.o
	rm -f *.build.json *.asc *.bin

.SECONDARY:

.PHONY: all prog clean test view
