module key_ctl(
    input            clk,
    input            key,
    
    output   reg     ctrl
);

    wire btn_deb;

    btn_deb_fix#(                    
        .BTN_WIDTH   (  4'd1        ), //parameter                  BTN_WIDTH = 4'd8
        .BTN_DELAY   (20'h7_ffff    )
    ) u_btn_deb                           
    (                            
        .clk         (  clk         ),//input                      clk,
        .btn_in      (  key         ),//input      [BTN_WIDTH-1:0] btn_in,
                                    
        .btn_deb_fix (  btn_deb     ) //output reg [BTN_WIDTH-1:0] btn_deb
    );

    reg btn_deb_1d;
    always @(posedge clk)
    begin
        btn_deb_1d <= btn_deb;
    end

    reg [1:0]  key_push_cnt=2'd0;
    always @(posedge clk)
    begin
        if(~btn_deb & btn_deb_1d) ctrl <= ~ctrl;
        else                      ctrl <= ctrl ;
    end

endmodule
