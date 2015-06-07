// Forwarding Unit for pipelining CPU
module forwardUnit (IDEXRs, IDEXRt, EXMEMRdMEM, MEMWBRd, EXMEMRegWrite, MEMWBRegWrite,ForwardA, ForwardB);
	input [4:0] IDEXRs, IDEXRt, EXMEMRd, MEMWBRd;
	input EXMEMRegWrite, MEMWBRegWrite;
	output reg [1:0] ForwardA, ForwardB


	//Forward A
	always @(EXMEMRegWrite or MEMWBRegWrite or EXMEMRd or MEMWBRd or IDEXRs)
		begin
			if (EXMEMRegWrite && (EXMEMRd != 0) && (EXMEMRd == IDEXRs))
				ForwardA = 2'b10;
			else if(MEMWBRegWrite && (MEMWBRd != 0) &&  ~(EXMEMRegWrite & (EXMEMRd != 0)) && (EXMEMRd !=IDEXRs) && (MEMWBRd == IDEXRs))
				ForwardA = 2'b01;
			else
				ForwardA = 2'b00;
		end


	//Forward B
	always @(EXMEMRegWrite or MEMWBRegWrite or EXMEMRd or MEMWBRd or IDEXRt)
		begin
			if(EXMEMRegWrite && (EXMEMRd != 0) && (EXMEMRd == IDEXRt))
				ForwardB = 2'b10;
			else if (MEMWBRegWrite && (MEMWBRd != 0) &&  ~(EXMEMRegWrite & (EXMEMRd != 0)) && (EXMEMRd !=IDEXRt) && (MEMWBRd == IDEXRt))
				ForwardB = 2'b01;
			else
				ForwardB = 2'b00;

		end

endmodule
