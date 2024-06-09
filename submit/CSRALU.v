module CSRALU(
    input [63:0] a,
    input [63:0] b,
    input [1:0] alu_op,
    output reg [63:0] res
);

reg [63:0] a_reg, b_reg;

always_latch @(*)begin
    if(alu_op == 2'b00)begin
        res = a;
    end
    else if(alu_op==2'b01)begin
        res = a|b;
    end
    else if(alu_op == 2'b10)begin
        res = a&b;
    end
end

endmodule