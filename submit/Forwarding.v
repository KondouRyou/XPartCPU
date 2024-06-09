`timescale 1ns / 1ps

module Forwarding(
    input wire [4:0] ID_rs1,
    input wire [4:0] ID_rs2,
    input wire [4:0] EX_rd,
    input wire [4:0] MEM_rd,
    input wire [4:0] WB_rd,
    input wire EX_we,
    input wire MEM_we,
    input wire WB_we,
    input wire [63:0] init_read_data_1,
    input wire [63:0] init_read_data_2,
    input wire [63:0] EX_alu_res,
    input wire [63:0] MEM_wdata,
    input wire [63:0] WB_wdata,
    output wire [63:0] read_data_1,
    output wire [63:0] read_data_2
);

reg [63:0] read_data_1_reg,read_data_2_reg;
reg flag1,flag2;

assign read_data_1 = read_data_1_reg;
assign read_data_2 = read_data_2_reg;

always_latch @(*)begin
    flag1=0;
    flag2=0;
    if(WB_we && WB_rd!=0 && WB_rd == ID_rs1) begin
        read_data_1_reg = WB_wdata;
        flag1=1;
    end
    if(WB_we && WB_rd!=0 && WB_rd == ID_rs2) begin
        read_data_2_reg = WB_wdata;
        flag2=1;
    end
    if(MEM_we && MEM_rd!=0 && MEM_rd == ID_rs1) begin
        read_data_1_reg = MEM_wdata;
        flag1=1;
    end
    if(MEM_we && MEM_rd!=0 && MEM_rd == ID_rs2) begin
        read_data_2_reg = MEM_wdata;
        flag2=1;
    end
    if(EX_we && EX_rd!=0 && EX_rd == ID_rs1) begin
        read_data_1_reg = EX_alu_res;
        flag1=1;
    end
    if(EX_we && EX_rd!=0 && EX_rd == ID_rs2) begin
        read_data_2_reg = EX_alu_res;
        flag2=1;
    end
    if(flag1==0) begin
        read_data_1_reg = init_read_data_1;
    end
    if(flag2==0)begin
        read_data_2_reg = init_read_data_2;
    end
end

endmodule