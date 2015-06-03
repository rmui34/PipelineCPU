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
        hazCtrl= 0;
      end

endmodule
