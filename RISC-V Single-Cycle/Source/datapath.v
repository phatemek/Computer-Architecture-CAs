module DataPath(input clk, rst, PCSrc, [1:0] ResultSrc, MemWrite, [2:0] ALUControl, ALUSrc, 

  [2:0] ImmSrc, RegWrite, input jalrSel, output [6:0] op, [6:0] func7, [2:0] func3, output lt, zero);

  wire [31:0] PC, Instr, PCPlus4, PCNext, SrcA, SrcB, ImmExt, PCTarget, WriteData, ALUResult, ReadData, Result, PCN; 

  reg1 PC_reg(clk, rst, PCNext, PC);

  InstructionMemory my_Ins(PC, Instr);

  RegisterFile my_regfile(clk, Instr[19:15], Instr[24:20], Instr[11:7], Result, RegWrite, SrcA, WriteData);

  Extend my_extend(Instr[31:7], ImmSrc, ImmExt);

  DataMemory my_datamem(clk, rst, ALUResult, WriteData, Memwrite, ReadData);

  adder4 my_adder4(PC, PCPlus4);

  adder my_adder(PCN, ImmExt, PCTarget);

  ALU my_ALU(SrcA, SrcB,  ALUControl, ALUResult, zero, lt);

  mux1 my_mux1(PCSrc, PCPlus4, PCTarget, PCNext);

  mux2 my_mux2(WriteData, ImmExt, ALUSrc, SrcB);

  mux3 my_mux3(ALUResult, ReadData, PCPlus4, ResultSrc, Result);

  mux1 my_mux4(jalrSel, PC, SrcA, PCN);


  assign op = Instr[6:0];

  assign func3 = Instr[14:12];

  assign func7 = Instr[31:25];

endmodule