module andGate (busAND, busA, busB, zAND, oAND, cAND, nAND);
	output [31:0] busAND;
	input  [31:0] busA, busB;
	output zAND, oAND, cAND, nAND;

	assign busAND = busA & busB;

	wire o_;
	flag test(busAND, busA, busB, 1'b0, zAND, o_, cAND, nAND);
	assign oAND = 1'b0;
endmodule