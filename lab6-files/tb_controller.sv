
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

wire waiting, w_en, en_A, en_B, en_C, en_status, sel_A, sel_B;
wire [1:0] reg_sel, wb_sel;

 controller dut (.clk(clk),  .rst_n(rst_n), .start(start),.opcode(opcode), 
                  .ALU_op(ALU_op), .shift_op(shift_op),
                   .Z(Z),  .N(N),  .V(V),
                   //outputs
                   .waiting(waiting),
                   .reg_sel(reg_sel), .wb_sel(wb_sel),  .w_en(w_en),
                   .en_A(en_A),  .en_B(en_B),  .en_C(en_C),  .en_status(en_status),
                   .sel_A(sel_A),  .sel_B(sel_B));

reg temp_err;
assign err = temp_err;

initial begin   
  clk = `zero;
  forever begin
      #5 clk = ~clk;
  end
end

initial begin
  //testing that reset works and stays in wait state until start asserted
    /*cycle 1*/
    start = 1'b0;
    rst_n = 1'b0;

    #10

    /*cycle 2 */
    rst_n = 1'b1;

    #10
    assert(waiting === 1'b1) $display("test PASS! wait_state = 1");
      else begin
        $error("test FAIL: wait_state should = 1");
        temp_err = 1'b1;
      end

    /*cycle 3*/
    #10

    /*cycle 4*/
    #10

    /*cycle 5*/
    //check that wait state is still high while start not asserted
    assert(waiting=== 1'b1) $display("test PASS! wait_state = 1");
      else begin
        $error("test FAIL: wait_state should = 1");
        temp_err = 1'b1;
      end

    #10

    /*cycle 6*/
    start = 1'b1;

    #10

    assert(waiting === 1'b0) $display("test PASS! wait_state = 0");
      else begin
        $error("test FAIL: wait_state should = 0");
        temp_err = 1'b1;
      end




// test if it stays in wait state
  rst_n = `zero; //reset the controller first
  #10
  start = `zero;
  #10
  $display("Check waiting state");

  assert({waiting, en_A, en_B, en_C, en_status, sel_A, sel_B, w_en, reg_sel,wb_sel} === 12'b100000000000 ) $display("[PASS] Correct wait state");
    else begin
      $error("[FAIL] Wrong wait state");
      temp_err = `one;
    end
  
  $display("Check at start then state is decode");
  rst_n = `one;
  #10
  start = `one;
  assert({waiting, en_A, en_B, en_C, en_status, sel_A, sel_B, w_en, reg_sel,wb_sel} === 12'b100000000000 ) $display("[PASS] Correct output decode state");
    else begin
      $error("[FAIL] Wrong output decode state");
      temp_err = `one;
    end
  
  //operation input 
  opcode  = 3'b110;
  ALU_op = 2'b00;
  shift_op = 2'b01;

  $display("Decode to Load B state");
  #10
  assert({waiting, en_A, en_B, en_C, en_status, sel_A, sel_B, w_en, reg_sel,wb_sel} ===  12'b0 ) $display("[PASS] Correct decode -> LOad B state");
    else begin
      $error("[FAIL] Wrong decode -> Load B state");
      temp_err = `one;
    end

  $display("Load B to ALU state");
 
  #10
  assert({waiting, en_A, en_B, en_C, en_status, sel_A, sel_B, w_en, reg_sel,wb_sel} ===  12'b001000000000 ) $display("[PASS] Correct Load B -> ALU state");
    else begin
      $error("[FAIL] Wrong Load B -> ALU state");
      temp_err = `one;
    end
  
  $display("ALU to writing state");
 
  #10
  assert({waiting, en_A, en_B, en_C, en_status, sel_A, sel_B, w_en, reg_sel,wb_sel} ===   12'b000101001100 ) $display("[PASS] Correct ALU -> write state");
    else begin
      $error("[FAIL] Wrong ALU -> write state");
      temp_err = `one;
    end
  
 $display("writing to wait state");
 
  #10
  assert({waiting, en_A, en_B, en_C, en_status, sel_A, sel_B, w_en, reg_sel,wb_sel} ===   12'b000000010100 ) $display("[PASS] Correct ALU -> write state");
    else begin
      $error("[FAIL] Wrong ALU -> write state");
      temp_err = `one;
    end

$display("Check at wait state");
start = `zero;
#10
assert({waiting, en_A, en_B, en_C, en_status, sel_A, sel_B, w_en, reg_sel,wb_sel} ===  12'b100000000000 ) $display("[PASS] Correct state");
    else begin
      $error("[FAIL] Wrong state");
      temp_err = `one;
    end



$stop;

end


endmodule: tb_controller


