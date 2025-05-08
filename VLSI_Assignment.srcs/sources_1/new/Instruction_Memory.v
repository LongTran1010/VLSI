`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/19/2025 01:39:23 PM
// Design Name: 
// Module Name: Instruction_Memory
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
module Instruction_Memory #(
  parameter ADDR_WIDTH = 5,          // width of address bus
            OPCODE_WIDTH = 4,
            OPERAND_WIDTH = 5,
            INST_WIDTH = OPCODE_WIDTH + OPERAND_WIDTH,
            DEPTH  = 1 << ADDR_WIDTH
)(
  input  wire                    clk,    // clock for synchronous read
  input  wire                    rd,     // read enable
  input  wire [ADDR_WIDTH-1:0]   addr,   // address input
  output reg  [INST_WIDTH-1:0]   instr_out   // data output
);
  // Memory array
  reg [INST_WIDTH-1:0] mem [0:DEPTH-1];
  //integer i;
  //reg [INST_WIDTH-1:0] tmp;
  // Optional: preload from hex file
  //initial begin
     //$readmemh("program.hex", mem);

  // Uncomment the line below to preload instructions from a hex file:
  // $readmemh("instruction_memory.hex", mem);
     
  // Otherwise, initialize memory sequentially for testing/demo
//  for (i = 0; i < DEPTH; i = i + 1) begin
//    tmp = i;                // cast integer to proper width
//    mem[i] = tmp;           // fill memory
//  end
  //end
  // Synchronous read: data available next clock cycle after rd
  always @(posedge clk) begin
    if (rd)
      instr_out <= mem[addr];
  end
endmodule