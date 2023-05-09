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

	input [data_width-1:0]archor_2D,
	input [data_width-1:0]archor_1D,
	output reg [0:input_channel*weight_length*weight_width*data_width-1] img_cal,
	output reg [0:input_channel*weight_length*weight_width*data_width-1] weight_cal
	//output reg cb_valid
	);

// image buffer
reg [data_width-1:0] img_buffer [0:input_channel-1][0:weight_width-1][0:weight_length-1];

// anchor stride for image
integer i,j,k;//stride for weight  integer or reg??
always@(posedge clk,negedge reset)begin
    if(!reset)begin
		for(i=0;i<input_channel;i=i+1)begin
			for(j=0;j<weight_width;j=j+1)begin
				for(k=0;k<weight_length;k=k+1)begin
					img_buffer[i][j][k]<=0;
				end
			end
		end
    end
    else begin
        if(conv_en)begin
            for(i=0;i<input_channel;i=i+1)begin
                for(j=0;j<weight_width;j=j+1)begin
					for(k=0;k<weight_length;k=k+1)begin
						// combinate later
						if (padding_en) begin
							if((archor_2D+j)<padding | (archor_2D+j)>image_width |
							(archor_1D+k) < padding | (archor_1D+k)>image_length)begin
								img_buffer[i][j][k]<=0;
							end
							else begin
								img_buffer[i][j][k]<=image[i*weight_length*weight_width*data_width
									+(archor_2D+j-padding)*image_length*data_width
									+(archor_1D+k-padding)*data_width 
									+:data_width];
							end
						end
						else begin
							img_buffer[i][j][k]<=image[i*weight_length*weight_width*data_width
								+(archor_2D+j)*image_length*data_width
								+(archor_1D+k)*data_width 
								+:data_width];
						end
					end
                end
            end
        end
        else begin
            for(i=0;i<input_channel;i=i+1)begin
				for(j=0;j<weight_width;j=j+1)begin
					for(k=0;k<weight_length;k=k+1)begin
						img_buffer[i][j][k]<=0;
					end
				end
			end       
        end
    end
end

//reg [data_width-1:0] weight_buffer [0:input_channel-1][0:weight_width-1][0:weight_length-1];
reg [0:input_channel*weight_width*weight_length*data_width-1] weight_buffer;
integer a,b,c;
always@(*)begin
    if(!reset)begin
		for(a=0;a<input_channel;a=a+1)begin
			for(b=0;b<weight_width;b=b+1)begin
				for(c=0;c<weight_length;c=c+1)begin
					weight_buffer[a*weight_width*weight_length*data_width
					+b*weight_length*data_width
					+c*data_width
					+:data_width]<=0;
				end
			end
		end
    end
    else begin
        if(conv_en)begin
			for(a=0;a<input_channel;a=a+1)begin
				for(b=0;b<weight_width;b=b+1)begin
					for(c=0;c<weight_length;c=c+1)begin
						/*
						weight_buffer[a][b][c]<=weight[a*weight_width*weight_length*data_width
						+b*weight_length*data_width
						+c*data_width
						+:data_width];
						*/
						weight_buffer[a*weight_width*weight_length*data_width
						+b*weight_length*data_width
						+c*data_width
						+:data_width]<=weight[a*weight_width*weight_length*data_width
						+b*weight_length*data_width
						+c*data_width
						+:data_width];
					end
				end
			end
        end
        else begin
            for(a=0;a<input_channel;a=a+1)begin
				for(b=0;b<weight_width;b=b+1)begin
					for(c=0;c<weight_length;c=c+1)begin
						weight_buffer[a*weight_width*weight_length*data_width
						+b*weight_length*data_width
						+c*data_width
						+:data_width]<=0;
					end
				end
			end
        end
    end
end


integer i1, j1, k1;
always @(*) begin
	for (i1 = 0; i1 < input_channel; i1 = i1 + 1) begin
  	    for (j1 = 0; j1 < weight_width; j1 = j1 + 1) begin
   			for (k1 = 0; k1 < weight_length; k1 = k1 + 1) begin
      			img_cal[i1*input_channel*weight_width*weight_length*data_width+
				j1*weight_length*data_width+
				k1*data_width
				+:data_width] = img_buffer[i1][j1][k1];
				/*
				weight_cal[i1*input_channel*weight_width*weight_length*data_width+
				j1*weight_length*data_width+
				k1*data_width
				+:data_width] = weight_buffer[i1][j1][k1];
				*/
    		end
 	    end
	end
	weight_cal = weight_buffer;
end

always @(*) begin
	i=(!reset)?0:i;
	j=(!reset)?0:j;
	k=(!reset)?0:k;
	a=(!reset)?0:a;
	b=(!reset)?0:b;
	c=(!reset)?0:c;
	i1=(!reset)?0:i1;
	j1=(!reset)?0:j1;
	k1=(!reset)?0:k1;
end

endmodule