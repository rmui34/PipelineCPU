
module mux32_1 (
	output out,
	input [31:0] in,
	input [4:0] sel
);
	wire v0, v1, v2, v3;
	mux8_1 m0(v0, in[0], in[1], in[2], in[3], in[4], in[5], in[6], in[7], sel[0], sel[1], sel[2]);
	mux8_1 m1(v1, in[8], in[9], in[10], in[11], in[12], in[13], in[14], in[15], sel[0], sel[1], sel[2]);
	mux8_1 m2(v2, in[16], in[17], in[18], in[19], in[20], in[21], in[22], in[23], sel[0], sel[1], sel[2]);
	mux8_1 m3(v3, in[24], in[25], in[26], in[27], in[28], in[29], in[30], in[31], sel[0], sel[1], sel[2]);
	mux4_1 m(.out(out), .i00(v0), .i01(v1), .i10(v2), .i11(v3), .sel0(sel[3]), .sel1(sel[4]));
endmodule