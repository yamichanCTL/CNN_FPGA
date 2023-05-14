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
    input cu_out_valid,

	output reg [data_width-1:0]anchor_1D,//anchor<(size+2p-w)/stride
	output reg [data_width-1:0]anchor_2D,
    output reg cu_conv_en
	//output reg cb_valid
	);


//search the addr of the top left point
//reg [data_width-1:0] ranchor_l;
//reg [data_width-1:0] ranchor_c;

//reg slide_1D;

always@(posedge clk,negedge reset)begin
    if(!reset)begin
        anchor_1D<=0;
        anchor_2D<=0;
        cu_conv_en<=0;
    end
    else begin
        if(conv_en)begin
            if(!cu_out_valid)begin
                anchor_1D<=anchor_1D;
                anchor_2D<=anchor_2D;
                cu_conv_en<=1;
            end
            else begin
                //slide in column
                if(anchor_1D<image_length+2*padding-weight_length)begin
                    anchor_1D<=anchor_1D+stride;
                    anchor_2D<=0;
                    cu_conv_en<=1;
                end
                //slide to colunmn end
                else if(anchor_1D==image_length+2*padding-weight_length & anchor_2D<image_width+2*padding-weight_width)begin
                    anchor_1D<=0;
                    anchor_2D<=anchor_2D+stride;
                    cu_conv_en<=1;
                end
                /*else if(anchor_2D==image_length+2*padding-weight_length)begin
                    anchor_1D<=0;
                    anchor_2D<=0;
                end*/
                else begin
                    anchor_1D<=0;
                    anchor_2D<=0;
                    cu_conv_en<=0;
                end
            end
        end
        else begin
            anchor_1D<=0;
            anchor_2D<=0;
            cu_conv_en<=0;
        end
    end
end


endmodule