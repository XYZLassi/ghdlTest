PROJ = main
WORK_DIR = work
LIB_DIR = lib
SRC_DIR = src
PACKAGE_DIR = package
FPGA_PKG = sg48
FPGA_TYPE = up5k



SRC_FILES := $(wildcard $(SRC_DIR)/*.vhd)
PACKAGE_FILES := $(wildcard $(PACKAGE_DIR)/*.vhd)

PIN_DEF = constrains/$(PROJ).pcf

all: $(PROJ).bin


$(LIB_DIR)/%.o: $(PACKAGE_DIR)/%.vhd
	ghdl -a --workdir=$(LIB_DIR) --work=$(notdir $(basename $^)) $^

$(WORK_DIR)/work-obj93.cf: $(wildcard $(SRC_DIR)/*.vhd)
	ghdl -i --workdir=$(WORK_DIR) $(SRC_DIR)/*.vhd

%.json: $(LIB_DIR)/*.o $(WORK_DIR)/work-obj93.cf
	yosys -m ghdl -p 'ghdl --workdir=$(WORK_DIR) -P=$(LIB_DIR) $(SRC_FILES) -e $(PROJ); synth_ice40 -json $@'

%.asc: %.json $(PIN_DEF)
	nextpnr-ice40 --$(FPGA_TYPE) --package $(FPGA_PKG) --pcf $(PIN_DEF) --json $< --asc $@

%.bin: %.asc
	icepack $< $@

prog: $(PROJ).bin

clean:
	rm -f $(LIB_DIR)/*
	rm -f *.json *.asc *.bin

.SECONDARY:

.PHONY: all prog clean
