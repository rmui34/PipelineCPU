// Instruction Memory 128 * 32 SRAM
// EE 471 Lab 4, Beck Pang, Spring 2015
module InstruMemory (clk, adx, WrEn, data, rst);
	parameter DATA_WIDTH = 32;
	parameter DATA_LENGTH= 128;
	parameter ADX_LENGTH = 7;

	input clk, WrEn, rst;
	input [ADX_LENGTH - 1:0] adx;
	inout [DATA_WIDTH - 1:0] data;
	reg [DATA_WIDTH - 1:0]SRAM[DATA_LENGTH - 1:0]; // memory regs
	
	assign data = (WrEn) ? SRAM[adx] : 32'bZ; // control the tri-state 
	
	always @(posedge clk) begin
		if(rst)
			$readmemb("instructions.txt", SRAM, 0, 70);
		else if(~WrEn) 
			SRAM[adx] = 0; // assign the SRAM index to data
	end

endmodule 

module IMtest();
	reg clk, WrEn, rst;
	reg [31:0] adx;
	wire [127:0] data;
	
	assign data = (~WrEn) ? 69 : 32'bZ;
	
	InstruMemory dut(clk, adx, WrEn, data, rst);
	
	parameter d = 20;
	
	always begin
		#(d/2); clk = ~clk;
	end
	
	initial begin
		clk = 0; WrEn = 1; rst = 0; adx = 0;
		#d; rst = 1;
		#(d*10); rst = 0;
		#(d*10);
		$stop;
		$finish;
	end 
endmodule 
