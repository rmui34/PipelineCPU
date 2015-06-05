//Raymond Mui , AJ Townsend, Beck Pang
module EXMEMReg(clk,WB, M, DataIn,ALURes,RdRt,
  WBReg, MReg, DataOut,ALUReg, RdRtReg);
  input clk;
  input [1:0] WB;
  input [2:0] M;
  input [4:0] RdRt;
  input [31:0] DataIn,ALURes;

  output reg [1:0] WBReg;
  output reg [2:0] MReg;
  output reg [4:0] RdRtReg;
  output reg [31:0] DataOut,ALUReg;

  initial begin
    WBReg = 0;
    MReg = 0;
    ALUReg = 0;
    DataOut = 0;
    RdRtReg = 0;
  end

  always @(posedge clk)
  begin  
    WBReg <= WB;
    MReg <= M;
    ALUReg <= ALURes;
    DataOut <= DataIn;
    RdRtReg <= RdRt;
  end

endmodule
