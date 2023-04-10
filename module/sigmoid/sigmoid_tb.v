`timescale 1ns/100ps

module sigmoid_SONF_tb;

  // Ports
  reg  signed [16:0] x;
  wire signed [32:0] y;

  sigmoid_SONF sigmoid_SONF_dut (
                                 .x (x ),
                                 .y (y )
                                );

// ����һ����������
integer i;

// ʹ��initial���always��
initial begin
  // ѭ����-65535��+65535������Ϊ100
  for (i = -65535; i <= 65535; i = i + 100) begin
    // ���������ݸ�ֵ
    x = i;
    // �ӳ�һ��ʱ�䣬���������Ҫ������
    #20;
  end
end

// �����ļ�������
    integer fd;

    // ��һ���ļ���ʹ�� w ģʽ
    initial begin
      fd = $fopen("data/data_xy.txt", "w");
      if(fd == 0)begin 
        $display ("can not open the file!");    //�����ļ�ʧ�ܣ���ʾcan not open the file!
        $stop;
      end
    end

    always @(y) begin
      $fwrite(fd, "%d\t%d\n", x, y);
    end

endmodule
