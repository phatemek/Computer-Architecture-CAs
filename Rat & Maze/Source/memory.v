module memory(Xm, Ym, Din, readMap, RD, WR, clk, rst, Dout);
input[4:0]Xm, Ym;
input Din, readMap, RD, WR,clk, rst;
output Dout;
integer i;

wire [7:0] addrs;
wire dataout;
reg[0:255] mem;
reg[0:15] memRow[0:15];
initial begin $readmemh("input.txt", memRow);
	for (i = 0; i < 16; i = i + 1) $display("%b", memRow[i]);
end
assign addrs = {Ym[3:0], Xm[3:0]};
assign dataout = ~((5'd0 <= Xm) & (Xm <= 5'd15) & (5'd0 <= Ym) & (Ym <= 5'd15) & (mem[addrs] == 0));
assign Dout = RD? dataout:Dout;
always@(posedge clk, posedge rst) begin
 if(rst)
  mem = 256'b0;
 else if(readMap) begin
  for(i = 0; i < 16; i = i + 1) begin
   mem[16*i +: 16] = memRow[i];
  end
  mem[0] = 1;
  $display("%b", mem[3]);
 end
 else if(WR) mem[addrs] = Din;
end
endmodule