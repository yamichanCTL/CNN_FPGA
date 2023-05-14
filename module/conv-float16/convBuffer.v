// load a set of 3Darray to do convolution 
module convBuffer#(
	parameter data_width = 16,
	parameter input_channel = 2,
	parameter output_channel = 1,

	parameter image_length = 4,
	parameter image_width = 4,
	parameter weight_length = 3,
	parameter weight_width = 3,

	parameter stride = 1,
	parameter padding_en = 0,
	parameter padding = 0,

	parameter result_length = 2,
	parameter result_width = 2
)(
	input clk,
	input reset,
	input conv_en,
	input [0:input_channel*image_length*image_width*data_width-1] image,
	input [0:input_channel*weight_length*weight_width*data_width-1] weight,

	input [data_width-1:0]anchor_2D,
	input [data_width-1:0]anchor_1D,
	output [0:input_channel*weight_length*weight_width*data_width-1] img_cal,
	output [0:input_channel*weight_length*weight_width*data_width-1] weight_cal
	//output reg cb_valid
	);

// image buffer
wire [0:input_channel*weight_width*weight_length*data_width-1] img_buffer;

genvar i,j,k;
generate
	for(i=0;i<input_channel;i=i+1)begin
		for(j=0;j<weight_width;j=j+1)begin
			for(k=0;k<weight_length;k=k+1)begin
					assign img_buffer[i*weight_width*weight_length*data_width
					+j*weight_length*data_width
					+k*data_width
					+:data_width]=
					(!reset&conv_en)?
						(padding_en?
							((anchor_2D+j)<padding | (anchor_2D+j)>image_width |(anchor_1D+k) < padding | (anchor_1D+k)>image_length?
								//padding content this  will continue padding even out of limit
								0
								//origin 
								:image[i*weight_length*weight_width*data_width
								+(anchor_2D+j-padding)*image_length*data_width
								+(anchor_1D+k-padding)*data_width 
								+:data_width])
							// no padding	
							:image[i*weight_length*weight_width*data_width
							+(anchor_2D+j)*image_length*data_width
							+(anchor_1D+k)*data_width
							+:data_width])
						:0;

			end
		end
	end
endgenerate


//reg [data_width-1:0] weight_buffer [0:input_channel-1][0:weight_width-1][0:weight_length-1];
wire [0:input_channel*weight_width*weight_length*data_width-1] weight_buffer;
//reg [data_width-1:0] a,b,c;
genvar a,b,c;
generate
	for(a=0;a<input_channel;a=a+1)begin
		for(b=0;b<weight_width;b=b+1)begin
			for(c=0;c<weight_length;c=c+1)begin
				assign weight_buffer[a*weight_width*weight_length*data_width
				+b*weight_length*data_width
				+c*data_width
				+:data_width]=(!reset&conv_en)?
				weight[a*weight_width*weight_length*data_width
				+b*weight_length*data_width
				+c*data_width
				+:data_width]:0;
			end
		end
	end
endgenerate

assign img_cal = img_buffer;
assign weight_cal = weight_buffer;


endmodule