module conv_top #(
    parameter data_width = 8,   
    parameter input_channel = 1,
    parameter output_channel = 1,

    parameter image_width = 160,            
    parameter image_length = 160,  
    parameter weight_width = 5,        
    parameter weight_length = 5,        

    parameter stride = 2,  
    parameter padding_en = 0,      
    parameter padding = 0,              

    parameter result_width = (image_width-weight_width+2*padding)/stride+1,       
    parameter result_length = (image_length-weight_length+2*padding)/stride+1    
    //parameter expand = 1        //expand the bitwidth of result 
    
)(
    input clk,
    input reset,   
    input conv_en,              //if 1,the conv is on

    input [0:input_channel*image_width*image_length*data_width-1]image,  
    input [0:output_channel*input_channel*weight_width*weight_length*data_width-1] weight, 
    input [0:output_channel*data_width-1] bias,                              

    output reg [0:output_channel*result_width*result_length*data_width-1]  result,  
    output reg out_valid //if 1, the result of the conv is correct
);

//controller
wire [data_width-1:0]anchor_2D;   //the addr of the top left point
wire [data_width-1:0]anchor_1D;

//buffer
wire [0:input_channel*weight_length*weight_width*data_width-1] img_cal;        //the data for calcualtion
wire [0:input_channel*weight_length*weight_width*data_width-1] wei_cal;
wire [data_width-1:0] rlt_cal;

wire cu_conv_en;                      //change the addr of the result array
wire cu_out_valid;                    //delay a clk

//controller block
conv_controller#(
	.data_width(data_width),
	.input_channel(input_channel),
    .output_channel(output_channel),

	.image_length(image_length),
	.image_width(image_width),
    .weight_length(weight_length),
    .weight_width(weight_width),

	.stride(stride),
	.padding_en(padding_en),
	.padding(padding), 

	.result_length(result_length),
	.result_width(result_width)    
)conv_controller_inst(
    .clk     (clk),
    .reset      (reset),
    .conv_en    (conv_en),
    .cu_out_valid(cu_out_valid),

    .anchor_1D(anchor_1D),
    .anchor_2D(anchor_2D),
    .cu_conv_en(cu_conv_en)
);

//buffer block
convBuffer #(
	.data_width(data_width),
	.input_channel(input_channel),
    .output_channel(output_channel),

	.image_length(image_length),
	.image_width(image_width),
    .weight_length(weight_length),
    .weight_width(weight_width),

	.stride(stride),
	.padding_en(padding_en),
	.padding(padding), 

	.result_length(result_length),
	.result_width(result_width)
)conv_buffer_inst(
    .clk     (clk),
    .reset      (reset),
    .conv_en    (conv_en),

    .image   (image),
    .weight   (weight),

    .anchor_2D      (anchor_2D),
    .anchor_1D      (anchor_1D),

    .img_cal    (img_cal),
    .weight_cal    (wei_cal)
);

//cu block
convUnit#(
    .data_width(data_width),
    .input_channel(input_channel),
    .weight_length(weight_length),
    .weight_width(weight_width)
)convUnit_inst(
    .clk(clk),
    .reset(reset),
    .conv_en(cu_conv_en),
    .image(img_cal),
    .weight(wei_cal),
    .result(rlt_cal),
    .cu_out_valid(cu_out_valid)
    );

reg [data_width-1:0]i;
always @(posedge clk,negedge reset) begin
    if(!reset)begin
		result<=0;
        out_valid<=0;
        i<=0;
    end
    else if(cu_out_valid & i<output_channel*result_length*result_width-1) begin
        result[i*data_width+:data_width]<=rlt_cal;
        out_valid<=0;
        i<=i+1;
    end
    else if(i==output_channel*result_length*result_width-1) begin
        result[i*data_width+:data_width]<=rlt_cal;
        out_valid<=1;
        i<=0;
    end
    else begin
        result<=0;
        out_valid<=0;
        i<=0;
    end
end
endmodule
