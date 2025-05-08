`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/19/2025 10:30:47 AM
// Design Name: 
// Module Name: tb_ALU_FP
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
module tb_ALU;
  reg  [7:0] inA, inB;
  reg  [3:0] opcode;
  wire [7:0] result;
  wire       is_zero;

  ALU_FP #(.DATA_WIDTH(8), .OPCODE_WIDTH(4), .FRACT_WIDTH(4))
    u_alu(.inA(inA), .inB(inB), .opcode(opcode), .result(result), .is_zero(is_zero));

  initial begin
    $display("op inA inB -> res zero");
    
    // Test a sequence of opcodes
    inA=8'd5; inB=8'd3;
    opcode=4'b0010; #1; // ADD
      $display("ADD: %d+%d=%d %b", inA, inB, result, is_zero);
    inA=8'd24; inB=8'd36;
    opcode=4'b1000; #1; // FMUL
      $display("FMUL: %d*%d>>4=%d %b", inA, inB, result, is_zero);
    opcode=4'b0111; #1; // JMP (pass-through)
      $display("JMP: pass %d %b", result, is_zero);

    $finish;
  end
endmodule
