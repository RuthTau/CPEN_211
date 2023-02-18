
`define one 1'b1
`define zero 1'b0


`define WAIT_STATE 3'b000
`define DECODE_STATE 3'b001
`define LOAD_A 3'b010
`define LOAD_B 3'b011
`define ALU_STATE 3'b100
`define WRITE_STATE 3'b101

module tb_controller(output err);

reg clk, rst_n, start, Z, N, V;
reg [1:0] ALU_op, shift_op;
reg [2:0] opcode;

wire clear_pc, w_en, en_A, en_B, en_C, en_status, sel_A, sel_B,load_ir, load_addr,load_pc, sel_addr;
wire [1:0] reg_sel, wb_sel;

 controller dut (.clk(clk),  .rst_n(rst_n), .opcode(opcode), 
                  .ALU_op(ALU_op), .shift_op(shift_op),
                  
                   //outputs
                   .clear_pc(clear_pc),
                   .reg_sel(reg_sel), .wb_sel(wb_sel),  .w_en(w_en),
                   .en_A(en_A),  .en_B(en_B),  .en_C(en_C),  .en_status(en_status),
                   .sel_A(sel_A),  .sel_B(sel_B), .load_ir(load_ir), 
                   .load_addr(load_addr), .load_pc(load_pc), .sel_addr(sel_addr));

reg temp_err;
assign err = temp_err;

initial begin   
  clk = `zero;
  forever begin
      #5 clk = ~clk;
  end
end

// it will output a result before next clk 


initial begin

// test if it stays in wait state
  rst_n = `zero; //reset the controller first
  #10
  rst_n =`one;
  //operation input 
  opcode  = 3'b110;
  ALU_op = 2'b00;
  shift_op = 2'b01;


  $display("Check clear_pc state");

  assert( {clear_pc, en_A, en_B, en_C, en_status, sel_A, sel_B, w_en, reg_sel,wb_sel, load_ir,load_addr, load_pc,sel_addr} === 16'b1000000000001000 ) $display("[PASS] Correct clear_pc state");
    else begin
      $error("[FAIL] Wrong clear_pc state");
      temp_err = `one;
    end
  
  #10


  $display("Decode to Load B state");

  assert( {clear_pc, en_A, en_B, en_C, en_status, sel_A, sel_B, w_en, reg_sel,wb_sel, load_ir,load_addr, load_pc,sel_addr} ===  16'b0000000000000110 ) $display("[PASS] Correct decode -> LOad B state");
    else begin
      $error("[FAIL] Wrong decode -> Load B state");
      temp_err = `one;
    end
  
  #10

  $display("Load B to ALU state");
  
  assert( {clear_pc, en_A, en_B, en_C, en_status, sel_A, sel_B, w_en, reg_sel,wb_sel, load_ir,load_addr, load_pc,sel_addr}===   16'b0010000000000010) $display("[PASS] Correct Load B -> ALU state");
    else begin
      $error("[FAIL] Wrong Load B -> ALU state");
      temp_err = `one;
    end
  #10

  $display("ALU to writing state");

  assert( {clear_pc, en_A, en_B, en_C, en_status, sel_A, sel_B, w_en, reg_sel,wb_sel, load_ir,load_addr, load_pc,sel_addr} ===  16'b0001010011000011) $display("[PASS] Correct ALU -> write state");
    else begin
      $error("[FAIL] Wrong ALU -> write state");
      temp_err = `one;
    end
  #10

  $display("writing to wait state");
 
  assert( {clear_pc, en_A, en_B, en_C, en_status, sel_A, sel_B, w_en, reg_sel,wb_sel, load_ir,load_addr, load_pc,sel_addr} === 16'b0000000101000111 ) $display("[PASS] Correct ALU -> write state");
    else begin
      $error("[FAIL] Wrong ALU -> write state");
      temp_err = `one;
    end
  #10


  $display("Check at wait state");
  start = `zero;
  assert( {clear_pc, en_A, en_B, en_C, en_status, sel_A, sel_B, w_en, reg_sel,wb_sel, load_ir,load_addr, load_pc,sel_addr} === 16'b1000000000001000) $display("[PASS] Correct state");
    else begin
      $error("[FAIL] Wrong state");
      temp_err = `one;
    end
  #10


$stop;

end


endmodule: tb_controller


