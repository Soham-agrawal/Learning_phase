# ==========================================
# 1. VARIABLES (Settings Configuration)
# ==========================================
Compiler  = iverilog
Simulator = vvp
Waveform  = gtkwave

# Target is the compiled binary file, Sim_File is the output VCD waveform
Target    = top_risc_v.vcd

Srcs      = top_risc_v.v \
            alu.v \
            decoder.v \
            data_memory.v \
            readonly_mem.v \
            program_counter.v \
            register_file.v 

# ==========================================
# 2. RULES & TARGETS (Workflow Steps)
# ==========================================

# Default target runs everything from scratch
all: wave

# STEP 1: Compile and check for errors
compile: $(Srcs)
	$(Compiler) -o $(Target) $(Srcs)

# STEP 2: Run the simulation to generate VCD
sim: compile
	$(Simulator) $(Target)

# STEP 3: Open GTKWave to view waveforms
wave: sim
	$(Waveform) $(Target)

# Clean utility to reset the directory (Windows Native)
clean:
	-del /f /q $(Target) 
