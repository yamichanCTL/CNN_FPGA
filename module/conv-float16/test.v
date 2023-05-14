module test#(
    parameter a=16
)(  
    input clk,
    input rst_n,
    input [a-1:0] data,
    output reg [a-1:0] dataout
);

reg [a-1:0]i;
always @(posedge clk,negedge rst_n) begin
    if(!rst_n) begin
        dataout<=0;
    end
    else begin
        for(i=0;i<10;i=i+1) begin
            dataout<=data+1;
        end
    end
end
endmodule
