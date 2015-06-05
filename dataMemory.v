// AJ, Beck, and Ray
// SRAM module
// 4/21/15, active low Write Enable

module dataMemory(clk, rst, adx, WrEn, data);
	parameter DATA_WIDTH = 16;
	parameter DATA_LENGTH= 2048;
	parameter ADX_LENGTH = 11;

	input clk, WrEn, rst;	// Active low write enable
	input [ADX_LENGTH - 1:0] adx;
	inout [DATA_WIDTH - 1:0] data;
	
	reg [DATA_WIDTH - 1:0]SRAM[DATA_LENGTH - 1:0]; // memory regs
	
	assign data = (WrEn) ? SRAM[adx] : 16'bZ; // control the tri-state 
	
	always @(posedge clk) begin
		if(~WrEn) 
				SRAM[adx] = data; // assign the SRAM index to data
				
		if(rst)		
				$readmemh("datahmem.txt", SRAM, 16, 31);
	end

endmodule  