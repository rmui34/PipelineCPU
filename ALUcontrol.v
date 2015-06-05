module ALUcontrol (ALUop, instr, ALUin);
	input [1:0] ALUop;
	input [5:0] instr;
	output reg [2:0] ALUin;
	parameter [2:0] NOP = 3'b000, ADD = 3'b001, SUB = 3'b010, AND = 3'b011, OR = 3'b100, XOR = 3'b101, SLT = 3'b110, SLL = 3'b111;

	always @(*) begin
		if (ALUop[1]) begin
			case (instr)
				6'b100000: ALUin = ADD;
				6'b100010: ALUin = SUB;
				6'b100100: ALUin = AND;
				6'b100101: ALUin = OR;
				6'b100110: ALUin = XOR;
				6'b101010: ALUin = SLT;
				6'b000000: ALUin = SLL;
				default :  ALUin = NOP;
			endcase
		end else begin
			if(ALUop[0])
				ALUin = SUB;
			else
				ALUin = ADD;
		end
	end

endmodule