module bound_flash(
    input wire flick,
    input wire clk,
    input wire rst,
    output wire [15:0] led
);
    
    // Khai báo các tham số trạng thái
    parameter INIT        = 4'b0000,
              ON_0_5     = 4'b0001,
              OFF_5_0    = 4'b0010,
              ON_0_10    = 4'b0011,
              OFF_10_0   = 4'b0100,
              OFF_10_5   = 4'b0101,
              ON_5_15    = 4'b0110,
              OFF_5_5    = 4'b0111,
              OFF_15_0   = 4'b1000;
    
    reg [3:0] current_state, next_state;
    reg [15:0] curled;
    assign led = curled;
    
    // Khối always điều khiển trạng thái khi có tín hiệu clk hoặc rst
    always @(posedge clk or negedge rst) begin
        if (~rst) 
            current_state <= INIT;
        else 
            current_state <= next_state;
    end
    
    // Xác định trạng thái tiếp theo dựa trên trạng thái hiện tại
    always @(*) begin
        case (current_state)
            INIT: next_state = flick ? ON_0_5 : INIT;
            ON_0_5: next_state = curled[5] ? OFF_5_0 : ON_0_5;
            OFF_5_0: next_state = ~curled[0] ? ON_0_10 : OFF_5_0;
            ON_0_10: begin
                if (flick) 
                    next_state = curled[10] ? OFF_10_0 : (curled[5] && ~curled[6]) ? OFF_5_0 : ON_0_10;
                else 
                    next_state = curled[10] ? OFF_10_5 : ON_0_10;
            end
            OFF_10_0: next_state = ~curled[0] ? ON_0_10 : OFF_10_0;
            OFF_10_5: next_state = ~curled[5] ? ON_5_15 : OFF_10_5;
            ON_5_15: begin
                if (flick) 
                    next_state = curled[10] ? OFF_10_5 : (curled[5] && ~curled[6]) ? OFF_5_5 : ON_5_15;
                else 
                    next_state = curled[15] ? OFF_15_0 : ON_5_15;
            end
            OFF_5_5: next_state = ~curled[5] ? ON_5_15 : OFF_5_5;
            OFF_15_0: next_state = ~curled[0] ? INIT : OFF_15_0;
            default: next_state = INIT;
        endcase
    end
    
    // Cập nhật giá trị của curled theo trạng thái hiện tại trên cạnh xuống của clk
    always @(negedge clk) begin
        case (current_state)
            INIT:       curled <= 0;
            ON_0_5:     curled <= (curled << 1) | 1;
            OFF_5_0:    curled <= curled >> 1;
            ON_0_10:    curled <= (curled << 1) | 1;
            OFF_10_0:   curled <= curled >> 1;
            OFF_10_5:   curled <= curled >> 1;
            ON_5_15:    curled <= (curled << 1) | 1;
            OFF_5_5:    curled <= curled >> 1;
            OFF_15_0:   curled <= curled >> 1;
            default:    curled <= 0;
        endcase
    end
    
endmodule
