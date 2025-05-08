`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/19/2025 09:50:56 PM
// Design Name: 
// Module Name: tb_Controller
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
module tb_Controller;
  reg clk, rst;
  reg [3:0] opcode;
  reg is_zero;
  wire sel, rd, ld_ir, halt, inc_pc, ld_ac, ld_pc, wr, data_e;
  wire [2:0] state;

  Controller uut (
    .clk(clk), .rst(rst), .opcode(opcode), .is_zero(is_zero),
    .sel(sel), .rd(rd), .ld_ir(ld_ir), .halt(halt),
    .inc_pc(inc_pc), .ld_ac(ld_ac), .ld_pc(ld_pc),
    .wr(wr), .data_e(data_e), .state(state)
  );

  initial clk = 0; always #5 clk = ~clk;

  initial begin
    $display("t st sel rd ld_ir halt inc_pc ld_ac ld_pc wr data_e | opc zero");
    $monitor("%2dns %b   %b   %b    %b    %b    %b     %b     %b    %b      %b | %b %b",
      $time, state, sel, rd, ld_ir, halt, inc_pc, ld_ac, ld_pc, wr, data_e, opcode, is_zero);

    rst = 1; opcode = 4'b0010; is_zero = 0; #10;
    rst = 0;

    // Test ADD
    opcode = 4'b0010; is_zero = 0;
    repeat(8) #10;
    
    // 2) Test SKZ (non-zero): should not skip
    opcode = 4'b0001; is_zero = 0;
    repeat (8) #10;
    //  SKZ (zero): should skip next instruction
    opcode = 4'b0001; is_zero = 1;
    repeat (8) #10;

    // 3) Test JMP: expect ld_pc asserted in OP_ADDR
    opcode = 4'b0111; is_zero = 0;
    repeat (8) #10;

    // 4) Test STO: expect data_e and wr in STORE phase
    opcode = 4'b0110; is_zero = 0;
    repeat (8) #10;

    // Test FMUL
    opcode = 4'b1000; is_zero = 0; repeat(8) #10;

    // Test FDIV
    opcode = 4'b1001; is_zero = 0; repeat(8) #10;

    $finish;
  end
endmodule
