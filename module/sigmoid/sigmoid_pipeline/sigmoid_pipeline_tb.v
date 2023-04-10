`timescale 1ns/100ps

module sigmoid_SONF_tb;

  // Parameters
  localparam  WIDTH_X = 17;
  localparam  WIDTH_Y = 33;

  parameter CYCLE = 20;

  // Ports
  reg clk = 0;
  reg rstn = 0;
  reg  [(WIDTH_X-1):0] x;
  wire [(WIDTH_Y-1):0] y;

  sigmoid_SONF 
  #(
    .WIDTH_X(WIDTH_X ),
    .WIDTH_Y(WIDTH_Y )
  )
  sigmoid_SONF_dut (
    .clk (clk ),
    .rstn (rstn ),
    .x (x ),
    .y (y )
  );

  always  #(CYCLE/2)  clk = ! clk ; 

  initial begin
    clk  = 0;
    rstn = 0;
    #5 rstn = 1;
  end
  
    // 定义一个整数变量
integer i;
// 使用initial块或always块
initial begin
  // 循环从-65535到+65535，步长为100
  for (i = -65535; i <= 65535; i = i + 100) begin
    // 给输入数据赋值
    x = i;
    // 延迟一段时间，根据你的需要来调整
    #CYCLE;
  end
end
    
  //    genvar i;
  //    generate
  //   // 循环从-65535到+65535，步长为100
  //   for (i = -65535; i <= 65535; i = i + 100) begin:generate_data
  //     // 给输入数据赋值
  //     always @(posedge clk or negedge rstn) begin
  //       if(!rstn)  x = 0;
  //       else       x = i;
  //     end
  //  end
  //  endgenerate

  // 声明文件描述符
  // integer fd;
  //   // 打开一个文件，使用 w 模式
  //   initial begin
  //     fd = $fopen("data/data_xy.txt", "w");
  //     if(fd == 0)begin 
  //       $display ("can not open the file!");    //创建文件失败，显示can not open the file!
  //       $stop;
  //     end
  //   end

    // always @(posedge clk) begin
    //   $fwrite(fd_x, "%d", x);
    //   #3*CYCLE
    //   $fwrite(fd_y, "%d", y);
    // end

endmodule
