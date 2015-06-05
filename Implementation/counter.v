module clkSlower(out, in, rst);
	output [1:0] out;
	input in, rst;

	reg [22:0] ps, ns;

	assign out[1] = ps[2];
	assign out[0] = ps[22];

	
	always @(*)
		ns = ps + 1'b1;

	always @(posedge in)
		ps = rst ? 1'b0 : ns;
endmodule


