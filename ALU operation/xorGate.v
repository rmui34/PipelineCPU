module xorGate (busXOR, busA, busB, zXOR, oXOR, cXOR, nXOR);
	output [31:0] busXOR;
	input  [31:0] busA, busB;
	output zXOR, oXOR, cXOR, nXOR;

	assign busXOR = busA ^ busB;

	wire o_;
	flag test(busXOR, busA, busB, 1'b0, zXOR, o_, cXOR, nXOR);
	assign oXOR = 1'b0;
endmodule