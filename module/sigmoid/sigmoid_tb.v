`timescale 1ns/100ps

module sigmoid_SONF_tb;

  // Ports
  reg  signed [16:0] x;
  wire signed [32:0] y;

  sigmoid_SONF sigmoid_SONF_dut (
                                 .x (x ),
                                 .y (y )
                                );

// 定义一个整数变量
integer i;

// 使用initial块或always块
initial begin
  // 循环从-65535到+65535，步长为100
  for (i = -65535; i <= 65535; i = i + 100) begin
    // 给输入数据赋值
    x = i;
    // 延迟一段时间，根据你的需要来调整
    #20;
  end
end

// 声明文件描述符
    integer fd;

    // 打开一个文件，使用 w 模式
    initial begin
      fd = $fopen("data/data_xy.txt", "w");
      if(fd == 0)begin 
        $display ("can not open the file!");    //创建文件失败，显示can not open the file!
        $stop;
      end
    end

    always @(y) begin
      $fwrite(fd, "%d\t%d\n", x, y);
    end

endmodule
