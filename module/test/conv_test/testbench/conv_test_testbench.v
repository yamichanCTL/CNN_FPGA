`timescale 1ns/1ps
module conv_top_tb();
    parameter weight_width = 2;
    parameter weight_height = 2;

    parameter img_width = 4;
    parameter img_height = 4;
    
    parameter padding_enable = 0;
    parameter padding = 0;
    parameter stride = 1;
    parameter bitwidth = 4;
    parameter result_width = (img_width-weight_width+2*padding)/stride+1;
    parameter result_height = (img_height-weight_height+2*padding)/stride+1;
    parameter bitsum = result_width*result_width*bitwidth  ;
    parameter expand = 1;

reg clk_en;
reg reset_n;
reg conv_en;

reg [img_width*img_height*bitwidth-1:0] img;
reg [weight_width*weight_height*bitwidth-1:0] weight;
reg [bitwidth-1:0]       bias;

wire [2*result_width*result_height*bitwidth-1:0] result;
wire conv_fin;

initial begin
    img=64'h1111_1111_1111_1111;
    weight = 16'h1111;
    //weight  =  27'b001_000_000_000_001_000_000_000_001;
    bias = 4'h1;
end
/*
3 2 4 1
2 0 6 2
6 7 1 2
5 6 4 2
         
1 0                
0 1                
               
            
1 0 0                                  
0 1 0                            
0 0 1                                               

*/

initial begin
    clk_en=0;
    forever #100 clk_en=~clk_en;
end

initial begin
   reset_n=0;
   #300 reset_n=1;     
end

initial begin
    conv_en=0;
    #400 conv_en=1;
    #700 conv_en=0;
end
conv_top #(
    .weight_width(weight_width),
    .weight_height(weight_height),
    .img_width(img_width),
    .img_height(img_height),
    .padding_enable(padding_enable),
    .padding(padding),

    .stride(stride),
    .bitwidth(bitwidth),
    .result_width(result_width),
    .result_height(result_height),
    .expand(expand)
) inst(
    .clk_en     (clk_en),
    .rst_n      (reset_n),
    .conv_en    (conv_en),

    .img          (img),
    .weight       (weight),
    .bias         (bias),
    
    .result       (result),
    .conv_fin     (conv_fin)
);
GTP_GRS   GRS_INST( .GRS_N(1'b1) );
endmodule