`timescale 1ns / 1ps

module CropStore(
    input wire ifcrop,
    input wire [63:0] EXMEM_alu_res,
    input wire [21:0] EXMEM_decoded,
    input wire [63:0] EXMEM_data_2,
    output wire [7:0] wmask,
    output wire [63:0] mem_wdata
);

reg [2:0] mem_mod;
reg [7:0] mask_reg;
reg [63:0] mem_wdata_reg;

assign wmask = mask_reg;
assign mem_wdata = mem_wdata_reg;

always_latch @(*)begin//s
  if(ifcrop)begin
    mem_mod = EXMEM_alu_res[2:0];
    case(EXMEM_decoded[2:0])
      3'b001:begin
        mask_reg = 8'hff;
        mem_wdata_reg = EXMEM_data_2;
      end
      3'b010:begin//sw
        mask_reg = 8'h0f<<mem_mod;
        mem_wdata_reg = (EXMEM_data_2<<(mem_mod*8));
      end
      3'b011:begin
        mask_reg = 8'h03<<mem_mod;
        mem_wdata_reg = (EXMEM_data_2<<(mem_mod*8));
      end
      3'b100:begin
        mask_reg = 8'h01<<mem_mod;
        mem_wdata_reg = (EXMEM_data_2<<(mem_mod*8));
      end
      default:begin
        mask_reg = 8'h00;
        mem_wdata_reg = EXMEM_data_2;
      end
    endcase
  end
end

endmodule
