module tb;
reg[0:3] memRow[0:3];
reg[0:15] mem;
integer i;

initial begin
	memRow[0] = 4'b0111;
	memRow[1] = 4'b0011;
	memRow[2] = 4'b0011;
	memRow[3] = 4'b0011;
	for(i = 0; i < 4; i = i + 1) begin
		mem[(4*i) +: 4] = memRow[i];
	end
	$display("%b", mem);
end
endmodule