`timescale 100 ns / 10 ps

module conv_buffer_tb #(
    parameter weight_width = 2,         
    parameter weight_height = 2,       

    parameter img_width = 4,           
    parameter img_height = 4,          
    
    parameter padding_enable = 0,     
    parameter padding = 0,             

    parameter stride = 1,               
    parameter bitwidth = 16,            
    parameter result_width = (img_width-weight_width+2*padding)/stride+1,      
    parameter result_height = (img_height-weight_height+2*padding)/stride+1,     
    parameter expand = 1 
);
reg clk, reset,conv_en;
reg [31:0]anchor_l,anchor_c;
reg [3:0] buf_c,buf_l;

reg [img_height*img_width*bitwidth-1:0] image;
reg [weight_height*weight_width*bitwidth-1:0] weight; 

wire [bitwidth-1:0] img_cal;
wire [bitwidth-1:0] weight_cal;



localparam PERIOD = 2;

always
	#(PERIOD/2) clk = ~clk;

initial begin
	#0
	clk = 1'b0;reset = 1;conv_en = 0;anchor_l = 0;anchor_c = 0;buf_c = 0;buf_l = 0;
	// We test with an image part and a filter whose values are all 4 

//1 channel
	image =  256'h0001000200030004_0005000600070008_0001000200030004_0005000600070008;
	weight = 144'h3C003C00_3C003C00;
/* 
 //2channel 
	image =  512'h3C003C003C003C00_3C003C003C003C00_3C003C003C003C00_3C003C003C003C00_3C003C003C003C00_3C003C003C003C00_3C003C003C003C00_3C003C003C003C00;
	weight = 288'h3C003C003C00_3C003C003C00_3C003C003C00_3C003C003C00_3C003C003C00_3C003C003C00;
*/	
	#2 reset = 0;conv_en = 1;

/*
	#10 
	image =  512'h4000400040004000_4000400040004000_4000400040004000_4000400040004000_4000400040004000_4000400040004000_4000400040004000_4000400040004000;
	weight = 288'h3C003C003C00_3C003C003C00_3C003C003C00_3C003C003C00_3C003C003C00_3C003C003C00;
	*/
end

conv_buffer
#(
	.weight_width(weight_width),
	.weight_height(weight_height),

	.img_width(img_width),
	.img_height(img_height),

    .padding_enable(padding_enable),
	.padding(padding),

	.stride(stride),
    .bitwidth(bitwidth),
    .result_width(result_width),
    .result_height(result_height),
    .expand(expand)
)
BUFFER
(
	.clk_en(clk),
	.rst_n(reset),
	.conv_on(conv_en),
	.img(image),
	.weight(weight),
	.anchor_l(anchor_l),
	.anchor_c(anchor_c),
    .img_cal(img_cal),
    .wei_cal(weight_cal),
    .buf_l(buf_l),
    .buf_c(buf_c)
);

endmodule
