module read_bin_file;

parameter DATA_WIDTH = 16;
parameter D = 5; //Depth of image and filter
  reg [0:DATA_WIDTH-1] data [0:D-1];
  reg [0:D*DATA_WIDTH-1] serialout;
  integer file;
  integer i;

  initial begin
    file = $fopen("temp.txt", "r");
    if (file == 0) begin
      $display("Error opening file.");
      $finish;
    end
    $readmemb("temp.txt", data);
    $fclose(file);
    for (i = 0; i < 5; i=i+1) begin
      serialout[DATA_WIDTH*i+:DATA_WIDTH] = data[i];
      $display("data[%0d] = %d", i, $bitstoreal(data[i]));
    end
    //$display("data = %b",  serialout);
/*
    // 输出前16个字节的内容
    for (i = 0; i < 16; i=i+1) begin
      $display("data[%0d] = %b", i, data[i]);
    end
    */
  end

endmodule

