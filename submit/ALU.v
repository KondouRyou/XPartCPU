module ALU (
  input [63:0] a,
  input [63:0] b,
  input [6:0] type_i,
  input ifunsigned,
  input [3:0]  alu_op,
  output reg [63:0] res
);

reg [63:0]a1;
reg [63:0]b1;
always_latch @(*)begin
  if(type_i == 7'h1b||type_i == 7'b0111011)begin
    a1[63:32] = 32'b0;
    a1[31:0] = a[31:0];
    b1[63:0] = b[63:0];
  end
  else begin
    a1[63:0] = a[63:0];
    b1[63:0] = b[63:0];
  end
  if (alu_op == 4'b0111 || alu_op == 4'b1000 || alu_op ==4'b1001) begin
    if(type_i == 7'b0010011)b1={58'b0,b[5:0]};
    else b1 = {59'b0,b[4:0]};
  end
  if(type_i==7'b1100011)begin
    if(alu_op==4'b000) res=a1-b1;
    if(ifunsigned==1)begin
      if(a<b)res=64'b0;
      else res=64'b1;
    end
  end
  else begin
    case (alu_op)
      4'b0000: res = a1 + b1;
      4'b0001: res = a1 - b1;
      4'b0111: res = a1 << b1;
      4'b0101 :begin
        if(a1[63] == 0 && b1[63] == 1) res = 0;
        else if (a1[63] == 1 && b1[63] == 0) res = 1;
        else if (a1[63] == b1[63])begin
          if(a1[62:0] < b1[62:0])res = 1;
          else res = 0;
        end
      end
      4'b0110:begin
        if (a1 < b1) res = 1;
        else res = 0;
      end
      4'b0100: res = a1 ^ b1;
      4'b1000: res = a1 >> b1;
      4'b1001: begin 
        if(type_i ==7'h1b||type_i == 7'b0111011) a1[63:32] = {32{a[31]}};
        if(b!=64'b0) res = ($signed(a1)) >>> b1;
        else res = a1;
      end
      4'b0011: res = a1 | b1;
      4'b0010: res = a1 & b1;
      default: res = 0;
    endcase
  end
  if(type_i == 7'h1b||type_i == 7'b0111011)begin
    if(res[31])res[63:32]=32'hffffffff;
    else res[63:32] = 32'b0;
  end
end

endmodule