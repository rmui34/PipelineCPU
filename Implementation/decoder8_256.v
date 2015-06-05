module decoder8_256(in,out);
	input [7:0] in;
	output[255:0] out;
	assign out = 1 << in;
endmodule
