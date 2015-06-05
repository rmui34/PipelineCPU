// It is a two dimensional multiplexer designed for multi words register file.
// @requires: a 32 by 32 stack input with each row storing one word;
// @returns:  find bits from each column using a 32 to 1 mux, and form a 32 bit output.
module mux32by32_32 (
	output [31:0] out,
	input [31:0] RF [31:0],
	input [4:0] sel
);
	genvar k, l;

	generate
		for (l = 0; l < 32; l = l + 1) begin: muxLoop
			reg [31:0] bitCompare;
			for (k = 0; k < 32; k = k + 1) begin: formARow
				buf e1(bitCompare[k], RF[k][l]);
			end
			mux32_1 mux (out[l], bitCompare, sel);
		end
	endgenerate
	
endmodule