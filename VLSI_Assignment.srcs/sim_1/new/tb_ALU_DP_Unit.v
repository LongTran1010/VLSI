`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/19/2025 10:29:36 AM
// Design Name: 
// Module Name: tb_ALU_DP_Unit
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module tb_ALU_DP_Unit;
  reg  [7:0] inA, inB;
  reg  [3:0] ctrl;
  wire [7:0] result;
  wire       is_zero;

  ALU_DP_Unit #(.DATA_WIDTH(8), .FRACT_WIDTH(4), .CTRL_WIDTH(4))
    u_dp(.inA(inA), .inB(inB), .ctrl(ctrl), .result(result), .is_zero(is_zero));

  initial begin
    $display("ctrl inA inB -> result is_zero");
    // ADD: 5+3=8
    ctrl=4'd2; inA=8'd5; inB=8'd3; #1;
    $display("%d  %d+%d -> %d %b", ctrl, inA, inB, result, is_zero);

    // FMUL: 1.5*2.25=3.375?24*36>>4=54
    ctrl=4'd8; inA=8'd24; inB=8'd36; #1;
    $display("%d  %d*%d>>4 -> %d %b", ctrl, inA, inB, result, is_zero);

    // SKZ/H… pass-through
    ctrl=4'd1; inA=8'd7; inB=8'd99; #1;
    $display("%d  pass %d -> %d %b", ctrl, inA, inB, result, is_zero);

    $finish;
  end
endmodule

