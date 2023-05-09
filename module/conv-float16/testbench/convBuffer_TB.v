`timescale 100 ns / 10 ps

module convBuffer_TB #(
	parameter data_width = 16,
	parameter input_channel = 1,
	parameter image_length = 4,
	parameter image_width = 4,

	parameter output_channel = 1,
	parameter weight_length = 3,
	parameter weight_width = 3,


	parameter result_length = 2,
	parameter result_width = 2,

	parameter stride = 1,
	parameter padding_en = 0,
	parameter padding = 0
);
reg clk, reset,conv_en;
reg [0:input_channel*image_length*image_width*data_width-1] image;
reg [0:input_channel*weight_length*weight_width*data_width-1] weight; 
reg [data_width-1:0]archor_2D,archor_1D;
wire [0:input_channel*weight_length*weight_width*data_width-1] img_cal,weight_cal;

localparam PERIOD = 2;

always
	#(PERIOD/2) clk = ~clk;

initial begin
	#0
	clk = 1'b0;reset = 1;conv_en = 0;archor_1D = 0;archor_2D = 0;
	// We test with an image part and a filter whose values are all 4 

//1 channel
	image =  256'h3C003C003C003C00_3C003C003C003C00_3C003C003C003C00_3C003C003C003C00;
	weight = 144'h3C003C003C00_3C003C003C00_3C003C003C00;
/* 
 //2channel 
	image =  512'h3C003C003C003C00_3C003C003C003C00_3C003C003C003C00_3C003C003C003C00_3C003C003C003C00_3C003C003C003C00_3C003C003C003C00_3C003C003C003C00;
	weight = 288'h3C003C003C00_3C003C003C00_3C003C003C00_3C003C003C00_3C003C003C00_3C003C003C00;
*/	
	#20 reset = 0;conv_en = 1;

/*
	#10 
	image =  512'h4000400040004000_4000400040004000_4000400040004000_4000400040004000_4000400040004000_4000400040004000_4000400040004000_4000400040004000;
	weight = 288'h3C003C003C00_3C003C003C00_3C003C003C00_3C003C003C00_3C003C003C00_3C003C003C00;
	*/
end

convBuffer 
#(
	.data_width(data_width),
	.input_channel(input_channel),
	.image_length(image_length),
	.image_width(image_width),

    .output_channel(output_channel),
	.weight_length(weight_length),
	.weight_width(weight_width),

    .result_length(result_length),
    .result_width(result_width),

    .stride(stride),
    .padding_en(padding_en),
    .padding(padding)
)
BUFFER
(
	.clk(clk),
	.reset(reset),
	.image(image),
	.conv_en(conv_en),
	.weight(weight),
	.archor_1D(archor_1D),
	.archor_2D(archor_2D),
    .img_cal(img_cal),
    .weight_cal(weight_cal)
);

endmodule
