// @sel high output i1, sel low output i0
module mux2_1(out, i0, i1, sel);
		output out;
		input i0, i1, sel;
		
		wire out1, out2, NOTsel;
		not n(NOTsel, sel);
		
		and a1(out1, i1, sel);
		and a2(out2, i0, NOTsel);
		or o(out, out1, out2);
endmodule

// module mux2_1_testbench();
// 		reg i0, i1, sel;
// 		wire out;
		
// 		mux2_1 dut (.out, .i0, .i1, .sel);
		
// 		initial begin
// 				sel = 0; i0 = 0; i1 = 0; #10;
// 				sel = 0; i0 = 0; i1 = 1; #10;
// 				sel = 0; i0 = 1; i1 = 0; #10;
// 				sel = 0; i0 = 1; i1 = 1; #10;
// 				sel = 1; i0 = 0; i1 = 0; #10;
// 				sel = 1; i0 = 0; i1 = 1; #10;
// 				sel = 1; i0 = 1; i1 = 0; #10;
// 				sel = 1; i0 = 1; i1 = 1; #10;
// 		end
// endmodule

