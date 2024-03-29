//Raymond Mui , AJ Townsend, Beck Pang
module IFIDReg (clk,flush,IFIDWr,instr, progCD, progCQ, instrReg);
  input clk,flush,IFIDWr;
  input [31:0] instr;
  input [6:0] progCD;
  output reg [6:0] progCQ;
  output reg [31:0] instrReg;

  initial begin
    instrReg = 0;
  end

  always @(posedge clk)
  begin
	progCQ <= progCD;
    if(flush)
      instrReg<=0;
    else if(IFIDWr)
      instrReg <= instr;
  end

endmodule
