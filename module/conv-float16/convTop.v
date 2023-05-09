module conv_top #(
    parameter data_width = 3,   
    parameter input_channel = 2,
    parameter output_channel = 1,

    parameter image_width = 4,            
    parameter image_length = 4,  
    parameter weight_width = 2,        
    parameter weight_length = 2,        

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
wire [data_width-1:0]archor_2D;   //the addr of the top left point
wire [data_width-1:0]archor_1D;

//buffer
wire [0:input_channel*weight_length*weight_width*data_width-1] img_cal;        //the data for calcualtion
wire [0:input_channel*weight_length*weight_width*data_width-1] wei_cal;
wire [data_width-1:0] rlt_cal;

wire chge_rlt;                      //change the addr of the result array
wire chge_rlt_q;                    //delay a clk

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

    .archor_1D(archor_1D),
    .archor_2D(archor_2D)
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

    .archor_2D      (archor_2D),
    .archor_1D      (archor_1D),

    .img_cal    (img_cal),
    .wei_cal    (wei_cal)
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

integer i,j,k,l;
always @(posedge clk,negedge reset) begin
    if(!reset)begin
		for(i=0;i<output_channel;i=i+1)begin
			for(j=0;j<result_width;j=j+1)begin
				for(k=0;k<result_length;k=k+1)begin
					result<=0;
                    out_valid<=0;
				end
			end
		end
    end
    else if(cu_out_valid) begin
        for(i=0;i<output_channel;i=i+1)begin
			for(j=0;j<result_width;j=j+1)begin
				for(k=0;k<result_length;k=k+1)begin
					result[i*result_width*result_length*data_width
                    +j*result_length*data_width
                    +k*data_width
                    +:data_width]<=rlt_cal;
                    out_valid<=((i==output_channel-1)&(j==result_width-1)&(k==result_length-1))?1:0;
				end
			end
		end
    end
    else begin
        for(i=0;i<output_channel;i=i+1)begin
            for(j=0;j<result_width;j=j+1)begin
                for(k=0;k<result_length;k=k+1)begin
                    result<=0;
                    out_valid<=0;
                end
            end
        end
    end
end
endmodule
