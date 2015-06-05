
module registerSingle (
	input clk,
	input rst,    // active low reset
	input writeEnable, // Read is high, write is low; Active low write enable
	input writeData,  
	output readData
);
	wire qBar;
	wire ns;
	mux2_1 mux(ns, writeData, readData, writeEnable);
	DFlipFlop register (readData, qBar, ns, clk, rst);
endmodule