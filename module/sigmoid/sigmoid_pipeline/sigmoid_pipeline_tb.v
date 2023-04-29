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
  
    // ����һ����������
integer i;
// ʹ��initial���always��
initial begin
  // ѭ����-65535��+65535������Ϊ100
  for (i = -65535; i <= 65535; i = i + 100) begin
    // ���������ݸ�ֵ
    x = i;
    // �ӳ�һ��ʱ�䣬���������Ҫ������
    #CYCLE;
  end
end
    
  //    genvar i;
  //    generate
  //   // ѭ����-65535��+65535������Ϊ100
  //   for (i = -65535; i <= 65535; i = i + 100) begin:generate_data
  //     // ���������ݸ�ֵ
  //     always @(posedge clk or negedge rstn) begin
  //       if(!rstn)  x = 0;
  //       else       x = i;
  //     end
  //  end
  //  endgenerate

  // �����ļ�������
  // integer fd;
  //   // ��һ���ļ���ʹ�� w ģʽ
  //   initial begin
  //     fd = $fopen("data/data_xy.txt", "w");
  //     if(fd == 0)begin 
  //       $display ("can not open the file!");    //�����ļ�ʧ�ܣ���ʾcan not open the file!
  //       $stop;
  //     end
  //   end

    // always @(posedge clk) begin
    //   $fwrite(fd_x, "%d", x);
    //   #3*CYCLE
    //   $fwrite(fd_y, "%d", y);
    // end

endmodule
