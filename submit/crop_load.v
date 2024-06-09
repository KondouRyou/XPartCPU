`timescale 1ns / 1ps

module CropLoad(
    input wire ifcrop,
    input wire [63:0] EXMEM_alu_res,
    input wire [21:0] EXMEM_decoded,
    input wire [63:0] cosim_mem_rdata,
    output wire [63:0] mem_rdata
);

reg [2:0] mem_mod;
reg [63:0] cropped_data;

assign mem_rdata = cropped_data;

always_latch @(*)begin//l
  if(ifcrop)begin
    mem_mod = EXMEM_alu_res[2:0];
    case(EXMEM_decoded[2:0])
      3'b001:begin
        cropped_data = cosim_mem_rdata;
      end
      3'b010:begin
        case(mem_mod)
          3'd0:cropped_data = {{32{cosim_mem_rdata[31]}},cosim_mem_rdata[31:0]};
          3'd4:cropped_data = {{32{cosim_mem_rdata[63]}},cosim_mem_rdata[63:32]};
          default:cropped_data = 64'b0;
        endcase
      end
      3'b011:begin
        case(mem_mod)
          3'd0:cropped_data = {{48{cosim_mem_rdata[15]}},cosim_mem_rdata[15:0]};
          3'd2:cropped_data = {{48{cosim_mem_rdata[31]}},cosim_mem_rdata[31:16]};
          3'd4:cropped_data = {{48{cosim_mem_rdata[47]}},cosim_mem_rdata[47:32]};
          3'd6:cropped_data = {{48{cosim_mem_rdata[63]}},cosim_mem_rdata[63:48]};
          default:cropped_data = 64'b0;
        endcase
      end
      3'b100:begin
        case(mem_mod)
          3'd0:cropped_data = {{56{cosim_mem_rdata[7]}},cosim_mem_rdata[7:0]};
          3'd1:cropped_data = {{56{cosim_mem_rdata[15]}},cosim_mem_rdata[15:8]};
          3'd2:cropped_data = {{56{cosim_mem_rdata[23]}},cosim_mem_rdata[23:16]};
          3'd3:cropped_data = {{56{cosim_mem_rdata[31]}},cosim_mem_rdata[31:24]};
          3'd4:cropped_data = {{56{cosim_mem_rdata[39]}},cosim_mem_rdata[39:32]};
          3'd5:cropped_data = {{56{cosim_mem_rdata[47]}},cosim_mem_rdata[47:40]};
          3'd6:cropped_data = {{56{cosim_mem_rdata[55]}},cosim_mem_rdata[55:48]};
          3'd7:cropped_data = {{56{cosim_mem_rdata[63]}},cosim_mem_rdata[63:56]};
          default:cropped_data = 64'b0;
        endcase
      end
      3'b101:begin
        case(mem_mod)
          3'd0:cropped_data = {{32'b0},cosim_mem_rdata[31:0]};
          3'd4:cropped_data = {{32'b0},cosim_mem_rdata[63:32]};
          default:cropped_data = 64'b0;
        endcase
      end
      3'b110:begin
        case(mem_mod)
          3'd0:cropped_data = {{48'b0},cosim_mem_rdata[15:0]};
          3'd2:cropped_data = {{48'b0},cosim_mem_rdata[31:16]};
          3'd4:cropped_data = {{48'b0},cosim_mem_rdata[47:32]};
          3'd6:cropped_data = {{48'b0},cosim_mem_rdata[63:48]};
          default:cropped_data = 64'b0;
        endcase
      end
      3'b111:begin
        case(mem_mod)
          3'd0:cropped_data = {{56'b0},cosim_mem_rdata[7:0]};
          3'd1:cropped_data = {{56'b0},cosim_mem_rdata[15:8]};
          3'd2:cropped_data = {{56'b0},cosim_mem_rdata[23:16]};
          3'd3:cropped_data = {{56'b0},cosim_mem_rdata[31:24]};
          3'd4:cropped_data = {{56'b0},cosim_mem_rdata[39:32]};
          3'd5:cropped_data = {{56'b0},cosim_mem_rdata[47:40]};
          3'd6:cropped_data = {{56'b0},cosim_mem_rdata[55:48]};
          3'd7:cropped_data = {{56'b0},cosim_mem_rdata[63:56]};
          default:cropped_data = 64'b0;
        endcase
      end
      default:begin
        cropped_data = 64'b0;
      end
    endcase
  end
  else begin
    cropped_data = cosim_mem_rdata;
  end
end

endmodule