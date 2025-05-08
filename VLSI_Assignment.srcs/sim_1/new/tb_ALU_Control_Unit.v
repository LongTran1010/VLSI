`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/19/2025 10:28:24 AM
// Design Name: 
// Module Name: tb_ALU_Control_Unit
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
module tb_ALU_Control_Unit;
  reg  [3:0] opcode;
  wire [3:0] ctrl;

  ALU_Control_Unit u_ctrl(.opcode(opcode), .ctrl(ctrl));

  initial begin
    $display("opcode -> ctrl");
    opcode = 4'b0010; #1; // ADD
      $display("%b -> %b (expect 0010)", opcode, ctrl);
    opcode = 4'b1000; #1; // FMUL
      $display("%b -> %b (expect 1000)", opcode, ctrl);
    opcode = 4'b0110; #1; // STO
      $display("%b -> %b (expect 0110)", opcode, ctrl);
    opcode = 4'b0111; #1; // JMP
      $display("%b -> %b (expect 0111)", opcode, ctrl);
    $finish;
  end
endmodule

