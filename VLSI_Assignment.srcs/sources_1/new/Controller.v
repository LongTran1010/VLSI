`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/19/2025 01:48:29 PM
// Design Name: 
// Module Name: Controller
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
module Controller #(
  parameter OPCODE_WIDTH = 4
)(
  input  wire                  clk,   //xung
  input  wire                  rst,   //synch reset, active high
  input  wire [OPCODE_WIDTH-1:0] opcode,    //instruction opcode
  input  wire                  is_zero, //zero flag
  output reg                   sel,  //0: PC add, 1: operand add
  output reg                   rd_imem,  //mem red
  output reg                   rd_dmem,
  output reg                   ld_ir,   //load ins reg
  output reg                   halt,    //halt cpu
  output reg                   inc_pc,  //increment PC
  output reg                   ld_ac,   //load accumu
  output reg                   ld_pc,   //load PC(JMP)
  output reg                   wr,  //mem write
  output reg                   data_e,  //mem data enable
  output reg  [2:0]            state,
  output reg                   ld_data  //load data from mem to bus
);

  // State encoding (unchanged)
  localparam S_INST_ADDR  = 3'd0,
             S_INST_FETCH = 3'd1,
             S_INST_LOAD  = 3'd2,
             S_IDLE       = 3'd3,
             S_OP_ADDR    = 3'd4,
             S_OP_FETCH   = 3'd5,
             S_ALU_OP     = 3'd6,
             S_STORE      = 3'd7;

  // Extended opcode definitions
  localparam OPC_HLT  = 4'b0000,
             OPC_SKZ  = 4'b0001,
             OPC_ADD  = 4'b0010,
             OPC_AND  = 4'b0011,
             OPC_XOR  = 4'b0100,
             OPC_LDA  = 4'b0101,
             OPC_STO  = 4'b0110,
             OPC_JMP  = 4'b0111,
             OPC_FMUL = 4'b1000,
             OPC_FDIV = 4'b1001;

  reg [2:0] next_state;

  // State register
  always @(posedge clk) begin
    if (rst)      
        state <= S_INST_ADDR;
    else          
        state <= next_state;
  end

  // Next-state logic
  always @(*) begin
    case (state)
      S_INST_ADDR:  next_state = S_INST_FETCH;
      S_INST_FETCH: next_state = S_INST_LOAD;
      S_INST_LOAD:  next_state = S_IDLE;
      S_IDLE:  next_state = S_OP_ADDR;
      S_OP_ADDR:    next_state = S_OP_FETCH;
      S_OP_FETCH:   next_state = S_ALU_OP;
      S_ALU_OP:     next_state = S_STORE;
      S_STORE:      next_state = S_INST_ADDR;
      default:      next_state = S_INST_ADDR;
    endcase
  end

  // Output logic
  always @(*) begin
    // defaults
    sel    = 1'b0; 
    rd_imem     = 1'b0; 
    rd_dmem = 1'b0;
    ld_ir  = 1'b0; 
    halt   = 1'b0;
    inc_pc = 1'b0; 
    ld_ac  = 1'b0; 
    ld_pc  = 1'b0; 
    wr     = 1'b0; 
    data_e = 1'b0;
    ld_data = 1'b0;
    case (state)
      S_INST_ADDR: begin
        //sel    = 0; inc_pc = 1;
        sel = 1'b1;
        //inc_pc = 1'b1;
      end

      S_INST_FETCH: begin
        //sel = 0; rd = 1;
        //sel = 1'b1;
        sel = 1'b1; // cho testcase c?a th?y
        rd_imem = 1'b1;
      end

      S_INST_LOAD: begin
        sel = 1'b0;

        ld_ir = 1'b1;
        //inc_pc = 1'b1;
      end

      S_IDLE: begin
//        sel = 1'b1;
//        rd = 1'b1;
//        ld_ir = 1'b1;
      end
            
      S_OP_ADDR: begin
      sel = 1'b0;
      inc_pc = 1'b1;
      if (opcode == OPC_HLT) begin        
        halt   = 1'b1;
        inc_pc = 1'b0;
      end else begin 
        inc_pc = 1'b1;
      end
      if (opcode == OPC_JMP)   ld_pc = 1'b1;
//        else if (opcode == OPC_SKZ && is_zero) inc_pc = 1;
      end

      S_OP_FETCH: begin
        sel = 1'b0;
        if (opcode == OPC_ADD || opcode == OPC_AND || opcode == OPC_XOR || opcode == OPC_LDA || opcode == OPC_FMUL || opcode == OPC_FDIV || opcode == OPC_STO) begin
        // Read data for all ALU/LOAD/FIXED-POINT
          rd_dmem = 1'b1;
        end
      end

      S_ALU_OP: begin
        sel = 1'b0;
        if (opcode == OPC_ADD || opcode == OPC_AND || opcode == OPC_XOR ||
                   opcode == OPC_LDA || opcode == OPC_FMUL || opcode == OPC_FDIV) begin
            ld_data = 1'b1;
            
        end
        if (opcode == OPC_SKZ && is_zero)
            inc_pc = 1'b1;
        if (opcode == OPC_JMP)
            ld_pc = 1'b1;
//        if (opcode == OPC_ADD || opcode == OPC_AND || opcode == OPC_XOR || opcode == OPC_LDA || opcode == OPC_FMUL || opcode == OPC_FDIV)
//            rd = 1'b1;  // ALUOP ??c data
//        if (opcode == OPC_STO)
//            data_e = 1'b1;         
      end

      S_STORE: begin
        sel = 1'b0;
        if (opcode == OPC_ADD || opcode == OPC_AND || opcode == OPC_XOR || opcode == OPC_LDA || opcode == OPC_FMUL || opcode == OPC_FDIV) begin
//          rd = 1'b1;  // ALUOP ??c data
          ld_ac = 1'b1;
        end
        if (opcode == OPC_JMP) begin
          ld_pc = 1'b1; 
        end
        if (opcode == OPC_STO) begin
          wr = 1'b1;
          data_e = 1'b1; 

          $display(">>> [CTRL] STORE at %0t | opcode=%04b | wr=1", $time, opcode);
        end
        if (opcode == OPC_HLT) begin
          halt = 1'b1;
        end
      end
    endcase
  end

endmodule

