`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/18/2025 05:23:05 PM
// Design Name: 
// Module Name: tb_Address_Mux
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

module tb_Address_Mux;
  parameter WIDTH = 5;

  reg                  sel;
  reg  [WIDTH-1:0]     pc_addr;
  reg  [WIDTH-1:0]     op_addr;
  wire [WIDTH-1:0]     addr_out;

  // Instantiate DUT
  Address_Mux #(.WIDTH(WIDTH)) uut (
    .sel(sel),
    .pc_addr(pc_addr),
    .op_addr(op_addr),
    .addr_out(addr_out)
  );

  initial begin
    $display(" time  sel  pc_addr  op_addr  addr_out");
    $monitor("%4dns   %b     %2d       %2d        %2d",
             $time, sel, pc_addr, op_addr, addr_out);

    // Test vector 1: sel=0 ? addr_out = pc_addr
    sel     = 0;
    pc_addr = 5'd10;
    op_addr = 5'd20;
    #10;

    // Test vector 2: sel=1 ? addr_out = op_addr
    sel = 1;
    #10;

    // Thay ??i ??a ch?, test l?i
    pc_addr = 5'd3;
    op_addr = 5'd15;
    sel     = 0;
    #10;
    sel     = 1;
    #10;

    $finish;
  end
endmodule

