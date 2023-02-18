module tb_idecoder(output err);
  // your implementation here
  reg [15:0] ir, sximm5, sximm8;
  reg [1:0] reg_sel, ALU_op, shift_op;
  reg [2:0] opcode, w_addr, r_addr;

  idecoder dut( .ir, .reg_sel, .opcode, .ALU_op, .shift_op,
                .sximm5, .sximm8, .r_addr, .w_addr);


  reg temp_err;

  initial begin
    ir = 16'b0011001100110011;
    #5;
    //test 1: that opcode is correct
    assert(opcode === ir[15:13]) $display("test 1 PASS! opcode = ir[15:13]");
      else begin
        $error("test 1 FAIL: opcode should = ir[15:13]");
        temp_err = 1'b1;
      end

    #5

    //test 2: that ALU_op is correct
    assert(ALU_op === 2'b10) $display("test 2 PASS! alu_op = ir[12:11]");
      else begin
        $error("test 2 FAIL:alu_op should = ir[12:11]");
        temp_err = 1'b1;
      end

    #5

    //test 3: that shift_op is correct
    assert(shift_op === 2'b10) $display("test 3 PASS! shift_op = ir[4:3]");
      else begin
        $error("test 3 FAIL: shift_op should = ir[4:3]");
        temp_err = 1'b1;
      end

    #5

    //test 4: that imm8 is sign-extended properly
    assert(sximm8 === 16'b0000000000110011) $display("test 4 PASS! sximm = 16'b0000000000110011");
      else begin
        $error("test 4 FAIL: sximm8 should = 16'b0000000000110011");
        temp_err = 1'b1;
      end

    #5

    //test 5: that imm5 is sign-extended properly
    assert(sximm5 === 16'b1111111111110011) $display("test 5 PASS! sximm5 = 16'b1111111111110011");
      else begin
        $error("test 5 FAIL: sximm5 should = 16'b1111111111110011");
        temp_err = 1'b1;
      end

    #5

    //test 6: that Rm is selected and outputted properly
    reg_sel = 2'b00;
    #5

    assert(w_addr === ir[2:0] && r_addr === ir[2:0]) $display("test 6 PASS! w_addr and r_addr = ir[2:0]");
      else begin
        $error("test 6 FAIL: w_addr and r_addr should = ir[2:0]");
        temp_err = 1'b1;
      end

    #5

    //test 7: that Rd is selected and outputted properly
    reg_sel = 2'b01;
    #5

    assert(w_addr === ir[7:5] && r_addr === ir[7:5]) $display("test 7 PASS! w_addr and r_addr = ir[7:5]");
      else begin
        $error("test 7 FAIL: w_addr and r_addr should = ir[7:5]");
        temp_err = 1'b1;
      end

    #5

    //test 8: that Rn is selected and outputted properly
    reg_sel = 2'b10;
    #5

    assert(w_addr === ir[10:8] && r_addr === ir[10:8]) $display("test 8 PASS! w_addr and r_addr = ir[10:8]");
      else begin
        $error("test 8 FAIL: w_addr and r_addr should = ir[10:8]");
        temp_err = 1'b1;
      end

    #5

    //test 9: that nothing happens when reg_sel = 11
    reg_sel = 2'b11;
    w_addr = 3'b0;
    r_addr = 3'b0;
    #5

    assert(w_addr === 3'b000 && r_addr === 3'b000) $display("test 9 PASS! w_addr and r_addr = 0");
      else begin
        $error("test 9 FAIL: w_addr and r_addr should = 0");
        temp_err = 1'b1;
      end
    
  end

  assign err = temp_err;

endmodule: tb_idecoder
