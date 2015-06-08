module ProgCountReg (clk, reset, jAdx, brAdx, j, br, z, prgCount);
	input clk, reset, j, br, z;
	input [25:0] jAdx;
	input [31:0] brAdx;
	output reg [6:0] prgCount;
	
	wire [31:0] r0, r1, r2, r3, r4;
	wire z0, o0, c0, n0, z1, o1, c1, n1, brT;
	
	addition prgAdd(r0, {25'b0, prgCount}, 1, z0, o0, c0, n0);
	addition branchAdd(r1, r0, brAdx, z1, o1, c1, n1);
	
	assign r2 = {6'b00000, jAdx};
	assign brT = br & ~z;
	assign r3 = brT ? r1 : r0;
	assign r4 = j ? r2 : r3;
		
	//mux2_1 branch(r3, r0, r1, brT);
	//mux2_1 branch(r4, r3, r2, j);
		
	always @(posedge clk) begin
		if(reset)
			prgCount <= 0;
		else 
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