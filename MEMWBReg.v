//Raymond Mui , AJ Townsend, Beck Pang
module MEMWBReg (clk,WB,Rd, MemOut, ALURes,WBReg,RdReg,MemReg,ALUReg);
  input clk;
  input [1:0] WB;
  input [4:0] Rd;
  input [31:0] MemOut, ALURes;

  output reg [1:0] WBReg;
  output reg [4:0] RdReg;
  output reg [31:0] MemReg, ALURes;

  initial begin
    WBReg = 0;
    RdReg = 0;
    MemReg = 0;
    ALUReg = 0;
  end

  always @(posedge clk)
  begin
  WBReg <= WB;
  RdReg <= Rd;
  MemReg <= MemOut;
  ALUReg <= ALURes;
  end

endmodule
