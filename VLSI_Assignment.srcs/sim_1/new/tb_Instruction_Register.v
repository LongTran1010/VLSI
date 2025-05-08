`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/19/2025 01:39:42 PM
// Design Name: 
// Module Name: tb_Instruction_Register
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
module tb_Instruction_Register;
  localparam OPCODE_WIDTH  = 4;
  localparam OPERAND_WIDTH = 5;
  localparam INST_WIDTH    = OPCODE_WIDTH + OPERAND_WIDTH;

  reg                        clk, rst, ld_ir;
  reg  [INST_WIDTH-1:0]      instr_in;
  wire [OPCODE_WIDTH-1:0]    opcode;
  wire [OPERAND_WIDTH-1:0]   operand;

  Instruction_Register #(
    .OPCODE_WIDTH(OPCODE_WIDTH),
    .OPERAND_WIDTH(OPERAND_WIDTH)
  ) dut (
    .clk(clk), .rst(rst), .ld_ir(ld_ir),
    .instr_in(instr_in),
    .opcode(opcode), .operand(operand)
  );

  initial clk = 0;
  always #5 clk = ~clk;

  initial begin
    $display("time rst ld_ir instr_in   | opcode operand");
    $monitor("%4dns  %b    %b     %b |   %b     %b",
             $time, rst, ld_ir, instr_in, opcode, operand);

    // 1) apply reset
    rst = 1; ld_ir = 0; instr_in = 0; #10;
    rst = 0;                #10;
    // 2) load a pattern
    instr_in = {4'b1010, 5'b11011}; ld_ir = 1; #10;
    ld_ir = 0;                           #10;
    // 3) change instr_in, no load => outputs hold
    instr_in = {4'b0101, 5'b00100};      #20;
    // 4) load new
    ld_ir = 1; #10;
    ld_ir = 0; #10;

    $finish;
  end
endmodule

