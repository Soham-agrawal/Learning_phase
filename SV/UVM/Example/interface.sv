interface reg_if (input bit clk);
  logic        rst_n;
  logic        wr_en;
  logic        rd_en;
  logic [3:0]  addr;
  logic [7:0]  wdata;
  logic [7:0]  rdata;
endinterface
