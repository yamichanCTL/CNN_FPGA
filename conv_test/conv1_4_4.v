module conv_c1w4h4_k2b1_s1p1(
    clk_en,
    rst_n,
    x00, x01, x02, x03,
    x10, x11, x12, x13,
    x20, x21, x22, x23,
    x30, x31, x32, x33,
    w00, w01,
    w10, w11,
    b0,
    y00, y01, y02,
    y10, y11, y12,
    y20, y21, y22
);
parameter BITWIDTH = 4'd1;

input clk_en;
input rst_n;
input signed [BITWIDTH:0] x00;
input signed [BITWIDTH:0] x01;
input signed [BITWIDTH:0] x02;
input signed [BITWIDTH:0] x03;
input signed [BITWIDTH:0] x10;
input signed [BITWIDTH:0] x11;
input signed [BITWIDTH:0] x12;
input signed [BITWIDTH:0] x13;
input signed [BITWIDTH:0] x20;
input signed [BITWIDTH:0] x21;
input signed [BITWIDTH:0] x22;
input signed [BITWIDTH:0] x23;
input signed [BITWIDTH:0] x30;
input signed [BITWIDTH:0] x31;
input signed [BITWIDTH:0] x32;
input signed [BITWIDTH:0] x33;

input signed [BITWIDTH:0] w00;
input signed [BITWIDTH:0] w01;
input signed [BITWIDTH:0] w10;
input signed [BITWIDTH:0] w11;

input signed [BITWIDTH:0] b0;

output reg signed [BITWIDTH:0] y00;
output reg signed [BITWIDTH:0] y01;
output reg signed [BITWIDTH:0] y02;
output reg signed [BITWIDTH:0] y10;
output reg signed [BITWIDTH:0] y11;
output reg signed [BITWIDTH:0] y12;
output reg signed [BITWIDTH:0] y20;
output reg signed [BITWIDTH:0] y21;
output reg signed [BITWIDTH:0] y22;

always @(*) begin
    y00 = x00*w00 + x01*w01 + x10*w10 + x11*w11 + b0;
    y01 = x01*w00 + x10*w01 + x11*w10 + x12*w11 + b0;
    y02 = x10*w00 + x11*w01 + x12*w10 + x13*w11 + b0;

    y10 = x10*w00 + x11*w01 + x20*w10 + x21*w11 + b0;
    y11 = x11*w00 + x12*w01 + x21*w10 + x22*w11 + b0;
    y12 = x12*w00 + x13*w01 + x22*w10 + x23*w11 + b0;

    y20 = x20*w00 + x21*w01 + x30*w10 + x31*w11 + b0;
    y21 = x21*w00 + x22*w01 + x31*w10 + x32*w11 + b0;
    y22 = x22*w00 + x23*w01 + x32*w10 + x33*w11 + b0;
end
endmodule