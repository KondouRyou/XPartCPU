module MMU (
    input wire clk,
    input wire rst,
    input wire [63:0] satp,

    input wire [63:0] pc,
    output wire [63:0] address1,
    input wire if_request_cpu,
    output wire if_request,

    input wire [63:0] mem_addr,
    output wire [63:0] address2,
    input wire mem_en_cpu,
    output wire mem_en
);

    reg [63:0] address1_reg;
    reg if_request_reg;
    always@(posedge clk)begin
        if(if_request_cpu&&~if_request)begin
            if(satp==64'b0)begin
                address1_reg <= pc;
                if_request_reg <= 1;
            end
        end else if(if_request)begin
            if_request_reg <= 0;
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