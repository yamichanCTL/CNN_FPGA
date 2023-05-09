`timescale 100 ns / 10 ps

module processingElement_TB();
	parameter DATA_WIDTH = 16;
	parameter WEIGHT_LENGTH = 3;
	parameter WEIGHT_WIDTH = 3;
	//parameter EXP = 5;//2^EXP==WEIGHT_WIDTH^2
reg clk,reset,conv_en;
reg [DATA_WIDTH-1:0] floatA, floatB;
wire [DATA_WIDTH-1:0] result;
wire out_valid;
//wire [EXP-1:0]i;
reg [0:9]test;

localparam PERIOD = 2;

always
	#(PERIOD/2) clk = ~clk;

initial begin
	#0
	clk = 1'b0;reset = 1;
	// A = 1 , B = 2
	floatA = 16'h3C00;
	floatB = 16'h4000;
	conv_en = 0;test = 10'b1111100000;
	$display("This is a 0th number:%b ", test[0], "!!!");
	$display("This is a 9th number:%b ", test[9], "!!!");

	#PERIOD     reset = 0;conv_en = 1;

	#PERIOD 	floatA = 16'h3_C_0_0;floatB = 16'h4000;conv_en = 1;
	#PERIOD 	floatA = 16'h3C00;floatB = 16'h4000;conv_en = 1;
	#PERIOD 	floatA = 16'h3C00;floatB = 16'h4000;conv_en = 1;
	#PERIOD 	floatA = 16'h3C00;floatB = 16'h4000;conv_en = 1;
	#PERIOD 	floatA = 16'h3C00;floatB = 16'h4000;conv_en = 1;
	#PERIOD 	floatA = 16'h3C00;floatB = 16'h4000;conv_en = 1;
	#PERIOD 	floatA = 16'h3C00;floatB = 16'h4000;conv_en = 1;
	#PERIOD 	floatA = 16'h3C00;floatB = 16'h4000;conv_en = 1;
	#PERIOD 	floatA = 16'h3C00;floatB = 16'h4000;conv_en = 1;
	#PERIOD 	floatA = 16'h3C00;floatB = 16'h4000;conv_en = 0;
	#PERIOD 	floatA = 16'h3C00;floatB = 16'h4000;conv_en = 1;
	#PERIOD 	floatA = 16'h3C00;floatB = 16'h4000;conv_en = 1;
	
end

processingElement16 #(
.DATA_WIDTH(DATA_WIDTH),
.WEIGHT_LENGTH(WEIGHT_LENGTH),
.WEIGHT_WIDTH(WEIGHT_WIDTH)
//.EXP(EXP)
)PE(
	.clk(clk),
	.reset(reset),
	.floatA(floatA),
	.floatB(floatB),
	.result(result),
	.conv_en(conv_en),
	.out_valid(out_valid)
	//.i(i)
);



endmodule
