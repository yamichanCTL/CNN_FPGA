// complete 1unit of 3Dconv 
// input data need to hold width^2 or other method
`timescale 100 ns / 10 ps
module convUnit#(
	parameter data_width = 16,
	parameter input_channel = 1,
	parameter weight_length = 3,
	parameter weight_width = 3
)(
	input clk,
	input reset,
	input conv_en,
	input [0:input_channel*weight_length*weight_width*data_width-1] image,
	input [0:input_channel*weight_length*weight_width*data_width-1] weight,
	input [data_width-1:0]bias,
	output reg [data_width-1:0] result,
	output reg cu_out_valid);

// PE
/*
reg [data_width-1:0] img_cal[0:input_channel-1];
reg [data_width-1:0] weight_cal[0:input_channel-1];
*/
wire [0:input_channel*data_width-1] pe_result;
//wire [0:input_channel*data_width+data_width-1] add_result;
reg pe_conv_en; // in
wire [0:input_channel*weight_length*weight_width-1]pe_out_valid; //out

//test
wire [data_width-1:0] add_result_0;
wire [data_width-1:0] add_result_1;
wire [data_width-1:0] add_result_2;
wire [data_width-1:0] add_result_3;
//
genvar a;
genvar b;
generate
	for (a = 0; a < input_channel; a = a + 1) begin 
		for (b = 0; b < weight_length*weight_width; b = b + 1) begin
			processingElement16#(
			.data_width(data_width),
			.weight_length(weight_length),
			.weight_width(weight_width)
			)PE(
			.clk(clk),
			.reset(reset),
			.conv_en(pe_conv_en),
			.floatA(image[a*weight_length*weight_width*data_width+b*data_width+:data_width]),
			.floatB(weight[a*weight_length*weight_width*data_width+b*data_width+:data_width]),
			.result(pe_result[a*data_width+:data_width]),
			.out_valid(pe_out_valid[a*weight_length*weight_width+b+:1])
			);
		end	
		//floatAdd16 depth_add(add_result[a*data_width+:data_width],pe_result[a*data_width+:data_width],add_result[a*data_width+data_width+:data_width]);
		floatAdd16 depth_add1(add_result_0,pe_result[a*data_width+:data_width],add_result_1);
		floatAdd16 depth_add2(add_result_1,pe_result[a*data_width+:data_width],add_result_2);
	end					
endgenerate

floatAdd16 add_bias(add_result_2,bias,add_result_3);

assign add_result_0=(reset == 1'b1)?0:add_result_0;


// 
always @ (posedge clk, posedge reset) begin
	if (reset == 1'b1) begin // reset
		pe_conv_en <= 0;
		result <= 0;
		cu_out_valid <= 0;
	end 
	else if (conv_en == 1'b1) begin 
		if(pe_out_valid[0] == 1) begin // change into self&
			//result <= add_result[input_channel*data_width+:data_width];
			result <= add_result_3;
			pe_conv_en <= 0;
			cu_out_valid <= 1;
		end
		else begin
		pe_conv_en <= 1;
		result <= 0;
		cu_out_valid <= 0;
		end
	end
	else begin
		pe_conv_en <= 0;
		result <= 0;
		cu_out_valid <= 0;
	end
end

endmodule