// data preprocess
// 
module conv_buffer #(
    parameter weight_width = 2,         
    parameter weight_height = 2,       

    parameter img_width = 4,           
    parameter img_height = 4,          
    
    parameter padding_enable = 0,     
    parameter padding = 0,             

    parameter stride = 1,               
    parameter bitwidth = 3,            
    parameter result_width = (img_width-weight_width+2*padding)/stride+1,      
    parameter result_height = (img_height-weight_height+2*padding)/stride+1,     
    parameter expand = 1        
) (
    input clk_en,
    input rst_n,
    input conv_en,
    
    input [bitwidth-1:0] img_cal,
    input [bitwidth-1:0] weight_cal,
    input [bitwidth-1:0] bias_cal,
    output reg [bitwidth-1:0] result,
    output reg result_valid
);

localparam IDLE = 2'b01;        
localparam BUSY = 2'b10;
localparam OVER = 2'b11;
reg [1:0] cur_state;
reg [1:0] next_state;
reg [5:0] count;

always @(posedge clk_en) begin
    if(!rst_n)begin
        cur_state<=IDLE;
    end
    else begin
        cur_state<=next_state;
    end
end

always@(*)begin
    case(cur_state)
        IDLE:begin
            if(conv_en)begin
                next_state=BUSY; 
            end 
            else begin
                next_state=IDLE;
            end
        end
        BUSY:begin
            if (count < weight_height * weight_height) begin
                next_state=OVER;
            end
            else begin
                next_state=BUSY;
            end
        end
        OVER:next_state=IDLE;
        default:begin
            if(conv_en)begin
                next_state=BUSY;
            end
            else begin
                next_state=IDLE;
            end
        end
    endcase
end

always @(posedge clk_en, negedge rst_n) begin
    case(cur_state)
        IDLE:begin
            result<=0;
            result_valid<=0;
        end
        BUSY:begin
            result<=result + img_cal*weight_cal;//乘法需要特写
            result_valid<=0;
        end
        OVER:begin
            result<=result;
            result_valid<=1;
        end
        default:begin
            result<=0;
            result_valid<=0;
        end
    endcase
    end
always @(posedge clk_en, negedge rst_n) begin
    case(cur_state)
        IDLE:begin
            count<=6'b1;
        end
        BUSY:begin
            count<=count+1;
        end
        OVER:begin
            count<=count;
        end
        default:begin
            count<=0;
        end
    endcase
    end
endmodule