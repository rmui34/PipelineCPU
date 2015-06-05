module flag (
	input [31:0] busOut, busA, busB, 
	input carryOut, 
	output z, o, c, n
);
	// NOR gate will act 1 when all inputs are 0
	assign z = ~|busOut[31:0];
	assign o = (busA[31]~^busB[31]) && (busA[31]^busOut[31]);
	assign c = carryOut;
	assign n = busOut[31];

endmodule