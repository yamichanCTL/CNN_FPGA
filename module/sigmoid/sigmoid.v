`timescale 1ns/100ps

module  sigmoid_SONF (
    input wire signed [16:0] x,
    output wire signed [32:0] y
);

    reg  signed [32:0] reg_y;
    reg  signed [16:0] abs_x;
    wire signed [32:0] reg_y_1;
    wire signed [32:0] reg_y_2;

    always @(*) begin
        if (x[16] == 1)  abs_x = -x;
        else  abs_x = x;
    end

    assign reg_y_1 = abs_x<<<12;
    assign reg_y_2 = (abs_x*abs_x)>>>5;

    always @(*) begin
        if(x > 0)   reg_y = 134217728 + reg_y_1 - reg_y_2;
        else        reg_y = 134217728 + reg_y_2 - reg_y_1;
    end

    assign y = reg_y;

endmodule