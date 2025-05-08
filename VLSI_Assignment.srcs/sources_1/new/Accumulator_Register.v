`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/19/2025 12:58:39 PM
// Design Name: 
// Module Name: Accumulator_Register
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
module Accumulator_Register #(
  parameter WIDTH = 8           // mac dinh 8-bit cho do rong cua accumulator
)(
  input  wire                  clk,    // xung 
  input  wire                  rst,    // reset, active-high
  input  wire                  ld_ac,  // khi =1: nap gtri moi vao accum
  input  wire [WIDTH-1:0]      d_in,   // du lieu dau vao
  output reg  [WIDTH-1:0]      ac_out  // gia tri hien tai cua accum
);

  // voi moi canh len clk:
  // 1) If rst=1 ? ac_out -> 0
  // 2) else if ld_ac=1 ? ac_out <= d_in
  // 3) else giu nguyen
  always @(posedge clk) begin
    if (rst)
      ac_out <= {WIDTH{1'b0}};
    else if (ld_ac)
      ac_out <= d_in;
      
    $display("AC updated = %0d from ALU = %0d", d_in, ac_out);
  end
    // giu nguyen ac_out
endmodule

