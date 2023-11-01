# Makefile for Verilog simulation using Icarus Verilog (iverilog)
# Install iverilog: sudo apt install iverilog
# Install gtkwave : sudo apt install gtkwave

VERILOG_FILES = ../rtl/computer.v
TB_FILES = computer_tb.v
TOP_MODULE = computer_tb

SIM_OUT = simulation.vvp
VCD_OUT = dump.vcd

.PHONY: all compile simulate waveform clean

all: clean compile simulate

compile: $(VERILOG_FILES) $(TB_FILES)
	iverilog -g2012 -o $(SIM_OUT) $(VERILOG_FILES) $(TB_FILES)

simulate: compile
	vvp $(SIM_OUT)

waveform: simulate
	gtkwave $(VCD_OUT)

clean:
	rm -f $(SIM_OUT) $(VCD_OUT)
