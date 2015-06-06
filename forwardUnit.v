// Forwarding Unit for pipelining CPU
module forwardUnit (
	// input clk,    // Clock
	input [4:0] RsEX, RtEX, RdRtME, RdRtWB,
	input RegWriteME, RegWriteWB,
	output [1:0] ForwardA, ForwardB
);

	always @(*) begin
		// Data Hazard
	end

endmodule