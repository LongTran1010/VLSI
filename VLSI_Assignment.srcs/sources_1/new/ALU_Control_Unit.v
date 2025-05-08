`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/18/2025 06:08:52 PM
// Design Name: 
// Module Name: ALU_Control_Unit
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
module ALU_Control_Unit #(
  parameter OPCODE_WIDTH = 4,
            CTRL_WIDTH   = 4
)(
  input  wire [OPCODE_WIDTH-1:0] opcode,
  output reg  [CTRL_WIDTH-1:0]   ctrl
);

  // Control code definitions (matching fixed-point ALU ops)
  localparam CTRL_HLT  = 4'd0,
             CTRL_SKZ  = 4'd1,
             CTRL_ADD  = 4'd2,
             CTRL_AND  = 4'd3,
             CTRL_XOR  = 4'd4,
             CTRL_LDA  = 4'd5,
             CTRL_STO  = 4'd6,
             CTRL_JMP  = 4'd7,
             CTRL_FMUL = 4'd8,
             CTRL_FDIV = 4'd9;

  always @(*) begin
    case (opcode)
      4'b0000: ctrl = CTRL_HLT;
      4'b0001: ctrl = CTRL_SKZ;
      4'b0010: ctrl = CTRL_ADD;
      4'b0011: ctrl = CTRL_AND;
      4'b0100: ctrl = CTRL_XOR;
      4'b0101: ctrl = CTRL_LDA;
      4'b0110: ctrl = CTRL_STO;
      4'b0111: ctrl = CTRL_JMP;
      4'b1000: ctrl = CTRL_FMUL;
      4'b1001: ctrl = CTRL_FDIV;
      default: ctrl = CTRL_HLT;
    endcase
  end

endmodule
