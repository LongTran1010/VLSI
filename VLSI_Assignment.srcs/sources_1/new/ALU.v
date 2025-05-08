`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/18/2025 05:28:00 PM
// Design Name: 
// Module Name: ALU
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
/// 
//////////////////////////////////////////////////////////////////////////////////
// ALU_FP.v: wrapper k?t h?p Control + Datapath
module ALU #(
  parameter DATA_WIDTH  = 8,
            OPCODE_WIDTH = 4,  //Vì thêm fixed-point nên s? dùng 4-bit opcode
            FRACT_WIDTH  = 4
)(
  input  wire [DATA_WIDTH-1:0]  inA,
  input  wire [DATA_WIDTH-1:0]  inB,
  input  wire [OPCODE_WIDTH-1:0] opcode,
  output wire [DATA_WIDTH-1:0]  result,
  output wire                   is_zero
);

  // Tín hi?u n?i b?
  wire [OPCODE_WIDTH-1:0] ctrl;

  // 1) Instantiate ALU Control
  ALU_Control_Unit #(
    .OPCODE_WIDTH(OPCODE_WIDTH),
    .CTRL_WIDTH  (OPCODE_WIDTH)
  ) u_ctrl (
    .opcode(opcode),
    .ctrl  (ctrl)
  );

  // 2) Instantiate ALU Datapath
  ALU_DP_Unit #(
    .DATA_WIDTH (DATA_WIDTH),
    .FRACT_WIDTH(FRACT_WIDTH),
    .CTRL_WIDTH (OPCODE_WIDTH)
  ) u_dp (
    .inA   (inA),
    .inB   (inB),
    .ctrl  (ctrl),
    .result(result),
    .is_zero(is_zero)
  );
endmodule

