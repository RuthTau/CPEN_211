module datapath(input clk, input [15:0] mdata, input [7:0] pc, input [1:0] wb_sel,
                input [2:0] w_addr, input w_en, input [2:0] r_addr, input en_A,
                input en_B, input [1:0] shift_op, input sel_A, input sel_B,
                input [1:0] ALU_op, input en_C, input en_status,
		            input [15:0] sximm8, input [15:0] sximm5,
                output [15:0] datapath_out, output Z_out, output N_out, output V_out);
  // your implementation here
   `define one 1'b1 
   `define zero 1'b0

  // wire for all output of modules and only reg for in use inside here
  // if its in input then no need to reg again
  // assign for all outputs

  reg [15:0] regA, regB, regC, val_A, val_B, w_data;
  wire [15:0] r_data, shift_out, ALU_out;
  reg regZ, regN, regV;
  wire Z,N,V;

  /*regfile instance*/
  regfile inst0(.w_data(w_data), .w_addr(w_addr), .w_en(w_en), .r_addr(r_addr), .clk(clk), .r_data(r_data));

  /*ALU instance*/
  ALU inst1(.val_A(val_A), .val_B(val_B), .ALU_op(ALU_op), .ALU_out(ALU_out), .Z(Z), .N(N), .V(V));

  /*shifter instance*/
  shifter inst2(.shift_in(regB), .shift_op(shift_op), .shift_out(shift_out));


  always @(*) begin

    //ser pc and mdata to 0
    /*mux 9*/ //might need to move this mux into sequential block
    case(wb_sel)
    2'b00: w_data = regC;
    2'b01: w_data = {8'b0, 16'b0};
    2'b10: w_data = sximm8;
    2'b11: w_data = 16'b0; //mdata

    default: begin
      if (en_C)
        w_data = regC;
      else
        w_data = w_data;
    end
    endcase

    /*mux 6*/
    case(sel_A)
    `one:
      val_A = 16'b0;
    default: begin
      if (en_A)
        val_A = regA;
      else  
        val_A = val_A;
    end
    endcase

    /*mux 7*/
    case(sel_B)
    `one:
      val_B = sximm5;
    default: begin
      val_B = shift_out;
    end
    endcase

  end


  always @(posedge clk) begin

    if(en_A) //same as en_A = 1'b1
      regA <= r_data;
    else  
      regA <= regA;

    if(en_B)
      regB <= r_data;
    else  
      regB <= regB;

    if(en_C)
      regC <= ALU_out;
    else
      regC <= regC;

    if(en_status) begin
      regZ <= Z;
      regN <= N;
      regV <= V;
    end
    else 
     begin 
      regZ <= regZ;
      regN <= regN;
      regV <= regV;
     end

  end

  assign datapath_out = regC;
  assign Z_out = regZ;
  assign N_out = regN;
  assign V_out = regV;

endmodule: datapath
