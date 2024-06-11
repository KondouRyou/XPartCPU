`include "CSRStruct.vh"
`include "RegStruct.vh"
`include "TimerStruct.vh"

module MMU(
    input           clk,
    input           rst,
    input   [63:0]  inst_addr_cpu,  // CPU传进来的当前pc
    input   [63:0]  mem_addr_cpu,  // CPU传进来的mem阶段的addr
    output  [63:0]  address1,
    output  [63:0]  address2,
    input           mem_write,  // CPU传来的使能信号
    input           mem_read,   // CPU传来的使能信号
    input   [63:0]  satp,
    output          stall_pipeline
);

    localparam SIM_UART_ADDR = 64'h10000000;

    wire            finish_translation;
    wire    [63:0]  addr1;
    wire    [63:0]  addr2;
    wire    [63:0]  data1;
    wire    [63:0]  data2;
    wire            ram_we, need_trans1, need_trans2, need_trans;

    assign need_trans1 = (satp[63:60] != 0);
    assign need_trans2 = (mem_read || mem_write) && (satp[63:60] != 0) && (mem_addr_cpu != SIM_UART_ADDR);
    assign need_trans = need_trans1 || need_trans2;

    Translator trans(
        .clk(clk),
        .rst(rst),
        .ram_en((mem_read || mem_write) && need_trans2),
        .satp(satp),
        .inst_addr(inst_addr_cpu),
        .data_addr(mem_addr_cpu),
        .memory_data1(data1),
        .memory_data2(data2),
        .finish(finish_translation),// o
        .memory_addr1(address1),   // o
        .memory_addr2(address2)    // o
    );

    assign stall_pipeline = need_trans && !finish_translation;

endmodule