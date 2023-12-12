module TB();
	reg start = 0, clk = 0, rst = 0, run = 0;
	wire fail, done;
	wire[1:0] move;
	rat UUT(start, clk, rst, run, fail, done, move);
	always #10 clk = ~clk;
initial begin
	#25 start = 1;
	#14000 rst = 1; run = 0;
	#20 rst = 0;
end
always@(posedge done) begin
	#95 run = 1;
end
endmodule