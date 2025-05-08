`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/18/2025 04:37:21 PM
// Design Name: 
// Module Name: tb_ProgramCounter
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

`timescale 1ns/1ps

module tb_ProgramCounter;
  localparam WIDTH = 5;
  reg                   clk;
  reg                   rst;
  reg                   load;
  reg  [WIDTH-1:0]      d_in;
  reg                   inc;
  wire [WIDTH-1:0]      pc_out;

  // instantiate
  ProgramCounter #(.WIDTH(WIDTH)) uut (
    .clk(clk),
    .rst(rst),
    .load(load),
    .d_in(d_in),
    .inc(inc),
    .pc_out(pc_out)
  );

  // clock: 10ns period
  initial clk = 0;
  always #5 clk = ~clk;

  initial begin
    // kh?i t?o
    rst   = 1; load = 0; inc = 0; d_in = 0;
    #20;         // hai chu k? clock
    rst   = 0;               // gi?i phóng reset

    // test t?ng PC t?ng b??c
    inc   = 1;
    #50;                     // 5 chu k?, pc_out = 5

    inc   = 0;
    #10;

    // test n?p giá tr? b?t k?
    d_in  = 5'd17;
    load  = 1;
    #10;                     // m?t chu k?
    load  = 0;
    #10;

    // ti?p t?c ??m t? 17
    inc   = 1;
    #20;                     // hai chu k?, pc_out = 19

    // test reset tr? l?i 0
    rst   = 1;
    inc   = 0;
    #10;
    rst   = 0;
    #10;

    $finish;
  end

  // optional: hi?n th? pc_out m?i xung lên
  initial begin
    $display(" time | rst load inc | pc_out");
    $monitor("%4dns |   %b    %b   %b  | %d", $time, rst, load, inc, pc_out);
  end
endmodule

