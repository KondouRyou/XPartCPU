`include "ExceptStruct.vh"
`include "CSRStruct.vh"
`include "RegStruct.vh"
`include "TimerStruct.vh"

module Core (
    input wire clk,                       /* 时钟 */ 
    input wire rstn,                       /* 重置信号 */ 

    output wire [63:0] address1,                /* current pc */
    input wire [63:0] data1,               /* read inst from ram */

    output wire [63:0] address2,           /* memory address */
    input wire [63:0] data2,          /* read data from memory */
    output wire we_mem,                   /* write enable */
    output wire [63:0] wdata_mem,         /* write data to memory */
    output wire [7:0] wmask_mem,          /* write enable for each byte */ 
    output wire re_mem,                   /* read enable */

    input wire if_stall,
    input wire mem_stall,
    output wire if_request,
    output wire switch_mode,

    input TimerStruct::TimerPack time_out,

    output cosim_valid,
    output [63:0] cosim_pc,          /* current pc */
    output [31:0] cosim_inst,        /* current instruction */
    output [ 7:0] cosim_rs1_id,      /* rs1 id */
    output [63:0] cosim_rs1_data,    /* rs1 data */
    output [ 7:0] cosim_rs2_id,      /* rs2 id */
    output [63:0] cosim_rs2_data,    /* rs2 data */
    output [63:0] cosim_alu,         /* alu out */
    output [63:0] cosim_mem_addr,    /* memory address */
    output [ 3:0] cosim_mem_we,      /* memory write enable */
    output [63:0] cosim_mem_wdata,   /* memory write data */
    output [63:0] cosim_mem_rdata,   /* memory read data */
    output [ 3:0] cosim_rd_we,       /* rd write enable */
    output [ 7:0] cosim_rd_id,       /* rd id */
    output [63:0] cosim_rd_data,     /* rd data */
    output [ 3:0] cosim_br_taken,    /* branch taken? */
    output [63:0] cosim_npc,         /* next pc */
    output CSRStruct::CSRPack cosim_csr_info,
    output RegStruct::RegPack cosim_regs,

    output cosim_interrupt,
    output [63:0] cosim_cause
);
    wire[63:0] pc_cpu;
    wire(63:0) satp;
    wire stall;

    CPU cpu(
        .clk(clk),
        .rstn(rstn),

        .pc(pc_cpu),// o
        .inst(data1[31:0]),

        .satp(satp),
        .stall(stall),
        .address(wdata_mem),// o
        .we_mem(we_mem),// o
        .wdata_mem(wdata_mem),// o
        .wmask_mem(wmask_mem),// o
        .re_mem(re_mem),// o
        .rdata_mem(rdata_mem),

        .if_stall(if_stall),
        .mem_stall(mem_stall),
        .if_request(if_request),// o
        .switch_mode(switch_mode),// o

        .time_out(time_out),

        // o
        .cosim_valid(cosim_valid),
        .cosim_pc(cosim_pc),
	    .cosim_inst(cosim_inst),
	    .cosim_rs1_id(cosim_rs1_id),
	    .cosim_rs1_data(cosim_rs1_data),
	    .cosim_rs2_id(cosim_rs2_id),
	    .cosim_rs2_data(cosim_rs2_data),
	    .cosim_alu(cosim_alu),
	    .cosim_mem_addr(cosim_mem_addr),
	    .cosim_mem_we(cosim_mem_we),
	    .cosim_mem_wdata(cosim_mem_wdata),
	    .cosim_mem_rdata(cosim_mem_rdata),
	    .cosim_rd_we(cosim_rd_we),
	    .cosim_rd_id(cosim_rd_id),
	    .cosim_rd_data(cosim_rd_data),
	    .cosim_br_taken(cosim_br_taken),
	    .cosim_npc(cosim_npc),
        .cosim_csr_info(cosim_csr_info),
        .cosim_regs(cosim_regs),
        .cosim_interrupt(cosim_interrupt),
        .cosim_cause(cosim_cause)
    );

    MMU mmu(
        .clk(clk),
        .rst(!rstn),
        .inst_addr_cpu(pc_cpu),
        .mem_addr_cpu(mem_addr_cpu),
        .address1(address1),
        .address2(address2),
        .mem_write(we_mem),
        .mem_read(re_mem),
        .satp(satp),
        .stall_pipeline(stall)
    );
endmodule