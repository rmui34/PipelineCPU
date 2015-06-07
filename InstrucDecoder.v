module InstrucDecoder (instr[31:26], j, br, Mem2Reg, ALUop, MemWrEn, ALUsrc, RegDst, regWR);

input [31:26] instr;
output reg regWR, j, br, Mem2Reg, MemWrEn, ALUsrc, RegDst;
output reg [1:0] ALUop;
parameter nop=6'b101100,add=6'b100000, sub=6'b100010, AND=6'b100100, OR=6'b100101, XOR=6'b100110, slt=6'b101010,
				sll=6'b000000, lw=6'b100011, sw=6'b101011, jmp=6'b000010, jr=6'b001000, bne=6'b000101;


always @(*)
	begin
		case(instr)
			nop:	begin
						RegDst = 1;
						j = 0; 
						br = 0;
						Mem2Reg = 0;
						ALUop = 2;
						MemWrEn = 1;
						ALUsrc = 0;
						regWR = 0;
						end
			add:	begin
						RegDst = 1;
						j = 0;
						br = 0;
						Mem2Reg = 0;
						ALUop = 2;
						MemWrEn = 1;
						ALUsrc = 0;
						regWR = 0;
						end			
			sub:	begin
						RegDst = 1;
						j = 0;
						br = 0;
						Mem2Reg = 0;
						ALUop = 2;
						MemWrEn = 1;
						ALUsrc = 0;
						regWR = 0;
						end
			AND:	begin
						RegDst = 1;
						j = 0;
						br = 0;
						Mem2Reg = 0;
						ALUop = 2;
						MemWrEn = 1;
						ALUsrc = 0;
						regWR = 0;
						end
			OR:		begin
						RegDst = 1;
						j = 0;
						br = 0;
						Mem2Reg = 0;
						ALUop = 2;
						MemWrEn = 1;
						ALUsrc = 0;
						regWR = 0;
						end
			XOR:	begin
						RegDst = 1;
						j = 0;
						br = 0;
						Mem2Reg = 0;
						ALUop = 2;
						MemWrEn = 1;
						ALUsrc = 0;
						regWR = 0;
						end
			slt:	begin
						RegDst = 1;
						j = 0;
						br = 0;
						Mem2Reg = 0;
						ALUop = 2;
						MemWrEn = 1;
						ALUsrc = 0;
						regWR = 0;
						end
			sll:	begin
						RegDst = 1;
						j = 0;
						br = 0;
						Mem2Reg = 0;
						ALUop = 2;
						MemWrEn = 1;
						ALUsrc = 0;
						regWR = 0;
						end
			lw:		begin
						RegDst = 0;
						j = 0;
						br = 0;
						Mem2Reg = 1;
						ALUop = 0;
						MemWrEn = 1;
						ALUsrc = 1;
						regWR = 0;
						end
			sw:		begin
						RegDst = 0;
						j = 0;
						br = 0;
						Mem2Reg = 1;
						ALUop = 0;
						MemWrEn = 0;
						ALUsrc = 1;
						regWR = 1;
						end
			jmp:		begin
						RegDst = 0;
						j = 1;
						br = 0;
						Mem2Reg = 1;
						ALUop = 0;
						MemWrEn = 1;
						ALUsrc = 1;
						regWR = 1;
						end
			jr:		begin
						RegDst = 0;
						j = 1;
						br = 0;
						Mem2Reg = 1;
						ALUop = 2;
						MemWrEn = 1;
						ALUsrc = 1;
						regWR = 1;
						end
			bne:	begin
						RegDst = 0;
						j = 0;
						br = 1;
						Mem2Reg = 1;
						ALUop = 1;
						MemWrEn = 1;
						ALUsrc = 0;
						regWR = 0;
						end
			default: begin 
						RegDst = 1'bx;
						j = 1'bx;
						br = 1'bx;
						Mem2Reg = 1'bx;
						ALUop = 1'bx;
						MemWrEn = 1'b1;
						ALUsrc = 1'bx;
						regWR = 1'b1;
						end 
		endcase
	end

endmodule
