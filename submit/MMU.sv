module MMU (
    input wire clk,
    input wire rst,

    input wire [63:0] satp,

    input wire [63:0] pc,
    output wire [63:0] address1,
    input wire if_request_cpu,
    output wire if_request,
    input wire if_stall,
    input wire [63:0] data1,
    output wire trans_finish,

    input wire [63:0] mem_addr,
    output wire [63:0] address2,
    input wire mem_en_cpu,
    output wire mem_en
);

    reg [63:0] address1_reg;
    reg if_request_reg;
    reg [1:0] trans_state1,next_state1;
    reg finish1;

    wire   [3:0]   satp_mode;
    wire   [43:0]  satp_ppn;

    reg            pte_D_1, pte_A_1, pte_G_1, pte_U_1, pte_X_1, pte_W_1, pte_R_1, pte_V_1;
    reg    [1:0]   pte_RSW_1;
    reg    [25:0]  pte_PPN2_1;
    reg    [8:0]   pte_PPN1_1, pte_PPN0_1;
    reg    [9:0]   pte_reserved_1;

    wire   [8:0]   vpn2_1, vpn1_1, vpn0_1;
    wire   [11:0]  pgoff_1;

    reg            pte_D_2, pte_A_2, pte_G_2, pte_U_2, pte_X_2, pte_W_2, pte_R_2, pte_V_2;
    reg    [1:0]   pte_RSW_2;
    reg    [25:0]  pte_PPN2_2;
    reg    [8:0]   pte_PPN1_2, pte_PPN0_2;
    reg    [9:0]   pte_reserved_2;

    wire   [8:0]   vpn2_2, vpn1_2, vpn0_2;
    wire   [11:0]  pgoff_2;

    assign vpn2_1 = pc[38:30];
    assign vpn1_1 = pc[29:21];
    assign vpn0_1 = pc[20:12];
    assign pgoff_1 = pc[11:0];

    assign vpn2_2 = address2[38:30];
    assign vpn1_2 = address2[29:21];
    assign vpn0_2 = address2[20:12];
    assign pgoff_2 = address2[11:0];

    assign satp_mode = satp[63:60];
    assign satp_ppn = satp[43:0];

    assign trans_finish = finish1;

    always@(posedge clk)begin
        if(rst)begin
            trans_state1 = 2'b00;
            next_state1 = 2'b00;
        end else begin
            if(satp==64'b0)begin
                if(if_request_cpu&&~if_request)begin
                    address1_reg = pc;
                    if_request_reg <= 1;
                end else begin
                    if(if_request)begin
                        if_request_reg <= 0;
                    end
                end
            end else begin
                if(~if_stall) begin
                    trans_state1 = next_state1;
                    if (trans_state1 == 2'd0) begin
                        finish1 <= 1'b0;
                    end
                    if (finish1) begin
                        finish1 <= 1'b0;
                    end
                    case (trans_state1)
                        2'd0: begin
                            address1_reg = {8'b0, satp_ppn, vpn2_1, 3'b0};
                            next_state1 = 2'd1;
                            finish1 <= 1'b0;
                            if_request_reg <= 1;
                        end
                        2'd1: begin
                            {pte_reserved_1, pte_PPN2_1, pte_PPN1_1, pte_PPN0_1, pte_RSW_1, pte_D_1, pte_A_1, pte_G_1, pte_U_1, pte_X_1, pte_W_1, pte_R_1, pte_V_1} = data1[63:0];
                            if (pte_R_1 == 1 || pte_X_1 == 1) begin
                                address1_reg = {8'b0, pte_PPN2_1, vpn1_1, vpn0_1, pgoff_1};
                                next_state1 = 2'd0;
                                finish1 <= 1'b1;
                                if_request_reg <= 1;
                            end else begin
                                address1_reg = {8'b0, pte_PPN2_1, pte_PPN1_1, pte_PPN0_1, vpn1_1, 3'b0};
                                next_state1 = 2'd2;
                                finish1 <= 1'b0;
                                if_request_reg <= 1;
                            end
                        end
                        2'd2: begin
                            {pte_reserved_1, pte_PPN2_1, pte_PPN1_1, pte_PPN0_1, pte_RSW_1, pte_D_1, pte_A_1, pte_G_1, pte_U_1, pte_X_1, pte_W_1, pte_R_1, pte_V_1} = data1[63:0];
                            if (pte_R_1 == 1 || pte_X_1 == 1) begin
                                address1_reg = {8'b0, pte_PPN2_1, pte_PPN1_1, vpn0_1, pgoff_1};
                                next_state1 = 2'd0;
                                finish1 <= 1'b1;
                            end else begin
                                address1_reg = {8'b0, pte_PPN2_1, pte_PPN1_1, pte_PPN0_1, vpn0_1, 3'b0};
                                next_state1 = 2'd3;
                                finish1 <= 1'b0;
                                if_request_reg <= 1;
                            end
                        end
                        2'd3: begin
                            {pte_reserved_1, pte_PPN2_1, pte_PPN1_1, pte_PPN0_1, pte_RSW_1, pte_D_1, pte_A_1, pte_G_1, pte_U_1, pte_X_1, pte_W_1, pte_R_1, pte_V_1} = data1[63:0];
                            address1_reg = {8'b0, pte_PPN2_1, pte_PPN1_1, pte_PPN0_1, pgoff_1};
                            next_state1 = 2'd0;
                            finish1 <= 1'b1;
                            if_request_reg <= 1;
                        end
                    endcase
                end else if(if_request) begin
                    if_request_reg <= 0;
                end
                if(next_state1 == 2'd0)begin
                    finish1 <= 1;
                end else begin
                    finish1 <= 0;
                end
            end
        end
    end
    assign address1 = address1_reg;
    assign if_request = if_request_reg;

    reg [63:0] address2_reg;
    reg mem_en_reg;
    always@(posedge clk)begin
        if(mem_en_reg) begin
            mem_en_reg <= 0;
        end
        if(mem_en_cpu)begin
            if(satp == 64'b0)begin
                address2_reg <= mem_addr;
                mem_en_reg <= 1;
            end
        end
    end
    assign address2 = address2_reg;
    assign mem_en = mem_en_reg;

endmodule