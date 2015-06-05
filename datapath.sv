module datapath (
	input clk,    // Clock
	input [4:0] read0, read1, write,
	input [31:0] writeData,
	// control lines
	input RegWrEn, MemWrEn
);
	
	wire [31:0] busA, busB, busC, busD, 
				busALUa, busALUb, busALUc,// ALU result
				busG, busData, 
				busH, busI	// Memory Output
				busWB; // page 309
	
	reg [1:0] WB; // page 310
	reg [2:0] M;
	reg [3:0] EX;
	reg [4:0] Rs, Rt, Rd, RdRt;
	reg MemRst;
	reg WBsel;

	wire [1:0] WBReg;
	wire [2:0] MReg;
	wire [3:0] EXReg;
	wire [4:0] RsReg,RtReg,RdReg, RdRtReg;

	reg [2:0] ALUline;
	reg zero, overflow, carryout, negative;


// Need to put register file, ID/EX registers, ALU, 
// EX/MEM register, Data Memory, MEM/WB register, and mux here
// should be clocked
	registerFile file(clk, read0, read1, write, RegWrEn, busWB, busA, busB);
	IDEXReg  	IDEX (clk, Rs, Rt,Rd, WB, M, EX,busA, busB, RsReg, RtReg, 
						 RdReg, WBReg, MReg, EXReg, busC, busD);
	ALUnit  	ALU  (ALUline, busC, busD, busALUa, zero, overflow, carryout, negative);
	EXMEMReg 	EXMEM(clk, WB, M, busD, busALUa, RdRt,
						 WBReg, MReg, busALUb, busG, RdRtReg);
	dataMemory 	data (.clk(clk), .rst(MemRst), .adx(busALUb), .WrEn(MemWrEn), .data(busData));
	assign busData 	= MemWrEn ? 16'bZ : busG[15:0]; // When store word, the data comes from the register file
	assign busH 	= {{16{busData[15]}}, busData};    
	MEMWBReg 	MEMWB(clk,WB,Rd, busH, busALUb,WBReg,RdReg,busI,busALUc);
	mux2_1 		WB   (busWB, busALUc, busI, WBsel); // If WBsel is 0, write back ALU result; if 1, write from memory

endmodule