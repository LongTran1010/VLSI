VLSI Assignment
- Phần source code nằm trong VLSI_Assigment.srcs/sources_1/new, chứa tất cả source code của từng module và top module RISC_FP.v
- Phần testbench dành cho simulation nằm trong VLSI_Assigment.srcs/sim_1/new, testbench tổng tb_RISC_FP.v
- risc_fp.xdc cho clock period là 10ns, test timing, slack và tìm Fmax thực tế (power_1.rpx và timing_1.rpx là 2 reports về timing và power optimization).
- Vì thiết kế sử dụng data memory và instruction memory nên testcase sẽ được chia làm 2 file là program.mem và data_memory.mem.
- Các testcase nằm trong VLSI_Assignment.sim/sim_1/behav/xsim.
- Với testcase 1 (PROG1.txt), sử dụng data_memory.mem và program.mem, với testcase 2 (PROG2.txt), sử dụng data_memory_2.mem và program_2.mem.
- Waveform cho 2 testcase nằm trong VLSI_Assignment.srcs/sim_1/imports/VLSI_Assignment.
