// EE 471 Lab 1,  Beck Pang, Spring 2015
// Sample D FlipFlop offered from the document

// @requires: an input, a clock, an active low reset
// @returns: a clocked input value, and its negative value
module DFlipFlop(q, qBar, D, clk, rst);
	input D, clk, rst;
	output q, qBar;
	reg q;
	not n1 (qBar, q);
	
	always@ (negedge rst or posedge clk)
	begin
		// active low reset
		if(!rst)
			q = 0;
		else
			q = D;
	end
endmodule