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
//pe input
reg [data_width-1:0] selectedInput1;
reg [data_width-1:0] selectedInput2;
reg pe_conv_en;
//pe output
wire [data_width-1:0] pe_result;
wire pe_out_valid;


reg [data_width-1:0] i;
reg [data_width-1:0] pe_result_temp;


reg [data_width-1:0]result_temp_0;
wire [data_width-1:0]result_temp_1;
wire [data_width-1:0]result_temp_2;

//assign result_temp_0=(!reset|conv_en)?result_temp_0:0;
//assign result_temp_1=(!reset|conv_en)?result_temp_1:0;
//assign result_temp_1=(!reset|conv_en)?result_temp_2:0;

processingElement16 #(
	.data_width(data_width),
	.weight_length(weight_length),
	.weight_width(weight_width)
)PE_inst(
	.clk(clk),
	.reset(reset),
	.conv_en(pe_conv_en),
	.floatA(selectedInput1),
	.floatB(selectedInput2),
	.result(pe_result),
	.out_valid(pe_out_valid)
	);

floatAdd16 addchannel(
	.floatA(result_temp_0),
	.floatB(pe_result_temp),
	.sum(result_temp_1)
	);
floatAdd16 addbias(
	.floatA(result_temp_1),
	.floatB(bias),
	.sum(result_temp_2)
	);


always @ (posedge clk, posedge reset) begin
	if (reset == 1'b1) begin // reset
		i <= 0;
		selectedInput1 <= 0;
		selectedInput2 <= 0;
		pe_conv_en <= 0;
		pe_result_temp <= 0;
		cu_out_valid <= 0;
		result<=0;
		result_temp_0<=0;
	end 

	else if(conv_en)begin
		if(i < input_channel*weight_width*weight_length & !pe_out_valid)begin 
			i <= i + 1;
			selectedInput1 <= image[data_width*i+:data_width];
			selectedInput2 <= weight[data_width*i+:data_width];		
			pe_conv_en <= 1;
			pe_result_temp <= 0;
			cu_out_valid <= 0;
			result<=0;
		end
		else if (i < input_channel*weight_width*weight_length & pe_out_valid)begin
			i<=i+1;
			selectedInput1 <= image[data_width*i+:data_width];
			selectedInput2 <= weight[data_width*i+:data_width];		
			pe_conv_en <= 1;
			pe_result_temp <= pe_result;
			cu_out_valid <= 0;
			result<=0;
			result_temp_0<=result_temp_1;
		end
		else if (i == input_channel*weight_width*weight_length)begin
			i<=i+1;
			selectedInput1 <= image[data_width*i+:data_width];
			selectedInput2 <= weight[data_width*i+:data_width];		
			pe_conv_en <= 1;
			pe_result_temp <= pe_result;
			cu_out_valid <= 1;
			result<=result_temp_2;
		end
		else begin
			i<=0;
			selectedInput1 <= 0;
			selectedInput2 <= 0;		
			pe_conv_en <= 0;
			pe_result_temp <= pe_result;
			cu_out_valid <= 0;
			result<=0;
			result_temp_0<=0;
		end
	end
	else  begin
		i <= 0;
		selectedInput1 <= 0;
		selectedInput2 <= 0;
		pe_conv_en <= 0;
		pe_result_temp <= 0;
		cu_out_valid <= 0;
		result<=0;

	end
end
endmodule


