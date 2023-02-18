module tb_datapath(output err);
  // your implementation here
reg clk;
reg [2:0] w_addr, r_addr;
reg [1:0] shift_op, ALU_op, wb_sel;
reg sel_A, sel_B;
reg w_en, en_A, en_B, en_C, en_status;
reg [7:0] pc;
reg [15:0] mdata,sximm8, sximm5;
wire [15:0] datapath_out;
wire Z_out, N_out, V_out;


// module datapath(input clk, input [15:0] mdata, input [7:0] pc, input [1:0] wb_sel,
//                 input [2:0] w_addr, input w_en, input [2:0] r_addr, input en_A,
//                 input en_B, input [1:0] shift_op, input sel_A, input sel_B,
//                 input [1:0] ALU_op, input en_C, input en_status,
// 		            input [15:0] sximm8, input [15:0] sximm5,
//                 output [15:0] datapath_out, output Z_out, output N_out, output V_out);


datapath dut(.clk(clk), .mdata(mdata), .pc(pc), .wb_sel(wb_sel),
                .w_addr(w_addr), .w_en(w_en), .r_addr(r_addr), .en_A(en_A),
                .en_B(en_B), .shift_op(shift_op), .sel_A(sel_A), .sel_B(sel_B),
                 .ALU_op(ALU_op), .en_C(en_C), .en_status(en_status),
                .sximm8(sximm8), .sximm5(sximm5), 
                .datapath_out(datapath_out), .Z_out(Z_out), .N_out(N_out), .V_out(V_out));

`define one 1'b1
`define zero 1'b0

reg temp_err;


