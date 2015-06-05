// module itself module in dataflow level, submodule will module in behavioural level
module ALUnit (
	// input clk,    // Clock
	input [2:0]  control,
	input [31:0] busA, busB,
	output reg [31:0] busOut,
	output zero, overflow, carryout, negative
);
	parameter [31:0] nul = 32'b0; // null
	parameter [2:0] NOP = 3'b000, ADD = 3'b001, SUB = 3'b010, AND = 3'b011, OR = 3'b100, XOR = 3'b101, SLT = 3'b110, SLL = 3'b111;
	wire [31:0] busADD, busSUB, busAND, busOR, busXOR, busSLT, busSLL;
	wire zADD, oADD, cADD, nADD;
	wire zSUB, oSUB, cSUB, nSUB;
	wire zAND, oAND, cAND, nAND;
	wire zOR,  oOR,  cOR,  nOR ;
	wire zXOR, oXOR, cXOR, nXOR;
	wire zSLT, oSLT, cSLT, nSLT;
	wire zSLL, oSLL, cSLL, nSLL;
	// present state and next state for zero, overflow, carryout, and negative;
	// reg zps, zns, ops, ons, cps, cns, nps, nns;
	reg zns, ons, cns, nns;
	reg [31:0] outps, outns;

	assign zero = zns;
	assign overflow = ons;
	assign carryout = cns;
	assign negative = nns;
	assign busOut = outns;

	addition add1  (busADD, busA, busB, zADD, oADD, cADD, nADD);
	subtract sub1  (busSUB, busA, busB, zSUB, oSUB, cSUB, nSUB);
	andGate  and1  (busAND, busA, busB, zAND, oAND, cAND, nAND);
	orGate   or1   (busOR,  busA, busB, zOR,  oOR,  cOR,  nOR );
	xorGate  xor1  (busXOR, busA, busB, zXOR, oXOR, cXOR, nXOR);
	setLT    slt1  (busSLT, busA, busB, zSLT, oSLT, cSLT, nSLT); // (R[rt] = (R[rs] < R[rt])? 32'b1:32'b0), set less than
	shiftll  sll1  (busSLL, busA, busB, zSLL, oSLL, cSLL, nSLL); // shift left logical, assuming busB input a 3 bit control signal

	always @(*) begin
		if (control == NOP) begin
			zns = 1'b1;
			ons = 1'b0;
			cns = 1'b0;
			nns = 1'b0;
			outns = nul;
		end else if (control == ADD) begin
			zns = zADD;
			ons = oADD;
			cns = cADD;
			nns = nADD;
			outns = busADD;
		end else if (control == SUB) begin
			zns = zSUB;
			ons = oSUB;
			cns = cSUB;
			nns = nSUB;
			outns = busSUB;
		end else if (control == AND) begin
			zns = zAND;
			ons = oAND;
			cns = cAND;
			nns = nAND;
			outns = busAND;
		end else if (control == OR) begin
			zns = zOR;
			ons = oOR;
			cns = cOR;
			nns = nOR;
			outns = busOR;
		end else if (control == XOR) begin
			zns = zXOR;
			ons = oXOR;
			cns = cXOR;
			nns = nXOR;
			outns = busXOR;
		end else if (control == SLT) begin
			zns = zSLT;
			ons = oSLT;
			cns = cSLT;
			nns = nSLT;
			outns = busSLT;
		end else if (control == SLL) begin
			zns = zSLL;
			ons = oSLL;
			cns = cSLL;
			nns = nSLL;
			outns = busSLL;
		end else begin
			zns = 1'bZ;
			ons = 1'bZ;
			cns = 1'bZ;
			nns = 1'bZ;
			outns = nul;
		end
	end

//	always @(posedge clk) begin
	//	zps <= zns;
	//	ops <= ons;
	//	cps <= cns;
	//	nps <= nns;
	//	outps <= outns;
	//end

endmodule

module ALUnit_Testbench();
	reg CLOCK_50;    // Clock
	reg [2:0]  control;
	reg [31:0] busA, busB;
	wire [31:0] busOut;
	wire zero, overflow, carryout, negative;

	ALUnit dut (CLOCK_50, control, busA, busB, busOut, zero, overflow, carryout, negative);
	// Set up the clocking
	
	parameter CLOCK_PERIOD = 100;
	initial CLOCK_50 = 1;
	always begin
		#(CLOCK_PERIOD / 2);
		CLOCK_50 = ~CLOCK_50;
	end 
	

	// Set up the inputs to the design
	integer i;
	initial begin
						      	@(posedge CLOCK_50);
		busA = 32'h01010101; busB = 32'h01010101; control = 3'b000;	
		@(posedge CLOCK_50);
		@(posedge CLOCK_50);
		@(posedge CLOCK_50);
		@(posedge CLOCK_50);
		@(posedge CLOCK_50);
		busA = 32'h7FFFFFFF; busB = 32'h7FFFFFFF; control = 3'b001;	
						      	@(posedge CLOCK_50);
						      	@(posedge CLOCK_50);
		@(posedge CLOCK_50);
		@(posedge CLOCK_50);
		@(posedge CLOCK_50);
		@(posedge CLOCK_50);
		busA = 32'h01010101; busB = 32'hFFFFFFFF; control = 3'b010;
			@(posedge CLOCK_50);
						      	@(posedge CLOCK_50);
		@(posedge CLOCK_50);
		@(posedge CLOCK_50);
		@(posedge CLOCK_50);
		@(posedge CLOCK_50);
		busA = 32'h00000001; busB = 32'hF0000000; control = 3'b011;
		@(posedge CLOCK_50);
		@(posedge CLOCK_50);
		@(posedge CLOCK_50);
		@(posedge CLOCK_50);
		@(posedge CLOCK_50);
		busA = 32'hFFFFFFFF; busB = 32'h01010101; control = 3'b100;
		@(posedge CLOCK_50);
		@(posedge CLOCK_50);
		@(posedge CLOCK_50);
		@(posedge CLOCK_50);
		@(posedge CLOCK_50);
		busA = 32'hF0000000; busB = 32'h00000001; control = 3'b101;
		@(posedge CLOCK_50);
		@(posedge CLOCK_50);
		@(posedge CLOCK_50);
		@(posedge CLOCK_50);
		@(posedge CLOCK_50);
		busA = 32'h00000000; busB = 32'h00000002; control = 3'b110;
		@(posedge CLOCK_50);
		@(posedge CLOCK_50);
		@(posedge CLOCK_50);
		@(posedge CLOCK_50);
		@(posedge CLOCK_50);
		busA = 32'h00000010; busB = 32'h00000034; control = 3'b111;
		@(posedge CLOCK_50);
		@(posedge CLOCK_50);
		@(posedge CLOCK_50);
		@(posedge CLOCK_50);
		@(posedge CLOCK_50);
		$stop;
	end
endmodule 
