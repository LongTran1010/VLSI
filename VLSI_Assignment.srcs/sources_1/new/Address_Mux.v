`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/18/2025 04:43:41 PM
// Design Name: 
// Module Name: Address_Mux
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
module Address_Mux #(
  parameter WIDTH = 5        // ?? r?ng bus ??a ch?, m?c ??nh 5, v?n có th? thay ??i trong module chính n?u c?n.
)(
  input  wire                  sel,       // sel=0: ch?n pc_addr; sel=1: ch?n op_addr
  input  wire [WIDTH-1:0]      pc_addr,   // ??a ch? l?nh (fetch)
  input  wire [WIDTH-1:0]      op_addr,   // ??a ch? toán h?ng (execute)
  output wire [WIDTH-1:0]      addr_out   // ??a ch? ??u ra
);
  // MUX 2?1 thu?n combinational
  assign addr_out = sel ? op_addr : pc_addr;
endmodule
