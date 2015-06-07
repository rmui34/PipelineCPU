//Raymond Mui , AJ Townsend, Beck Pang
module IFIDReg (clk,flush,IFIDWr,instr,instrReg);
  input clk,flush,IFIDWr;
  input [31:0] instr;
  output reg [31:0] instrReg;

  initial begin
    instrReg = 0;
  end

  always @(posedge clk)
  begin
    if(flush)
      instrReg<=0;
    else if(IFIDWr)
      instrReg <= instr;
  end

endmodule
