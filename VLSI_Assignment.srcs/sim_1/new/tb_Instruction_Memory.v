`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/19/2025 01:40:01 PM
// Design Name: 
// Module Name: tb_Instruction_Memory
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
module tb_Instruction_Memory;
  localparam ADDR_WIDTH   = 5;
  localparam OPCODE_WIDTH = 4;
  localparam OPERAND_WIDTH= 5;
  localparam INST_WIDTH   = OPCODE_WIDTH + OPERAND_WIDTH;
  localparam DEPTH        = 1 << ADDR_WIDTH;

  reg                     clk, rd;
  reg  [ADDR_WIDTH-1:0]   addr;
  wire [INST_WIDTH-1:0]   instr_out;

  Instruction_Memory #(
    .ADDR_WIDTH(ADDR_WIDTH),
    .OPCODE_WIDTH(OPCODE_WIDTH),
    .OPERAND_WIDTH(OPERAND_WIDTH)
  ) dut (
    .clk(clk), .rd(rd), .addr(addr), .instr_out(instr_out)
  );

  initial clk = 0;
  always #5 clk = ~clk;

  initial begin
    $display("time rd addr | instr_out");
    $monitor("%4dns  %b   %2d  | %b", $time, rd, addr, instr_out);

    // 1) rd=0: instr_out gi? giá tr? tr??c
    rd = 0; addr = 0; #10;
    // 2) rd=1, addr=3
    rd = 1; addr = 3; #10;
    // 3) addr=7 (still rd=1)
    addr = 7;     #10;
    // 4) turn off rd, change addr to 5 -> no change
    rd = 0; addr = 5; #10;
    // 5) back to rd=1, addr=5
    rd = 1;        #10;

    $finish;
  end
endmodule

