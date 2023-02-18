module tb_cpu(output err);
  // your implementation here

  `define one 1'b1
  `define zero 1'b0

  reg clk, rst_n, load, start;
  reg [15:0] instr;
  wire waiting, N, V, Z;
  wire [15:0] out;

  cpu dut(.clk, .rst_n, .load, .start, 
          .instr, .waiting, .out, .N, .V, .Z);


  reg temp_err;


  initial begin   
    clk = `zero;
    forever begin
      #5 clk = ~clk;
    end
  end

  initial begin
    //CASE 1: R[Rd] = R[Rn] + sh_Rm

    /*cycle 1*/
    instr = 16'b1010001011010011; // ALU, addition, Rn = 010 (r2), Rd = 110 (r5), shift = 10 (/2), Rm = 011 (r3)
    load = `one;
    start = `one;
    
    #10

    /*cycle 2*/
    start = `zero;

    #10

    //addition should take 4 cycles

    /*cycle 3*/
    #10

    /*cycle 4*/
    #10

    /*cycle 5*/

    //test 1: that wait state is low during processing
    assert(waiting === `zero) $display("test 1 PASS! waiting is = 0");
      else begin
        $error("test 1 FAIL: waiting should be low/=0");
        temp_err = `one;
      end
    #10

    /*cycle 6 */
    #10

    /*cycle 7*/

    //test 2: that wait state is high after expected end of processing
    assert(waiting === `one) $display("test 2 PASS! waiting is = 1");
      else begin
        $error("test 2 FAIL: waiting should be high/=1");
        temp_err = `one;
      end
    #10

    //CASE 2: R[Rn] = sx(imm8)

    /*cycle 1*/
    instr = 16'b1101001000000001; // MOV immediate, op = 10, Rn = 010 (r2), imm8  
    load = `one;
    start = `one;
    
    #10

    /*cycle 2*/
    start = `zero;

    #10

    //mov immediate should happen immediately

    /*cycle 3*/
    #10

    /*cycle 4*/

    //test 3: that mov immediate executed
    assert(waiting === `one) $display("test 3 PASS! waiting is = 1");
      else begin
        $error("test 3 FAIL: waiting should be high/=1");
        temp_err = `one;
      end

    #10

    //CASE 3: testing rst_n works

    /*cycle 1*/
    instr = 16'b1010001011001011; // ALU, addition, Rn = 010 (r2), Rd = 110 (r5), shift = 01 (*2), Rm = 011 (r3)
    load = `one;
    start = `one;
    
    #10

    /*cycle 2*/
    start = `zero;

    #10

    //addition should take 4 cycles

    /*cycle 3*/
    #10

    /*cycle 4*/
    rst_n = `one;
    #10

    /*cycle 5*/

    //test 4: that wait state is high after rst_n asserted
    assert(waiting === `one) $display("test 4 PASS! waiting is = 1");
      else begin
        $error("test 4 FAIL: waiting should be high/=1");
        temp_err = `one;
      end
    #10



    $stop;
  end

  assign err = temp_err;

endmodule: tb_cpu
