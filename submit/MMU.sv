`include "CSRStruct.vh"
`include "RegStruct.vh"
`include "TimerStruct.vh"

module MMU(

):

Core core(
        .clk(clk),
        .rstn(rstn),
        .time_out(time_out),
        .pc(pc),
        .inst(inst),
        .address(address_cpu),
        .we_mem(wen_cpu),
        .wdata_mem(wdata_cpu),
        .wmask_mem(wmask_cpu),
        .re_mem(ren_cpu),
        .rdata_mem(rdata_cpu),
        .if_request(if_request),
        .switch_mode(switch_mode),
        .if_stall(if_stall_final),
        .mem_stall(mem_stall),

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
    
endmodule