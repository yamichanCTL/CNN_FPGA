`timescale 1 ns / 1 ps

module conv2d_TB #(
    parameter integer BITWIDTH = 8,
    
    parameter integer DATAWIDTH = 4,
    parameter integer DATAHEIGHT = 4,
    parameter integer DATACHANNEL = 1,
    
    parameter integer FILTERHEIGHT = 3,
    parameter integer FILTERWIDTH = 3,
    parameter integer FILTERBATCH = 1,
    
    parameter integer STRIDEHEIGHT = 1,
    parameter integer STRIDEWIDTH = 1,
    
    parameter integer PADDINGENABLE = 0

);
reg clk, reset;
reg [0:DATACHANNEL*DATAHEIGHT*DATAWIDTH*BITWIDTH-1] image;
reg [0:FILTERBATCH*DATACHANNEL*FILTERHEIGHT*FILTERWIDTH*BITWIDTH-1] weight; 
reg [BITWIDTH * FILTERBATCH - 1 : 0] filterBias;
wire [(BITWIDTH * 2) * FILTERBATCH * (PADDINGENABLE == 0 ? (DATAWIDTH - FILTERWIDTH + 1) / STRIDEWIDTH : (DATAWIDTH / STRIDEWIDTH)) * (PADDINGENABLE == 0 ? (DATAHEIGHT - FILTERHEIGHT + 1) / STRIDEHEIGHT : (DATAHEIGHT / STRIDEHEIGHT)) - 1 : 0] result;

localparam PERIOD = 2;

always
	#(PERIOD/2) clk = ~clk;

initial begin
	#0
	clk = 1'b0;reset = 1;
	// We test with an image part and a filter whose values are all 4 

//1 channel
	image =  128'h01020304_05060708_090A0B0C_0D0E0F10;
	weight = 72'h010101_010101_010101;
    filterBias = 8'h0;
/* 
 //2channel 
	image =  512'h3C003C003C003C00_3C003C003C003C00_3C003C003C003C00_3C003C003C003C00_3C003C003C003C00_3C003C003C003C00_3C003C003C003C00_3C003C003C003C00;
	weight = 288'h3C003C003C00_3C003C003C00_3C003C003C00_3C003C003C00_3C003C003C00_3C003C003C00;
*/	
	#2 reset = 0;

/*
	#10 
	image =  512'h4000400040004000_4000400040004000_4000400040004000_4000400040004000_4000400040004000_4000400040004000_4000400040004000_4000400040004000;
	weight = 288'h3C003C003C00_3C003C003C00_3C003C003C00_3C003C003C00_3C003C003C00_3C003C003C00;
	*/
end

Conv2d 
#(
	.BITWIDTH(BITWIDTH),
	.DATAWIDTH(DATAWIDTH),
	.DATAHEIGHT(DATAHEIGHT),
	.DATACHANNEL(DATACHANNEL),

    .FILTERHEIGHT(FILTERHEIGHT),
	.FILTERWIDTH(FILTERWIDTH),
	.FILTERBATCH(FILTERBATCH),

    .STRIDEHEIGHT(STRIDEHEIGHT),
    .STRIDEWIDTH(STRIDEWIDTH),

    .PADDINGENABLE(PADDINGENABLE)
)conv2d_inst(
	.data(image),
	.filterWeight(weight),
	.filterBias(filterBias),
	.result(result)
);

endmodule
