//Raymond Mui , AJ Townsend, Beck Pang
module EXMEMReg(clk,WB, M, DataIn,ALURes,RdRt,zero
  WBReg, MReg, DataOut,ALUReg, RdRtReg, zeroReg);
  input clk;
  input [1:0] WB;
  input [2:0] M;
  input [4:0] RdRt;
  input [31:0] DataIn,ALURes;
  input zero;

  output reg [1:0] WBReg;
  output reg [2:0] MReg;
  output reg [4:0] RdRtReg;
  output reg [31:0] DataOut,ALUReg;
  output reg zeroReg;

  initial begin
    WBReg = 0;
    MReg = 0;
    ALUReg = 0;
    DataOut = 0;
    RdRtReg = 0;
    zeroReg = 0;
  end

  always @(posedge clk)
  begin  
    WBReg <= WB;
    MReg <= M;
    ALUReg <= ALURes;
    DataOut <= DataIn;
    RdRtReg <= RdRt;
    zeroReg <= zero;
  end

endmodule
