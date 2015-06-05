// UWEE, Beck Pang, Raymond Mui, Andrew J. Townsend
// EE 471 Lab 2, Apr.20, 2015
// This module is a piece of a synchronous memory system that store the most accessed data
// called register file, with 32 registers of 32 bit wide.
// The first register is set as ground reference and always output
// It takes clock, address and signals from the system bus, active low writeEnable,
// have both read or write function, read data from or write data to registers.
// Read Operation:
//	@requires:  a clock signal, a low signal for write enable,
// 			two read address width of 5 bits;
//	@returns:	a data of 32 bits specified by the address; 
//              the first address is set as the ground reference.
// Write Operation:
//  @requires:	a clock signal, a high signal for write enable,
// 			a write address with width of 5 bits, and an data with width of 32 bits;
// 	@modifies:	the data of the address passed in
module registerFile (
	input clk, 
	input [4:0] read0, read1, write,
	input wrEn, // Write Enable
	input [31:0] writeData, 
	output [31:0] readOutput0, readOutput1
);
	wire regReadIndex;

	// The address to write
	wire [31:0] wrEnDecoded;
	wire  [31:0] written;
	wire [31:0] RF [31:0];
	reg rst = 1'b0;

	// Step1: Decode the write address with wrEn
	decoder5_32 writeDecode(write, wrEnDecoded);

	genvar i;
	generate
		for (i = 0; i < 32; i = i + 1) begin: writtenEnableLoop
			or writtenEnableAnd(written[i], wrEn, wrEnDecoded[i]);
		end
	endgenerate

	// Step2: form the RF with each row storing one word of 32 bit
	// Register 0 always output 0, active low writeEnable
	register reg0(clk, rst, written[0], 32'bx, RF[0]);
	
	genvar j;

	generate
		for (j = 1; j < 32; j = j + 1) begin: registerLoopj
			register regj (clk, ~rst, written[j], writeData, RF[j]);
		end
	endgenerate

	// Step3: using a mux to extrace a 32 bit word from the read address
	// mux32by32_32 regMux0(readOutput0, RF, read0);
	// mux32by32_32 regMux1(readOutput1, RF, read1);

	// It is a two dimensional multiplexer designed for multi words register file.
	// @requires: a 32 by 32 stack input with each row storing one word;
	// @returns:  find bits from each column using a 32 to 1 mux, and form a 32 bit output.
	genvar k, l;
	generate
		for (l = 0; l < 32; l = l + 1) begin: muxLoop
			wire [31:0] bitCompare;
			for (k = 0; k < 32; k = k + 1) begin: formARow
				buf e1(bitCompare[k], RF[k][l]);
			end
			mux32_1 mux (readOutput0[l], bitCompare, read0);
		end
	endgenerate

	generate
		for (l = 0; l < 32; l = l + 1) begin: muxLoop2
			wire [31:0] bitCompare;
			for (k = 0; k < 32; k = k + 1) begin: formARow
				buf e1(bitCompare[k], RF[k][l]);
			end
			mux32_1 mux (readOutput1[l], bitCompare, read1);
		end
	endgenerate

endmodule