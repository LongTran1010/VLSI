module bound_flasher(clock, reset, flick, led);

input clock, reset, flick;

output [15:0] led;

//input ports data type
wire clock, reset, flick;

//output ports data type
reg [15:0] led;

//internal parameters
parameter INIT= 3'd0, 
        S1=3'd1,
        S2=3'd2,
        S3=3'd3, 
        S4=3'd4, 
        S5=3'd5, 
        S6=3'd6;

//internal variable
reg [2:0] state;
reg [3:0] counter;  //range 0->15 for 16 led
//code start here
always@(posedge clock or negedge reset)
begin
    if (reset == 1'b0) begin
        state <= INIT;
        led <= 16'b0000000000000000;
        counter <= 4'b0000;
    end
    else begin
        case(state)
            INIT: if(flick == 1'b1) begin
                    state <= S1;
                    end
            S1: begin
                if(counter == 4'd5) begin
                    state <= S2;
                    led[counter] <= 1'b1;
                    end
                else begin
                    led[counter] <= 1'b1;
                    counter <= counter + 1;
                end
                end
            S2 : begin
                if(counter == 4'd0) begin
                    state <= S3;
                    led[counter] <= 1'b0;
                    end
                else begin
                    led[counter] <= 1'b0;
                    counter <= counter - 1;
                end
                end
            S3: begin
                if(counter == 4'd5 && flick == 1'b1) begin
                    led[counter] <= 1'b1;
                    state <= S2;
                    end
                else if(counter == 4'd10 && flick == 1'b1) begin
                    led[counter] <= 1'b1;
                    state <= S2;
                    end
                else if(counter == 4'd10) begin
                    led[counter] <= 1'b1;
                    state <= S4;
                    end
                else begin
                    led[counter] <= 1'b1;
                    counter = counter + 1;
                end
                end
            S4 : begin
                if(counter == 4'd5) begin
                    led[counter] <= 1'b0;
                    state <= S5;
                    end
                else begin
                    led[counter] <= 1'b0;
                    counter <= counter - 1;
                end
                end
            S5: begin
                if(counter == 4'd10 && flick == 1'b1) begin
                    led[counter] <= 1'b1;
                    state <= S4;
                    end
                else if(counter == 4'd15) begin
                    led[counter] <= 1'b1;
                    state <= S6;
                    end
                else begin
                    led[counter] <= 1'b1;
                    counter = counter + 1;
                end
                end
            S6: begin
                if(counter == 4'd0) begin
                    led[counter] <= 1'b0;
                    state <= INIT;
                    end
                else begin
                    led[counter] <= 1'b0;
                    counter <= counter - 1;
                end
                end
            default: state <= INIT;
        endcase
    end
end

endmodule