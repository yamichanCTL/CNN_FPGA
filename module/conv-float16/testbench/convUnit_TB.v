/*
`timescale 100 ns / 10 ps

module convUnit_TB ();
parameter data_width = 16;
parameter input_channel = 2;
parameter image_length = 3;
parameter image_width = 3;
parameter weight_length = 3;
parameter weight_width = 3;

reg clk, reset,conv_en;
reg [0:input_channel*weight_length*weight_width*data_width-1] image, weight; // error dut
reg pe_out_valid;
wire [data_width-1:0] result;
wire cu_out_valid;

localparam PERIOD = 2;

always
	#(PERIOD/2) clk = ~clk;

initial begin
	#0
	clk = 1'b0;reset = 1;conv_en = 0;
	// We test with an image part and a filter whose values are all 4 
	image =  288'h3C003C003C00_3C003C003C00_3C003C003C00_3C003C003C00_3C003C003C00_3C003C003C00;
	weight = 288'h3C003C003C00_3C003C003C00_3C003C003C00_3C003C003C00_3C003C003C00_3C003C003C00;
	
	#PERIOD reset = 0;conv_en = 1;

	#23 pe_out_valid=1;
	#40 
	image =  288'h400040004000_400040004000_400040004000_400040004000_400040004000_400040004000;
	weight = 288'h3C003C003C00_3C003C003C00_3C003C003C00_3C003C003C00_3C003C003C00_3C003C003C00;
	
end

convUnit 
#(
	.data_width(data_width),
	.input_channel(input_channel),
	//.image_length(image_length),
	//.image_width(image_width),
	.weight_length(weight_length),
	.weight_width(weight_width)
)
UUT
(
	.clk(clk),
	.reset(reset),
	.image(image),
	.conv_en(conv_en),
	.weight(weight),
	.pe_out_valid(pe_out_valid),
	.result(result),
	.cu_out_valid(cu_out_valid)
);

/*
convUnit 
#(
	.DATA_WIDTH(data_width),
	.IMAGE_DEPTH(input_channel),
	.WEIGHT_LENGHT(image_length),
	.WEIGHT_WIDTH(image_width)
)
UUT
(
	.clk(clk),
	.reset(reset),
	.image(image),
	.conv_en(conv_en),
	.weight(weight),
	.result(result),
	.cu_out_valid(cu_out_valid)
);
*/
/*
endmodule
*/

`timescale 100 ns / 10 ps

module convUnit_TB ();
parameter data_width = 16;
parameter input_channel = 2;
parameter image_length = 3;
parameter image_width = 3;
parameter weight_length = 3;
parameter weight_width = 3;

reg clk, reset,conv_en;
reg [0:input_channel*weight_length*weight_width*data_width-1] image, weight; // error dut
reg [data_width-1:0] bias;
wire [data_width-1:0] result;
wire cu_out_valid;

localparam PERIOD = 2;

always
	#(PERIOD/2) clk = ~clk;

initial begin
	#0
	clk = 1'b0;reset = 1;conv_en = 0;
	// We test with an image part and a filter whose values are all 4 
	image =  288'h3C003C003C00_3C003C003C00_3C003C003C00_3C003C003C00_3C003C003C00_3C003C003C00;
	weight = 288'h3C003C003C00_3C003C003C00_3C003C003C00_3C003C003C00_3C003C003C00_3C003C003C00;
	bias = 16'h3C00;
	#PERIOD reset = 0;conv_en = 1;

	#40 
	image =  288'h400040004000_400040004000_400040004000_400040004000_400040004000_400040004000;
	weight = 288'h3C003C003C00_3C003C003C00_3C003C003C00_3C003C003C00_3C003C003C00_3C003C003C00;
	
end

convUnit 
#(
	.data_width(data_width),
	.input_channel(input_channel),
	//.image_length(image_length),
	//.image_width(image_width),
	.weight_length(weight_length),
	.weight_width(weight_width)
)
UUT
(
	.clk(clk),
	.reset(reset),
	.image(image),
	.conv_en(conv_en),
	.weight(weight),
	.bias(bias),
	.result(result),
	.cu_out_valid(cu_out_valid)
);

/*
convUnit 
#(
	.DATA_WIDTH(data_width),
	.IMAGE_DEPTH(input_channel),
	.WEIGHT_LENGHT(image_length),
	.WEIGHT_WIDTH(image_width)
)
UUT
(
	.clk(clk),
	.reset(reset),
	.image(image),
	.conv_en(conv_en),
	.weight(weight),
	.result(result),
	.cu_out_valid(cu_out_valid)
);
*/
endmodule
