`define add 2'b00
`define sub 2'b01
`define bwa 2'b10
`define bn  2'b11

module ALU(input [15:0] val_A, input [15:0] val_B, input [1:0] ALU_op, output [15:0] ALU_out, output Z, output N, output V);

 reg [15:0] out;
 assign ALU_out = out;
 
 reg temp_Z, temp_N, temp_V;
 assign Z = temp_Z;
 assign N = temp_N;
 assign V = temp_V;
 
always_comb begin
 case(ALU_op) 
 `add: out = val_A + val_B;
 `sub: out = val_A - val_B;
 `bwa: out = val_A & val_B;
 `bn:  out = ~val_B;
default: out = {16{1'bx}};
endcase


//for Z
if(ALU_out == 16'd0)  
 temp_Z = 1'b1;
else 
  temp_Z = 1'b0;

//for N
if (ALU_out[15])
 temp_N = 1'b1;
else
 temp_N = 1'b0;

//for 'v' bit
if(((val_A[15] == 1'b0) && (val_B[15]== 1'b0)  && (out[15]== 1'b1) && (ALU_op ==2'b00) ) ||
((val_A[15] == 1'b1) && (val_B[15]== 1'b1)  && (out[15]== 1'b0) && (ALU_op ==2'b00) ) ||
((val_A[15] == 1'b1) && (val_B[15]== 1'b0)  && (out[15]== 1'b0) && (ALU_op ==2'b01) ))
temp_V = 1'b1;
else 
temp_V =1'b0;



end 
endmodule: ALU
