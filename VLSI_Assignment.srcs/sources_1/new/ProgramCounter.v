`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/18/2025 04:13:38 PM
// Design Name: 
// Module Name: ProgramCounter
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
module ProgramCounter #(
    parameter WIDTH = 5)
(
    input  wire                  clk,      // xung clock
    input  wire                  rst,      // reset dong bo, active_high
    input  wire                  load,     // khi load=1: nap gia tri moi vao PC
    input  wire [WIDTH-1:0]      d_in,     // du lieu nap vao
    input  wire                  inc,      // khi inc=1: tang PC len 1
    output reg  [WIDTH-1:0]      pc_out    // gia tri hien tai cua PC
);
    always @(posedge clk) begin
        if(rst) begin
            pc_out <= {WIDTH{1'b0}};   //reset ve 0
        end else if(load) begin
            pc_out <= d_in;   //Load so bat ki vao pc
        end else if(inc) begin
            pc_out <= pc_out + 1'b1; //tang dem len 1
        end //hoat donng bth
    end
endmodule
