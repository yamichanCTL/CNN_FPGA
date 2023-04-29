`timescale 1ns/100ps

module slice_tb;

  // Parameters
  localparam  LAYER_num = 1;
  localparam  WIDTH_in_data = 160;
  localparam  WIDTH_out_data = 80;
  localparam  WIDTH_each_data = 16;

  // Ports
  reg clk;
  reg rstn;
  reg  [LAYER_num * WIDTH_in_data  * WIDTH_in_data  * WIDTH_each_data -1:0] slice_in_data;
  wire [LAYER_num * WIDTH_out_data * WIDTH_out_data * WIDTH_each_data -1:0] slice_out_1;
  wire [LAYER_num * WIDTH_out_data * WIDTH_out_data * WIDTH_each_data -1:0] slice_out_2;
  wire [LAYER_num * WIDTH_out_data * WIDTH_out_data * WIDTH_each_data -1:0] slice_out_3;
  wire [LAYER_num * WIDTH_out_data * WIDTH_out_data * WIDTH_each_data -1:0] slice_out_4;

  slice 
  #(
    .LAYER_num(LAYER_num ),
    .WIDTH_in_data(WIDTH_in_data ),
    .WIDTH_out_data(WIDTH_out_data ),
    .WIDTH_each_data (WIDTH_each_data )
  )
  slice_dut (
    .clk (clk ),
    .rstn (rstn ),
    .slice_in_data (slice_in_data ),
    .slice_out_1 (slice_out_1 ),
    .slice_out_2 (slice_out_2 ),
    .slice_out_3 (slice_out_3 ),
    .slice_out_4 (slice_out_4 )
  );

  initial begin
    clk = 0;
    rstn = 0;
    #5 rstn = 1;
  end

  initial begin
    slice_in_data = 409600'd1;
    //slice_in_data = 1024'h1212121212121212343434343434343412121212121212123434343434343434121212121212121234343434343434341212121212121212343434343434343412121212121212123434343434343434121212121212121234343434343434341212121212121212343434343434343412121212121212123434343434343434;
    //#20 slice_in_data = 1024'hababababababababcdcdcdcdcdcdcdcdababababababababcdcdcdcdcdcdcdcdababababababababcdcdcdcdcdcdcdcdababababababababcdcdcdcdcdcdcdcdababababababababcdcdcdcdcdcdcdcdababababababababcdcdcdcdcdcdcdcdababababababababcdcdcdcdcdcdcdcdababababababababcdcdcdcdcdcdcdcd;
  end

  always
    #10  clk = ! clk ;

endmodule
