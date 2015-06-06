module datapath (
	input clk,  	// Clock
	input MemRst,	// Load memory from a txt file
	input [4:0] read0, read1, write,
	// control lines
	input [1:0] WBID,	// RegWrite, MemtoReg
	input [2:0] MEID,	// Branch, MemRead, MemWrite
	input [3:0] EXID,	// RegDst, ALUOp1, ALUOp0, ALUSrc
	input [31:0] instr,
	output Branch
);
	
	wire [31:0] busA, busB, busC, busD, busE, busF,
				busS, busALUa, busALUb, busALUc,	// ALU result
				busG, busData, 	// Memory Input
				busH, busI,		// Memory Output
				busWB; 			// page 309
	
	wire [1:0] WBEX, WBME, WBWB;
	wire [2:0] MEEX,  MEME;
	wire [3:0] EXEX;
	wire [4:0] 	RsID, RtID, RdID, write,
				RsEX, RtEX, RdEX,
				RdRtEX, RdRtME, RdRtWB;

	reg [2:0] ALUctrl;
	reg zero, overflow, carryout, negative, negativeReg;
	wire ALUSrc, RegDst, MemRdEn, MemWrEn, RegWrEn;
	wire [1:0] ALUOp;
	assign RsID = instr[25:21];
	assign RtID = instr[20:16];
	assign RdID = instr[15:11];

	// Need to put register file, ID/EX registers, ALU, 
	// EX/MEM register, Data Memory, MEM/WB register, and mux here

	// Instruction decoding state
	registerFile file(clk, RsID, RtID, write, RegWrEn, busWB, busA, busB);
	assign busC 	= {{16{instr[15]}}, instr[15:0]};
	IDEXReg  	IDEX (clk, 	RsID, RtID, RdID, WBID, MEID, EXID, busA, busB, busC, 
							RsEX, RtEX, RdEX, WBEX, MEEX, EXEX, busD, busE, busF);

	// Execution, address calculation state
	assign ALUSrc	= EXEX[0];
	assign ALUOp 	= EXEX[2:1];
	assign RegDst	= EXEX[3];
	assign busS		= ALUSrc ? busF : busE; // if EXID is 1, choose immediate busF, otherwise choose register output
	ALUcontrol	translate (.ALUop(ALUOp), .instr(instr[5:0]), .ALUin(ALUctrl));
	assign RdRtEX 	= RegDst ? RtEX : RdEX;
	ALUnit  	ALU  (ALUctrl, busD, busS, busALUa, zero, overflow, carryout, negative);
	EXMEMReg 	EXMEM(clk, 	WBEX, MEEX, busE, busALUa, RdRtEX, 
							WBME, MEME, busG, busALUb, RdRtME);

	// Memory Access state
			// assign Branch	= MEME[2] & ~negativeReg & ~zeroReg;	// Branch greater than at not negative nor zero
	assign MemRdEn	= MEME[1];
	assign MemWrEn	= MEME[0]; // MemRdEn was not implemented so MEME[1] was not used
	dataMemory 	data (.clk(clk), .rst(MemRst), .adx(busALUb), .WrEn(MemWrEn), .data(busData));
	assign busData 	= MemWrEn ? 16'bZ : busG[15:0]; // When store word, the data comes from the register file
	assign busH 	= {{16{busData[15]}}, busData};    
	MEMWBReg 	MEMWB(clk,	WBME,RdRtME, busH, busALUb, 
							WBWB,RdRtWB, busI, busALUc);

	// Write back state
	assign busWB	= WBWB[0] ? busALUc : busI; // Write back mux; If WBsel is 0, write back ALU result; if 1, write from memory
	assign RegWrEn  = WBWB[1];
	assign write 	= RdRtWB;
endmodule