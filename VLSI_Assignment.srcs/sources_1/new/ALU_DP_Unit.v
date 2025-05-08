`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/18/2025 06:11:08 PM
// Design Name: 
// Module Name: ALU_DP_Unit
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
module ALU_DP_Unit #(
  parameter DATA_WIDTH  = 8,
            FRACT_WIDTH = 4,
            CTRL_WIDTH  = 4
)(
  input  wire [DATA_WIDTH-1:0]   inA,
  input  wire [DATA_WIDTH-1:0]   inB,
  input  wire [CTRL_WIDTH-1:0]   ctrl,
  output reg  [DATA_WIDTH-1:0]   result,
  output wire                    is_zero
);

  // Re-declare control codes for DP mapping
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

  // Intermediate fixed-point units
  wire [DATA_WIDTH-1:0]      add_res = inA + inB;
  wire [2*DATA_WIDTH-1:0]    mul_raw = inA * inB;
  wire [DATA_WIDTH-1:0]      mul_res = mul_raw >> FRACT_WIDTH;
  wire [DATA_WIDTH+FRACT_WIDTH-1:0] div_num = {inA, {FRACT_WIDTH{1'b0}}};
  wire [DATA_WIDTH-1:0]      div_res = div_num / inB;

  always @(*) begin
    case (ctrl)
      CTRL_ADD:  result = add_res;                 // ADD
      CTRL_AND:  result = inA & inB;               // AND
      CTRL_XOR:  result = inA ^ inB;               // XOR
      CTRL_LDA:  result = inB;                     // LDA
      CTRL_FMUL: result = mul_res;                 // FMUL Q4.4
      CTRL_FDIV: result = div_res;                 // FDIV Q4.4
      CTRL_STO:  result = inA;
      CTRL_JMP:  result = inA;
      CTRL_SKZ:  result = inA;
      CTRL_HLT:  result = inA;
      default:   result = inA;                     // HLT/SKZ/STO/JMP pass-through
    endcase
  end

  assign is_zero = (result == {DATA_WIDTH{1'b0}});

endmodule
