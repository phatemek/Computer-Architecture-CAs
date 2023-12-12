module counter_2b(enCnt, ldcnt, parIn, rstcnt, clk, rst, cnt, carryOut);
  input enCnt, ldcnt,rstcnt, clk, rst;
  input [1:0] parIn;
  output reg carryOut = 0;
  output reg [1:0] cnt = 0;
  always @(posedge clk, posedge rst)begin
    if (rst || rstcnt)begin
      cnt <= 0;
      carryOut <= 0;
    end
    else if(ldcnt)begin
      cnt = parIn;
      carryOut <= 0;
    end
    else if(enCnt) {carryOut, cnt} <= cnt + 1;
  end
endmodule