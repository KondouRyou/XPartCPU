`timescale 1ns / 1ps

module Mux2x64 (
    input [63:0] I0,
    input [63:0] I1,
    input s,
    output [63:0] o
);
    assign o = s ? I1 : I0;
endmodule

module Mux4x64 (
    input [63:0] I0,
    input [63:0] I1,
    input [63:0] I2,
    input [63:0] I3,
    input [1:0] s,
    output [63:0] o
);
    reg [63:0] out;
    always @(*) begin
        case (s)
            2'b00: out = I0;
            2'b01: out = I1;
            2'b10: out = I2;
            2'b11: out = I3;
            default:out = 0;
        endcase
    end
    assign o = out;
endmodule

module MuxPC (
    input [63:0] I0,         // pc+4
    input [63:0] I1,         // csr
    input [63:0] I2,         // trap
    input [63:0] I3,         // branch
    input s,          // pc_src
    input [2:0] b_op,
    input [63:0] alu_res,    // alu
    input ifecall,
    input ifcsr,
    output ifjump,
    output [63:0] o           // ??? pc
);
    reg ifjump_reg;
    reg [63:0] out;
    assign ifjump = ifjump_reg;
    always @(*) begin
        ifjump_reg = 0;
        if(ifcsr) begin
            out = I1;
            ifjump_reg = 1;
        end
        else if(ifecall) begin
            out = I2;
            ifjump_reg = 1;
        end
        else if (b_op==3'b001) begin // beq
            if (alu_res == 64'b0) begin
                out = I3;
                ifjump_reg=1;
            end
            else out = I0;
        end
        else if(b_op==3'b010) begin // bne
            if (alu_res == 64'b0) out = I0;
            else begin 
                out = I3;
                ifjump_reg=1;
            end
        end
        else if(b_op==3'b011)begin //blt
            if(alu_res[63] == 1'b1) begin
                out = I3;
                ifjump_reg=1;
            end
            else out = I0;
        end
        else if(b_op==3'b100)begin //bge
            if(alu_res[63] == 1'b0) begin
                out = I3;
                ifjump_reg=1;
            end
            else out = I0;
        end
        else if(b_op==3'b101)begin //bltu
            if(alu_res[0] == 1'b0) begin
                out = I3;
                ifjump_reg=1;
            end
            else out = I0;
        end
        else if(b_op==3'b110)begin //bgeu
            if(alu_res[0] == 1'b1) begin
                out = I3;
                ifjump_reg=1;
            end
            else out = I0;
        end
        else case (s)
            1'b0: out = I0;
            1'b1: begin
                out = alu_res;
                ifjump_reg=1;
            end
        endcase
    end
    assign o = out;
endmodule