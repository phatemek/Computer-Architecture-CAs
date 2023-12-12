module RiscVSingleCycle(input clk, input rst, output done);

  wire [6:0] op, func7;

  wire [2:0] func3, ImmSrc, ALUControl;

  wire zero, lt;

  wire PCSrc, MemWrite, ALUSrc, RegWrite, jalrSel;

  wire [1:0] ResultSrc;

  controller cont(clk, op, func3, func7, zero, lt, PCSrc, ResultSrc, MemWrite, ALUControl, ALUSrc,ImmSrc, RegWrite, jalrSel, done);

   DataPath dat(clk, rst, PCSrc, ResultSrc, MemWrite, ALUControl, ALUSrc, ImmSrc, RegWrite, jalrSel, op, func7, func3, lt, zero);

endmodule