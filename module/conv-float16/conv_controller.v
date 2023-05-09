module conv_controller#(
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

	output reg [data_width-1:0]anchor_1D,
	output reg [data_width-1:0]anchor_2D
	//output reg cb_valid
	);


//search the addr of the top left point
reg [data_width-1:0] ranchor_l;
reg [data_width-1:0] ranchor_c;
assign anchor_l=ranchor_l;
assign anchor_c=ranchor_c;
always@(posedge clk)begin
    if(!reset)begin
        ranchor_l<=0;
        ranchor_c<=0;
    end
    else begin
        if(conv_en)begin
            if(keep_buf)begin
                ranchor_l<=ranchor_l;
                ranchor_c<=ranchor_c;
            end
            else begin
                if(~chge_buf&chge_buf_q&chge_rlt_l)begin
                    ranchor_l<=ranchor_l+stride;
                    ranchor_c<=0;
                end
                else if(~chge_buf&chge_buf_q&!chge_rlt_l)begin
                    ranchor_l<=ranchor_l;
                    ranchor_c<=ranchor_c+stride;
                end
                else if(chge_buf&~chge_buf_q&!chge_rlt_l)begin
                    ranchor_l<=ranchor_l;
                    ranchor_c<=ranchor_c;
                end
                else begin
                    ranchor_l<=ranchor_l;
                    ranchor_c<=ranchor_c;
                end
            end
        end
        else begin
            ranchor_l<=0;
            ranchor_c<=0;
        end
    end
end


endmodule