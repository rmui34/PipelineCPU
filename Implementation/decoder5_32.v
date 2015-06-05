// It's a five to one of thirty-two decoder.
// @requires:	five bit of data address;
// @returns:	thirty two bit of an array of high with only a single low.
module decoder5_32 (
	input [4:0] in,  
	output [31:0] notOut
);
	wire [31:0] out;
	wire [4:0] no;
	genvar i, j;
	generate		
		for (i = 0; i < 5; i = i + 1) begin: notLineLoop
			not n1(no[i], in[i]);
		end
	endgenerate
	and n00000(out[0], no[0], no[1], no[2], no[3], no[4]);
	and n10000(out[1], in[0], no[1], no[2], no[3], no[4]);
	and n01000(out[2], no[0], in[1], no[2], no[3], no[4]);
	and n11000(out[3], in[0], in[1], no[2], no[3], no[4]);
	and n00100(out[4], no[0], no[1], in[2], no[3], no[4]);
	and n10100(out[5], in[0], no[1], in[2], no[3], no[4]);
	and n01100(out[6], no[0], in[1], in[2], no[3], no[4]);
	and n11100(out[7], in[0], in[1], in[2], no[3], no[4]);
	and n00010(out[8], no[0], no[1], no[2], in[3], no[4]);
	and n10010(out[9], in[0], no[1], no[2], in[3], no[4]);
	and n01010(out[10], no[0], in[1], no[2], in[3], no[4]);	
	and n11010(out[11], in[0], in[1], no[2], in[3], no[4]);	
	and n00110(out[12], no[0], no[1], in[2], in[3], no[4]);
	and n10110(out[13], in[0], no[1], in[2], in[3], no[4]);	
	and n01110(out[14], no[0], in[1], in[2], in[3], no[4]);	
	and n11110(out[15], in[0], in[1], in[2], in[3], no[4]);

	and n00001(out[16], no[0], no[1], no[2], no[3], in[4]);
	and n10001(out[17], in[0], no[1], no[2], no[3], in[4]);
	and n01001(out[18], no[0], in[1], no[2], no[3], in[4]);
	and n11001(out[19], in[0], in[1], no[2], no[3], in[4]);
	and n00101(out[20], no[0], no[1], in[2], no[3], in[4]);
	and n10101(out[21], in[0], no[1], in[2], no[3], in[4]);
	and n01101(out[22], no[0], in[1], in[2], no[3], in[4]);
	and n11101(out[23], in[0], in[1], in[2], no[3], in[4]);
	and n00011(out[24], no[0], no[1], no[2], in[3], in[4]);
	and n10011(out[25], in[0], no[1], no[2], in[3], in[4]);
	and n01011(out[26], no[0], in[1], no[2], in[3], in[4]);	
	and n11011(out[27], in[0], in[1], no[2], in[3], in[4]);	
	and n00111(out[28], no[0], no[1], in[2], in[3], in[4]);
	and n10111(out[29], in[0], no[1], in[2], in[3], in[4]);	
	and n01111(out[30], no[0], in[1], in[2], in[3], in[4]);	
	and n11111(out[31], in[0], in[1], in[2], in[3], in[4]);	
	generate
		for (j = 0; j < 32; j = j + 1) begin: outLineLoop
			not n2(notOut[j], out[j]);
		end
	endgenerate
endmodule