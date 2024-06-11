`include "ExceptStruct.vh"
`include "CSRStruct.vh"
`include "RegStruct.vh"
`include "TimerStruct.vh"

module Core (
    input wire clk,                       /* 时钟 */ 
    input wire rstn,                       /* 重置信号 */ 

    output wire [63:0] address1,                /* current pc */
    input wire [31:0] inst,               /* read inst from ram */

    output wire [63:0] address2,           /* memory address */
    output wire we_mem,                   /* write enable */
    output wire [63:0] wdata_mem,         /* write data to memory */
    output wire [7:0] wmask_mem,          /* write enable for each byte */ 
    output wire re_mem,                   /* read enable */
    input wire [63:0] rdata_mem,          /* read data from memory */

    input wire if_stall,
    input wire mem_stall,
    output wire if_request,
    output wire switch_mode,
    output wire inst_wait,

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

    wire [63:0] pc,address;
    wire if_request_cpu;

    wire mem_en_mask;   // 来自于MMU模块，让MEM的读写使能的第一拍都不传给总线，以保持和地址同步到达总线上
    wire we_mem_cpu,re_mem_cpu;
    // 除了读写使能第一拍不能传到总线上，读写使能应该尽快收回，主要是为了Slave valid之后Master 的en不能开启。
    assign we_mem = we_mem_cpu & mem_en_mask & (mem_finish_state == 2'b00);
    assign re_mem = re_mem_cpu & mem_en_mask & (mem_finish_state == 2'b00);

    wire mem_stall_cpu;// mem_stall 来自总线，mem_stall_cpu 传给CPU
    reg [1:0] mem_finish_state;// 0IDEL，1正在访存，2访存结束
    // 需要 re_mem_cpu 发生时同步 mem_stall_cpu 置1，但之后再接收到mem_stall==0时解除
    assign mem_stall_cpu = (re_mem_cpu | we_mem_cpu) && mem_finish_state != 2'b10;
    always @(posedge clk)begin
        if(~rstn)begin
            mem_finish_state <= 2'b00;
        end else begin
            if(mem_finish_state == 2'b10)begin
                mem_finish_state <= 2'b00;
            end else if(mem_finish_state == 2'b00 && re_mem|we_mem)begin
                mem_finish_state <= 2'b01;
            end else if(mem_finish_state == 2'b01 && mem_stall == 0)begin
                mem_finish_state <= 2'b10;
            end
        end
    end


    CPU cpu(
        .clk(clk),
        .rstn(rstn),
        .time_out(time_out),
        .pc(pc),
        .inst(inst),
        .address(address),
        .we_mem(we_mem_cpu),
        .wdata_mem(wdata_mem),
        .wmask_mem(wmask_mem),
        .re_mem(re_mem_cpu),
        .rdata_mem(rdata_mem),
        .if_request(if_request_cpu),
        .switch_mode(switch_mode),
        .if_stall(if_stall | (if_request_cpu)),
        .mem_stall(mem_stall_cpu),
        .inst_wait(inst_wait),

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
        
        .satp(cosim_csr_info.satp),

        .pc(pc),
        .address1(address1),
        .if_request_cpu(if_request_cpu),
        .if_request(if_request),

        .mem_addr(address),
        .address2(address2),
        .mem_en_cpu(we_mem_cpu | re_mem_cpu),
        .mem_en(mem_en_mask)
    );

endmodule