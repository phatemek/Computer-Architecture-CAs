module adder4(input[31:0] PC, output reg[31:0] PCPlus4);

 assign PCPlus4 = PC + 4;

endmodule











module mux2_to_1(input[31:0] x, input[31:0] y, input sel, output[31:0] ou);

 assign ou = sel? y: x;

endmodule









module adder(input[31:0] PC, input signed[31:0]ImmExt, output[31:0] PCTarget);

 assign PCTarget = PC + ImmExt;

endmodule









module mux3_to_1(input[31:0] x, input[31:0] y, input[31:0] z, input[1:0] sel,

     output reg[31:0] ou);

 always@(x, y, z, sel) begin

  case(sel)

   2'b00: ou = x;

   2'b01: ou = y;

   2'b10: ou = z;

  endcase

 end

endmodule











module ALU(input signed[31:0] SrcA, input signed[31:0] SrcB, input[2:0] ALUControl, output reg signed[31:0] ALUResult,

    output zero, lt);



 always@(ALUControl, SrcA, SrcB) begin

  case(ALUControl)

   3'b000: ALUResult = SrcA + SrcB;

   3'b001: begin ALUResult = SrcA - SrcB; end

   3'b010: ALUResult = SrcA & SrcB;

   3'b011: ALUResult = SrcA | SrcB;

   3'b100: ALUResult = SrcB;

   3'b101: ALUResult = (SrcA < SrcB);

   3'b111: ALUResult = SrcA ^ SrcB;

  endcase

 end

assign lt = (SrcA < SrcB);
assign zero = (SrcA == SrcB);


endmodule











module mux1(input PCSrc, input[31:0] PCPlus4, input[31:0] PCTarget, output[31:0] PCNext);

 assign PCNext = PCSrc? PCTarget: PCPlus4;

endmodule









module reg1(input clk, rst, en, input[31:0] PCNext, output reg[31:0] PC);

  always@(posedge clk, posedge rst) begin

  if(rst) begin PC = 32'b0; end

  else if(!en) begin PC = PCNext; end

 end

endmodule



module Extend(input signed [31:7] imm, [2:0] immSrc, output reg signed [31:0] ImmExt);

	always @(imm, immSrc) begin

	case (immSrc)

	3'b000: ImmExt = {{20{imm[31]}}, imm[31:20]};

	3'b001: ImmExt = {{20{imm[31]}}, imm[31:25], imm[11:7]};

	3'b010: ImmExt = {{19{imm[31]}}, imm[31], imm[7], imm[30:25], imm[11:8], 1'b0};

	3'b011: ImmExt = {{11{imm[31]}}, imm[31], imm[19:12], imm[20], imm[30:21], 1'b0};

	3'b100: ImmExt = {imm[31:12], 12'b0};

	endcase

	end

endmodule



module InstructionMemory(input [31:0] PC, output [31:0] Instr);

	reg[31:0] InstMem[15999:0];

	integer j;

	initial begin $readmemh("code.txt", InstMem);

			for(j = 0; j < 15; j = j + 1) $display("%h", InstMem[j]); end

	assign Instr = InstMem[PC[15:0] >> 2];

endmodule



module DataMemory(input clk, input rst, input signed [31:0] ALUResult, input signed [31:0] WriteData, input MemWrite, output signed [31:0] ReadDate);

	reg signed [31:0] DataMem[15999:0];

	integer i;

	initial begin $readmemh("array.txt", DataMem); 

			for(i = 0; i < 15; i = i + 1) $display("%h", DataMem[i]); end

	assign ReadDate = DataMem[ALUResult[15:0] >> 2];

	always @(posedge clk) begin

		if (MemWrite) DataMem[ALUResult[15:0] >> 2] = WriteData;

	end

endmodule



module RegisterFile(input clk, input [4:0] A1, [4:0] A2, [4:0] A3, [31:0] Result, input RegWrite, output signed [31:0] RD1, output signed [31:0] RD2);

	reg signed[31:0] RegFile[31:0];

	initial $readmemh("init.txt", RegFile);

	assign RD1 = RegFile[A1];

	assign RD2 = RegFile[A2];

	always @(negedge clk) begin

		if (RegWrite & A3 != 0) RegFile[A3] = Result;

	end

endmodule



module reg_en(input clk, rst, en, clr, input [31:0] Next, output reg [31:0] Now);

	always @(posedge clk, posedge rst)begin

		if (rst | clr) Now = 32'b0;

		else if(!en) Now = Next;

	end

endmodule



module reg1b(input clk, rst, en ,clr, Next, output reg Now);

	always @(posedge clk, posedge rst) begin

		if (rst | clr) Now = 0;

		else if(~en) Now = Next;

	end

endmodule 



module reg2b(input clk, rst, en, clr, input [1:0] Next, output reg [1:0] Now);

	always @(posedge clk, posedge rst) begin

		if (rst | clr) Now = 2'b0;

		else if(~en) Now = Next;

	end

endmodule



module reg3b(input clk, rst, en, clr, input [2:0] Next, output reg [2:0] Now);

	always @(posedge clk, posedge rst) begin

		if (rst | clr) Now = 3'b0;

		else if(~en) Now = Next;

	end

endmodule

