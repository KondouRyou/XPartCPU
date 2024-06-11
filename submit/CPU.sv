`include "ExceptStruct.vh"
`include "CSRStruct.vh"
`include "RegStruct.vh"
`include "TimerStruct.vh"

module CPU (
    input wire clk,                       /* 时钟 */ 
    input wire rstn,                       /* 重置信号 */ 

    output wire [63:0] pc,                /* current pc */
    input wire [31:0] inst,               /* read inst from ram */

    output wire [63:0] address,           /* memory address */
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
    import ExceptStruct::*;
    wire rst=~rstn;
    
    reg [63:0] IF_pc,IFID_pc,IDEX_pc,EXMEM_pc,MEMWB_pc;
    reg [31:0] IFID_inst,IDEX_inst,EXMEM_inst,MEMWB_inst;
    reg [21:0] IDEX_decoded,MEMWB_decoded,EXMEM_decoded;
    reg [63:0] IDEX_data_1,EXMEM_data_1;
    reg [63:0] IDEX_data_2,EXMEM_data_2;
    reg [63:0] IDEX_imm,EXMEM_imm,MEMWB_imm;
    reg [63:0] MEMWB_alu_res,EXMEM_alu_res;
    reg [63:0] MEMWB_wdata;
    reg IF_valid,IFID_valid,IDEX_valid,EXMEM_valid,MEMWB_valid;
    reg if_request_reg,inst_wait_reg;
    reg [9:0] csr_decode,IDEX_csr_decode,EXMEM_csr_decode,MEMWB_csr_decode;
    reg [63:0] pc_csr;
    reg [63:0] csr_read_val,IDEX_csr_read_val,EXMEM_csr_read_val,MEMWB_csr_read_val;
    reg [63:0] csr_alu_b;
    reg [63:0] csr_alu_res,EXMEM_csr_alu_res,MEMWB_csr_alu_res;
    reg [63:0] csr_val,MEMWB_csr_val;
    reg test_flag;

    wire except_happen_id;
    wire [1:0] priv;
    wire [21:0] decoded,EXMEM_decoded_wire;
    wire [63:0] read_data_1, read_data_2;
    wire [63:0] imm;
    wire [63:0] next_pc,jmp_addr;
    wire [63:0] mux_out_1, mux_out_2;
    wire [63:0] alu_res;
    wire [63:0] mem_rdata;
    wire [63:0] MEM_rd_data;
    wire ifjump,ifjump_mux;
    wire reg_read1,reg_read2,stall_pc,stall_IFID,stall_IDEX,stall_EXMEM;
    wire flush_IFID,flush_IDEX,flush_EXMEM,flush_MEMWB;
    wire [63:0] init_read_data_1,init_read_data_2;
    wire [63:0] EXMEM_alu_res_wire;

    ExceptPack except_id,except_exe,except_mem,except_wb,except_final;

    assign EXMEM_decoded_wire = EXMEM_decoded;
    assign EXMEM_alu_res_wire = EXMEM_alu_res;
    assign pc = IF_pc;
    assign address = EXMEM_alu_res;
    assign we_mem = EXMEM_decoded[20];
    assign re_mem = EXMEM_inst[6:0]==7'b0000011;
    assign if_request = if_request_reg;
    assign ifjump = ifjump_mux;
    assign jmp_addr = EXMEM_pc + EXMEM_imm;
    assign inst_wait = inst_wait_reg;

    assign cosim_valid=MEMWB_valid&~cosim_interrupt;
    assign cosim_pc=MEMWB_pc;      
    assign cosim_inst=MEMWB_inst;
    assign cosim_rd_we={3'b0,MEMWB_decoded[21]};
    assign cosim_rd_id={3'b0,MEMWB_inst[11:7]}; 
    assign cosim_rd_data=MEMWB_wdata;  

    assign cosim_rs1_id={3'b0,MEMWB_inst[19:15]};
    assign cosim_rs1_data=read_data_1;
    assign cosim_rs2_id={3'b0,MEMWB_inst[24:20]};
    assign cosim_rs2_data=read_data_2;
    assign cosim_alu=MEMWB_alu_res;

    assign cosim_mem_addr=MEMWB_alu_res;
    assign cosim_mem_we={3'b0,MEMWB_decoded[20]};
    assign cosim_mem_wdata=wdata_mem;
    assign cosim_mem_rdata=rdata_mem;

    assign cosim_br_taken={3'b0,ifjump};
    assign cosim_npc=next_pc;

    CSRModule csrmodule(
        .clk(clk),
        .rst(rst),
        .csr_we_wb(MEMWB_csr_decode[0]&MEMWB_csr_decode[1]),//1
        .csr_addr_wb(MEMWB_inst[31:20]),//12
        .csr_val_wb(MEMWB_csr_val),//64
        .csr_addr_id(csr_decode[9]?12'h305:IFID_inst[31:20]),//12
        .csr_val_id(csr_read_val),//o 64

        .pc_wb(cosim_pc),//64
        .inst_wb(cosim_inst),
        .valid_wb(MEMWB_valid),//1
        .time_out(time_out),
        .csr_ret_wb(MEMWB_csr_decode[6:5]),//2
        .csr_we_wb_temp(),
        .except_wb(except_final),

        .priv(priv),//o
        .switch_mode(switch_mode),//o
        .pc_csr(pc_csr),//o
        
        .cosim_interrupt(cosim_interrupt),//o
        .cosim_cause(cosim_cause),//o
        .cosim_csr_info(cosim_csr_info)//o
    );

    InstExamine IFIDexamine(
        .PC_i(IFID_pc),
        .priv_i(priv),
        .is_ecall_id_i(csr_decode[9]),
        .is_ebreak_id_i(0),
        .illegal_id_i(0),
        .inst_i(IFID_inst),
        .valid_i(IFID_valid),
        .except_o(except_id)
    );

    IDExceptExamine IDEXexamine(
        .clk(clk),
        .rst(rst),
        .stall(stall_IFID),
        .flush(flush_IFID),
        
        .pc_id(IFID_pc),
        .priv(priv),
        .is_ecall_id(0),
        .is_ebreak_id(0),
        .illegal_id(0),
        .inst_id(IFID_inst),
        .valid_id(IFID_valid),

        .except_id(except_id),
        .except_exe(except_exe),
        .except_happen_id(except_happen_id)
    );

    RaceController racecontroller(
        .clk(!clk),
        .rstn(rstn),
        .ID_reg_read1(reg_read1),
        .ID_reg_read2(reg_read2),
        .IFID_rs1(IFID_inst[19:15]),
        .IFID_rs2(IFID_inst[24:20]),
        .IDEX_rd(IDEX_inst[11:7]),
        .IDEX_we(IDEX_decoded[21]),
        .ifload(IDEX_inst[6:0]==7'b0110111),
        .ifjump(ifjump),
        .ifswitch(switch_mode),
        .if_stall(if_stall),
        .mem_stall(mem_stall),
        .stall_PC(stall_pc),
        .stall_IFID(stall_IFID),
        .stall_IDEX(stall_IDEX),
        .stall_EXMEM(stall_EXMEM),
        .stall_MEMWB(),
        .flush_IFID(flush_IFID),
        .flush_IDEX(flush_IDEX),
        .flush_EXMEM(flush_EXMEM),
        .flush_MEMWB(flush_MEMWB)
    );

    Forwarding forwarding(
        .ID_rs1(IFID_inst[19:15]),
        .ID_rs2(IFID_inst[24:20]),
        .EX_rd(IDEX_inst[11:7]),
        .MEM_rd(EXMEM_inst[11:7]),
        .WB_rd(MEMWB_inst[11:7]),
        .EX_we(IDEX_decoded[21]),
        .MEM_we(EXMEM_decoded[21]),
        .WB_we(MEMWB_decoded[21]),
        .init_read_data_1(init_read_data_1),
        .init_read_data_2(init_read_data_2),
        .EX_alu_res(alu_res),
        .MEM_wdata(MEM_rd_data),
        .WB_wdata(cosim_rd_data),
        .read_data_1(read_data_1),
        .read_data_2(read_data_2)
    );

    always @(posedge clk) begin
        if(rstn==0)begin
            inst_wait_reg <= 0;
        end
        if(inst_wait_reg == 0)begin
            if(ifjump)begin
                inst_wait_reg <= 1;
            end
        end
    end

    always @(posedge clk) begin
        if(~rstn) begin
            IF_pc <= 64'b0;
            IFID_pc <= 64'b0;
            IDEX_pc <= 64'b0;
            EXMEM_pc <= 64'b0;
            MEMWB_pc <= 64'b0;
            IFID_inst <= 32'h13;
            IDEX_inst <= 32'h13;
            EXMEM_inst <= 32'h13;
            MEMWB_inst <= 32'h13;
            EXMEM_decoded <= 0;
            IDEX_decoded <= 0;
            MEMWB_decoded <= 0;
            IF_valid <= 1;
            if_request_reg <= 1;
            IFID_valid <= 0;
            IDEX_valid <= 0;
            EXMEM_valid <= 0;
            MEMWB_valid <= 0;
        end
        else begin
            if(if_request_reg == 1)begin
                if_request_reg <= 0;
            end
            /*
            if(except_wb.epc != 0)begin
                except_final <= except_wb;
            end
            
            if(stall_EXMEM)begin
                MEMWB_pc <= 0;
                MEMWB_inst <= 32'h13;
                MEMWB_decoded <= 0;
                MEMWB_valid <= 0;
                MEMWB_csr_decode <= 0;
                MEMWB_csr_val <= 0;
                except_wb.except <= 0;
            end
            else begin
                MEMWB_pc <= EXMEM_pc;
                MEMWB_inst <= EXMEM_inst;
                MEMWB_decoded <= EXMEM_decoded;
                MEMWB_wdata <= MEM_rd_data;
                MEMWB_alu_res <= EXMEM_alu_res;
                MEMWB_imm <= EXMEM_imm;
                MEMWB_valid <= EXMEM_valid;
                MEMWB_csr_decode <= EXMEM_csr_decode;
                MEMWB_csr_val <= csr_val;
                MEMWB_csr_read_val <= EXMEM_csr_read_val;
                except_wb <= except_mem;

                if(stall_IDEX)begin
                    EXMEM_pc <= 0;
                    EXMEM_data_1 <= 0;
                    EXMEM_data_2 <= 0;
                    EXMEM_imm <= 0;
                    EXMEM_inst <= 32'h13;
                    EXMEM_decoded <= 0;
                    EXMEM_alu_res <= 0;
                    EXMEM_valid <= 0;
                    EXMEM_csr_decode <= 0;
                    except_mem.except <= 0;
                end
                else begin
                    EXMEM_pc <= IDEX_pc;
                    EXMEM_data_1 <= IDEX_data_1;
                    EXMEM_data_2 <= IDEX_data_2;
                    EXMEM_imm <= IDEX_imm;
                    EXMEM_inst <= IDEX_inst;
                    EXMEM_decoded <= IDEX_decoded;
                    EXMEM_alu_res <= alu_res;
                    EXMEM_valid <= IDEX_valid;
                    EXMEM_csr_decode <= IDEX_csr_decode;
                    EXMEM_csr_read_val <= IDEX_csr_read_val;
                    except_mem <= except_exe;

                    if(stall_IFID)begin
                        IDEX_pc <= 0;
                        IDEX_data_1 <= read_data_1;
                        IDEX_data_2 <= read_data_2;
                        IDEX_imm <= imm;
                        IDEX_inst <= 32'h13;
                        IDEX_decoded <= 0;
                        IDEX_valid <= 0;
                        IDEX_csr_decode <= 0;
                    end
                    else begin
                        IDEX_pc <= IFID_pc;
                        IDEX_data_1 <= read_data_1;
                        IDEX_data_2 <= read_data_2;
                        IDEX_imm <= imm;
                        IDEX_inst <= IFID_inst;
                        IDEX_decoded <= decoded;
                        IDEX_valid <= IFID_valid;
                        IDEX_csr_decode <= csr_decode;
                        IDEX_csr_read_val <= csr_read_val;

                        if(stall_pc||inst_wait)begin
                            IFID_pc <= 0;
                            IFID_inst <= 32'h13;
                            IFID_valid <= 0;

                            if(stall_pc == 0) begin
                                inst_wait <= 0;
                            end
                        end else begin
                            IFID_pc <= pc;
                            IFID_inst <= inst;
                            IFID_valid <= IF_valid;
                            IF_pc <= cosim_npc;
                            IF_valid <= 1;
                            if_request_reg <= 1;
                        end
                    end
                end
            end

            if(flush_IFID)begin
                IFID_pc <= 0;
                IFID_inst <= 32'h13;
                IFID_valid <= 0;
                if(MEMWB_csr_decode[9] == 0)begin
                    IF_pc <= cosim_npc;
                    if_request_reg <= 1;
                end
            end
            if(flush_IDEX)begin
                IDEX_pc <=0;
                IDEX_inst <= 32'h13;
                IDEX_decoded <= 0;
                IDEX_csr_decode <= 0;
                IDEX_valid <= 0;
            end
            if(flush_EXMEM)begin
                EXMEM_pc <= 0;
                EXMEM_inst <= 32'h13;
                EXMEM_decoded <= 0;
                EXMEM_csr_decode <= 0;
                EXMEM_valid <= 0;
            end
            */

            if(stall_EXMEM)begin
                MEMWB_pc <= 0;
                MEMWB_inst <= 32'h13;
                MEMWB_decoded <= 0;
                MEMWB_valid <= 0;
                MEMWB_csr_decode <= 0;
                MEMWB_csr_val <= 0;
                except_wb.except <= 0;
            end else begin
                MEMWB_pc <= EXMEM_pc;
                MEMWB_inst <= EXMEM_inst;
                MEMWB_decoded <= EXMEM_decoded;
                MEMWB_wdata <= MEM_rd_data;
                MEMWB_alu_res <= EXMEM_alu_res;
                MEMWB_imm <= EXMEM_imm;
                MEMWB_valid <= EXMEM_valid;
                MEMWB_csr_decode <= EXMEM_csr_decode;
                MEMWB_csr_val <= csr_val;
                MEMWB_csr_read_val <= EXMEM_csr_read_val;
                except_wb <= except_mem;

                EXMEM_pc <= IDEX_pc;
                EXMEM_data_1 <= IDEX_data_1;
                EXMEM_data_2 <= IDEX_data_2;
                EXMEM_imm <= IDEX_imm;
                EXMEM_inst <= IDEX_inst;
                EXMEM_decoded <= IDEX_decoded;
                EXMEM_alu_res <= alu_res;
                EXMEM_valid <= IDEX_valid;
                EXMEM_csr_decode <= IDEX_csr_decode;
                EXMEM_csr_read_val <= IDEX_csr_read_val;
                except_mem <= except_exe;

                IDEX_pc <= IFID_pc;
                IDEX_data_1 <= read_data_1;
                IDEX_data_2 <= read_data_2;
                IDEX_imm <= imm;
                IDEX_inst <= IFID_inst;
                IDEX_decoded <= decoded;
                IDEX_valid <= IFID_valid;
                IDEX_csr_decode <= csr_decode;
                IDEX_csr_read_val <= csr_read_val;

                if(if_stall||inst_wait_reg)begin
                    IFID_pc <= 0;
                    IFID_inst <= 32'h13;
                    IFID_valid <= 0;
                    if(stall_pc == 0) begin
                        // ifjump之后，inst_wait保持为1
                        // 直到stall_pc归零一次，即要舍弃的inst流过去，inst_wait也就归零
                        inst_wait_reg <= 0;
                    end
                end else begin
                    IFID_pc <= pc;
                    IFID_inst <= inst;
                    IFID_valid <= IF_valid;
                    IF_pc <= cosim_npc;
                    IF_valid <= 1;
                    if_request_reg <= 1;
                end
            end

            if(flush_IFID)begin
                IFID_pc <= 0;
                IFID_inst <= 32'h13;
                IFID_valid <= 0;
                // if(MEMWB_csr_decode[9] == 0)begin
                //     IF_pc <= cosim_npc;
                //     if_request_reg <= 1;
                // end
                IF_pc <= cosim_npc;
                if_request_reg <= 1;
            end
            if(flush_IDEX)begin
                IDEX_pc <=0;
                IDEX_inst <= 32'h13;
                IDEX_decoded <= 0;
                IDEX_csr_decode <= 0;
                IDEX_valid <= 0;                            
                // if(stall_pc == 0) begin
                //     inst_wait <= 0;
                // end
            end
            if(flush_EXMEM)begin
                EXMEM_pc <= 0;
                EXMEM_inst <= 32'h13;
                EXMEM_decoded <= 0;
                EXMEM_csr_decode <= 0;
                EXMEM_valid <= 0;
            end
        end
    end

    CropStore cropstore(
        .ifcrop(EXMEM_inst[6:0] == 7'b0100011),
        .EXMEM_alu_res(EXMEM_alu_res_wire),
        .EXMEM_decoded(EXMEM_decoded_wire),
        .EXMEM_data_2(EXMEM_data_2),
        .wmask(wmask_mem),
        .mem_wdata(wdata_mem)
    );

    CropLoad cropload(
        .ifcrop(EXMEM_inst[6:0] == 7'b0000011),
        .EXMEM_alu_res(EXMEM_alu_res_wire),
        .EXMEM_decoded(EXMEM_decoded_wire),
        .cosim_mem_rdata(rdata_mem),
        .mem_rdata(mem_rdata)
    );

    MuxPC mux_pc (
        .I0(pc + 4),
        .I1(pc_csr),
        .I2(EXMEM_csr_read_val),
        .I3(jmp_addr),
        .s(EXMEM_decoded[19]),
        .b_op(EXMEM_decoded[11:9]),
        .alu_res(EXMEM_alu_res),
        .ifecall(EXMEM_csr_decode[9]),
        .ifcsr(switch_mode),
        .ifjump(ifjump_mux),
        .o(next_pc)
    );

    Control ctrl(
        .inst(IFID_inst),
        .decode(decoded),
        .reg_read1(reg_read1),
        .reg_read2(reg_read2),
        .csr_decode(csr_decode)
    );

    Regs regs (
        .clk(clk),
        .rst(rst),
        .we(MEMWB_decoded[21]&cosim_valid),
        .read_addr_1(IFID_inst[19:15]),
        .read_addr_2(IFID_inst[24:20]),
        .write_addr(MEMWB_inst[11:7]),
        .write_data(MEMWB_wdata),
        .read_data_1(init_read_data_1),
        .read_data_2(init_read_data_2),
        .cosim_regs(cosim_regs)
    );

    ImmGen immgen (
        .immgen_op(decoded[18:16]),
        .inst(IFID_inst),
        .imm(imm)
    );

    Mux4x64 mux4x64_1 (
        .I0(0),
        .I1(IDEX_data_1),
        .I2(IDEX_pc),
        .I3(),
        .s(IDEX_decoded[8:7]),
        .o(mux_out_1)
    );

    Mux4x64 mux4x64_2 (
        .I0(0),
        .I1(IDEX_data_2),
        .I2(IDEX_imm),
        .I3(),
        .s(IDEX_decoded[6:5]),
        .o(mux_out_2)
    );

    Mux2x64 mux_csr_b(
        .I0(IDEX_data_1),
        .I1({59'b0,IDEX_inst[19:15]}),
        .s(IDEX_csr_decode[2]),
        .o(csr_alu_b)
    );

    ALU alu (
        .a(mux_out_1),
        .b(mux_out_2),
        .type_i(IDEX_inst[6:0]),
        .alu_op(IDEX_decoded[15:12]),
        .ifunsigned((IDEX_decoded[11:9]==3'b110)|(IDEX_decoded[11:9]==3'b101)),
        .res(alu_res)
    );

    CSRALU csr_alu(
        .a(IDEX_csr_read_val),
        .b(csr_alu_b),
        .alu_op(IDEX_csr_decode[8:7]),
        .res(csr_alu_res)
    );

    Mux4x64 mux4x64_mem (
        .I0(EXMEM_csr_decode[0]?EXMEM_csr_read_val:mem_rdata),
        .I1(EXMEM_alu_res),
        .I2(EXMEM_imm),
        .I3(EXMEM_pc + 4),
        .s(EXMEM_decoded[4:3]),
        .o(MEM_rd_data)
    );

    Mux4x64 mux_csr(
        .I0(EXMEM_data_1),
        .I1(EXMEM_csr_alu_res),
        .I2({59'b0,EXMEM_inst[19:15]}),
        .I3(),
        .s(EXMEM_csr_decode[4:3]),
        .o(csr_val)
    );
endmodule
