module CPUcontrol (clk, rst, z, IMR, instr2Load, loadAdx, regWR, Mem2Reg, ALUop, MemWrEn, ALUsrc, RegDst, regAdx1, regAdx2, writeAdx, imd);
	input clk, rst, z, IMR;
	input [31:0] instr2Load;
	input [6:0] loadAdx;
	output regWR, Mem2Reg, MemWrEn, ALUsrc, RegDst;
	output [4:0] regAdx1, regAdx2, writeAdx;
	output [31:0] imd;
	output [1:0] ALUop;
	wire [31:0] brAdx, instr;
	wire [6:0] instrAdx, prgCount;
	wire j, br;
	
	assign imd = brAdx;
	assign brAdx = {{16{instr[15]}}, instr[15:0]};
	assign instr = IMR ? 32'bZ : instr2Load;
	assign instrAdx = IMR ? prgCount : loadAdx;
	assign regAdx1 = instr[25:21];
	assign regAdx2 = instr[20:16];
	assign writeAdx = RegDst ? instr[15:11]: instr[20:16];

	// Instruction Memory
	// Holds the instructions
	InstruMemory memInstr(clk, instrAdx, IMR, instr, rst);
	
	// Program Counter Register
	// Stores and Updates the program counter
	ProgCountReg pc(clk, rst, instr[25:0], brAdx, j, br, z, prgCount);
	
	// Instruction Decoder
	// Decodes the 32-bit instruction into appropriate control signals
	InstrucDecoder decoder(instr[31:26], j, br, Mem2Reg, ALUop, MemWrEn, ALUsrc, RegDst, regWR);
	
endmodule 

module CPUtester();
	reg CLOCK_50;  // connect to system 50 MHz clock
	wire [9:0] LEDR;
	reg [9:0] SW;
	reg [3:0] KEY;
	DE1_SoC dut (CLOCK_50, LEDR, SW, KEY);
	// Set up the clocking
	
	parameter d = 20;
	initial begin
		CLOCK_50 = 1;
		SW = 12;
		KEY = 0;
	end
	
	always #(d/2) CLOCK_50 = ~CLOCK_50;
	

	// Set up the inputs to the design
	initial begin
		#(d*10); SW[9] = 1;
		#d; SW[9] = 0; SW[8] = 1;
		#(d*500); SW[8] = 0;
		#d SW[5:0] = 64;
		#d SW[5:0] = 32;
		#d SW[5:0] = 16;
		#d SW[5:0] = 8;
		#d SW[5:0] = 120;
		$stop;
	end
endmodule