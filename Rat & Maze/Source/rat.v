module rat(start, clk, rst, run, fail, done, move);
  input start, clk, rst, run;
  output fail, done;
  output [1:0] move;
  wire [4:0] x, y, xp, yp, xm, ym;
  wire Co, doneRun, Din, ins, pop, shiftl, rstcnt, rstpnt, ldcnt,  sel, selAlu, enx, eny, ensz, enCnt, init, RD,
    WR, Dout, readMap;
  wire [1:0] cnt, stfront, stback;
  controller controllerT(x, y, xp, yp, Co, cnt, stfront, stback, doneRun, Din, start, run, clk, rst,
   fail, done, move, ins, pop, shiftl, rstcnt, rstpnt, ldcnt, sel, selAlu, enx, eny, ensz, enCnt, init, RD, WR,
   xm, ym, Dout, readMap);
  DataPath DataPathT(clk, rst | init, x, enx, y, eny, xp, yp, ensz, enCnt, ldcnt, rstcnt, rstpnt, pop, ins, sel,
   selAlu, cnt, Co, stback, stfront, shiftl, doneRun);
  memory memoryT(xm, ym, Dout, readMap | init, RD, WR, clk, rst, Din);
endmodule