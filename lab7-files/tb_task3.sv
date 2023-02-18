module tb_task3(output err);
  // your implementation here
  reg temp_err;
  reg clk, rst_n;
  reg [7:0] start_pc;

   
  wire [15:0] out;


  task2 dut(.clk, .rst_n, .start_pc, .out);

  initial begin   
    clk = 1'b0;
    forever begin
      #5 clk = ~clk;
    end
  end

  initial begin
    temp_err = 1'b0;
    start_pc = 8'b00001011;

    //cycle 1-4 (to go through through ram and get to datapath)
    #10
    #10
    #10
    #10

    //three cycles for initial mov
    #10
    #10
    #10

    //3 cycles for str
    #10
    #10
    #10

    //2 cycles for ldr
    #10
    #10

    //three cycles for mov
    #10
    #10
    #10
    $display("test that output is correct and STR is functioning");
    assert(out === 16'd2) $display("PASS! output = 2");
    else begin
      $error("test FAIL: output should = 2");
      temp_err = 1'b1;
    end
    #10 //should be in HALT state here

    rst_n = 1'b0;

    #10

     //cycle 1-4 (to go through through ram and get to datapath)
    #10
    #10
    #10
    #10

    //three cycles for initial mov
    #10
    #10
    #10

    //3 cycles for str
    #10
    #10
    #10

    //2 cycles for ldr
    #10
    #10

    //three cycles for mov
    #10
    #10
    #10
    $display("test that output is correct and STR and reset are working ");
    assert(out === 16'd2) $display("PASS! output = 2");
    else begin
      $error("test FAIL: output should = 2");
      temp_err = 1'b1;
    end


    //3 cycles for str
    #10
    #10
    #10

    //2 cycles for ldr
    #10
    #10

    //three cycles for mov
    #10
    #10
    #10
    $display("test that output is correct and STR is working with LSL");
    assert(out === 16'd4) $display("PASS! output = 4");
    else begin
      $error("test FAIL: output should = 2");
      temp_err = 1'b1;
    end
    $stop;
  end
  assign err = temp_err;
endmodule: tb_task3
