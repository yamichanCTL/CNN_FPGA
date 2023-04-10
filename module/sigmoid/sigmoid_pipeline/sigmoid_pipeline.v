`timescale 1ns/100ps

module  sigmoid_SONF 
#(
    parameter LAYER_num = 1,
    parameter WIDTH_in_data = 16,    //1+14+2
    parameter WIDTH_each_data_x = 17,
    parameter WIDTH_each_data_y = 33  //1+28+4
)
(
    input  clk,
    input  rstn,
    input  wire signed [(LAYER_num*WIDTH_in_data*WIDTH_in_data*WIDTH_each_data_x-1):0] x,  //1*16*16*17=4352
    output reg  signed [(LAYER_num*WIDTH_in_data*WIDTH_in_data*WIDTH_each_data_y-1):0] y   //1*16*16*33=8448
);

    parameter MUL_X = 12;          //14-2 (x*2^14)
    parameter Y_X0  = 134217728;   //(2^28)/2

    reg [WIDTH_each_data_x -1:0] layer_1 [0:WIDTH_in_data-1][0:WIDTH_in_data-1];
    //reg [WIDTH_each_data -1:0] layer_2 [0:WIDTH_in_data-1][0:WIDTH_in_data-1];
    //reg [WIDTH_each_data -1:0] layer_3 [0:WIDTH_in_data-1][0:WIDTH_in_data-1];

    reg  signed [WIDTH_each_data_x-1:0] reg_abs_x [0:WIDTH_in_data-1][0:WIDTH_in_data-1];
    reg  signed [WIDTH_each_data_y-1:0] reg_y     [0:WIDTH_in_data-1][0:WIDTH_in_data-1];
    reg  signed [WIDTH_each_data_y-1:0] reg_y_1   [0:WIDTH_in_data-1][0:WIDTH_in_data-1];
    reg  signed [WIDTH_each_data_y-1:0] reg_y_2   [0:WIDTH_in_data-1][0:WIDTH_in_data-1];

    integer i1,j1;
    always @(posedge clk) begin
        for ( i1=0 ; i1<WIDTH_in_data; i1=i1+1) begin
            for ( j1=0 ; j1<WIDTH_in_data; j1=j1+1) begin
                layer_1[i1][j1] <= x[((LAYER_num     * WIDTH_in_data * WIDTH_in_data * WIDTH_each_data_x -1) - i1*WIDTH_in_data*WIDTH_each_data_x - j1*WIDTH_each_data_x) -: WIDTH_each_data_x];
                //layer_2[i][j] = slice_in_data[(((LAYER_num-1) * WIDTH_in_data * WIDTH_in_data * WIDTH_each_data -1) - i*WIDTH_in_data*WIDTH_each_data - j*WIDTH_each_data) -: WIDTH_each_data];
                //layer_3[i][j] = slice_in_data[(((LAYER_num-2) * WIDTH_in_data * WIDTH_in_data * WIDTH_each_data -1) - i*WIDTH_in_data*WIDTH_each_data - j*WIDTH_each_data) -: WIDTH_each_data];
            end
        end
    end

    integer i2,j2;
    always @(posedge clk or negedge rstn) begin
        for ( i2=0 ; i2<WIDTH_in_data; i2=i2+1) begin
            for ( j2=0 ; j2<WIDTH_in_data; j2=j2+1) begin
                if (!rstn)                                      reg_abs_x[i2][j2] <= 0;
                else if(layer_1[i2][j2][WIDTH_in_data-1] == 1)  reg_abs_x[i2][j2] <= -layer_1[i2][j2];
                else                                            reg_abs_x[i2][j2] <= -layer_1[i2][j2];
            end
        end
    end

    integer i3,j3;
    always @(posedge clk or negedge rstn) begin
        for ( i3=0 ; i3<WIDTH_in_data; i3=i3+1) begin
            for ( j3=0 ; j3<WIDTH_in_data; j3=j3+1) begin
                if (!rstn) begin
                    reg_y_1[i3][j3] <= 0;
                    reg_y_2[i3][j3] <= 0;
                end
                else begin
                    reg_y_1[i3][j3] <= reg_abs_x[i3][j3]<<<MUL_X;
                    reg_y_2[i3][j3] <= (reg_abs_x[i3][j3]*reg_abs_x[i3][j3])>>>5;
                end
            end
        end
    end

    integer i4,j4;
    always @(posedge clk or negedge rstn) begin
        for ( i4=0 ; i4<WIDTH_in_data; i4=i4+1) begin
            for ( j4=0 ; j4<WIDTH_in_data; j4=j4+1) begin
                if(!rstn)        reg_y[i4][j4] <= 0;
                else if(x > 0)   reg_y[i4][j4] <= reg_y_1[i4][j4] - reg_y_2[i4][j4];
                else             reg_y[i4][j4] <= reg_y_2[i4][j4] - reg_y_1[i4][j4];
            end
        end
    end

    integer m,n;
    always @(posedge clk) begin
        for ( m=0 ; m<WIDTH_in_data; m=m+1) begin
            for ( n=0 ; n<WIDTH_in_data; n=n+1) begin
                y[((LAYER_num     * WIDTH_in_data * WIDTH_in_data * WIDTH_each_data_y -1) - m*WIDTH_in_data*WIDTH_each_data_y - n*WIDTH_each_data_y) -: WIDTH_each_data_y] <= reg_y[m][n] + Y_X0;
                //slice_out_1[(((LAYER_num-1) * WIDTH_out_data * WIDTH_out_data * WIDTH_each_data -1) - m*WIDTH_out_data*WIDTH_each_data - n*WIDTH_each_data) -: WIDTH_each_data] = layer_2[2*m][2*n];
                //slice_out_1[(((LAYER_num-2) * WIDTH_out_data * WIDTH_out_data * WIDTH_each_data -1) - m*WIDTH_out_data*WIDTH_each_data - n*WIDTH_each_data) -: WIDTH_each_data] = layer_3[2*m][2*n];
            end
        end
    end

endmodule