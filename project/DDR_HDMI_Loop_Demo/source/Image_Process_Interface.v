`timescale 1ns/1ps

//视频图像处理接口
module Image_Process_Interface
#(  
	parameter MEM_DQ_WIDTH         = 16,
	parameter CTRL_ADDR_WIDTH      = 28,
	parameter BURST_LENGTH		   = 8,
	parameter DEVICE_NUM		   = 4
)
(
	input i_axi_aclk,  //100M
	input i_rstn,
	
	//-----------------VIDEO_IN1信号-----------------//
	input [23:0]i_video1_data,
	input i_video1_vde,
	input i_video1_hsync,
	input i_video1_vsync,
	input i_video1_clk,

	//-----------------VIDEO_IN2信号-----------------//
	input [23:0]i_video2_data,
	input i_video2_vde,
	input i_video2_hsync,
	input i_video2_vsync,
	input i_video2_clk,

	//--------------------按键控制--------------------//
	input ctrl_0,
	input ctrl_1,

	//-----------------VIDEO_OUT1信号-----------------//
	output [23:0]o_video1_data,
	output o_video1_vde,
	output o_video1_hsync,
	output o_video1_vsync,
	output o_video1_clk,
	
	//-------------------外部写DDR控制总线------------------//
	input i_mbus_wdata_rq,									//写数据请求,上升沿代表开始需要写入数据
	input i_mbus_wbusy,										//写忙信号,高电平代表忙碌
	input [DEVICE_NUM - 1:0]i_mbus_wsel,					//片选信号
	
	//外设0
	output o_mbus_wrq0,										//写请求信号
	output [CTRL_ADDR_WIDTH - 1:0]o_mbus_waddr0,    		//写初始地址信号
	output [MEM_DQ_WIDTH * BURST_LENGTH - 1:0]o_mbus_wdata0,//写数据
	output o_mbus_wready0,									//写数据准备好
	
	//外设1
	output o_mbus_wrq1,										//写请求信号
	output [CTRL_ADDR_WIDTH - 1:0]o_mbus_waddr1,    		//写初始地址信号
	output [MEM_DQ_WIDTH * BURST_LENGTH - 1:0]o_mbus_wdata1,//写数据
	output o_mbus_wready1,									//写数据准备好
	
	//外设2
	output o_mbus_wrq2,										//写请求信号
	output [CTRL_ADDR_WIDTH - 1:0]o_mbus_waddr2,    		//写初始地址信号
	output [MEM_DQ_WIDTH * BURST_LENGTH - 1:0]o_mbus_wdata2,//写数据
	output o_mbus_wready2,									//写数据准备好
	
	//外设3
	output o_mbus_wrq3,										//写请求信号
	output [CTRL_ADDR_WIDTH - 1:0]o_mbus_waddr3,    		//写初始地址信号
	output [MEM_DQ_WIDTH * BURST_LENGTH - 1:0]o_mbus_wdata3,//写数据
	output o_mbus_wready3,									//写数据准备好
	
	//-------------------外部读DDR控制总线------------------//
	input [MEM_DQ_WIDTH * BURST_LENGTH - 1:0]i_mbus_rdata,	//读数据
	input i_mbus_rdata_rq,									//读数据请求,上升沿代表开始需要读数据
	input i_mbus_rbusy,										//读忙信号,高电平代表忙碌
	input [DEVICE_NUM - 1:0]i_mbus_rsel,					//片选信号
	
	//外设0
	output o_mbus_rrq0,										//读请求信号
	output [CTRL_ADDR_WIDTH - 1:0]o_mbus_raddr0,    		//读初始地址信号
	output o_mbus_rready0									//读数据准备好
);
	//-------------解析输出1---------------//
	wire [3:0]video1_mode;										//视频格式
	wire [11:0]video1_format_x;									//像素长度X
	wire [11:0]video1_format_y;									//像素长度Y
	wire [11:0]video1_x;										//解析坐标X
	wire [11:0]video1_y;										//解析坐标Y
	wire video1_hsync_valid;									//行信号有效电平
	wire video1_vsync_valid;									//场信号有效电平
	wire video1_end;											//帧结束,上升沿有效
	wire video1_change;											//帧图像分辨率改变,高电平有效

	wire video2_vsync_valid;									//场信号有效电平
	
	//-------------视频信号1---------------//
	wire [23:0]video1_data0;
	wire video1_vde0;
	wire video1_hsync0;
	wire video1_vsync0;

	//-------------视频信号2---------------//
	wire [23:0]video2_data0;
	wire video2_vde0;
	wire video2_hsync0;
	wire video2_vsync0;
	
	//输出信号
	wire [23:0]video1_data_o;
	wire video1_vde_o;
	wire video1_hsync_o;
	wire video1_vsync_o;
	wire video1_clk_o;

	//输出信号
	wire [23:0]video2_data_o;
	wire video2_vde_o;
	wire video2_hsync_o;
	wire video2_vsync_o;
	wire video2_clk_o;
	
	//写数据有效信号
	reg [DEVICE_NUM - 1:0]video_valid = 0;
	reg video1_vde1 = 0;
	reg video1_vsync1 = 0;

	//写数据有效信号
	reg [DEVICE_NUM - 1:0]video_valid2 = 0;
	reg video2_vde1 = 0;
	reg video2_vsync1 = 0;
	
	//输出连线
	assign o_video1_data = video1_data_o;
	assign o_video1_vde = video1_vde_o;
	assign o_video1_hsync = video1_hsync_o;
	assign o_video1_vsync = video1_vsync_o;
	assign o_video1_clk = video1_clk_o;
	
	assign o_led = {4'd0,video1_mode};
	
	//行缓冲标志
	always@(posedge i_video1_clk)begin
		video1_vde1 <= video1_vde0;
		video1_vsync1 <= video1_vsync0;
	end

	//行缓冲标志
	always@(posedge i_video2_clk)begin
		video2_vde1 <= video2_vde0;
		video2_vsync1 <= video2_vsync0;
	end
	
	//写数据有效信号
	always@(posedge i_video1_clk or negedge i_rstn)begin
		if(i_rstn == 1'b0)video_valid <= 4'b1010;
		else if({video1_vsync1,video1_vsync0} == {~video1_vsync_valid,video1_vsync_valid})video_valid <= 4'b1010;
		else if(video1_vde0 == 1'b1)video_valid <= ~video_valid;
		else video_valid <= video_valid;
	end

	//写数据有效信号
	always@(posedge i_video2_clk or negedge i_rstn)begin
		if(i_rstn == 1'b0)video_valid2 <= 4'b1010;
		else if({video2_vsync1,video2_vsync0} == {~video2_vsync_valid,video2_vsync_valid})video_valid2 <= 4'b1010;
		else if(video2_vde0 == 1'b1)video_valid2 <= ~video_valid2;
		else video_valid2 <= video_valid2;
	end
	
	//视频图像预处理接口实例化
	Image_Preprocess_Interface Image_Preprocess_Interface_1(
		.i_pclk(i_video1_clk),
		.i_rstn(i_rstn),
		
		//-------------视频输入通道---------------//
		.i_video_data(i_video1_data),
		.i_video_vde(i_video1_vde),
		.i_video_hsync(i_video1_hsync),
		.i_video_vsync(i_video1_vsync),
		
		//-------------视频输出通道---------------//
		.o_video_data(video1_data0),
		.o_video_vde(video1_vde0),
		.o_video_hsync(video1_hsync0),
		.o_video_vsync(video1_vsync0),
		
		//-------------解析输出通道---------------//
		.o_video_mode(video1_mode),					//视频格式
		.o_video_format_x(video1_format_x),			//像素长度X
		.o_video_format_y(video1_format_y),			//像素长度Y
		.o_video_x(video1_x),						//解析坐标X
		.o_video_y(video1_y),						//解析坐标Y
		.o_video_hsync_valid(video1_hsync_valid),	//行信号有效电平
		.o_video_vsync_valid(video1_vsync_valid),	//场信号有效电平
		.o_video_end(video1_end),					//帧结束,上升沿有效
		.o_video_change(video1_change)				//帧图像分辨率改变,高电平有效
	);

	Image_Preprocess_Interface Image_Preprocess_Interface_2(
		.i_pclk(i_video2_clk),
		.i_rstn(i_rstn),
		
		//-------------视频输入通道---------------//
		.i_video_data(i_video2_data),
		.i_video_vde(i_video2_vde),
		.i_video_hsync(i_video2_hsync),
		.i_video_vsync(i_video2_vsync),
		
		//-------------视频输出通道---------------//
		.o_video_data(video2_data0),
		.o_video_vde(video2_vde0),
		.o_video_hsync(video2_hsync0),
		.o_video_vsync(video2_vsync0),

		//-------------解析输出通道---------------//
		.o_video_mode(),					//视频格式
		.o_video_format_x(),			//像素长度X
		.o_video_format_y(),			//像素长度Y
		.o_video_x(),						//解析坐标X
		.o_video_y(),						//解析坐标Y
		.o_video_hsync_valid(),	//行信号有效电平
		.o_video_vsync_valid(video2_vsync_valid),	//场信号有效电平
		.o_video_end(),					//帧结束,上升沿有效
		.o_video_change()				//帧图像分辨率改变,高电平有效
	);

	reg ctrl_video1_vde;
	reg ctrl_video2_vde;
	always @(*) begin
		if(ctrl_0 == 1'b1 && ctrl_1 == 1'b0) begin
			ctrl_video1_vde = video1_vde0;
			ctrl_video2_vde = (video2_vde0 & video_valid2[0]);
		end
		else if(ctrl_0 == 1'b0 && ctrl_1 == 1'b1) begin
			ctrl_video1_vde = (video1_vde0 & video_valid[0]);
			ctrl_video2_vde = video2_vde0;
		end
		else begin
			ctrl_video1_vde = (video1_vde0 & video_valid[0]);
			ctrl_video2_vde = (video2_vde0 & video_valid2[0]);
		end
	end

	//地址跳转
	localparam START_ADDRESS_0 = 28'h0000000;
	localparam START_ADDRESS_1 = 28'h0000400;
	localparam START_ADDRESS_2 = 28'h00FD200;
	localparam START_ADDRESS_3 = 28'h00FD600;

	//帧写接口实例化
	Frame_WR_Interface1 #(  	
		.MEM_DQ_WIDTH(MEM_DQ_WIDTH),
		.CTRL_ADDR_WIDTH(CTRL_ADDR_WIDTH),
		.BURST_LENGTH(BURST_LENGTH),
		.START_ADDRESS(START_ADDRESS_0),
		.ROW_NUM(1920),
		.IMAGE_RESIZE_ROW(1),
		.IMAGE_RESIZE_COL(1)
	)Frame_WR_Interface_Inst0(
		.i_axi_aclk(i_axi_aclk),
		.i_rstn(i_rstn),
		
		//-----------------------视频通道-----------------------//
		//视频解析信号
		.i_video_vsync_valid(video1_vsync_valid),				//场信号有效电平

		//视频控制信号
		.ctrl_0(ctrl_0),
		.ctrl_1(ctrl_1),
		
		//视频帧信号
		.i_video_data(video1_data0),
		.i_video_vde(ctrl_video1_vde),
		.i_video_vsync(video1_vsync0),
		.i_video_clk(i_video1_clk),
		
		//-------------------外部写DDR控制总线------------------//
		.i_mbus_wdata_rq(i_mbus_wdata_rq),						//写数据请求,上升沿代表开始需要写入数据
		.i_mbus_wbusy(i_mbus_wbusy),							//写忙信号,高电平代表忙碌
		.i_mbus_wsel(i_mbus_wsel[0]),							//片选信号
		
		.o_mbus_wrq(o_mbus_wrq0),								//写请求信号
		.o_mbus_waddr(o_mbus_waddr0),    						//写初始地址信号
		.o_mbus_wdata(o_mbus_wdata0),							//写数据
		.o_mbus_wready(o_mbus_wready0)							//写数据准备好
	);
	
	//帧写接口实例化
	Frame_WR_Interface1 #(  	
		.MEM_DQ_WIDTH(MEM_DQ_WIDTH),
		.CTRL_ADDR_WIDTH(CTRL_ADDR_WIDTH),
		.BURST_LENGTH(BURST_LENGTH),
		.START_ADDRESS(START_ADDRESS_1),
		.ROW_NUM(1920),
		.IMAGE_RESIZE_ROW(1),
		.IMAGE_RESIZE_COL(1)
	)Frame_WR_Interface_Inst1(
		.i_axi_aclk(i_axi_aclk),
		.i_rstn(i_rstn),
		
		//-----------------------视频通道-----------------------//
		//视频解析信号
		.i_video_vsync_valid(video1_vsync_valid),				//场信号有效电平

		//视频控制信号
		.ctrl_0(ctrl_0),
		.ctrl_1(ctrl_1),
		
		//视频帧信号
		.i_video_data(video1_data0),
		.i_video_vde(ctrl_video1_vde),
		.i_video_vsync(video1_vsync0),
		.i_video_clk(i_video1_clk),
		
		//-------------------外部写DDR控制总线------------------//
		.i_mbus_wdata_rq(i_mbus_wdata_rq),						//写数据请求,上升沿代表开始需要写入数据
		.i_mbus_wbusy(i_mbus_wbusy),							//写忙信号,高电平代表忙碌
		.i_mbus_wsel(i_mbus_wsel[1]),							//片选信号
		
		.o_mbus_wrq(o_mbus_wrq1),								//写请求信号
		.o_mbus_waddr(o_mbus_waddr1),    						//写初始地址信号
		.o_mbus_wdata(o_mbus_wdata1),							//写数据
		.o_mbus_wready(o_mbus_wready1)							//写数据准备好
	);

	//帧写接口实例化
	Frame_WR_Interface2 #(  	
		.MEM_DQ_WIDTH(MEM_DQ_WIDTH),
		.CTRL_ADDR_WIDTH(CTRL_ADDR_WIDTH),
		.BURST_LENGTH(BURST_LENGTH),
		.START_ADDRESS(START_ADDRESS_2),
		.ROW_NUM(1920),
		.IMAGE_RESIZE_ROW(1),
		.IMAGE_RESIZE_COL(1)
	)Frame_WR_Interface_Inst2(
		.i_axi_aclk(i_axi_aclk),
		.i_rstn(i_rstn),
		
		//-----------------------视频通道-----------------------//
		//视频解析信号
		.i_video_vsync_valid(video2_vsync_valid),				//场信号有效电平

		//视频控制信号
		.ctrl_0(ctrl_0),
		.ctrl_1(ctrl_1),

		//视频帧信号
		.i_video_data(video2_data0),
		.i_video_vde(ctrl_video2_vde),
		.i_video_vsync(video2_vsync0),
		.i_video_clk(i_video2_clk),
		
		//-------------------外部写DDR控制总线------------------//
		.i_mbus_wdata_rq(i_mbus_wdata_rq),						//写数据请求,上升沿代表开始需要写入数据
		.i_mbus_wbusy(i_mbus_wbusy),							//写忙信号,高电平代表忙碌
		.i_mbus_wsel(i_mbus_wsel[2]),							//片选信号
		
		.o_mbus_wrq(o_mbus_wrq2),								//写请求信号
		.o_mbus_waddr(o_mbus_waddr2),    						//写初始地址信号
		.o_mbus_wdata(o_mbus_wdata2),							//写数据
		.o_mbus_wready(o_mbus_wready2)							//写数据准备好
	);
	
	//帧写接口实例化
	Frame_WR_Interface2 #(
		.MEM_DQ_WIDTH(MEM_DQ_WIDTH),
		.CTRL_ADDR_WIDTH(CTRL_ADDR_WIDTH),
		.BURST_LENGTH(BURST_LENGTH),
		.START_ADDRESS(START_ADDRESS_3),
		.ROW_NUM(1920),
		.IMAGE_RESIZE_ROW(1),
		.IMAGE_RESIZE_COL(1)
	)Frame_WR_Interface_Inst3(
		.i_axi_aclk(i_axi_aclk),
		.i_rstn(i_rstn),
		
		//-----------------------视频通道-----------------------//
		//视频解析信号
		.i_video_vsync_valid(video2_vsync_valid),				//场信号有效电平

		//视频控制信号
		.ctrl_0(ctrl_0),
		.ctrl_1(ctrl_1),

		//视频帧信号
		.i_video_data(video2_data0),
		.i_video_vde(ctrl_video2_vde),
		.i_video_vsync(video2_vsync0),
		.i_video_clk(i_video2_clk),
		
		//-------------------外部写DDR控制总线------------------//
		.i_mbus_wdata_rq(i_mbus_wdata_rq),						//写数据请求,上升沿代表开始需要写入数据
		.i_mbus_wbusy(i_mbus_wbusy),							//写忙信号,高电平代表忙碌
		.i_mbus_wsel(i_mbus_wsel[3]),							//片选信号
		
		.o_mbus_wrq(o_mbus_wrq3),								//写请求信号
		.o_mbus_waddr(o_mbus_waddr3),    						//写初始地址信号
		.o_mbus_wdata(o_mbus_wdata3),							//写数据
		.o_mbus_wready(o_mbus_wready3)							//写数据准备好
	);
	
	//帧读接口实例化
	Frame_RD_Interface #(  	.MEM_DQ_WIDTH(MEM_DQ_WIDTH),.CTRL_ADDR_WIDTH(CTRL_ADDR_WIDTH),.BURST_LENGTH(BURST_LENGTH),
							.START_ADDRESS(28'h0000000))Frame_RD_Interface_Inst(
		.i_axi_aclk(i_axi_aclk),
		.i_rstn(i_rstn),

		//视频控制信号
		.ctrl_0(ctrl_0),
		.ctrl_1(ctrl_1),
		
		//--------------视频输入通道(参考视频信号)--------------//
		.i_video_clk(i_video1_clk),
		.i_video_vde(video1_vde0),
		.i_video_hsync(video1_hsync0),
		.i_video_vsync(video1_vsync0),
		.i_video_vsync_valid(video1_vsync_valid),
		
		//---------------------视频输出通道---------------------//
		.o_video_data(video1_data_o),
		.o_video_vde(video1_vde_o),
		.o_video_hsync(video1_hsync_o),
		.o_video_vsync(video1_vsync_o),
		.o_video_clk(video1_clk_o),
		
		//-------------------外部读DDR控制总线------------------//
		.i_mbus_rdata(i_mbus_rdata),							//读数据
		.i_mbus_rdata_rq(i_mbus_rdata_rq),						//读数据请求,上升沿代表开始需要读数据
		.i_mbus_rbusy(i_mbus_rbusy),							//读忙信号,高电平代表忙碌
		.i_mbus_rsel(i_mbus_rsel[0]),							//片选信号
		
		.o_mbus_rrq(o_mbus_rrq0),								//读请求信号
		.o_mbus_raddr(o_mbus_raddr0),    						//读初始地址信号
		.o_mbus_rready(o_mbus_rready0)							//读数据准备好
	);

endmodule