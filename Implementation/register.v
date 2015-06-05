// It's an unit in a synchronous memory system, 32-bit wide.
// @requires: a clock signal, a reset signal, a low signal for write enable,
//            a 32-bit array of data to write
// @modifies: When writeEnable is low, register replaces its data array with the passed in data
//            in the positive or negative edge of the clock
// @returns:  When writeEnable is high, register output the data stored in the register.

module register (
	input clk,
	input rst,    // active low reset
	input writeEnable, // Write Enable, active low
	input [31:0] writeData,  // Asynchronous reset active low
	output [31:0] readData
);
	genvar j;
		
	generate
		for (j = 0; j < 32; j = j + 1) begin: registerLoop
			registerSingle register (clk, rst, writeEnable, writeData[j], readData[j]);
		end
	endgenerate
endmodule
