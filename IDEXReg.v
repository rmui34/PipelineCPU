//Raymond Mui , AJ Townsend, Beck Pang
module IDEXReg (clk,Rs, Rt,Rd, WB, M, EX, busA, busB, busC,
  RsReg, RtReg,RdReg,WBReg,MReg,EXReg, busAReg, busBReg, busCReg);
  input clk;
  input [1:0] WB; // page 310
  input [2:0] M;
  input [3:0] EX;
  input [4:0] Rs, Rt, Rd;
  
  // busA, and busB are inputs to ALU from prev design
  input [31:0] busA, busB, busC; // immediate = busC
  output reg [1:0] WBReg;
  output reg [2:0] MReg;
  output reg [3:0] EXReg;
  output reg [4:0] RsReg,RtReg,RdReg;
  output reg [31:0] busAReg, busBReg, busCReg;

  initial begin
  WBReg = 0;
  MReg = 0;
  EXReg = 0;
  RsReg = 0;
  RtReg = 0;
  RdReg = 0;
  busAReg = 0;
  busBReg = 0; //immediate [31:0]?
  busCReg = 0;
  end

  always @(posedge clk) begin
  WBReg <= WB;
  MReg <= M;
  EXReg <= EX;
  RsReg <= Rs;
  RtReg <= Rt;
  RdReg <= Rd;
  busAReg <= busA;
  busBReg <= busB;
  busCReg <= busC;
  end


endmodule
