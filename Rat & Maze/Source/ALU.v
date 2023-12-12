module ALU_4b(d, sel, y);
  input sel;
  input [4:0] d;
  output [4:0] y;
  assign y[4]=(&{sel, d[3:0]}) | ((~|{d}) & (~sel));
  assign y[3:0] = sel? d + 1:d - 1;
endmodule

module ALU_8b(d, sel, y);
  input sel;
  input [7:0] d;
  output [7:0] y;
  assign y = sel?d + 1:d - 1;
endmodule

