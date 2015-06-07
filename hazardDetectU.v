// Checking for load instructions, the control for the hazard detection unit is this single condition.

// The first line tests to see if the instruction is a load: the only instruction that reads data memory is a load.
// The next two lines check to see if the destination register field of the load in the EX stage matches either source register
// of the instruction in the ID stage. If the condition holds, the instruction stalls one clock cycle. After this 1-cycle stall,
//  the forwarding logic can handle the dependence and execution proceeds.
module hazardDetectU(IFIDRegRs,IFIDRegRt,IDEXRegRt,IDEXMemRead,IFIDWr,PCWr,hazCtrl)
  input [4:0]IFIDRegRs,IFIDRegRt,IDEXRegRt;
  input IDEXMemRead;

  output reg IFIDWr,PCWr hazCtrl;

  always @(IFIDRegRs,IFIDRegRt,IDEXRegRt,IDEXMemRead)
    if(IDEXMemRead & (IDEXRegRt == IFIDRegRs) | (IDEXRegRt == IFIDRegRt))
      begin
        IFIDWr = 0;
        PCWr = 0;
        hazCtrl = 1;
      end
    else
      begin
        IFIDWr = 1;
        PCWr = 1;
        hazCtrl= 1;
      end

endmodule
