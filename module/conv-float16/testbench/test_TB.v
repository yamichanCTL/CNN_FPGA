`timescale 100 ns / 10 ps

module test_TB #(
	parameter a = 16
);
reg clk, rst_n;
reg [a-1:0] data;
wire [a-1:0] dataout;

localparam PERIOD = 2;

always
	#(PERIOD/2) clk = ~clk;

initial begin
	#0
	clk = 1'b0;rst_n = 1;
	data =  4'h3;
	#2 rst_n = 0;

end

test 
#(
	.a(a)
)
test_inst
(
	.clk(clk),
	.rst_n(rst_n),
	.data(data),
	.dataout(dataout)
);

endmodule
