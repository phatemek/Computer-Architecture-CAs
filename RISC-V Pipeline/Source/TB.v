module PipelineTB();
  reg clk = 0;
  reg rst = 1;
  wire done;
  pipeline UUT(clk, rst, done);
  always #20 clk = ~clk;
  always @(posedge done)#10 $stop;
  initial #10 rst = 0;
endmodule