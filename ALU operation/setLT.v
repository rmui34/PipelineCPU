// logical set less than
// @requires: Two 32 bit signed 2's complemented, a completed subtract module 
// @returns: (R[rt] = (R[rs] < R[rt])? 32'b1:32'b0), set less than
module setLT (busSLT, busA, busB, zSLT, oSLT, cSLT, nSLT);
	output [31:0] busSLT;
	input  [31:0] busA, busB;
	output zSLT, oSLT, cSLT, nSLT;

	assign busSLT = (busA < busB) ? 32'b1:32'b0;
	assign zSLT = ~busSLT[0];
	assign oSLT = 1'b0;
	assign cSLT = 1'b0;
	assign nSLT = 1'b0;
endmodule