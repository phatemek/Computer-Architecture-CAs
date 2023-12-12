`define lw   7'b0000011
`define sw   7'b0100011
`define RT   7'b0110011
`define BT   7'b1100011
`define IT   7'b0010011
`define jalr 7'b1100111
`define jal  7'b1101111
`define lui  7'b0110111

`define S0  5'b00000
`define S1  5'b00001
`define S2  5'b00010
`define S3  5'b00011
`define S4  5'b00100
`define S5  5'b00101
`define S6  5'b00110
`define S7  5'b00111
`define S8  5'b01000
`define S9  5'b01001
`define S10 5'b01010
`define S11 5'b01011
`define S12 5'b01100
`define S13 5'b01101
`define S14 5'b01110
`define S15 5'b01111
`define S16 5'b10000
`define S17 5'b10001
`define S18 5'b10010
`define S19 5'b10011
`define S20 5'b10100

module controller(clk, rst, op, func3, func7, zero, lt, PCWrite, AdrSrc, MemWrite, IRWrite,
    ResultSrc, AluControl, AluSrcB, AluSrcA, ImmSrc, RegWrite, done);
input clk, rst, zero, lt;
input[6:0] op, func7;
input [2:0] func3;
output reg PCWrite, AdrSrc, MemWrite, IRWrite, RegWrite, done;
output reg[1:0] ResultSrc, AluSrcB, AluSrcA;
output reg[2:0] ImmSrc;
output[2:0] AluControl;
reg [1:0]AluOp;
reg branch;
reg[4:0] ns, ps = `S0;
wire beq, bne, blt, bge;
assign beq = branch & (func3 == 3'b000);
assign bne = branch & (func3 == 3'b001);
assign blt = branch & (func3 == 3'b100);
assign bge = branch & (func3 == 3'b101);
assign AluControl = (AluOp == 2'b00)? 3'b000:
                    (AluOp == 2'b01)? 3'b001:
                    (AluOp == 2'b11)? 3'b100:
                    (AluOp == 2'b10)? (func3 == 3'b000)? ((op == `RT & func7 == 7'b0100000)? 3'b001: 3'b000):
                                      (func3 == 3'b111)? 3'b010:
                                      (func3 == 3'b100)? 3'b111:
                                      (func3 == 3'b110)? 3'b011:
                                      (func3 == 3'b010)? 3'b101: 3'b000: 3'b000;

always@(ps, beq, bne, blt, bge, zero, lt) begin
 ns = `S0;
 {PCWrite, AdrSrc, MemWrite, IRWrite, RegWrite, branch, done} = 7'b0;
 {ResultSrc, AluSrcB, AluSrcA, AluOp} = 8'b0;
 ImmSrc = 3'b0;

 case(ps)
  `S0:  begin IRWrite = 1; AluSrcB = 2'b10; ResultSrc = 2'b10; PCWrite = 1; ns = `S1; end
  `S1:  begin AluSrcB = 2'b01; AluSrcA = 2'b01; ImmSrc = 3'b010; 
         ns = (op == `lw)? `S3:
      	(op == `sw)?   `S6:
      	(op == `RT)?   `S8:
      	(op == `BT)?   `S2:
      	(op == `IT)?   `S10:
      	(op == `jalr)? `S12:
      	(op == `jal)?  `S15:
      	(op == `lui)?  `S18: `S20;
        end
    	`S2:  begin AluSrcA = 2'b10; AluOp = 2'b01; branch = 1; PCWrite = (beq & zero)? 1:
									  (bne & ~zero)? 1:
									  (blt & lt)? 1:
									  (bge & ~lt)? 1:0;
		    ns = `S0; end
        `S3:  begin AluSrcA = 2'b10; AluSrcB = 2'b01; ns = `S4; end
        `S4:  begin AdrSrc = 1; ns = `S5; end
        `S5:  begin ResultSrc = 2'b01; RegWrite = 1; ns = `S0; end
        `S6:  begin ImmSrc = 3'b001; AluSrcA = 2'b10; AluSrcB = 2'b01; ns = `S7; end
        `S7:  begin AdrSrc = 1; MemWrite = 1; ns = `S0; end
        `S8:  begin AluSrcA = 2'b10; AluOp = 2'b10; ns = `S9; end
        `S9:  begin RegWrite = 1; ns = `S0; end
        `S10: begin AluSrcA = 2'b10; AluSrcB = 2'b01; AluOp = 2'b10; ns = `S11; end
        `S11: begin RegWrite = 1; ns = `S0; end
        `S12: begin AluSrcA = 2'b10; AluSrcB = 2'b01; ns = `S13; end
        `S13: begin PCWrite = 1; AluSrcA = 2'b01; AluSrcB = 2'b10; ns = `S14; end
        `S14: begin RegWrite = 1; ns = `S0; end
        `S15: begin AluSrcA = 2'b01; AluSrcB = 2'b01; ImmSrc = 3'b011; ns = `S16; end
        `S16: begin PCWrite = 1; AluSrcA = 2'b01; AluSrcB = 2'b10; ns = `S17; end
        `S17: begin RegWrite = 1; ns = `S0; end
        `S18: begin ImmSrc = 3'b100; AluSrcB = 2'b01; AluOp = 2'b11; ns = `S19; end
        `S19: begin RegWrite = 1; ns = `S0; end
  	`S20: begin done = 1; ns = `S20; end
 endcase
end

always@(posedge clk) begin
 ps <= ns;
end
endmodule