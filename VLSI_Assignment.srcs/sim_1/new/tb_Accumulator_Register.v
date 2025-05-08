`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/19/2025 01:01:24 PM
// Design Name: 
// Module Name: tb_Accumulator_Register
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
module tb_Accumulator_Register;
  localparam WIDTH = 8;

  reg                   clk;
  reg                   rst;
  reg                   ld_ac;
  reg  [WIDTH-1:0]      d_in;
  wire [WIDTH-1:0]      ac_out;

  // Instantiate DUT
  Accumulator_Register #(.WIDTH(WIDTH)) uut (
    .clk   (clk),
    .rst   (rst),
    .ld_ac (ld_ac),
    .d_in  (d_in),
    .ac_out(ac_out)
  );

  // Clock: 10?ns period
  initial clk = 0;
  always #5 clk = ~clk;

  initial begin
    // Header
    $display(" time | rst ld_ac d_in => ac_out");
    $monitor("%4dns |  %b    %b   %02h  =>   %02h",
             $time, rst, ld_ac, d_in, ac_out);

    // 1) Reset ve 0
    rst   = 1; ld_ac = 0; d_in = 8'hAA;
    #10;                          // sau 1 T
    rst   = 0;
    #10;                          // ac_out = 0

    // 2) nap gia tri 0x12
    ld_ac = 1; d_in = 8'h12;
    #10;                          // ac_out = 0x12
    ld_ac = 0;

    // 3) giu nguyen khi ld_ac=0 mac cho d_in thay doi
    d_in  = 8'h34;
    #20;                          // ac_out van giu gia tri = 0x12

    // 4) nap lai gia tri 0xFF
    ld_ac = 1; d_in = 8'hFF;
    #10;                          // ac_out = 0xFF

    $finish;
  end
endmodule

