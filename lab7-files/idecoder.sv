module idecoder(input [15:0] ir, input [1:0] reg_sel,
                output [2:0] opcode, output [1:0] ALU_op, output [1:0] shift_op,
		output [15:0] sximm5, output [15:0] sximm8,
                output [2:0] r_addr, output [2:0] w_addr);

  // your implementation here

  reg [15:0] imm5_temp, imm8_temp;
  reg [4:0] imm5;
  reg [7:0] imm8;

  reg [2:0] r_temp, w_temp, ir_in;


  always @(*) begin 
        //reg_select mux        
        case (reg_sel)
        2'b00: //Rm
                ir_in = ir[2:0];
        2'b01: //Rd
                ir_in = ir[7:5];
        2'b10: //Rn
                ir_in = ir[10:8];
        default: //2'b11
                ir_in = ir_in;
        endcase
        w_temp = ir_in;
        r_temp = ir_in;

        //for imm5
        imm5 = ir[4:0];
        imm5_temp = { {11{ir[4]}}, ir[4:0] };

        //for imm8
        imm8 = ir[7:0];
        imm8_temp = { {8{ir[7]}}, ir[7:0] };

end

assign w_addr = w_temp;
assign r_addr = r_temp;

assign sximm5 = imm5_temp;
assign sximm8 = imm8_temp;

assign shift_op = ir[4:3];
assign ALU_op = ir[12:11];
assign opcode = ir[15:13];


endmodule: idecoder