initial begin   
  clk = `zero;
  forever begin
      #5 clk = ~clk;
  end
end

initial begin
  temp_err = `zero;

  /* CASE ONE: addition */

  //initializing r2 = 2
  sximm8 = 16'd2;
  wb_sel = 2'b10;
  w_en = `one;
  w_addr = 2'b10; //write to r2
  #10

  //initializing r3 = 3
  sximm8 = 16'd3;
  wb_sel = 2'b10;
  w_en = `one;
  w_addr = 2'b11; //write to r3
  #10


  /*cycle 1*/
  r_addr = 2'b10; //reads r2
  en_A = `one; en_B = `zero;
  w_en = `zero;

  #10
  /*cycle 2*/ 
  r_addr = 2'b11; //reads r3
  en_A = `zero; en_B = `one;
  w_en = `zero;
  
  #10
  /*cycle 3*/
  en_A = `zero; en_B = `zero;
  ALU_op = 2'b00; //addition
  sel_A = `zero; sel_B = `zero;
  shift_op = 2'b00; //no shift
  en_C = `one;
  en_status = `one;
  w_en = `zero;

  #10
  /*cycle 4*/
  en_A = `zero; en_B = `zero; en_C = `zero;
  w_en = `one;
  wb_sel = 2'b00;
  w_addr = 3'b101; //writes to r5

  #10
  //test that datapath_out is correct
  assert(datapath_out === 16'd5) $display("test PASS! outputting sum of r2 + r3 = 5");
    else begin
      $error("FAIL: datapath_out should = 5");
      temp_err = `one;
    end
  //test that status flop outputs 0 when datapath_out ~= 0
  assert(Z_out === `zero) $display("test PASS! Z_out is zero");
    else begin
      $error("FAIL: Z_out should be zero");
      temp_err = `one;
    end
  
   assert(N_out === `zero) $display("test PASS! N_out is zero");
    else begin
      $error("FAIL: N_out should be zero");
      temp_err = `one;
    end

    assert(V_out === `zero) $display("test PASS! V_out is zero");
    else begin
      $error("FAIL: V_out should be zero");
      temp_err = `one;
    end



  /* CASE TWO: LSR and subtraction*/

  //initializing r2 = 2
  sximm8 = 16'd2;
  wb_sel = 2'b10;
  w_en = `one;
  w_addr = 2'b10; //write to r2
  #10

 //initializing r3 = 4
  sximm8 = 16'd4;
  wb_sel = 2'b10;
  w_en = `one;
  w_addr = 2'b11; //write to r3
  #10

  /*cycle 1*/
  r_addr = 2'b10; //reads r2
  en_A = `one; en_B = `zero;
  w_en = `zero;

  #10
  /*cycle 2*/ 
  r_addr = 2'b11; //reads r3
  en_A = `zero; en_B = `one;
  w_en = `zero;

  #10
  /*cycle 3*/
  en_A = `zero; en_B = `zero;
  sel_A = `zero; sel_B = `zero;
  ALU_op = 2'b01; //subtraction
  shift_op = 2'b10; // LSR #1
  en_C = `one;
  en_status = `one;
  w_en = `zero;

  #10
  /*cycle 4*/
  en_A = `zero; en_B = `zero; en_C = `zero;
  w_en = `one;
  wb_sel = 2'b00;
  w_addr = 3'b101; //writes to r5

  #10
  //test that output is correct after shifting regB
  assert(datapath_out === `zero) $display("test PASS! outputting subtraction of 2 from 2");
    else begin
      $error("FAIL: datapath_out should be 2 - 2 = 0");
      temp_err = `one;
    end
  //test that status flop will output 1 when datapath_out = 0
  assert(Z_out === `one) $display("test PASS! Z_out is one");
    else begin
      $error("FAIL: Z_out should be one");
      temp_err = `one;
    end

  assert(N_out === `zero) $display("test PASS! N_out is zero");
    else begin
      $error("FAIL: N_out should be zero");
      temp_err = `one;
    end

    assert(V_out === `zero) $display("test PASS! V_out is zero");
    else begin
      $error("FAIL: V_out should be zero");
      temp_err = `one;
    end


  /* CASE THREE: mov  */

  //initializing r2 = 0
  sximm8 = 16'd0;
  wb_sel = 2'b10;
  w_en = `one;
  w_addr = 2'b10; //write to r2
  #10

  //initializing r3 = 4
  sximm8 = 16'd4;
  wb_sel = 2'b10;
  w_en = `one;
  w_addr = 2'b11; //write to r3
  #10

  /*cycle 1*/
  r_addr = 2'b10; //reads r2 to regA
  en_A = `one; en_B = `zero;
  w_en = `zero;
  
  #10
  /*cycle 2*/
  r_addr = 2'b11; //reads r3 to regB
  en_A = `zero; en_B = `one;
  w_en = `zero;

  #10
  /*cycle 3*/
  en_A = `zero; en_B = `zero;
  ALU_op = 2'b00; //addition 
  sel_A = `zero; sel_B = `zero;
  shift_op = 2'b00; //no shift
  en_C = `one;
  en_status = `one;
  w_en = `zero;

  #10
  /*cycle 4*/
  en_A = `zero; en_B = `zero; en_C = `zero;
  w_en = `one;
  wb_sel = 2'b00;
  w_addr = 2'b10; //writes to r2

  #10
  /*cycle 5*/
  r_addr = 2'b10; //reads r2 to regA
  en_A = `one; en_B = `zero;
  w_en = `zero;

  #10
  /*cycle 5.5*/
  r_addr = 2'b11; //reads r3 to regB
  en_A = `zero; en_B = `one;
  w_en = `zero;

  #10
  /*cycle 6*/
  en_A = `zero; en_B = `zero;
  sel_A = `zero; sel_B = `zero;
  ALU_op = 2'b01; //subtraction
  shift_op = 2'b00; // no shift
  en_C = `one;
  en_status = `one;
  w_en = `zero;

  #10
  /*cycle 7*/
  en_A = `zero; en_B = `zero; en_C = `zero;
  w_en = `one;
  wb_sel = 2'b00;
  w_addr = 3'b110; //writes to r6

  #10
  assert(datapath_out === `zero) $display("test PASS! moved r3 to r2, difference is zero");
    else begin
      $error("FAIL: after moving r3 to r2, difference should be zero");
      temp_err = `one;
    end

  /*Case FOUR: additon and overflow*/
  //initializing r2 = 2
 sximm8 = 16'b0101000000000000;
  wb_sel = 2'b10;
  w_en = `one;
  w_addr = 2'b10; //write to r2
  #10

  //initializing r3 = 3
  sximm8 = 16'b0101000000000000;
  wb_sel = 2'b10;
  w_en = `one;
  w_addr = 2'b11; //write to r3
  #10


  /*cycle 1*/
  r_addr = 2'b10; //reads r2
  en_A = `one; en_B = `zero;
  w_en = `zero;

  #10
  /*cycle 2*/ 
  r_addr = 2'b11; //reads r3
  en_A = `zero; en_B = `one;
  w_en = `zero;
  
  #10
  /*cycle 3*/
  en_A = `zero; en_B = `zero;
  ALU_op = 2'b00; //addition
  sel_A = `zero; sel_B = `zero;
  shift_op = 2'b00; //no shift
  en_C = `one;
  en_status = `one;
  w_en = `zero;

  #10
  /*cycle 4*/
  en_A = `zero; en_B = `zero; en_C = `zero;
  w_en = `one;
  wb_sel = 2'b00;
  w_addr = 3'b101; //writes to r5

  #10
  //test that datapath_out is correct
  //test that status flop outputs 0 when datapath_out ~= 0
  assert(V_out === `one) $display("test PASS! Overflowed");
    else begin
      $error("FAIL: V_out should be overflowed");
      temp_err = `one;
    end
  
  /*Case FIVE: subtraction and negative =1*/

  //initializing r2 = 0
  sximm8 = 16'b0000000000000000;
  wb_sel = 2'b10;
  w_en = `one;
  w_addr = 2'b10; //write to r2
  #10

  //initializing r3 = 3
  sximm8 = 16'b1111111111111100;
  wb_sel = 2'b10;
  w_en = `one;
  w_addr = 2'b11; //write to r3
  #10


  /*cycle 1*/
  r_addr = 2'b10; //reads r2
  en_A = `one; en_B = `zero;
  w_en = `zero;

  #10
  /*cycle 2*/ 
  r_addr = 2'b11; //reads r3
  en_A = `zero; en_B = `one;
  w_en = `zero;
  
  #10
  /*cycle 3*/
  en_A = `zero; en_B = `zero;
  ALU_op = 2'b00; //subtraction
  sel_A = `zero; sel_B = `zero;
  shift_op = 2'b00; //no shift
  en_C = `one;
  en_status = `one;
  w_en = `zero;

  #10
  /*cycle 4*/
  en_A = `zero; en_B = `zero; en_C = `zero;
  w_en = `one;
  wb_sel = 2'b00;
  w_addr = 3'b101; //writes to r5

  #10
  //test that status flop outputs 0 when datapath_out ~= 0
  assert(Z_out === `zero) $display("test PASS! Z_out is zero");
    else begin
      $error("FAIL: Z_out should be zero");
      temp_err = `one;
    end

  assert(N_out === `one) $display("test PASS! N_out is one");
    else begin
      $error("FAIL: N_out should be one");
      temp_err = `one;
    end
  $stop;
end
assign err = temp_err;

endmodule: tb_datapath