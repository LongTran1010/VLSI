`ifndef STATES_DEF_VH
`define STATES_DEF_VH

localparam S_INST_ADDR  = 3'd0,
           S_INST_FETCH = 3'd1,
           S_INST_LOAD  = 3'd2,
           S_IDLE       = 3'd3,
           S_OP_ADDR    = 3'd4,
           S_OP_FETCH   = 3'd5,
           S_ALU_OP     = 3'd6,
           S_STORE      = 3'd7;

`endif
