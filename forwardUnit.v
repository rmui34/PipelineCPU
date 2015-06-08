// Forwarding Unit for pipelining CPU
module forwardUnit (IDEXRs, IDEXRt, EXMEMRd, MEMWBRd, EXMEMRegWrite, MEMWBRegWrite,ForwardA, ForwardB);
	input [4:0] IDEXRs, IDEXRt, EXMEMRd, MEMWBRd;
	input EXMEMRegWrite, MEMWBRegWrite;
	output reg [1:0] ForwardA, ForwardB;

	//Forward A
	always @(EXMEMRegWrite or MEMWBRegWrite or EXMEMRd or MEMWBRd or IDEXRs)
		begin
			if (EXMEMRegWrite && (EXMEMRd != 0) && (EXMEMRd == IDEXRs))
				ForwardA = 2'b10;
			else if (MEMWBRegWrite && (MEMWBRd != 0) &&  ~(EXMEMRegWrite && (EXMEMRd != 0) && (EXMEMRd == IDEXRs)) && (MEMWBRd == IDEXRs))
				ForwardA = 2'b01;
			else
				ForwardA = 2'b00;
		end

	//Forward B
	always @(EXMEMRegWrite or MEMWBRegWrite or EXMEMRd or MEMWBRd or IDEXRt)
		begin
			if (EXMEMRegWrite && (EXMEMRd != 0) && (EXMEMRd == IDEXRt))
				ForwardB = 2'b10;
			else if (MEMWBRegWrite && (MEMWBRd != 0) &&  ~(EXMEMRegWrite && (EXMEMRd != 0) && (EXMEMRd == IDEXRt)) && (MEMWBRd == IDEXRt))
				ForwardB = 2'b01;
			else
				ForwardB = 2'b00;
		end


endmodule

module forwardUnit_test ();
	reg [4:0] IDEXRs, IDEXRt, EXMEMRd, MEMWBRd;
	reg EXMEMRegWrite, MEMWBRegWrite;
	wire [1:0] ForwardA, ForwardB;

	forwardUnit dut(IDEXRs, IDEXRt, EXMEMRd, MEMWBRd, EXMEMRegWrite, MEMWBRegWrite,ForwardA, ForwardB);

	parameter d = 20;

	initial begin
		#d;
		EXMEMRegWrite <= 1'b1; MEMWBRegWrite <= 1'bx; 
		EXMEMRd <= 5'b1; MEMWBRd <= 5'bx; 
		IDEXRs  <= 5'b1;  IDEXRt <= 5'b1; 
		#d;#d;
		EXMEMRegWrite <= 1'b1; MEMWBRegWrite <= 1'b1; 
		EXMEMRd <= 5'b00100; MEMWBRd <= 5'b1; 
		IDEXRs  <= 5'b1;  IDEXRt <= 5'b1; 
		#d;#d;
		EXMEMRegWrite <= 1'b1; MEMWBRegWrite <= 1'b1; 
		EXMEMRd <= 5'b1; MEMWBRd <= 5'b1; 
		IDEXRs  <= 5'b1;  IDEXRt <= 5'b00100; 
		#d;#d;
		EXMEMRegWrite <= 1'b0; MEMWBRegWrite <= 1'b1; 
		EXMEMRd <= 5'bx; MEMWBRd <= 5'b1; 
		IDEXRs  <= 5'b00101;  IDEXRt <= 5'b1; 
		#d;
		$stop;
		$finish;
	end 
endmodule
