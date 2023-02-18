`define add 2'b00
`define sub 2'b01
`define bwa 2'b10
`define bn  2'b11

module ALU(input [15:0] val_A, input [15:0] val_B, input [1:0] ALU_op, output [15:0] ALU_out, output Z);

 reg [15:0] out;
 assign ALU_out = out;
 
 reg temp;
 assign Z=temp;
 always_comb begin
 case(ALU_op) 
 `add: out = val_A + val_B;
 `sub: out = val_A - val_B;
 `bwa: out = val_A & val_B;
 `bn:  out = ~val_B;
default: out = val_A + val_B;
endcase

if(ALU_out == 16'd0)
begin temp = 1'b1;
end
else begin
	temp = 1'b0;
end

end 
endmodule: ALU
