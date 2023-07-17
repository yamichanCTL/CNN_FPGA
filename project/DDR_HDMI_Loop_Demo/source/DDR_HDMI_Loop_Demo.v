`timescale 1ns / 1ps

module DDR_HDMI_Loop_Demo
#(  parameter MEM_ROW_ADDR_WIDTH   = 15  ,
	parameter MEM_COL_ADDR_WIDTH   = 10  ,
	parameter MEM_BADDR_WIDTH      = 3   ,
	parameter MEM_DQ_WIDTH         = 16  ,
	parameter MEM_DM_WIDTH         = MEM_DQ_WIDTH/8,
	parameter MEM_DQS_WIDTH        = MEM_DQ_WIDTH/8,
	parameter CTRL_ADDR_WIDTH      = MEM_ROW_ADDR_WIDTH + MEM_BADDR_WIDTH + MEM_COL_ADDR_WIDTH,
	parameter BURST_LENGTH		   = 8,
	parameter BURST_NUM			   = 15,
	parameter BURST_WIDTH		   = 4,
	parameter DEVICE_NUM		   = 4
)
(
	input i_clk,
	input i_rstn,

	input  [1:0] key,
	output [1:0] ctrl_led,
	
	output [1:0]o_led,

	//OV5647
    output  [1:0]                        cmos_init_done       ,//OV5640寄存器初始化完成
    //coms1	
    inout                                cmos1_scl            ,//cmos1 i2c 
    inout                                cmos1_sda            ,//cmos1 i2c 
    input                                cmos1_vsync          ,//cmos1 vsync
    input                                cmos1_href           ,//cmos1 hsync refrence,data valid
    input                                cmos1_pclk           ,//cmos1 pxiel clock
    input   [7:0]                        cmos1_data           ,//cmos1 data
    output                               cmos1_reset          ,//cmos1 reset
    //coms2
    inout                                cmos2_scl            ,//cmos2 i2c 
    inout                                cmos2_sda            ,//cmos2 i2c 
    input                                cmos2_vsync          ,//cmos2 vsync
    input                                cmos2_href           ,//cmos2 hsync refrence,data valid
    input                                cmos2_pclk           ,//cmos2 pxiel clock
    input   [7:0]                        cmos2_data           ,//cmos2 data
    output                               cmos2_reset          ,//cmos2 reset
	
	//------------------HDMI通道数据------------------------//
	//HDMI1输入
	input [23:0]i_hdmi1_data,
	input i_hdmi1_vde,
	input i_hdmi1_hsync,
	input i_hdmi1_vsync,
	input i_hdmi1_clk,
	
	//HDMI3输出
	output [23:0]o_hdmi3_data,
	output o_hdmi3_vde,
	output o_hdmi3_hsync,
	output o_hdmi3_vsync,
	output o_hdmi3_clk,
	output o_hdmi3_rstn,
	
	//HDMI驱动芯片IIC信号
	output o_hdmi1_scl,
	inout io_hdmi1_sda,

	output o_hdmi3_scl,
	inout io_hdmi3_sda,
	
	//-----------------DDR管脚信号-----------------------//
	output o_ddr3_rstn,
	output o_ddr3_clk_p,
	output o_ddr3_clk_n,
	output o_ddr3_cke,
	output o_ddr3_cs,
	output o_ddr3_ras,
	output o_ddr3_cas,
	output o_ddr3_we,
	output o_ddr3_odt,
	output [MEM_ROW_ADDR_WIDTH-1:0]o_ddr3_address,
	output [MEM_BADDR_WIDTH-1:0]o_ddr3_ba,
	output [MEM_DM_WIDTH-1:0]o_ddr3_dm,
	inout [MEM_DQS_WIDTH-1:0]o_ddr3_dqs_p,
	inout [MEM_DQS_WIDTH-1:0]o_ddr3_dqs_n,
	inout [MEM_DQ_WIDTH-1:0]o_ddr3_dq
   );

   /////////////////////////////////////////////////////////////////////////////////////
   reg  [15:0]                 rstn_1ms            ;
   wire                        cmos_scl            ;//cmos i2c clock
   wire                        cmos_sda            ;//cmos i2c data
   wire                        cmos_vsync          ;//cmos vsync
   wire                        cmos_href           ;//cmos hsync refrence,data valid
   wire                        cmos_pclk           ;//cmos pxiel clock
   wire   [7:0]                cmos_data           ;//cmos data
   wire                        cmos_reset          ;//cmos reset
   wire                        initial_en          ;
   wire[15:0]                  cmos1_d_16bit       ;
   wire                        cmos1_href_16bit    ;
   reg [7:0]                   cmos1_d_d0          ;
   reg                         cmos1_href_d0       ;
   reg                         cmos1_vsync_d0      ;
   wire                        cmos1_pclk_16bit    ;
   wire[15:0]                  cmos2_d_16bit       /*synthesis PAP_MARK_DEBUG="1"*/;
   wire                        cmos2_href_16bit    /*synthesis PAP_MARK_DEBUG="1"*/;
   reg [7:0]                   cmos2_d_d0          /*synthesis PAP_MARK_DEBUG="1"*/;
   reg                         cmos2_href_d0       /*synthesis PAP_MARK_DEBUG="1"*/;
   reg                         cmos2_vsync_d0      /*synthesis PAP_MARK_DEBUG="1"*/;
   wire                        cmos2_pclk_16bit    /*synthesis PAP_MARK_DEBUG="1"*/;
   wire[15:0]                  o_rgb565            ;
   wire                        pclk_in_test        ;    
   wire                        vs_in_test          ;
   wire                        de_in_test          ;
   wire[15:0]                  i_rgb565            ;
   wire                        de_re               ;

   wire cmos1_hsync_16bit ;
   wire cmos1_vsync_16bit ;
   wire [23:0] data_rgb_24bit  ;

    //按键控制
    wire ctrl_0;
	wire ctrl_1;

	//系统时钟
	wire clk_system;
	wire pll_locked;
	wire axi_clk;
	wire clk_config_hdmi;
	wire config_locked;
	
	//HDMI复位
	reg hdmi_resetn = 0;
	reg [15:0]hdmi_rcnt = 0;
	
	//HDMI时钟BUFG信号
	wire hdmi1_clk_bufg;
	wire hdmi2_clk_bufg;
	wire hdmi3_clk;
	
	//-------------------外部写DDR控制总线------------------//
	wire ddr_mbus_wdata_rq;									//写数据请求,上升沿代表开始需要写入数据
	wire ddr_mbus_wbusy;										//写忙信号,高电平代表忙碌
	wire [DEVICE_NUM - 1:0]ddr_mbus_wsel;					//片选信号
	
	//外设0
	wire ddr_mbus_wrq0;										//写请求信号
	wire [CTRL_ADDR_WIDTH - 1:0]ddr_mbus_waddr0;    		//写初始地址信号
	wire [MEM_DQ_WIDTH * BURST_LENGTH - 1:0]ddr_mbus_wdata0;//写数据
	wire ddr_mbus_wready0;									//写数据准备好
	
	//外设1
	wire ddr_mbus_wrq1;										//写请求信号
	wire [CTRL_ADDR_WIDTH - 1:0]ddr_mbus_waddr1;    		//写初始地址信号
	wire [MEM_DQ_WIDTH * BURST_LENGTH - 1:0]ddr_mbus_wdata1;//写数据
	wire ddr_mbus_wready1;									//写数据准备好
	
	//外设2
	wire ddr_mbus_wrq2;										//写请求信号
	wire [CTRL_ADDR_WIDTH - 1:0]ddr_mbus_waddr2;    		//写初始地址信号
	wire [MEM_DQ_WIDTH * BURST_LENGTH - 1:0]ddr_mbus_wdata2;//写数据
	wire ddr_mbus_wready2;									//写数据准备好
	
	//外设3
	wire ddr_mbus_wrq3;										//写请求信号
	wire [CTRL_ADDR_WIDTH - 1:0]ddr_mbus_waddr3;    		//写初始地址信号
	wire [MEM_DQ_WIDTH * BURST_LENGTH - 1:0]ddr_mbus_wdata3;//写数据
	wire ddr_mbus_wready3;									//写数据准备好
	
	//-------------------外部读DDR控制总线------------------//
	wire [MEM_DQ_WIDTH * BURST_LENGTH - 1:0]ddr_mbus_rdata;	//读数据
	wire ddr_mbus_rdata_rq;									//读数据请求,上升沿代表开始需要读数据
	wire ddr_mbus_rbusy;									//读忙信号,高电平代表忙碌
	wire [DEVICE_NUM - 1:0]ddr_mbus_rsel;					//片选信号
	
	//外设0
	wire ddr_mbus_rrq0;										//读请求信号
	wire [CTRL_ADDR_WIDTH - 1:0]ddr_mbus_raddr0;    		//读初始地址信号
	wire ddr_mbus_rready0;									//读数据准备好

	//时钟BUFG
	GTP_CLKBUFG MST7200_BUFG0(.CLKOUT(hdmi1_clk_bufg),.CLKIN(i_hdmi1_clk));
	GTP_CLKBUFG MST7201_BUFG0(.CLKOUT(o_hdmi3_clk),.CLKIN(hdmi3_clk));
	GTP_CLKBUFG AXI4_BUFG0(.CLKOUT(axi_clk),.CLKIN(clk_system));
	
	assign o_hdmi3_rstn = hdmi_resetn;

	//视频图像处理接口实例化
	Image_Process_Interface #(	.MEM_DQ_WIDTH(MEM_DQ_WIDTH),.CTRL_ADDR_WIDTH(CTRL_ADDR_WIDTH),
								.BURST_LENGTH(BURST_LENGTH),
								.DEVICE_NUM(DEVICE_NUM))Image_Process_Interface_Inst(
		.i_axi_aclk(axi_clk),
		.i_rstn(pll_locked),
		
		//-----------------VIDEO_IN1信号-----------------//
		.i_video1_data(i_hdmi1_data),
		.i_video1_vde(i_hdmi1_vde),
		.i_video1_hsync(i_hdmi1_hsync),
		.i_video1_vsync(i_hdmi1_vsync),
		.i_video1_clk(hdmi1_clk_bufg),

		//-----------------VIDEO_IN2信号-----------------//
		.i_video2_data(data_rgb_24bit),
		.i_video2_vde(cmos1_href_16bit),
		.i_video2_hsync(~cmos1_hsync_16bit),
		.i_video2_vsync(cmos1_vsync_16bit),
		.i_video2_clk(cmos1_pclk_16bit),

		//--------------------按键控制--------------------//
		.ctrl_0(ctrl_0),
		.ctrl_1(ctrl_1),

		//-----------------VIDEO_OUT1信号-----------------//
		.o_video1_data(o_hdmi3_data),
		.o_video1_vde(o_hdmi3_vde),
		.o_video1_hsync(o_hdmi3_hsync),
		.o_video1_vsync(o_hdmi3_vsync),
		.o_video1_clk(hdmi3_clk),
	
		//-------------------外部写DDR控制总线------------------//
		.i_mbus_wdata_rq(ddr_mbus_wdata_rq),					//写数据请求,上升沿代表开始需要写入数据
		.i_mbus_wbusy(ddr_mbus_wbusy),							//写忙信号,高电平代表忙碌
		.i_mbus_wsel(ddr_mbus_wsel),							//片选信号
		
		//外设0
		.o_mbus_wrq0(ddr_mbus_wrq0),							//写请求信号
		.o_mbus_waddr0(ddr_mbus_waddr0),    					//写初始地址信号
		.o_mbus_wdata0(ddr_mbus_wdata0),						//写数据
		.o_mbus_wready0(ddr_mbus_wready0),						//写数据准备好
		
		//外设1
		.o_mbus_wrq1(ddr_mbus_wrq1),							//写请求信号
		.o_mbus_waddr1(ddr_mbus_waddr1),    					//写初始地址信号
		.o_mbus_wdata1(ddr_mbus_wdata1),						//写数据
		.o_mbus_wready1(ddr_mbus_wready1),						//写数据准备好
		
		//外设2
		.o_mbus_wrq2(ddr_mbus_wrq2),							//写请求信号
		.o_mbus_waddr2(ddr_mbus_waddr2),    					//写初始地址信号
		.o_mbus_wdata2(ddr_mbus_wdata2),						//写数据
		.o_mbus_wready2(ddr_mbus_wready2),						//写数据准备好
		
		//外设3
		.o_mbus_wrq3(ddr_mbus_wrq3),							//写请求信号
		.o_mbus_waddr3(ddr_mbus_waddr3),    					//写初始地址信号
		.o_mbus_wdata3(ddr_mbus_wdata3),						//写数据
		.o_mbus_wready3(ddr_mbus_wready3),						//写数据准备好
		
		//-------------------外部读DDR控制总线------------------//
		.i_mbus_rdata(ddr_mbus_rdata),							//读数据
		.i_mbus_rdata_rq(ddr_mbus_rdata_rq),					//读数据请求,上升沿代表开始需要读数据
		.i_mbus_rbusy(ddr_mbus_rbusy),							//读忙信号,高电平代表忙碌
		.i_mbus_rsel(ddr_mbus_rsel),							//片选信号
		
		//外设0
		.o_mbus_rrq0(ddr_mbus_rrq0),							//读请求信号
		.o_mbus_raddr0(ddr_mbus_raddr0),    					//读初始地址信号
		.o_mbus_rready0(ddr_mbus_rready0)						//读数据准备好
	);

	//写视频控制
	reg                                     ctrl_ddr_mbus_wrq0    ;
	reg [CTRL_ADDR_WIDTH - 1:0]             ctrl_ddr_mbus_waddr0  ;
	reg [MEM_DQ_WIDTH * BURST_LENGTH - 1:0] ctrl_ddr_mbus_wdata0  ;
	reg                                     ctrl_ddr_mbus_wready0 ;
	reg                                     ctrl_ddr_mbus_wrq1    ;
	reg [CTRL_ADDR_WIDTH - 1:0]             ctrl_ddr_mbus_waddr1  ;
	reg [MEM_DQ_WIDTH * BURST_LENGTH - 1:0] ctrl_ddr_mbus_wdata1  ;
	reg                                     ctrl_ddr_mbus_wready1 ;
	reg                                     ctrl_ddr_mbus_wrq2    ;
	reg [CTRL_ADDR_WIDTH - 1:0]             ctrl_ddr_mbus_waddr2  ;
	reg [MEM_DQ_WIDTH * BURST_LENGTH - 1:0] ctrl_ddr_mbus_wdata2  ;
	reg                                     ctrl_ddr_mbus_wready2 ;
	reg                                     ctrl_ddr_mbus_wrq3    ;
	reg [CTRL_ADDR_WIDTH - 1:0]             ctrl_ddr_mbus_waddr3  ;
	reg [MEM_DQ_WIDTH * BURST_LENGTH - 1:0] ctrl_ddr_mbus_wdata3  ;
	reg                                     ctrl_ddr_mbus_wready3 ;

	always @(*) begin
		if(ctrl_0 == 1'b1 && ctrl_1 == 1'b0) begin
			ctrl_ddr_mbus_wrq0    = ddr_mbus_wrq0    ;
            ctrl_ddr_mbus_waddr0  = ddr_mbus_waddr0  ;
            ctrl_ddr_mbus_wdata0  = ddr_mbus_wdata0  ;
            ctrl_ddr_mbus_wready0 = ddr_mbus_wready0 ;

			ctrl_ddr_mbus_wrq1    = 1'b0   ;
            ctrl_ddr_mbus_waddr1  = 28'd0  ;
            ctrl_ddr_mbus_wdata1  = 128'd0 ;
            ctrl_ddr_mbus_wready1 = 1'b0   ;

			ctrl_ddr_mbus_wrq2    = 1'b0   ;
            ctrl_ddr_mbus_waddr2  = 28'd0  ;
            ctrl_ddr_mbus_wdata2  = 128'd0 ;
            ctrl_ddr_mbus_wready2 = 1'b0   ;

			ctrl_ddr_mbus_wrq3    = 1'b0   ;
            ctrl_ddr_mbus_waddr3  = 28'd0  ;
            ctrl_ddr_mbus_wdata3  = 128'd0 ;
            ctrl_ddr_mbus_wready3 = 1'b0   ;
		end
		else if(ctrl_0 == 1'b0 && ctrl_1 == 1'b1) begin
			ctrl_ddr_mbus_wrq0    = 1'b0   ;
            ctrl_ddr_mbus_waddr0  = 28'd0  ;
            ctrl_ddr_mbus_wdata0  = 128'd0 ;
            ctrl_ddr_mbus_wready0 = 1'b0   ;

			ctrl_ddr_mbus_wrq1    = 1'b0   ;
            ctrl_ddr_mbus_waddr1  = 28'd0  ;
            ctrl_ddr_mbus_wdata1  = 128'd0 ;
            ctrl_ddr_mbus_wready1 = 1'b0   ;

			ctrl_ddr_mbus_wrq2    = ddr_mbus_wrq2    ;
            ctrl_ddr_mbus_waddr2  = ddr_mbus_waddr2  ;
            ctrl_ddr_mbus_wdata2  = ddr_mbus_wdata2  ;
            ctrl_ddr_mbus_wready2 = ddr_mbus_wready2 ;

			ctrl_ddr_mbus_wrq3    = 1'b0   ;
            ctrl_ddr_mbus_waddr3  = 28'd0  ;
            ctrl_ddr_mbus_wdata3  = 128'd0 ;
            ctrl_ddr_mbus_wready3 = 1'b0   ;
		end
		else begin
			ctrl_ddr_mbus_wrq0    = ddr_mbus_wrq0    ;
            ctrl_ddr_mbus_waddr0  = ddr_mbus_waddr0  ;
            ctrl_ddr_mbus_wdata0  = ddr_mbus_wdata0  ;
            ctrl_ddr_mbus_wready0 = ddr_mbus_wready0 ;

			ctrl_ddr_mbus_wrq1    = ddr_mbus_wrq1    ;
            ctrl_ddr_mbus_waddr1  = ddr_mbus_waddr1  ;
            ctrl_ddr_mbus_wdata1  = ddr_mbus_wdata1  ;
            ctrl_ddr_mbus_wready1 = ddr_mbus_wready1 ;

			ctrl_ddr_mbus_wrq2    = ddr_mbus_wrq2    ;
            ctrl_ddr_mbus_waddr2  = ddr_mbus_waddr2  ;
            ctrl_ddr_mbus_wdata2  = ddr_mbus_wdata2  ;
            ctrl_ddr_mbus_wready2 = ddr_mbus_wready2 ;

			ctrl_ddr_mbus_wrq3    = ddr_mbus_wrq3    ;
            ctrl_ddr_mbus_waddr3  = ddr_mbus_waddr3  ;
            ctrl_ddr_mbus_wdata3  = ddr_mbus_wdata3  ;
            ctrl_ddr_mbus_wready3 = ddr_mbus_wready3 ;
		end
	end

	//DDR3接口实例化
	DDR3_Interface #(.MEM_ROW_ADDR_WIDTH(MEM_ROW_ADDR_WIDTH),.MEM_COL_ADDR_WIDTH(MEM_COL_ADDR_WIDTH),
					.MEM_BADDR_WIDTH(MEM_BADDR_WIDTH),.MEM_DQ_WIDTH(MEM_DQ_WIDTH),
					.MEM_DM_WIDTH(MEM_DM_WIDTH),.MEM_DQS_WIDTH(MEM_DQS_WIDTH),
					.CTRL_ADDR_WIDTH(CTRL_ADDR_WIDTH),
					.BURST_LENGTH(BURST_LENGTH),.BURST_NUM(BURST_NUM),.BURST_WIDTH(BURST_WIDTH),
					.DEVICE_NUM(DEVICE_NUM))DDR3_Interface_Inst(
		.i_clk(i_clk),
		.i_rstn(i_rstn),
		.o_pll_locked(pll_locked),
		.o_clk_100MHz(clk_system),
	
		//-------------------外部写DDR控制总线------------------//
		.o_mbus_wdata_rq(ddr_mbus_wdata_rq),					//写数据请求,上升沿代表开始需要写入数据
		.o_mbus_wbusy(ddr_mbus_wbusy),							//写忙信号,高电平代表忙碌
		.o_mbus_wsel(ddr_mbus_wsel),							//片选信号
		
		//外设0
		.i_mbus_wrq0(ctrl_ddr_mbus_wrq0),							//写请求信号
		.i_mbus_waddr0(ctrl_ddr_mbus_waddr0),    					//写初始地址信号
		.i_mbus_wdata0(ctrl_ddr_mbus_wdata0),						//写数据
		.i_mbus_wready0(ctrl_ddr_mbus_wready0),						//写数据准备好
		
		//外设1
		.i_mbus_wrq1(ctrl_ddr_mbus_wrq1),							//写请求信号
		.i_mbus_waddr1(ctrl_ddr_mbus_waddr1),    					//写初始地址信号
		.i_mbus_wdata1(ctrl_ddr_mbus_wdata1),						//写数据
		.i_mbus_wready1(ctrl_ddr_mbus_wready1),						//写数据准备好
		
		//外设2
		.i_mbus_wrq2(ctrl_ddr_mbus_wrq2),							//写请求信号
		.i_mbus_waddr2(ctrl_ddr_mbus_waddr2),    					//写初始地址信号
		.i_mbus_wdata2(ctrl_ddr_mbus_wdata2),						//写数据
		.i_mbus_wready2(ctrl_ddr_mbus_wready2),						//写数据准备好
		
		//外设3
		.i_mbus_wrq3(ctrl_ddr_mbus_wrq3),							//写请求信号
		.i_mbus_waddr3(ctrl_ddr_mbus_waddr3),    					//写初始地址信号
		.i_mbus_wdata3(ctrl_ddr_mbus_wdata3),						//写数据
		.i_mbus_wready3(ctrl_ddr_mbus_wready3),						//写数据准备好
		
		//-------------------外部读DDR控制总线------------------//
		.o_mbus_rdata(ddr_mbus_rdata),							//读数据
		.o_mbus_rdata_rq(ddr_mbus_rdata_rq),					//读数据请求,上升沿代表开始需要读数据
		.o_mbus_rbusy(ddr_mbus_rbusy),							//读忙信号,高电平代表忙碌
		.o_mbus_rsel(ddr_mbus_rsel),							//片选信号
		
		//外设0
		.i_mbus_rrq0(ddr_mbus_rrq0),							//读请求信号
		.i_mbus_raddr0(ddr_mbus_raddr0),    					//读初始地址信号
		.i_mbus_rready0(ddr_mbus_rready0),						//读数据准备好
		
		//外设1
		.i_mbus_rrq1(1'b0),										//读请求信号
		.i_mbus_raddr1(28'd0),    								//读初始地址信号
		.i_mbus_rready1(1'b0),									//读数据准备好
		
		//外设2
		.i_mbus_rrq2(1'b0),										//读请求信号
		.i_mbus_raddr2(28'd0),    								//读初始地址信号
		.i_mbus_rready2(1'b0),									//读数据准备好
		
		//外设3
		.i_mbus_rrq3(1'b0),										//读请求信号
		.i_mbus_raddr3(28'd0),    								//读初始地址信号
		.i_mbus_rready3(1'b0),									//读数据准备好
		
		//------------------DDR管脚信号---------------------//
		.o_ddr3_rstn(o_ddr3_rstn),
		.o_ddr3_clk_p(o_ddr3_clk_p),
		.o_ddr3_clk_n(o_ddr3_clk_n),
		.o_ddr3_cke(o_ddr3_cke),
		.o_ddr3_cs(o_ddr3_cs),
		.o_ddr3_ras(o_ddr3_ras),
		.o_ddr3_cas(o_ddr3_cas),
		.o_ddr3_we(o_ddr3_we),
		.o_ddr3_odt(o_ddr3_odt),
		.o_ddr3_address(o_ddr3_address),
		.o_ddr3_ba(o_ddr3_ba),
		.o_ddr3_dm(o_ddr3_dm),
		.o_ddr3_dqs_p(o_ddr3_dqs_p),
		.o_ddr3_dqs_n(o_ddr3_dqs_n),
		.o_ddr3_dq(o_ddr3_dq)
	);
	
	//HDMI复位
	always@(posedge clk_config_hdmi or negedge config_locked)begin
		if(config_locked == 1'b0)hdmi_resetn <= 1'b0;
		else if(hdmi_rcnt == 16'h2710)hdmi_resetn <= 1'b1;
		else hdmi_resetn <= hdmi_resetn;
	end
	
	//HDMI复位计数
	always@(posedge clk_config_hdmi or negedge config_locked)begin
		if(config_locked == 1'b0)hdmi_rcnt <= 16'd0;
		else if(hdmi_rcnt == 16'h2710)hdmi_rcnt <= hdmi_rcnt;
		else hdmi_rcnt <= hdmi_rcnt + 1;
	end
	
	//配置HDMI
	Config_HDMI Config_HDMI_Inst(
		.pll_rst(~pll_locked),      // input
		.clkin1(clk_system),        // input
		.pll_lock(config_locked),	// output
		.clkout0(clk_config_hdmi)   // output
	);

	//HDMI配置
	ms72xx_ctl ms72xx_ctl(
        .clk(clk_config_hdmi), 
        .rst_n(hdmi_resetn),
                                
        .init_over_tx(o_led[0]),
		.init_over_rx(o_led[1]),
        .iic_tx_scl(o_hdmi3_scl),
        .iic_tx_sda(io_hdmi3_sda),
        .iic_scl(o_hdmi1_scl),
        .iic_sda(io_hdmi1_sda)
    );

	pll u_pll (
        .clkin1   (  i_clk    ),//50MHz
        .clkout0  (  clk_25M    ),//25M
        .pll_lock (  locked     )
    );

	//配置CMOS///////////////////////////////////////////////////////////////////////////////////
//OV5640 register configure enable    
    power_on_delay	power_on_delay_inst(
    	.clk_50M                 (i_clk        ),//input
    	.reset_n                 (1'b1           ),//input	
    	.camera1_rstn            (cmos1_reset    ),//output
    	.camera2_rstn            (cmos2_reset    ),//output	
    	.camera_pwnd             (               ),//output
    	.initial_en              (initial_en     ) //output		
    );
//CMOS1 Camera 
    reg_config	coms1_reg_config(
    	.clk_25M                 (clk_25M            ),//input
    	.camera_rstn             (cmos1_reset        ),//input
    	.initial_en              (initial_en         ),//input		
    	.i2c_sclk                (cmos1_scl          ),//output
    	.i2c_sdat                (cmos1_sda          ),//inout
    	.reg_conf_done           (cmos_init_done[0]  ),//output config_finished
    	.reg_index               (                   ),//output reg [8:0]
    	.clock_20k               (                   ) //output reg
    );

//CMOS2 Camera 
    reg_config	coms2_reg_config(
    	.clk_25M                 (clk_25M            ),//input
    	.camera_rstn             (cmos2_reset        ),//input
    	.initial_en              (initial_en         ),//input		
    	.i2c_sclk                (cmos2_scl          ),//output
    	.i2c_sdat                (cmos2_sda          ),//inout
    	.reg_conf_done           (cmos_init_done[1]  ),//output config_finished
    	.reg_index               (                   ),//output reg [8:0]
    	.clock_20k               (                   ) //output reg
    );
//CMOS 8bit转16bit///////////////////////////////////////////////////////////////////////////////////
//CMOS1
    always@(posedge cmos1_pclk)
        begin
            cmos1_d_d0        <= cmos1_data    ;
            cmos1_href_d0     <= cmos1_href    ;
            cmos1_vsync_d0    <= cmos1_vsync   ;
        end

    cmos_8_16bit cmos1_8_16bit(
    	.pclk           (cmos1_pclk       ),//input
    	.rst_n          (cmos_init_done[0]),//input
    	.pdata_i        (cmos1_d_d0       ),//input[7:0]
    	.de_i           (cmos1_href_d0    ),//input
    	.vs_i           (cmos1_vsync_d0    ),//input

    	.pixel_clk      (cmos1_pclk_16bit ),//output
    	.pdata_o        (cmos1_d_16bit    ),//output[15:0]
    	.de_o           (cmos1_href_16bit ),//output

		.hs_o           (cmos1_hsync_16bit),
		.vs_o           (cmos1_vsync_16bit)
    );
	assign data_rgb_24bit = {{cmos1_d_16bit[4:0],3'd0},{cmos1_d_16bit[10:5],2'd0},{cmos1_d_16bit[15:11],3'd0}};//{r,g,b};
//CMOS2
    always@(posedge cmos2_pclk)
        begin
            cmos2_d_d0        <= cmos2_data    ;
            cmos2_href_d0     <= cmos2_href    ;
            cmos2_vsync_d0    <= cmos2_vsync   ;
        end

    cmos_8_16bit cmos2_8_16bit(
    	.pclk           (cmos2_pclk       ),//input
    	.rst_n          (cmos_init_done[1]),//input
    	.pdata_i        (cmos2_d_d0       ),//input[7:0]
    	.de_i           (cmos2_href_d0    ),//input
    	.vs_i           (cmos2_vsync_d0    ),//input
    	
    	.pixel_clk      (cmos2_pclk_16bit ),//output
    	.pdata_o        (cmos2_d_16bit    ),//output[15:0]
    	.de_o           (cmos2_href_16bit ) //output
    );
    //输入视频源选择//////////////////////////////////////////////////////////////////////////////////////////
    `ifdef CMOS_1
    assign     pclk_in_test    =    cmos1_pclk_16bit    ;
    assign     vs_in_test      =    cmos1_vsync_d0      ;
    assign     de_in_test      =    cmos1_href_16bit    ;
    assign     i_rgb565        =    {cmos1_d_16bit[4:0],cmos1_d_16bit[10:5],cmos1_d_16bit[15:11]};//{r,g,b}
    `elsif CMOS_2
    assign     pclk_in_test    =    cmos2_pclk_16bit    ;
    assign     vs_in_test      =    cmos2_vsync_d0      ;
    assign     de_in_test      =    cmos2_href_16bit    ;
    assign     i_rgb565        =    {cmos2_d_16bit[4:0],cmos2_d_16bit[10:5],cmos2_d_16bit[15:11]};//{r,g,b}
    `endif
	
    key_ctl key_ctl_dut1 (
      .clk  (i_clk  ),
      .key  (key[0] ),
      .ctrl (ctrl_0 )
    );
	key_ctl key_ctl_dut2 (
      .clk  (i_clk  ),
      .key  (key[1] ),
      .ctrl (ctrl_1 )
    );

	assign ctrl_led[0] = ctrl_0;
	assign ctrl_led[1] = ctrl_1;

endmodule