`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/19/2025 09:53:14 PM
// Design Name: 
// Module Name: Data_Memory
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
module Data_Memory #(
  parameter ADDR_WIDTH = 5,       // width of address bus
            DATA_WIDTH = 8,       // width of data bus (fixed-point Qm.n)
            DEPTH      = 1 << ADDR_WIDTH
)(
  input  wire                   clk,   // clock for synchronous write
  input  wire                   rst,
  input  wire                   rd,    // read enable
  input  wire                   wr,    // write enable
  input  wire                   data_e,
  input  wire [ADDR_WIDTH-1:0]  addr,  // address bus
  input  wire [DATA_WIDTH-1:0]  write_data,
  output reg [DATA_WIDTH-1:0]  read_data   // bidirectional data port
);

  // Internal memory array
  reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];

  integer i;
   // write on rising clock when wr=1
//  always @(posedge clk or posedge rst) begin
//    if(wr && data_e)
//      mem[addr] <= write_data;
//  end
  always @(posedge clk or posedge rst) begin
    if(rst) begin
      for(i = 0; i < DEPTH; i = i + 1)
        mem[i] <= {DATA_WIDTH{1'b0}};
    end else if(wr && data_e) begin
      mem[addr] <= write_data;
    end
  end
   // read on rising clock when rd=1
  always @(posedge clk) begin
    if(rd)
      read_data <= mem[addr];
  end
endmodule