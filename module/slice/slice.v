`timescale 1ns/100ps

module slice
#(
    parameter LAYER_num = 1,
    parameter WIDTH_in_data = 160,
    parameter WIDTH_out_data = 80,
    parameter WIDTH_each_data = 16
)
(
    input clk,
    input rstn,
    input      [LAYER_num * WIDTH_in_data  * WIDTH_in_data  * WIDTH_each_data -1:0] slice_in_data,  //3*320*320*16=4915200
    output reg [LAYER_num * WIDTH_out_data * WIDTH_out_data * WIDTH_each_data -1:0] slice_out_1,    //3*160*160*16=1228800
    output reg [LAYER_num * WIDTH_out_data * WIDTH_out_data * WIDTH_each_data -1:0] slice_out_2,
    output reg [LAYER_num * WIDTH_out_data * WIDTH_out_data * WIDTH_each_data -1:0] slice_out_3,
    output reg [LAYER_num * WIDTH_out_data * WIDTH_out_data * WIDTH_each_data -1:0] slice_out_4
);  

    reg [WIDTH_each_data -1:0] layer_1 [0:WIDTH_in_data-1][0:WIDTH_in_data-1];
    //reg [WIDTH_each_data -1:0] layer_2 [0:WIDTH_in_data-1][0:WIDTH_in_data-1];
    //reg [WIDTH_each_data -1:0] layer_3 [0:WIDTH_in_data-1][0:WIDTH_in_data-1];

    integer i,j;
    always @(posedge clk) begin
        for ( i=0 ; i<WIDTH_in_data; i=i+1) begin
            for ( j=0 ; j<WIDTH_in_data; j=j+1) begin
                layer_1[i][j] <= slice_in_data[((LAYER_num     * WIDTH_in_data * WIDTH_in_data * WIDTH_each_data -1) - i*WIDTH_in_data*WIDTH_each_data - j*WIDTH_each_data) -: WIDTH_each_data];
                //layer_2[i][j] = slice_in_data[(((LAYER_num-1) * WIDTH_in_data * WIDTH_in_data * WIDTH_each_data -1) - i*WIDTH_in_data*WIDTH_each_data - j*WIDTH_each_data) -: WIDTH_each_data];
                //layer_3[i][j] = slice_in_data[(((LAYER_num-2) * WIDTH_in_data * WIDTH_in_data * WIDTH_each_data -1) - i*WIDTH_in_data*WIDTH_each_data - j*WIDTH_each_data) -: WIDTH_each_data];
            end
        end
    end

    integer m,n;
    always @(posedge clk) begin
        for ( m=0 ; m<WIDTH_out_data; m=m+1) begin
            for ( n=0 ; n<WIDTH_out_data; n=n+1) begin
                slice_out_1[((LAYER_num     * WIDTH_out_data * WIDTH_out_data * WIDTH_each_data -1) - m*WIDTH_out_data*WIDTH_each_data - n*WIDTH_each_data) -: WIDTH_each_data] <= layer_1[2*m][2*n];
                //slice_out_1[(((LAYER_num-1) * WIDTH_out_data * WIDTH_out_data * WIDTH_each_data -1) - m*WIDTH_out_data*WIDTH_each_data - n*WIDTH_each_data) -: WIDTH_each_data] = layer_2[2*m][2*n];
                //slice_out_1[(((LAYER_num-2) * WIDTH_out_data * WIDTH_out_data * WIDTH_each_data -1) - m*WIDTH_out_data*WIDTH_each_data - n*WIDTH_each_data) -: WIDTH_each_data] = layer_3[2*m][2*n];

                slice_out_2[((LAYER_num     * WIDTH_out_data * WIDTH_out_data * WIDTH_each_data -1) - m*WIDTH_out_data*WIDTH_each_data - n*WIDTH_each_data) -: WIDTH_each_data] <= layer_1[2*m][2*n+1];
                //slice_out_2[(((LAYER_num-1) * WIDTH_out_data * WIDTH_out_data * WIDTH_each_data -1) - m*WIDTH_out_data*WIDTH_each_data - n*WIDTH_each_data) -: WIDTH_each_data] = layer_2[2*m][2*n+1];
                //slice_out_2[(((LAYER_num-2) * WIDTH_out_data * WIDTH_out_data * WIDTH_each_data -1) - m*WIDTH_out_data*WIDTH_each_data - n*WIDTH_each_data) -: WIDTH_each_data] = layer_3[2*m][2*n+1];
                
                slice_out_3[((LAYER_num     * WIDTH_out_data * WIDTH_out_data * WIDTH_each_data -1) - m*WIDTH_out_data*WIDTH_each_data - n*WIDTH_each_data) -: WIDTH_each_data] <= layer_1[2*m+1][2*n];
                //slice_out_3[(((LAYER_num-1) * WIDTH_out_data * WIDTH_out_data * WIDTH_each_data -1) - m*WIDTH_out_data*WIDTH_each_data - n*WIDTH_each_data) -: WIDTH_each_data] = layer_2[2*m+1][2*n];
                //slice_out_3[(((LAYER_num-2) * WIDTH_out_data * WIDTH_out_data * WIDTH_each_data -1) - m*WIDTH_out_data*WIDTH_each_data - n*WIDTH_each_data) -: WIDTH_each_data] = layer_3[2*m+1][2*n];

                slice_out_4[((LAYER_num     * WIDTH_out_data * WIDTH_out_data * WIDTH_each_data -1) - m*WIDTH_out_data*WIDTH_each_data - n*WIDTH_each_data) -: WIDTH_each_data] <= layer_1[2*m+1][2*n+1];
                //slice_out_4[(((LAYER_num-1) * WIDTH_out_data * WIDTH_out_data * WIDTH_each_data -1) - m*WIDTH_out_data*WIDTH_each_data - n*WIDTH_each_data) -: WIDTH_each_data] = layer_2[2*m+1][2*n+1];
                //slice_out_4[(((LAYER_num-2) * WIDTH_out_data * WIDTH_out_data * WIDTH_each_data -1) - m*WIDTH_out_data*WIDTH_each_data - n*WIDTH_each_data) -: WIDTH_each_data] = layer_3[2*m+1][2*n+1];
            end
        end
    end






    // integer i,j;
    // always @(*) begin
    //     for ( i= 0; i<loop_num; i=i+1) begin
    //         for ( j= 0; j<loop_num; j=j+1) begin
    //             slice_out_1_addr[WIDTH_out_data*(WIDTH_out_data-i)-1-j] = slice_in_addr[WIDTH_in_data*(WIDTH_in_data-2*i)-1-2*j];
    //             slice_out_2_addr[WIDTH_out_data*(WIDTH_out_data-i)-1-j] = slice_in_addr[WIDTH_in_data*(WIDTH_in_data-2*i)-2-2*j];
    //             slice_out_3_addr[WIDTH_out_data*(WIDTH_out_data-i)-1-j] = slice_in_addr[WIDTH_in_data*(WIDTH_in_data-2*i-1)-1-2*j];
    //             slice_out_4_addr[WIDTH_out_data*(WIDTH_out_data-i)-1-j] = slice_in_addr[WIDTH_in_data*(WIDTH_in_data-2*i-1)-2-2*j];
    //         end
    //     end
    // end

endmodule //slice