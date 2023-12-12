module DataPath(clk, rst, x, enx, y, eny, xp, yp, ensz, enCnt, ldcnt, rstcnt, rstpnt, pop, ins, sel, selAlu, cnt, carryOut, stback, stfront, shiftl, doneRun);
  input clk, rst, enx, eny, ensz, enCnt, ldcnt ,rstcnt, pop, ins, sel, selAlu, shiftl, rstpnt;
  output [1:0] cnt;
  output carryOut, doneRun;
  wire [7:0] sz;
  output [4:0] x, y, xp, yp;
  output [1:0] stback;
  output [1:0] stfront;
  wire [1:0] parIn;
  wire [4:0] w; 
  wire [7:0] q;
  wire [0:255] s0, s1;
  wire [7:0] pnt;
  wire [7:0] i0;
  wire [4:0] z;
  reg_8b regpnt(i0, shiftl, clk, rst | rstpnt, pnt);
  reg_5b regx(w, enx, clk, rst, x);
  reg_5b regy(w, eny, clk, rst, y);
  reg_8b regsz(q, ensz, clk, rst, sz);
  counter_2b count1(enCnt, ldcnt, parIn, rstcnt, clk, rst, cnt, carryOut);
  mux_2_to_1 mux1(y, x, sel, z);
  stack_255b path(cnt, pop, ins, clk, rst, sz, s1, s0);
  ALU_8b alu1(sz, ins, q);
  ALU_4b alu2(z, selAlu, w);
  mux_2_to_1 mux2(x, w, sel, xp);
  mux_2_to_1 mux3(w, y, sel, yp);
  assign stfront = (sz > 0)?{s1[sz - 1], s0[sz - 1]}:0;
  assign stback = {s1[pnt], s0[pnt]};
  assign doneRun = (sz == pnt + 1) ? 1:0;
  assign parIn = stfront + 1; 
  assign i0 = pnt + 1;
endmodule