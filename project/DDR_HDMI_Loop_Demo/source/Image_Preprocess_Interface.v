`timescale 1ns/1ps

//图像预处理接口
module Image_Preprocess_Interface(
	input i_pclk,
	input i_rstn,
	
	//-------------视频输入通道---------------//
	input [23:0]i_video_data,
	input i_video_vde,
	input i_video_hsync,
	input i_video_vsync,
	
	//-------------视频输出通道---------------//
	output [23:0]o_video_data,
	output o_video_vde,
	output o_video_hsync,
	output o_video_vsync,
	
	//-------------解析输出通道---------------//
	output [3:0]o_video_mode,						//视频格式
	output [11:0]o_video_format_x,					//像素长度X
	output [11:0]o_video_format_y,					//像素长度Y
	output [11:0]o_video_x,							//解析坐标X
	output [11:0]o_video_y,							//解析坐标Y
	output o_video_hsync_valid,						//行信号有效电平
	output o_video_vsync_valid,						//场信号有效电平
	output o_video_end,								//帧结束,上升沿有效
	output o_video_change							//帧图像分辨率改变,高电平有效
);
	
	//视频分析接口
	Video_Analyze_Interface Video_Analyze_Interface_Inst(
		.i_pclk(i_pclk),
		.i_rstn(i_rstn),
		
		//-------------视频输入通道---------------//
		.i_video_data(i_video_data),
		.i_video_vde(i_video_vde),
		.i_video_hsync(i_video_hsync),
		.i_video_vsync(i_video_vsync),
		
		//-------------视频输出通道---------------//
		.o_video_data(o_video_data),
		.o_video_vde(o_video_vde),
		.o_video_hsync(o_video_hsync),
		.o_video_vsync(o_video_vsync),
		
		//-------------解析输出通道---------------//
		.o_video_mode(o_video_mode),				//视频格式
		.o_video_format_x(o_video_format_x),		//像素长度X
		.o_video_format_y(o_video_format_y),		//像素长度Y
		.o_video_x(o_video_x),						//解析坐标X
		.o_video_y(o_video_y),						//解析坐标Y
		.o_video_hsync_valid(o_video_hsync_valid),	//行信号有效电平
		.o_video_vsync_valid(o_video_vsync_valid),	//场信号有效电平
		.o_video_end(o_video_end),					//帧结束,上升沿有效
		.o_video_change(o_video_change)				//帧图像分辨率改变,高电平有效
	);
endmodule

