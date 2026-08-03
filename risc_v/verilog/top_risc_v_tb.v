module top_risc_v_tb;

    reg clk;
    reg reset;
    `define SIMULATION
    // Instantiate the top-level RISC-V module
    top_risc_v dut (
        .clk(clk),
        .reset(reset)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10 time units clock period
    end

    integer idx;
    initial begin
        $dumpfile("top_risc_v.vcd");
        $dumpvars(0, top_risc_v_tb);
        for (idx = 0; idx < 32; idx = idx + 1) begin
            $dumpvars(0, dut.reg_file_inst.registers[idx]);
        end
        for (idx = 0; idx < 32; idx = idx + 1) begin
            $dumpvars(0, dut.data_mem_inst.registers[idx]);
        end
        for (idx = 0; idx < 32; idx = idx + 1) begin
            $dumpvars(0, dut.rom_inst.memory[idx]);
        end
        
    end

    // Test sequence
    initial begin
        // Initialize reset
        reset = 1;
        #10; // Hold reset for 10 time units
        reset = 0;

        // Add your test cases here
        // For example, you can load instructions into the instruction memory,
        // set up initial register values, and check the outputs.
        

      #700; // Run simulation for 100 time units

        $finish; // End simulation
    end
    endmodule
    