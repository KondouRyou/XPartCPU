module Control(
  input [31:0] inst,
  output wire [21:0] decode,
  output reg reg_read1,
  output reg reg_read2,
  output wire [9:0] csr_decode
);
  reg we_reg, we_mem, npc_sel;
  reg [1:0] alu_asel, alu_bsel, wb_sel;
  reg [2:0] immgen_op, bralu_op, memdata_width;
  reg [3:0] alu_op;

  reg if_csr,csr_we,csr_alu_bsel,ifecall;
  reg [1:0] csr_sel,csr_ret,csr_alu;
  //sel 0 for reg, 1 for alu, 2 for imm
  //alu 0 for none, 1 for or, 2 for and

  reg [6:0] op_code;
  reg [2:0] funct3;
  reg [6:0] funct7;
  reg [11:0] csr;
  always @(*) begin
    op_code = inst[6:0];
    funct3 = inst[14:12];
    funct7 = inst[31:25];
    csr = inst[31:20];
    we_reg = 0;
    we_mem = 0;
    npc_sel = 0;
    bralu_op = 0;
    alu_op = 0;
    alu_asel = 2'b01;
    alu_bsel = 2'b01;
    memdata_width = 3'b010;
    reg_read1 = 0;
    reg_read2 = 0;
    if_csr = 0;
    csr_we = 1;
    csr_ret = 2'b00;
    ifecall = 0;
    case (op_code)
      7'b1110011:begin//system
        case(funct3)
          3'b000:begin
            case(csr)
              12'b000000000000:begin//ecall
                ifecall = 1;
              end
              12'b000000000010:begin//uret
              end
              12'b000100000010:begin//sret
                csr_ret[0] = 1;
              end 
              12'b001100000010:begin//mret
                csr_ret[1] = 1;
              end
              default:begin
                
              end
            endcase
          end
          3'b001:begin//csrrw
            if_csr = 1;
            csr_sel = 2'b00;
            csr_alu = 2'b00;
            csr_alu_bsel = 0;
            wb_sel = 2'b00;
            we_reg = 1;
          end
          3'b010:begin//csrrwi
            if_csr = 1;
            csr_sel = 2'b10;
            csr_alu = 2'b00;
            csr_alu_bsel = 1;
            wb_sel = 2'b00;
            we_reg = 1;
          end
          3'b011:begin//csrrs
            if_csr = 1;
            csr_sel = 2'b01;
            csr_alu = 2'b01;
            csr_alu_bsel = 0;
            wb_sel = 2'b00;
            we_reg = 1;
          end
          3'b101:begin//csrrsi
            if_csr = 1;
            csr_sel = 2'b01;
            csr_alu = 2'b01;
            csr_alu_bsel = 1;
            wb_sel = 2'b00;
            we_reg = 1;
          end
          3'b110:begin//csrrc
            if_csr = 1;
            csr_sel = 2'b01;
            csr_alu = 2'b10;
            csr_alu_bsel = 0;
            wb_sel = 2'b00;
            we_reg = 1;
          end
          3'b111:begin//csrrci
            if_csr = 1;
            csr_sel = 2'b01;
            csr_alu = 2'b10;
            csr_alu_bsel = 1;
            wb_sel = 2'b00;
            we_reg = 1;
          end
          default:if_csr = 0;
        endcase
      end    
      7'b0110011:begin//R
        case(funct3)
            3'b000:begin
                if(funct7==0) alu_op = 4'b0000;//add
                else alu_op = 4'b0001;//sub
            end
            3'b001:alu_op = 4'b0111;//sll
            3'b010:alu_op = 4'b0101;//slt
            3'b011:alu_op = 4'b0110;//sltu
            3'b100:alu_op = 4'b0100;//xor
            3'b101:begin
                if(funct7==0) alu_op = 4'b1000;//srl
                else alu_op = 4'b1001;//sra
            end
            3'b110:alu_op = 4'b0011;//or
            3'b111:alu_op = 4'b0010;//and
        endcase
        we_reg = 1'b1;
        immgen_op = 0;
        wb_sel = 2'b01;
      end
      7'b0010011:begin//I
        case(funct3)
            3'b000:alu_op = 4'b0000;//addi
            3'b010:alu_op = 4'b0101;//slti
            3'b011:alu_op = 4'b0110;//sltiu
            3'b100:alu_op = 4'b0100;//xori
            3'b110:alu_op = 4'b0011;//ori
            3'b111:alu_op = 4'b0010;//andi
            3'b001:alu_op = 4'b0111;//slli
            3'b101:begin
                if(funct7==0) alu_op = 4'b1000;//srli
                else alu_op = 4'b1001;//srai
            end
        endcase
        we_reg = 1'b1;
        immgen_op = 3'b001;
        alu_bsel = 2'b10;
        wb_sel = 2'b01;
      end
      7'b0000011:begin//load
        we_reg = 1'b1;
        immgen_op = 3'b001;
        alu_bsel = 2'b10;
        wb_sel =2'b00;
        case(funct3)
          3'b000:memdata_width = 3'b100;//lb
          3'b001:memdata_width = 3'b011;//lh
          3'b010:memdata_width = 3'b010;//lw
          3'b011:memdata_width = 3'b001;//ld
          3'b100:memdata_width = 3'b111;//lbu
          3'b101:memdata_width = 3'b110;//lhu
          3'b110:memdata_width = 3'b101;//lwu
          default:memdata_width = 3'b001;//ldu
        endcase
      end
      7'b0100011:begin//s
        we_mem = 1'b1;
        immgen_op = 3'b010;
        alu_bsel = 2'b10;
        wb_sel = 2'b00;
        case(funct3)
          3'b000:memdata_width = 3'b100;//sb
          3'b001:memdata_width = 3'b011;//sh
          3'b010:memdata_width = 3'b010;//sw
          default:memdata_width = 3'b001;//sd
        endcase
      end
      7'b0010111:begin//auipc
        we_reg = 1'b1;
        immgen_op = 3'b100;
        alu_asel = 2'b10;
        alu_bsel = 2'b10;
        wb_sel = 2'b01;
      end
      7'b1101111:begin//j+jal
        we_reg = 1'b1;
        npc_sel = 1'b1;
        immgen_op = 3'b101;
        alu_asel = 2'b10;
        alu_bsel = 2'b10;
        wb_sel = 2'b11;
      end
      7'b1100011:begin//b
        npc_sel = 1'b1;
        immgen_op = 3'b011;
        case(funct3)
          3'b000:bralu_op = 3'b001;
          3'b001:bralu_op = 3'b010;
          3'b100:bralu_op = 3'b011;
          3'b101:bralu_op = 3'b100;//bltu
          3'b110:bralu_op = 3'b101;
          3'b111:bralu_op = 3'b110;
          default:bralu_op = 0;
        endcase
      end
      7'b0110111:begin //lui
        we_reg = 1'b1;
        immgen_op = 3'b100;
        wb_sel = 2'b10;
      end
      7'b0011011:begin //iw
        we_reg = 1'b1;
        immgen_op = 3'b001;
        alu_asel = 2'b01;
        alu_bsel = 2'b10;
        wb_sel = 2'b01;
        case(funct3)
          3'b000:begin
            case(funct7)
            7'b0000000:alu_op = 4'b0000;//addiw
            7'b0100000:alu_op = 4'b0001;//subiw
            default:alu_op = 4'b0000;
            endcase
          end
          3'b001:alu_op = 4'b0111;//slliw
          3'b101:begin
            if(inst[31:26]==6'b0) alu_op = 4'b1000;//srliw
            else alu_op = 4'b1001;//sraiw
          end
          default:alu_op = 4'b0000;
        endcase
      end
      7'b1100111:begin//jalr
        we_reg = 1'b1;
        immgen_op = 3'b001;
        alu_asel = 2'b01;
        alu_bsel = 2'b10;
        npc_sel = 1'b1;
        wb_sel = 2'b11;
      end
      7'b0111011:begin//w
        we_reg = 1'b1;
        immgen_op = 0;
        wb_sel = 2'b01;
        case(funct3)
          3'b000:begin
            case(funct7)
            7'b0000000:alu_op = 4'b0000;//addw
            7'b0100000:alu_op = 4'b0001;//subw
            default: alu_op = 0;
            endcase
          end
          3'b001:alu_op = 4'b0111;//sllw
          3'b101:begin
              if(funct7==0) alu_op = 4'b1000;//srlw
              else alu_op = 4'b1001;//sraw
          end
          default:alu_op = 0;
        endcase
      end
      default: alu_op = 0;
    endcase
    if(alu_asel == 2'b01) reg_read1 = 1;
    if(alu_bsel == 2'b01) reg_read2 = 1;
  end

  assign decode = {we_reg, we_mem, npc_sel, immgen_op, alu_op, bralu_op, alu_asel, alu_bsel, wb_sel, memdata_width};
  //assign csr_decode = {if_csr,csr_we,csr_alu_bsel,csr_sel,csr_ret,csr_alu};
  assign csr_decode = {ifecall,csr_alu,csr_ret,csr_sel,csr_alu_bsel,csr_we,if_csr};
endmodule