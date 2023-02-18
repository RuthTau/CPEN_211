  module cpu(input clk, input rst_n, input start, input [15:0] instr,
           output waiting, output [15:0] out, output N, output V, output Z);


  wire [2:0] opwire, Z_out;
  wire [1:0] shiftwire, aluwire, wbWire;
  wire r_selwire, status, A, B, C, selA, selB, enWire;

  reg [15:0] ir_reg, temp_out;
  reg temp_wait;



  controller inst0(.clk(clk), .rst_n(rst_n), .start(start), .opcode(opwire), .ALU_op(aluwire), .shift_op(shiftwire),
                    .Z(Z_out[0]), .N(Z_out[1]), .V(Z_out[2]), .waiting(temp_wait), .reg_sel(r_selwire), .wb_sel(wbWire), .w_en(enWire), .en_A(A),
                    .en_B(B), .en_C(C), .en_status(status), .sel_A(selA), .sel_B(selB), .load_ir(load_ir));
						  
  datapath inst1(.clk(clk), .mdata(16'b0), .sximm8(sximm8), .sximm5(sximm5), .wb_sel(wbWire), .w_addr(w_addr), .w_en(enWire), 
                  .r_addr(r_addr), .en_A(A), .en_B(B), .shift_op(shiftwire), .sel_A(selA), .sel_B(selB), .ALU_op(aluwire), 
                  .en_C(C), .en_status(status), .datapath_out(temp_out), .Z_out(Z_out), .N_out(N_out), .V_out(V_out));

  idecoder inst2(.ir(ir_reg), .reg_sel(r_selwire), .opcode(opwire), .ALU_op(aluwire), .shift_op(shiftwire), 
                  .sximm5(sximm5), .sximm8(sximm8), .r_addr(r_addr), .w_addr(w_addr));

  
  
  

  always @(*) begin

  end

  always @(posedge clk) begin

      //for instruction register
      if(load_ir) begin
        ir_reg <= instr;
    end


    //for wait state during processing
    //if(temp_out != out) //how do i check if the instruction has been completed?
      //temp_wait <= 1'b1;
    //else
      //temp_wait <= 1'b0;


  end


  assign Z = Z_out[0];
  assign N = Z_out[1];
  assign V = Z_out[2];

  assign out = temp_out;
  assign waiting = temp_wait;

endmodule: cpu

