module datapath (
	input clk,    // Clock
	input [4:0] read0, read1, write,

	// control lines
	input [1:0] WBID,	// RegWrite, MemtoReg
	input [2:0] MID,	// Branch, MemRead, MemWrite
	input [3:0] EXID,	// RegDst, ALUOp1, ALUOp0, ALUSrc
	input [15:0] instr,
	input RegWrEn, MemWrEn
);
	
	wire [31:0] busA, busB, busC, busD, busE, busF,
				busS, busALUa, busALUb, busALUc,	// ALU result
				busG, busData, 	// Memory Input
				busH, busI		// Memory Output
				busWB; 			// page 309
	
	wire [1:0] WBEX, WBMEM, WBWB;
	wire [2:0] MEX,  MMEM;
	wire [3:0] EXEX;
	reg [4:0] Rs, Rt, Rd, RdRt;
	reg MemRst;
	reg WBsel;

	wire [4:0] RsReg,RtReg,RdReg, RdRtReg;

	reg [2:0] ALUctrl;
	reg zero, overflow, carryout, negative;


	// Need to put register file, ID/EX registers, ALU, 
	// EX/MEM register, Data Memory, MEM/WB register, and mux here

	// Instruction decoding state
	registerFile file(clk, read0, read1, write, RegWrEn, busWB, busA, busB);
	assign busC 	= {{16{instr[15]}}, instr};
	// assign busB  	= EXID
	IDEXReg  	IDEX (clk, Rs, Rt, Rd, WBID, MID, EXID, busA, busB, busC, RsReg, RtReg, 
								RdReg, WBEX, MEX, EXEX, busD, busE, busF);

	// Execution, address calculation state
	assign busS		= EXID[0] ? busF : busE; // if EXID is 1, choose immediate busF, otherwise choose register output
	ALUnit  	ALU  (ALUctrl, busD, busS, busALUa, zero, overflow, carryout, negative);
	EXMEMReg 	EXMEM(clk, WBEX, MEX, busD, busALUa, RdRt,
						 WBMEM, MMEM, busALUb, busG, RdRtReg);

	// Memory Access state
	dataMemory 	data (.clk(clk), .rst(MemRst), .adx(busALUb), .WrEn(MemWrEn), .data(busData));
	assign busData 	= MemWrEn ? 16'bZ : busG[15:0]; // When store word, the data comes from the register file
	assign busH 	= {{16{busData[15]}}, busData};    
	MEMWBReg 	MEMWB(clk,WBMEM,Rd, busH, busALUb, WBWB,RdReg,busI,busALUc);
	assign busWB	= WBsel ? busALUc : busI; // Write back mux; If WBsel is 0, write back ALU result; if 1, write from memory

	// Wire up the control lines
	ALUcontrol	translate (.ALUop(EXID[2:1]), .instr(instr[5:0]), .ALUin(ALUctrl));

endmodule