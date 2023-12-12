`define S0 4'b0000

`define S1 4'b0001

`define S2 4'b0010

`define S3 4'b0011

`define S4 4'b0100

`define S5 4'b0101

`define S6 4'b0110

`define S7 4'b0111

`define S8 4'b1000

`define S9 4'b1001

`define S10 4'b1010

`define S11 4'b1011

module controller(X, Y, Xp, Yp, Co, cnt, stkfront, stkback, doneRun, Din, start, run, clk, rst, fail, done, move,
       push, pop, shiftl, rstcntr, rstpnt, loadcntr, sel, selALU, enX, enY, enReg, enCnt, init, RD, WR, Xm, Ym, Dout, readMap);

input[4:0] X, Y, Xp, Yp;

input[1:0] cnt, stkfront, stkback;

input Co, doneRun, Din, start, run, clk, rst;

output fail, done, push, pop, shiftl, rstcntr, rstpnt, loadcntr, sel, selALU, enX, enY, enReg, enCnt, init, RD, WR, Dout, readMap;

output [1:0] move;

output[4:0] Xm, Ym;

reg fail, done, push, pop, shiftl, rstcntr, rstpnt, loadcntr, sel, selALU, enX, enY, enReg, enCnt, init, WR, Dout, readMap;

reg RD = 1'b1;

reg [3:0] ps, ns;



assign Xm = Xp;

assign Ym = Yp;



always@(posedge clk or posedge rst) begin

 if(rst)

  ps = `S0;

 else

  ps = ns;

end



always@(ps or start or Din or Co or X or Y or run or doneRun) begin

 ns = `S0;

 case(ps)

  `S0: ns = start? `S1:`S0;

  `S1: begin

   if (X == 15 & Y == 15) ns = `S5;

   else if (Co == 1 & X == 0 & Y == 0) ns = `S4;

   else if (Co == 1) ns = `S3;

   else if (Din) ns = `S8;

   else ns = `S2;

  end

  `S2: ns = `S9;

  `S3: ns = `S10;

  `S4: ns = `S4;

  `S5: ns = run? `S6:`S5;

  `S6: ns = doneRun? `S7:`S6;

  `S7: ns = `S0;

  `S8: ns = `S11;

  `S9: ns = `S1;

  `S10: ns = `S1;

  `S11: ns = `S1;

 endcase

end



always@(ps) begin

 {fail, done, push, pop, shiftl, rstcntr, rstpnt, loadcntr, sel, selALU, enX, enY, enReg, enCnt, init, WR, Dout, readMap} = 18'b0;

 case(ps)

  `S0: begin init = 1; Dout = 1; WR = 1; readMap = 1; end

  `S1: begin sel = cnt[0]^cnt[1]; selALU = cnt[0]; end

  `S2: begin push = 1; rstcntr = 1; sel = cnt[0] ^ cnt[1]; selALU = cnt[0];

      Dout = 1; enX = sel; enY = ~sel; WR = 1; enReg = 1; end

  `S3: begin pop = 1; loadcntr = 1; sel = stkfront[0] ^ stkfront[1]; enX = sel;

      enY = ~sel; selALU = ~stkfront[0]; enReg = 1; end

  `S4: begin fail = 1; end

  `S5: begin done = 1; rstpnt = 1; end

  `S6: begin shiftl = 1; $display("%b", stkback); end

  `S7: begin done = 1; end

  `S8: begin enCnt = 1; end

 endcase

end

assign move = stkback;

endmodule


