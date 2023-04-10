module conv_top_test#(
    parameter weight_width = 2,         
    parameter weight_height = 2,       

    parameter img_width = 4,           
    parameter img_height = 4,          
    
    parameter padding_enable = 0,     
    parameter padding = 0,             
    parameter stride = 1,      
        
    parameter bitwidth = 7,            
    parameter result_width = (img_width-weight_width+2*padding)/stride+1,      
    parameter result_height = (img_height-weight_height+2*padding)/stride+1,     
    parameter bitsum = result_width*result_width*bitwidth       
) (
    input [bitwidth-1:0] img,
    input [bitwidth-1:0] weight,
    input [bitwidth-1:0] b0,
    input clk_en,
    input rst_n,
    input conv_en,
    output reg [bitsum-1:0] conv_out 
);

reg [bitwidth-1:0] img_buffer [0:img_width-1][0:img_height-1];
reg [10:0] i;// img_height の base
reg [10:0] j;
always@(posedge clk_en)begin
    if(!rst_n)begin
        for(i=0;i<img_height;i=i+1)begin
            for(j=0;j<img_width;j=j+1)begin
                img_buffer[i][j]=0;
            end
        end
    end
    else begin
            for(i=0;i<img_height;i=i+1)begin
                for(j=0;j<img_width;j=j+1)begin
                    img_buffer[i][j]=img;
                end       
        end
    end
end

reg [bitwidth-1:0] weight_buffer [0:weight_width-1][0:weight_height-1];
reg [2:0] m;// weight_height の base
reg [2:0] n;
always@(posedge clk_en)begin
    if(!rst_n)begin
        for(m=0;m<weight_height;m=m+1)begin
            for(n=0;n<weight_width;n=n+1)begin
                weight_buffer[m][n]=0;
            end
        end
    end
    else begin
            for(m=0;m<weight_height;m=m+1)begin
                for(n=0;n<weight_width;n=n+1)begin
                    weight_buffer[m][n]=weight;
                end
            end
    end
end

// conv
integer iw;
integer ih;
integer ww;
integer wh;
integer rw;
integer rh;
reg [bitwidth-1:0] temp;
reg [bitwidth-1:0] result_buffer [0:result_width-1][0:result_height-1];
always @(*) begin
    if(!conv_en)begin
        for(rw=0;m<result_width;rw=rw+1)begin
            for(rh=0;n<result_height;rh=rh+1)begin
                result_buffer[rw][rh]=0;
            end
        end
    end
    else begin
            for(iw=0; iw<img_width-weight_width; iw=iw+stride)begin
                for(ih=0; ih<img_height-weight_height; ih=ih+stride)begin
                    for(ww=0; ww<weight_width; ww=ww+1)begin
                        for(wh=0; wh<weight_height; wh=wh+1)begin
                            temp=temp+img_buffer[iw+ww][ih+wh]*weight_buffer[ww][wh];
                        end
                    end
                    result_buffer[rw][rh]=temp+b0;
                    temp=0;
                    rh=rh+1;
                end
                rw=rw+1;
            end
            rh=0;
            rw=0;
    end
end
/*
wire [bitwidth-1:0] result_buffer [0:result_width-1][0:result_height-1];
conv_c1w4h4_k2b1_s1p1 conv_cal_inst(
    .clk_en         (clk_en),
    .rst_n          (rst_n),
    .x00        (img_buffer[0][0]),
    .x01        (img_buffer[0][1]),
    .x02        (img_buffer[0][2]),
    .x03        (img_buffer[0][3]),
    .x10        (img_buffer[1][0]),
    .x11        (img_buffer[1][1]),
    .x12        (img_buffer[1][2]),
    .x13        (img_buffer[1][3]),
    .x20        (img_buffer[2][0]),
    .x21        (img_buffer[2][1]),
    .x22        (img_buffer[2][2]),
    .x23        (img_buffer[2][3]),
    .x30        (img_buffer[3][0]),
    .x31        (img_buffer[3][1]),
    .x32        (img_buffer[3][2]),
    .x33        (img_buffer[3][3]),
    .w00        (weight_buffer[0][0]),
    .w01        (weight_buffer[0][1]),
    .w10        (weight_buffer[1][0]),
    .w11        (weight_buffer[1][1]),
    .b0         (b0),
    .y00        (result_buffer[0][0]),
    .y01        (result_buffer[0][1]),
    .y02        (result_buffer[0][2]),
    .y10        (result_buffer[1][0]),
    .y11        (result_buffer[1][1]),
    .y12        (result_buffer[1][2]),
    .y20        (result_buffer[2][0]),
    .y21        (result_buffer[2][1]),
    .y22        (result_buffer[2][2])
);*/

// output serial
integer oi;
integer oj;
always@(posedge clk_en)begin
    if(!rst_n)begin
        conv_out=0;
    end
    else begin
            for(oi=0;oi<result_height;oi=oi+1)begin
                for(oj=0;oj<result_width;oj=oj+1)begin
                    //conv_out[(bitsum-oi*bitwidth):(bitsum-oi*bitwidth-bitwidth)]=result_buffer[oi][oj];
                    conv_out[bitsum-oi*bitwidth -: bitwidth]=result_buffer[oi][oj];//赋值时位宽后一个不能含变量
                end       
        end
    end
end

endmodule