# Makefile for compiling Verilog code using Icarus Verilog (iverilog)

# Compiler
IVERILOG = iverilog

# Simulation program
VVP = vvp

# Flags
FLAGS = -Wall

# Source files
SOURCES = ../rtl/rat.v

# Testbench
TESTBENCH = tb_rat.v

# Target executable
TARGET = simulation.out

# waveform
WAVEFORM = waveform.vcd

.PHONY: all clean

all: $(TARGET) run

$(TARGET): $(SOURCES) $(TESTBENCH)
	$(IVERILOG) $(FLAGS) -o $@ $(SOURCES) $(TESTBENCH)

run: $(TARGET)
	$(VVP) $(TARGET)

clean:
	rm -f $(TARGET) $(WAVEFORM)