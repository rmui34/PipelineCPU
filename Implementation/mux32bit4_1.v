// 4 to 1 mux in 32 bits
// @requires: four 32 bits word input
// @returns:  a 32 bit word
module mux32bit4_1 (
	output reg [31:0] out,
	input [31:0] i00, i01, i10, i11,
	input [1:0] sel
);
	always @(sel or i00 or i01 or i10 or i11) begin
		case (sel)
			2'b00	: out = i00;
			2'b01	: out = i01;
			2'b10	: out = i10;
			2'b11	: out = i11;
			default : out = 32'bx;
		endcase
	end
endmodule 