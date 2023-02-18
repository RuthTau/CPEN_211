module tb_task1(output err);
  // your implementation here

  reg temp_err;
  reg clk, rst_n;
  reg [7:0] start_pc;
  
  wire [15:0] out;

  task1 dut(.clk, .rst_n, .start_pc, .out);

  initial begin   
    clk = 1'b0;
    forever begin
      #5 clk = ~clk;
    end
  end

  initial begin
    temp_err = 1'b0;

    start_pc = 8'b0;

    //cycle 1-4 (to go through through ram and get to datapath)
    #10
    #10
    #10
    #10

    //three cycles per mov
    #10
    #10
    #10

    //3 cycles to write and return from ram
    #10
    #10
    #10
    
    //mov
    #10
    #10
    #10

    //3 cycles to write and return from ram
    #10
    #10
    #10

    //three cycles for addition
    #10
    #10
    #10
    $display("test that output is correct after expected # of cycles");
    assert(out === 16'd5) $display("PASS! output = 5");
    else begin
      $error("test FAIL: output should = 5");
      temp_err = 1'b1;
    end

    //should be in HALT state here

    //add r5, r3, r5 --> this instruction should NOT be executed
    #10
    #10
    #10
    //if this add instruction were to be executed output = 8

    $display("test that instructions are not executed while in HALT state");
    assert(out === 16'd5) $display("PASS! output should still = 5"); //might need to change to !== 8
    else begin
      $error("test FAIL: output should still = 5");
      temp_err = 1'b1;
    end

    #10

    rst_n = 1'b0;
    #10
    #10
    #10

    //mov
    #10
    #10
    #10

    #10
    #10
    #10

    //add
    #10
    #10
    #10
    $display("test that we return to start_pc address while in HALT state when low reset");
    assert(out === 16'd5) $display("PASS! output is still = 5");
    else begin
      $error("test FAIL: output should still = 5");
      temp_err = 1'b1;
    end

    #10
  

    $stop;
  end

  assign err = temp_err;

endmodule: tb_task1
