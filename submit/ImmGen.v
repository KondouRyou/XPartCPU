`timescale 1ns / 1ps

module ImmGen(
    input [2:0] immgen_op,
    input [31:0] inst,
    output  [63:0]  imm
);

    reg [63:0] out;
    reg [2:0] funct3;
    assign imm = out;
    always @(*) begin
        funct3 = inst[14:12];
        case (immgen_op)
            3'b000: out = 0;
            3'b001: case(funct3)
                3'b000:begin
                    if(inst[6:0]==7'b0011011) out = {{52{inst[31]}},inst[31:20]};//addiw
                    else out = {{52{inst[31]}}, inst[31:20]};//li
                end
                3'b001: begin
                    if(inst[6:0]==7'b0011011) out = {59'b0,inst[24:20]};//w
                    else out = {{52{inst[31]}},inst[31:20]};//lh
                end
                3'b101:begin
                    if(inst[6:0]==7'b0010011) out = {58'b0,inst[25:20]};//srli
	                else if(inst[6:0]==7'b0000011) out = {52'b0,inst[31:20]};//lhu
                    else if(inst[6:0]==7'b0011011) out = {59'b0,inst[24:20]};//srliw
                    else out = {{59{inst[24]}},inst[24:20]};
                end
                default: out = {{52{inst[31]}}, inst[31:20]};
            endcase
            3'b010: out = {{52{inst[31]}}, inst[31:25], inst[11:7]};
            3'b011: out = {{51{inst[31]}}, inst[31], inst[7], inst[30:25], inst[11:8], 1'b0};
            3'b100: out = {{32{inst[31]}}, inst[31:12], 12'b0};
            3'b101: out = {{43{inst[31]}}, inst[31], inst[19:12], inst[20], inst[30:21], 1'b0};
            default:out = 0;
        endcase
    end
endmodule
