module tb_lab3();

reg [9:0] SW;
reg [3:0] KEY;
wire [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
wire [9:0] LEDR;
reg clk,rst_n;

reg [3:0] state;

assign KEY[0] = clk;
assign KEY[3] = rst_n;

// displays for seven segment
`define display0 7'b1000000
`define display1 7'b1111001
`define display2 7'b0100100  
`define display3 7'b0110000
`define display4 7'b0011001
`define display5 7'b0010010
`define display6 7'b0000010
`define display7 7'b1111000
`define display8 7'b0000000
`define display9 7'b0011000
`define displayC 7'b1000110
`define displayL 7'b1000111
`define displayO 7'b1000000
`define displayS 7'b0010010
`define displayE 7'b0000110
`define displayd 7'b0100001
`define displayP 7'b0001100
`define displayN 7'b1001000  
`define displayr 7'b0101111
`define displayo 7'b0100011 
`define displayOff 7'b1111111

// 4 bit displays for switches
`define zero 4'b0000
`define one 4'b0001
`define two 4'b0010
`define three 4'b0011
`define four 4'b0100
`define five 4'b0101
`define six 4'b0110
`define seven 4'b0111
`define eight 4'b1000
`define nine 4'b1001

// state encodings for OPEN path
`define A 4'b0000
`define B 4'b0001
`define C 4'0010
`define D 4'b0011
`define E 4'b0100
`define F 4'b0101
`define OPEN 4'b0110

//state encodings for CLOSED path
`define G 4'b1000
`define H 4'b1001
`define I 4'b1010
`define J 4'b1011
`define K 4'b1100
`define CLOSED 4'b1101

lab3 dut(.SW(SW), .KEY(KEY), .HEX0(HEX0), .HEX1(HEX1), .HEX2(HEX2), .HEX3(HEX3), .HEX4(HEX4), .HEX5(HEX5), .LEDR(LEDR));

initial begin
    clk = `zero;
    forever begin
        #5 clk = ~clk;
    end
end

//test that lock open; code is 100518, (#1)
initial begin
    SW[3:0] = `one;
    #10

    SW[3:0] = `zero;
    #10

    SW[3:0] = `zero;
    #10

    SW[3:0] = `five;
    #10

    SW[3:0] = `one;
    #10

    SW[3:0] = `eight;
    #10

    assert(HEX5 === `displayO && HEX4 === `displayP && HEX3 === `displayE && HEX2 === `displayN) $display ("test passed! lock opened");
        else $error ("test failed: lock should be open");

   
end

//test that numbers are displayed immediatly on dispay and for inputs >9, "error" is displayed(#2)

initial begin
    SW[3:0] = `zero;
    assert(HEX0 === `display0) $display ("test passed! HEX0 displayed 0");
        else $error ("test failed: HEX0 should display 0");
    
    #10

    SW[3:0] = `one;
    #1
    assert(HEX0 === `display1) $display ("test passed! HEX0 displayed 1");
        else $error ("test failed: HEX0 should display 1");
    
    #1

    SW[3:0] = `two;
    assert(HEX0 === `display2) $display ("test passed! HEX0 displayed 2");
        else $error ("test failed: HEX0 should display 2");

    #1

    SW[3:0] = 4'b1100;
    assert(HEX5 === `displayE && HEX4 === `displayr && HEX3 === `displayr && HEX2 === `displayo && HEX1 === `displayr) $display ("test passed! 'error' was displayed");
        else $error ("test failed: HEX5 - HEX1 should display 'Error'");

    
end

//test that reset is functional with "perfect match" inputs, and that state transitions are working(#3)

initial begin

    SW[3:0] = `one;
    #10

    SW[3:0] = `zero;
    #10

    SW[3:0] = `zero;
    #10

    assert(state === 4'b0011) $display ("test passed! in third state; state = C");
        else $error ("test failed: should be in third state; state = C");
    
    rst_n = `one;
    #10

    assert(state === 4'b0000) $display ("test passed! state has been reset to first state; state = A");
        else $error ("test failed: state should be reset to first state; state = A");


   
end

//test that reset is funcitonal with "imperfect match" inputs (#4)
initial begin
    SW[3:0] = `one;
    #10

    SW[3:0] = `zero;
    #10

    SW[3:0] = `zero;
    #10

    SW[3:0] = `eight;
    #10
    
    rst_n = `one;
    #10

    assert(state === `A) $display ("test passed! state has been reset to first state; state = A");
        else $error ("test failed: state should be reset to first state; state = A");

   
end

//test that lock will enter "CLOSED" state if wrong input recieved at any state (#5)
initial begin
    //at first number
    SW[3:0] = `two;
    #10
    assert(state === `G) $display ("test passed! state entered CLOSED path at state G");
        else $error ("test failed: should have entered CLOSED path at state G");
    rst_n = `one;
    #10
    rst_n = `zero;
    #10

    //at second number
    SW[3:0] = `one; //first
    #10

    SW[3:0] = `two; //second
    #10
    assert(state === `H) $display ("test passed! state entered CLOSED path at state H");
        else $error ("test failed: should have entered CLOSED path at state H");
    rst_n = `one;
    #10

    //at third number
    SW[3:0] = `one; //first
    #10

    SW[3:0] = `zero; //second
    #10

    SW[3:0] = `two; //third
    #10
    assert(state === `I) $display ("test passed! state entered CLOSED path at state I");
        else $error ("test failed: should have entered CLOSED path at state I");
    rst_n = `one;
    #10
    rst_n = `zero;
    #10

    //at fourth number
    SW[3:0] = `one; //first
    #10

    SW[3:0] = `zero; //second
    #10

    SW[3:0] = `zero; //third
    #10

    SW[3:0] = `two; //fourth
    #10
    assert(state === `J) $display ("test passed! state entered CLOSED path at state J");
        else $error ("test failed: should have entered CLOSED path at state J");
    rst_n = `one;
    #10
    rst_n = `zero;
    #10

    //at fifth number
    SW[3:0] = `one; //first
    #10

    SW[3:0] = `zero; //second
    #10

    SW[3:0] = `zero; //third
    #10

    SW[3:0] = `five; //fourth
    #10

    SW[3:0] = `two; //fifth
    #10
    assert(state === `K) $display ("test passed! state entered CLOSED path at state K");
        else $error ("test failed: should have entered CLOSED path at state K");
    rst_n = `one;
    #10
    rst_n = `zero;
    #10

    //at sixth number
    SW[3:0] = `one; //first
    #10

    SW[3:0] = `zero; //second
    #10

    SW[3:0] = `zero; //third
    #10

    SW[3:0] = `five; //fourth
    #10

    SW[3:0] = `one; //fifth
    #10

    SW[3:0] = `two; //sixth
    #10

    assert(state === `CLOSED) $display ("test passed! state entered CLOSED path at state 'CLOSED'");
        else $error ("test failed: should have entered CLOSED path at state 'CLOSED'");
    rst_n = `one;
    #10
    rst_n = `zero;
    #10

    $stop;
end


endmodule: tb_lab3
