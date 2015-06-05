// active high flags


module addition (busADD, busA, busB, zADD, oADD, cADD, nADD);
	output [31:0] busADD;
	input  [31:0] busA, busB;
	output zADD, oADD, cADD, nADD;
	wire carryOut;
	
	assign {carryOut, busADD} = busA + busB;
	
	flag test(busADD, busA, busB, carryOut, zADD, oADD, cADD, nADD);
endmodule

