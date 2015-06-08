module pipes (clk, rst);
	input clk, rst;
	
	wire [31:0] jAdx, JRAdx, brAdx, instrD, instrQ, IDbusA, IDbusB, writeData, EXbusA, EXbusB, EXbusOut, ALUB, busA, busB, busALU, WrData, busALUWB;
	wire [15:0] IDimd, EXimd, data, ReadData;
	wire [6:0] prgCD, prgCQ;
	wire [4:0] RsID, RtID, RdID, RsEX, RtEX, RdEX, dstReg, RdRtEX, RdRtME;
	wire [3:0] IDEX, EX;
	wire [2:0] control;
	wire [1:0] ALUop, IDWB, WBEX, WBME, WB, fwdA, fwdB;
	wire IFIDWr, PCWr, hazCtrl, flush, JR, regWR, RegDst, ALUsrc, MemWrEn, Mem2Reg, br, j, IDM, MEX, ME, zero, overflow, carryout, negative;
	
	
	assign flush = 0;
	assign jAdx = instrQ[25:0];
	assign JRAdx = IDbusA;
	assign brAdx = {{16{instrQ[15]}}, instrQ[15:0]};
	
	hazardDetectU hazItAll(instrQ[25:21], instrQ[20:16], RtEX, ME, IFIDWr, PCWr, hazCtrl);
	
	///////////////////////////////////////////////////////////////////////////////////
	// FETCH																									//
	///////////////////////////////////////////////////////////////////////////////////
	
	// Program Counter Register
	// Stores and Updates the program counter
	// Takes zero flag and br signal from the decoder from ALU to operate
	// on the SLT, BEQ pseudoinstruction for BGT
	ProgCountReg pc(clk, rst, jAdx, JRAdx, brAdx, j, JR, br, zero, prgCD, PCWr);
	
	// Instruction Memory
	// Holds the instructions
	InstruMemory memInstr(clk, prgCD, 1, instrD, rst);
	
	// Bridges the Fetch and Decode
	IFIDReg IFID (clk, flush, IFIDWr, instrD, prgCD, prgCQ, instrQ);
	
	///////////////////////////////////////////////////////////////////////////////////
	// DECODE																								//
	///////////////////////////////////////////////////////////////////////////////////
	
	registerFile regs(clk, instrQ[25:21], instrQ[20:16], dstReg, WB[0], writeData, IDbusA, IDbusB);
	
	
	// Instruction Decoder
	// Decodes the 32-bit instruction into appropriate control signals
	InstrucDecoder decoder(instrQ[31:26], j, br, Mem2Reg, ALUop, MemWrEn, ALUsrc, RegDst, regWR, JR);
	
	assign {IDWB, IDM, IDEX} = hazCtrl ? 7'b0 : {{Mem2Reg, regWR}, MemWrEn, {ALUop, ALUsrc, RegDst}};
	
	assign RsID  = instrQ[25:21];
	assign RtID  = instrQ[20:16];
	assign RdID  = instrQ[15:11];
	assign IDimd = instrQ[15:0];
	
	IDEXReg IDEXReg (clk, RsID, RtID, RdID, IDWB, IDM, IDEX, IDbusA, IDbusB, IDimd, 
							 RsEX, RtEX, RdEX, WBEX, MEX, EX,   EXbusA, EXbusB, EXimd);
									
	///////////////////////////////////////////////////////////////////////////////////
	// EXECUTE																								//
	///////////////////////////////////////////////////////////////////////////////////
	
	assign ALUB = (ALUsrc) ? EXimd : busB;
	assign RdRtEX = EX[0] ? RdEX : RtEX;
	
	
	mux32bit4_1 busAfwd(busA, EXbusA, writeData, busALU, 0, fwdA);
	mux32bit4_1 busBfwd(busB, EXbusB, writeData, busALU, 0, fwdB);
	
	forwardUnit movinFWD(RsEX, RtEX, RdRtME, dstReg, WBME[0], WB[0], fwdA, fwdB);
	
	ALUcontrol translate(EX[1:0], EXimd[5:0], control);
	
	ALUnit logicUnit(control, busA, ALUB, EXbusOut, zero, overflow, carryout, negative);
	
	EXMEMReg EXMEM(clk, WBEX, MEX, busB, EXbusOut, RdRtEX, WBME, ME, WrData, busALU, RdRtME);
	
	///////////////////////////////////////////////////////////////////////////////////
	// MEMORY																								//
	///////////////////////////////////////////////////////////////////////////////////
	
	assign data = ME ? WrData[15:0] : 16'bZ;
	
	SRAM2Kby16 dataMemory(clk, busALU, ME, data);
	
	MEMWBReg MEMWB(clk, WBME, RdRtME, data, busALU, WB, dstReg, ReadData, busALUWB);
	
	///////////////////////////////////////////////////////////////////////////////////
	// WRITE BACK																							//
	///////////////////////////////////////////////////////////////////////////////////
	
	assign writeData = WB[1] ? {{16{ReadData[15]}}, ReadData[15:0]} : busALUWB;

	endmodule
	