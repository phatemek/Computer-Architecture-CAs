module RiscVMultiCycle(input clk, input rst, output done);
  wire [6:0] op, func7;
  wire [2:0] func3, ImmSrc, ALUControl;
  wire zero, lt, PCSrc, MemWrite, ALUSrc, RegWrite, PCWrite, AdrSrc, IRWrite;
  wire [1:0] ResultSrc, ALUSrcA, ALUSrcB;

  controller my_con(clk, rst, op, func3, func7, zero, lt, PCWrite, AdrSrc, MemWrite, IRWrite,
                    ResultSrc, ALUControl, ALUSrcB, ALUSrcA, ImmSrc, RegWrite, done);

  DataPath dat(clk, rst, PCWrite, AdrSrc, IRWrite, RegWrite, MemWrite, ResultSrc, ALUControl,
  	       ALUSrcB, ALUSrcA, ImmSrc, op, func7, func3, lt, zero);
endmodule