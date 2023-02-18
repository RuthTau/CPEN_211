module tb_task2(output err);
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
    start_pc = 8'b00000101;

    //cycle 1-4
    #10
    #10
    #10
    #10

    //three cycles for mov
    #10
    #10
    #10

    //two more cycle to return to datapath from ram
    #10
    #10

    //three cycles for mov
    #10
    #10
    #10
    $display("test that output is correct and LDR is functioning");
    assert(out === 16'd3) $display("PASS! output = 3");
    else begin
      $error("test FAIL: output should = 3");
      temp_err = 1'b1;
    end

    #10

    //three cycles for mov
    #10
    #10
    #10

    //two more cycles to return to datapath from ram
    #10
    #10

    //asserting rst_n during processing
    rst_n = 1'b0;
    #10

    //cycle 1-4 (to go through through ram and get to datapath)
    #10
    #10
    #10
    #10

    //three cycles for mov
    #10
    #10
    #10

    //two more cycle to return to datapath from ram
    #10
    #10

    //three cycles for mov
    #10
    #10
    #10
    $display("test that output is correct after asserting resert partway through process");
    assert(out === 16'd4) $display("PASS! output = 4");
    else begin
      $error("test FAIL: output should = 4");
      temp_err = 1'b1;
    end

    #10
    //should be in HALT state here

    $stop;
  end
  assign err = temp_err;

endmodule: tb_task2
