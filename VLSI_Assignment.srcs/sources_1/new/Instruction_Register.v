`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/19/2025 01:38:41 PM
// Design Name: 
// Module Name: Instruction_Register
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
module Instruction_Register #(
  parameter OPCODE_WIDTH  = 4,
            OPERAND_WIDTH = 5
)(
  input  wire                           clk,        // Clock signal
  input  wire                           rst,        // Synchronous reset, active-high
  input  wire                           ld_ir,      // Load enable: when high, latch instr_in
  input  wire [OPCODE_WIDTH+OPERAND_WIDTH-1:0] instr_in, // Combined instruction input
  output reg  [OPCODE_WIDTH-1:0]        opcode,     // Extracted opcode field
  output reg  [OPERAND_WIDTH-1:0]       operand     // Extracted operand field
);

  // On each clock rising edge:
  // 1) If reset, clear both opcode and operand
  // 2) Else if ld_ir is asserted, latch the entire instr_in
  // 3) Otherwise hold previous values
  always @(posedge clk) begin
    if (rst) begin
      opcode <= {OPCODE_WIDTH{1'b0}};
      operand <= {OPERAND_WIDTH{1'b0}};
    end else if (ld_ir) begin
      opcode  <= instr_in[OPCODE_WIDTH+OPERAND_WIDTH-1:OPERAND_WIDTH];
      operand <= instr_in[OPERAND_WIDTH-1:0];
    end
  end

endmodule
