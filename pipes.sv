module pipes (clk, rst);
	input clk, rst;
	
	assign jAdx = (JR) ? IFbusA : instrQ[25:0];
	
	///////////////////////////////////////////////////////////////////////////////////
	// FETCH																									//
	///////////////////////////////////////////////////////////////////////////////////
	
	// Program Counter Register
	// Stores and Updates the program counter
	// Takes zero flag and br signal from the decoder from ALU to operate
	// on the SLT, BEQ pseudoinstruction for BGT
	ProgCountReg pc(clk, rst, jAdx, brAdx, j, br, zero, prgCount);
	
	// Instruction Memory
	// Holds the instructions
	InstruMemory memInstr(clk, prgCount, IMR, instrD, rst);
	
	// Bridges the Fetch and Decode
	IFIDReg (clk, flush, IFIDWr, instrD, progCD, progCQ, instrQ);
	
	///////////////////////////////////////////////////////////////////////////////////
	// DECODE																								//
	///////////////////////////////////////////////////////////////////////////////////
	
	registerFile regs(clk, instrQ[25:21], instrQ[20:16], dstReg, WBregWR, writeData, IFbusA, IFbusB);
	
	
	// Instruction Decoder
	// Decodes the 32-bit instruction into appropriate control signals
	InstrucDecoder decoder(instrQ[31:26], j, br, Mem2Reg, ALUop, MemWrEn, ALUsrc, RegDst, regWR, JR);
	
	IDEXReg IDEX (clk, RsID, RtID, RdID, {Mem2Reg, regWR}, {br, MemWrEn}, {ALUop, ALUsrc, RegDst}, IFbusA, IFbusB, IFimd, 
							 RsEX, RtEX, RdEX, WBEX, MEMEX, EX, EXbusA, EXbusB, EXimd);
									
	///////////////////////////////////////////////////////////////////////////////////
	// EXECUTE																								//
	///////////////////////////////////////////////////////////////////////////////////
	
	assign ALUB = (ALUsrc) ? EXimd : EXbusB;
	
	ALUcontrol translate(EX[1:0], EXimd[5:0], control);
	
	ALUnit logicUnit(control, EXbusA, ALUB, EXbusOut, zero, overflow, carryout, negative);
	
	EXMEMReg EXMEM(clk, 	WBEX, MEMEX, EXbusB, EXbusOut, RdRtEX, WBME, ME, busG, busALU, RdRtME);
	
	///////////////////////////////////////////////////////////////////////////////////
	// MEMORY																								//
	///////////////////////////////////////////////////////////////////////////////////
	
	SRAM2Kby16 dataMemory(clk, adxData, MemWrEn, data);
	
	MEMWBReg MEMWB(clk,	WBME,RdRtME, busH, busALUb, WB,RdRtWB, busI, busALUc);
	
	///////////////////////////////////////////////////////////////////////////////////
	// WRITE BACK																							//
	///////////////////////////////////////////////////////////////////////////////////
	
	/*
	wire [31:0] busA, busB, busC, busD, busE, busF, busX, busY,
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
	wire [1:0] ForwardA, ForwardB;
	wire [2:0] ALUctrl;
	wire zero, overflow, carryout, negative, negativeReg;
	wire ALUSrc, RegDst, MemRdEn, MemWrEn, RegWrEn;
	wire [1:0] ALUOp;
	assign 		RsID = instr[25:21];
	assign 		RtID = instr[20:16];
	assign 		RdID = instr[15:11];

	// Need to put register file, ID/EX registers, ALU, 
	// EX/MEM register, Data Memory, MEM/WB register, and mux here
/*
	// Instruction decoding state
	registerFile file(clk, RsID, RtID, write, RegWrEn, busWB, busA, busB);
	assign 		busC 	= {{16{instr[15]}}, instr[15:0]};
	IDEXReg  	IDEX (clk, 	RsID, RtID, RdID, WBID, MEID, EXID, busA, busB, busC, 
							RsEX, RtEX, RdEX, WBEX, MEEX, EXEX, busD, busE, busF);

	// Execution, address calculation state
	assign 		ALUSrc	= EXEX[0];
	assign 		ALUOp 	= EXEX[2:1];
	assign 		RegDst	= EXEX[3];
			// add forwarding inside
	forwardUnit	forward(RsEX, RtEX, RdRtME, RdRtWB, WBME[1], WBWB[1], ForwardA, ForwardB);
	// Need to build a 32 bits mux
	mux32bit4_1 ALUA (busX, busD, busWB, busALUb, 32'bx, ForwardA);
	mux32bit4_1 ALUB (busY, busE, busWB, busALUb, 32'bx, ForwardB); // Figure 4.57

	assign 		busS	= ALUSrc ? busF : busY; // if EXID is 1, choose immediate busF, otherwise choose register output
	ALUcontrol	translate (.ALUop(ALUOp), .instr(instr[5:0]), .ALUin(ALUctrl));
	ALUnit  	ALU  (ALUctrl, busX, busS, busALUa, zero, overflow, carryout, negative);
	assign 		RdRtEX 	= RegDst ? RtEX : RdEX;
	EXMEMReg 	EXMEM(clk, 	WBEX, MEEX, busY, busALUa, RdRtEX, 
							WBME, MEME, busG, busALUb, RdRtME);

	// Memory Access state
	assign 		MemRdEn	= MEME[1];
	assign 		MemWrEn	= MEME[0]; // MemRdEn was not implemented so MEME[1] was not used
	dataMemory 	data (.clk(clk), .rst(MemRst), .adx(busALUb), .WrEn(MemWrEn), .data(busData));
	assign 		busData = MemWrEn ? 16'bZ : busG[15:0]; // When store word, the data comes from the register file
	assign 		busH 	= {{16{busData[15]}}, busData};    
	MEMWBReg 	MEMWB(clk,	WBME,RdRtME, busH, busALUb, 
							WBWB,RdRtWB, busI, busALUc);

	// Write back state
	assign 		busWB	= WBWB[0] ? busALUc : busI; // Write back mux; If WBsel is 0, write back ALU result; if 1, write from memory
	assign		RegWrEn = WBWB[1];
	assign 		write 	= RdRtWB;
endmodule