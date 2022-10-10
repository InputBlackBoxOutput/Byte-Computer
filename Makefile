DESIGN=counter
DESIGNS_DIRECTORY=designs
TIME=$$(date +'%Y%m%d-%H%M%S')

.PHONY: all clean burn

all: clean
	$(info Please specify operation!)
	$(info burn: Synthesize and burn to the FPGA)
	$(info sim: Simulate design and view simulation waveforms)
	$(info synth: Synthesize design and view logic diagram)

burn: clean
	# Synthesize using Yosys
	yosys -p "synth_ice40 -top ${DESIGN} -json yosys-opt.json" ${DESIGNS_DIRECTORY}/${DESIGN}.v
	
	# Place and route using nextpnr
	nextpnr-ice40 -r --hx8k --json yosys-opt.json --package cb132 --asc nextpnr-opt.asc --opt-timing --pcf iceFUN.pcf

	# Convert to bitstream using IcePack
	icepack nextpnr-opt.asc design.bin

	sudo iceFUNprog design.bin

sim: clean
	iverilog -o  ${DESIGN}_tb.vvp  ${DESIGNS_DIRECTORY}/${DESIGN}_tb.v
	/usr/bin/vvp  ${DESIGN}_tb.vvp
	gtkwave dump.vcd

synth: clean
	touch synth.ys
	echo "read_verilog ${DESIGNS_DIRECTORY}/${DESIGN}.v" > synth.ys
	echo "hierarchy -top ${DESIGN}" >> synth.ys
	echo "proc; opt; techmap; opt" >> synth.ys
	echo "write_verilog synth.v" >> synth.ys
	echo "show -prefix design -colors $(TIME)" >> synth.ys

	yosys synth.ys

clean:
	rm -rf *.asc *.bin *blif *.json
	rm -rf *.vvp dump.vcd synth.ys synth.v *.blif *.dot *.dot.pid
