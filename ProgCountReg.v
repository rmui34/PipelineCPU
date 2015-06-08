module ProgCountReg (clk, reset, jAdx, JRAdx, brAdx, j, JR, br, z, out, PCWr);
	input clk, reset, j, JR, br, z, PCWr;
	input [31:0] jAdx, JRAdx, brAdx;
	output [6:0] out;
	
	assign out = r3[5:0];
	
	reg [6:0] prgCount;
	
	wire [31:0] r0, r1, r2, r3, r4;
	wire z0, o0, c0, n0, z1, o1, c1, n1, brT, nCon;
	
	addition prgAdd(r4, r3, 1, z0, o0, c0, n0);
	addition branchAdd(r1, {25'b0, prgCount}, brAdx, z1, o1, c1, n1);
	
	assign r0 = JR ? JRAdx : jAdx;
	assign brT = br & ~z;
	assign r2 = brT ? r1 : r0;
	assign nCon = j | JR | br;
	assign r3 =  nCon ? r2 : {25'b0, prgCount};
	/*
	assign r2 = {6'b00000, jAdx};
	assign brT = br & ~z;
	assign r3 = brT ? r1 : r0;
	assign r4 = j ? r2 : r3;
	*/
	//mux2_1 branch(r3, r0, r1, brT);
	//mux2_1 branch(r4, r3, r2, j);
		
	always @(posedge clk) begin
		if(reset)
			prgCount <= 0;
		else if(PCWr)
			prgCount <= r4[6:0];
	end
			
endmodule 

module PGRtest();
	wire [6:0] prgCount;
	reg clk, reset, j, br, n;
	reg [25:0] jAdx;
	reg [31:0] brAdx;
	
	ProgCountReg dut (clk, reset, jAdx, brAdx, j, br, n, prgCount);
	
	parameter d = 20;
	
	always begin
		#(d/2); clk = ~clk;
	end
	
	initial begin
		clk = 0; reset = 1; j = 0; br = 0; n = 0; jAdx = 0; brAdx = 0;
		#d; reset = 0;
		#(d*10); j = 1; jAdx = 15;
		#(d*2); jAdx = 4;
		#d; j = 0;
		#d; br = 1; brAdx = 25;
		#d; n = 1;
		#d; n = 0; br = 0;
		#d; reset = 1;
		#d; reset = 0;
		#(d*10); 
		$stop;
		$finish;
	end
endmodule 