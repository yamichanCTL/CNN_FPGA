`timescale 100 ns / 10 ps

module convTop_TB #(
	parameter data_width = 16,
	parameter input_channel = 1,
	parameter image_length = 4,
	parameter image_width = 4,

	parameter output_channel = 1,
	parameter weight_length = 3,
	parameter weight_width = 3,

	parameter stride = 1,
	parameter padding_en = 0,
	parameter padding = 0,

	parameter result_length = (image_length-weight_length+2*padding)/stride+1,
	parameter result_width = (image_width-weight_width+2*padding)/stride+1


);
reg clk, reset,conv_en;
reg [0:input_channel*image_length*image_width*data_width-1] image;
reg [0:output_channel*input_channel*weight_length*weight_width*data_width-1] weight; 
reg [0:output_channel*data_width-1]bias;
wire [0:output_channel*input_channel*weight_length*weight_width*data_width-1] result;
wire out_valid;

localparam PERIOD = 2;

always
	#(PERIOD/2) clk = ~clk;

initial begin
	#0
	clk = 1'b0;reset = 1;conv_en = 0;
	// We test with an image part and a filter whose values are all 4 

//1 channel
	image =  256'h3C003C003C003C00_3C003C003C003C00_3C003C003C003C00_3C003C003C003C00;
	weight = 144'h3C003C003C00_3C003C003C00_3C003C003C00;
	bias = 16'h3c00;

 //2channel 
	//image =  512'h3C003C003C003C00_3C003C003C003C00_3C003C003C003C00_3C003C003C003C00_4000400040004000_3C003C003C003C00_3C003C003C003C00_3C003C003C003C00;
	//weight = 288'h3C003C003C00_3C003C003C00_3C003C003C00_400040004000_3C003C003C00_3C003C003C00;
	
	#2 reset = 0;conv_en = 1;
/*
	#10 
	image =  512'h4000400040004000_4000400040004000_4000400040004000_4000400040004000_4000400040004000_4000400040004000_4000400040004000_4000400040004000;
	weight = 288'h3C003C003C00_3C003C003C00_3C003C003C00_3C003C003C00_3C003C003C00_3C003C003C00;
	*/
end

conv_top 
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
conv_top_inst
(
	.clk(clk),
	.reset(reset),
	.image(image),
	.conv_en(conv_en),
	.weight(weight),
    .result(result),
    .out_valid(out_valid)
);

endmodule
