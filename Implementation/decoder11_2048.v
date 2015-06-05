module decoder11_2048 (
	input [10:0] in,  
	output [2047:0] out
);
	assign out = 1 << in;
endmodule