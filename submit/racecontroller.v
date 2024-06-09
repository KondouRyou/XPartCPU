module RaceController(
    input clk,
    input rstn,
    input ID_reg_read1,
    input ID_reg_read2,
    input [4:0] IFID_rs1,
    input [4:0] IFID_rs2,
    input [4:0] IDEX_rd,
    input IDEX_we,
    input ifload,
    input ifjump,
    input ifswitch,
    input if_stall,
    input mem_stall,
    output wire stall_PC,
    output wire stall_IFID,
    output wire stall_IDEX,
    output wire stall_EXMEM,
    output wire stall_MEMWB,
    output wire flush_IFID,
    output wire flush_IDEX,
    output wire flush_EXMEM,
    output wire flush_MEMWB
);

assign stall_PC = if_stall;
assign stall_IFID = ifload && IDEX_we && (IDEX_rd == IFID_rs1 || IDEX_rd ==IFID_rs2) && (IDEX_rd!=0);
assign stall_IDEX = ifjump;
assign stall_EXMEM = mem_stall;
assign flush_IFID = ifjump;
assign flush_IDEX = ifjump||ifswitch;
assign flush_EXMEM = ifjump;
assign flush_MEMWB = 0;

endmodule