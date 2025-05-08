`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/19/2025 10:12:33 PM
// Design Name: 
// Module Name: tb_RISC_FP
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
module tb_RISC_FP;
  localparam ADDR_WIDTH    = 5,
             OPCODE_WIDTH  = 4,
             OPERAND_WIDTH = 5,
             INST_WIDTH    = OPCODE_WIDTH + OPERAND_WIDTH,
             DATA_WIDTH    = 8;

  reg clk, rst;
  wire [ADDR_WIDTH-1:0] pc_out;
  wire [DATA_WIDTH-1:0] ac_out;
  wire [DATA_WIDTH-1:0] data_bus;
  wire [OPCODE_WIDTH-1:0] debug_opcode;
  wire [OPERAND_WIDTH-1:0] debug_operand;
  wire [DATA_WIDTH-1:0] debug_data_bus;
  wire [DATA_WIDTH-1:0] debug_alu_out;
  wire debug_ld_ac, debug_wr, debug_rd_imem;
  wire debug_ld_pc,       debug_rd_dm;
  wire [2:0] debug_state;
  wire debug_sel;
  wire debug_rd_dmem;
  wire debug_data_e;
  wire debug_ld_data;
  wire debug_ld_ir;
  wire debug_halt;
  
  RISC_FP #(
    .ADDR_WIDTH(ADDR_WIDTH),
    .OPCODE_WIDTH(OPCODE_WIDTH),
    .OPERAND_WIDTH(OPERAND_WIDTH),
    .INST_WIDTH(INST_WIDTH),
    .DATA_WIDTH(DATA_WIDTH),
    .FRACT_WIDTH(4)
  ) cpu (
    .clk    (clk),
    .rst    (rst),
    .data_bus (data_bus),
    .pc_out (pc_out),
    .ac_out (ac_out),
    .debug_opcode(debug_opcode),
    .debug_operand(debug_operand),
    .debug_data_bus(debug_data_bus),
    .debug_alu_out(debug_alu_out),
    .debug_ld_ac(debug_ld_ac),
    .debug_wr(debug_wr),
    .debug_rd_imem(debug_rd_imem),
    .debug_state(debug_state),
    .debug_sel(debug_sel),
    .debug_rd_dmem(debug_rd_dmem),
    .debug_rd_dm (debug_rd_dm),
    .debug_ld_data(debug_ld_data),
    .debug_data_e(debug_data_e),
    .debug_ld_pc(debug_ld_pc),
    .debug_ld_ir(debug_ld_ir),
    .debug_halt(debug_halt)
  );

  //----------------------------------------------------------------------
  // Clock generation: 100 MHz
  //----------------------------------------------------------------------
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  //----------------------------------------------------------------------
  // Reset sequence
  //----------------------------------------------------------------------
  initial begin
    rst = 1;
    #20;
    rst = 0;
  end

  //----------------------------------------------------------------------
  // Memory initialization
  //----------------------------------------------------------------------
  integer i;
  initial begin
    @(negedge rst);
    $readmemb("program.mem", cpu.imem_u.mem);
    $display(">>> [IMEM] contents <<<");
    for(i = 0; i < (1<<ADDR_WIDTH); i = i + 1) begin
      $display("IMEM[%02d] = %09b", i, cpu.imem_u.mem[i]);
    end
    $readmemb("data_memory.mem", cpu.dmem_u.mem);
    $display("Data Memory content:");
    for(i = 0; i < (1<<ADDR_WIDTH); i = i + 1) begin
      $display("M[%02d] = %09b", i , cpu.dmem_u.mem[i]);
    end
  end
  

  //----------------------------------------------------------------------
  // Monitor internal signals after combinational settles
  //----------------------------------------------------------------------
  always @(posedge clk) begin
    #1;  // allow combinational assignments to settle
    $strobe("%0t | state=%0d rd_imem=%b rd_dmem=%b sel=%b rd_dm=%b | data_bus=%02h alu_out=%02h ac_out=%02h",
             $time, debug_state, debug_rd_imem, debug_rd_dmem, debug_sel, debug_rd_dm,
             debug_data_bus, debug_alu_out, ac_out);
  end

  //----------------------------------------------------------------------
  // Simulation duration
  //----------------------------------------------------------------------
  always @(posedge clk) begin
   if (debug_halt) begin
     $display(">>> HLT detected at time=%0t, stopping simulation", $time);
     $finish;
   end
  end
endmodule