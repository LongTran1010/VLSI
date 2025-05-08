`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/19/2025 10:05:06 PM
// Design Name: 
// Module Name: RISC_FP
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
module RISC_FP #(
  parameter ADDR_WIDTH    = 5,
            OPCODE_WIDTH  = 4,
            OPERAND_WIDTH = 5,
            INST_WIDTH    = OPCODE_WIDTH + OPERAND_WIDTH,
            DATA_WIDTH    = 8,
            FRACT_WIDTH   = 4
)(
  input  wire                   clk,
  input  wire                   rst,
  output  wire [DATA_WIDTH-1:0]  data_bus,
  output wire [ADDR_WIDTH-1:0]  pc_out,
  output wire [DATA_WIDTH-1:0]  ac_out,
  output wire [3:0]  debug_opcode,
  output wire [4:0]  debug_operand,
  output wire [7:0]  debug_data_bus,
  output wire [7:0]  debug_alu_out,
  output wire        debug_ld_ac,
  output wire        debug_wr,
  output wire        debug_rd_imem,
  output wire        debug_rd_dmem,
  output wire [2:0]  debug_state,
  output wire        debug_sel,
  output wire        debug_rd_dm,
  output wire        debug_ld_pc,
  output wire        debug_ld_data,
  output wire        debug_data_e,
  output wire        debug_ld_ir,
  output wire        debug_halt
);
  localparam S_INST_ADDR  = 3'd0,
           S_INST_FETCH = 3'd1,
           S_INST_LOAD  = 3'd2,
           S_IDLE       = 3'd3,
           S_OP_ADDR    = 3'd4,
           S_OP_FETCH   = 3'd5,
           S_ALU_OP     = 3'd6,
           S_STORE      = 3'd7;
  // Instruction and data buses
  wire [INST_WIDTH-1:0]         instr_bus;

  wire [OPCODE_WIDTH-1:0]       opcode;
  wire [OPERAND_WIDTH-1:0]      operand;
  //wire [DATA_WIDTH-1:0]         data_bus_cpu;
  //wire [DATA_WIDTH-1:0]         data_bus_mem;
  
  // ALU outputs
  wire [DATA_WIDTH-1:0]         alu_out;
  wire                          is_zero;        
  // Control signals
  wire                          sel;       // address mux select
  wire                          rd_imem;        // memory read
  wire                          rd_dmem;
  wire                          wr;        // memory write
  wire                          ld_ir;     // load IR
  wire                          inc_pc;    // increment PC
  wire                          ld_ac;     // load accumulator
  wire                          ld_pc;     // load PC (JMP)
  wire                          data_e;  
  wire                          ld_data;
  // Separate read enables
  wire                          rd_dm = rd_dmem & (~sel);
  wire [ADDR_WIDTH-1:0]         addr_dm;
  reg ld_ir_d;
  reg [OPERAND_WIDTH-1:0] operand_d;
  reg [OPCODE_WIDTH-1:0] opcode_reg;
  always @(posedge clk or posedge rst) begin
    if(rst) begin
      ld_ir_d <= 1'b0;
    end else ld_ir_d <= ld_ir;
  end
  always @(posedge clk or posedge rst) begin
    if (rst)      operand_d <= {OPERAND_WIDTH{1'b0}};
    else if (ld_ir_d) operand_d <= operand;
  end 
  always @(posedge clk or posedge rst) begin
    if(rst) begin
      opcode_reg <= {OPCODE_WIDTH{1'b0}};
    end else if(ld_ir_d) begin
      opcode_reg <= opcode; //latch ngay khi IR load
      $display(">>> [RISC_FP] Latching OPCODE = %04b at time = %0t", opcode, $time);
    end
  end 
   
  
  // 1) Program Counter
  ProgramCounter #(
    .WIDTH(ADDR_WIDTH)
  ) pc_u (
    .clk        (clk),
    .rst        (rst),
    .inc        (inc_pc),
    .load       (ld_pc),
    .d_in       (operand_d),
    .pc_out     (pc_out)
  );

  // 2) Instruction Memory (separate)
  Instruction_Memory #(
    .ADDR_WIDTH(ADDR_WIDTH),
    .INST_WIDTH(INST_WIDTH)
  ) imem_u (
    .clk       (clk),
    .rd        (rd_imem),
    .addr      (pc_out),
    .instr_out (instr_bus)
  );

  // 3) Instruction Register
  Instruction_Register #(
    .OPCODE_WIDTH(OPCODE_WIDTH),
    .OPERAND_WIDTH(OPERAND_WIDTH)
  ) ir_u (
    .clk      (clk),
    .rst      (rst),
    .ld_ir    (ld_ir),
    .instr_in (instr_bus),
    .opcode   (opcode),
    .operand  (operand)
  );
  


  // 4) Address Mux for Data Memory
  Address_Mux #(
    .WIDTH(ADDR_WIDTH)
  ) amux_u (
    .sel      (~sel),
    .pc_addr  ({ADDR_WIDTH{1'b0}}), // unused for DM
    .op_addr  (operand_d),
    .addr_out (addr_dm)
  );

  // 5) Data Memory: single bidirectional port
  wire [DATA_WIDTH-1:0] mem_data_out;
  Data_Memory #(
    .ADDR_WIDTH(ADDR_WIDTH),
    .DATA_WIDTH(DATA_WIDTH)
  ) dmem_u (
    .clk       (clk),
    .rd        (rd_dmem),
    .wr        (wr),
    .addr      (addr_dm),
    .data_e    (data_e),
    .write_data      (ac_out),
    .read_data (mem_data_out)
  );

 // --- internal bus register for read data ---
  reg [DATA_WIDTH-1:0] data_bus_reg;
  always @(posedge clk or posedge rst) begin
    if(rst) begin
      data_bus_reg <= {DATA_WIDTH{1'b0}};
    end else if(ld_data) begin
      data_bus_reg <= mem_data_out;
    end
  end
  assign data_bus = data_bus_reg;
  always @(*) begin
    if (rd_dm) begin
      $display(">>> [RISC_FP] time=%0t state=%0d rd_dm=%b sel=%b addr_dm=%0d data_bus=%02h",
               $time, debug_state, rd_dm, sel, addr_dm, data_bus);
    end
  end
  // 6) ALU
  ALU #(
    .DATA_WIDTH   (DATA_WIDTH),
    .OPCODE_WIDTH (OPCODE_WIDTH),
    .FRACT_WIDTH  (FRACT_WIDTH)
  ) alu_u (
    .inA    (ac_out),
    .inB    (data_bus_reg),
    .opcode (opcode_reg),
    .result (alu_out),
    .is_zero(is_zero)
  );

  // 7) Accumulator Register
  Accumulator_Register #(
    .WIDTH(DATA_WIDTH)
  ) ac_u (
    .clk    (clk),
    .rst    (rst),
    .ld_ac  (ld_ac),
    .d_in   (alu_out),
    .ac_out (ac_out)
  );

  // 8) Controller FSM
  Controller #(
    .OPCODE_WIDTH(OPCODE_WIDTH)
  ) ctrl_u (
    .clk    (clk),
    .rst    (rst),
    .opcode (opcode_reg),
    .is_zero(is_zero),
    .sel    (sel),
    .rd_imem (rd_imem),
    .rd_dmem (rd_dmem),
    .ld_ir  (ld_ir),
    .halt   (debug_halt),      
    .inc_pc(inc_pc),
    .ld_ac  (ld_ac),
    .ld_pc  (ld_pc),
    .wr     (wr),
    .ld_data   (ld_data),
    .data_e (data_e),
    .state  (debug_state)
  );

  assign debug_opcode     = opcode;
  assign debug_operand    = operand;
  assign debug_data_bus   = data_bus_reg;
  assign debug_alu_out    = alu_out;
  assign debug_ld_ac      = ld_ac;
  assign debug_ld_pc      = ld_pc;
  assign debug_wr         = wr;
  assign debug_rd_imem         = rd_imem;
  assign debug_rd_dmem         = rd_dmem;
  assign debug_sel        = sel;
  assign debug_rd_dm      = rd_dm;
  assign debug_ld_data    = ld_data;
  assign debug_data_e     = data_e;
  assign debug_ld_ir      = ld_ir;
endmodule