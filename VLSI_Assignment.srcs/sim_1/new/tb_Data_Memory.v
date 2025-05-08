`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/19/2025 09:57:10 PM
// Design Name: 
// Module Name: tb_Data_Memory
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
module tb_Data_Memory;
  reg clk;
  reg rd, wr;
  reg [4:0] addr;
  wire [7:0] data;

  Data_Memory #(.ADDR_WIDTH(5), .DATA_WIDTH(8)) dmem (
    .clk(clk), .rd(rd), .wr(wr), .addr(addr), .data(data)
  );

  initial begin
    $readmemh("data_memory.hex", dmem.mem);
    clk = 0; forever #5 clk = ~clk;
  end

  initial begin
    // test read at addr=1,2
    rd = 1; wr = 0; addr = 1; #10;
    rd = 1; wr = 0; addr = 2; #10;
    $finish;
  end
endmodule

