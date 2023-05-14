// cost WEIGHT_LENGHT*WEIGHT_WIDTH period
// every clk get one floatA floatB
// add and multi for one time
`timescale 100 ns / 10 ps

module processingElement16#(
	parameter data_width = 16,
	parameter weight_length = 3,
	parameter weight_width = 3
)(
	input clk,
	input reset,
	input [data_width-1:0] floatA,
	input [data_width-1:0] floatB,
	input conv_en,
	output reg [data_width-1:0] result,
	output reg out_valid
	//output reg [EXP-1:0] i//count of multi and add
	);

localparam EXP = 7; //2^EXP==WEIGHT_WIDTH^2
wire [data_width-1:0] multResult;
wire [data_width-1:0] addResult;
//integer i;
reg [EXP-1:0] i;

floatMult16 FM (floatA,floatB,multResult);
floatAdd16 FADD (multResult,result,addResult);


always @ (posedge clk or posedge reset) begin
	if (reset == 1'b1) begin
		result <= 0;
		i <= 0;
		result <= 0;
		out_valid <= 0;
	end 
	else if (conv_en == 1'b1) begin
		if (i == weight_length * weight_width-1) begin
			i <= i + 1;
			result <= addResult;
			out_valid <= 1;
		end 
		else if(i>=weight_length * weight_width) begin
			i <= 0;
			result <= 0;
			out_valid <= 0;
		end
		else begin
			i <= i + 1;
			result <= addResult;
			out_valid <= 0;
		end
	end
	else begin
		i <= 0;
		result <= 0;
		out_valid <= 0;
	end
end

endmodule
