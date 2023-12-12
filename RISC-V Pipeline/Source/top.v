module pipeline(input clk, rst, output done);
    wire PCSrcD, MemWriteD, ALUSrcD, RegWriteD, StallF, StallD, FlushD, FlushE, lt, zero, PCSrcE,
     RegWriteM, RegWriteW, beq, bne, blt, bge, jmp, jalrSel;
    wire [1:0] ResultSrcD, ForwardAE, ForwardBE, ResultSrcE;
    wire [2:0] ALUControlD, ImmSrcD, func3;
    wire [4:0] Rs1D, Rs2D, Rs1E, Rs2E, RdE, RdM, RdW;
    wire [6:0] op, func7;
    DataPath datapath(clk, rst, jalrSel, PCSrcD, ResultSrcD, MemWriteD, ALUControlD, ALUSrcD, ImmSrcD, RegWriteD,
                      StallF, StallD, FlushD, FlushE, ForwardAE, ForwardBE, op, func7, func3, beq, bne,
                      blt, bge, jmp, Rs1D, Rs2D, Rs1E, Rs2E, RdE, PCSrcE, ResultSrcE, RdM, RegWriteM, RdW, RegWriteW);
    controller cntrlr(clk, op, func3, func7, beq, bne, blt, bge, jmp, ResultSrcD, MemWriteD, ALUControlD, ALUSrcD,
                      ImmSrcD, RegWriteD, jalrSel, done);
    hazardunit hzrdunit(clk, Rs1D, Rs2D, Rs1E, Rs2E, RdE, PCSrcE, ResultSrcE[0], RdM, RegWriteM, RdW,
                        RegWriteW, StallF, StallD, FlushD, FlushE, ForwardAE, ForwardBE);
endmodule