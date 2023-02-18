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
    `define displayoff 7'b1111111

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
    `define C 4'b0010
    `define D 4'b0011
    `define E 4'b0101
    `define F 4'b0110
    `define OPEN 4'b0111

    //state encodings for CLOSED path
    `define G 4'b1000
    `define H 4'b1001
    `define I 4'b1010
    `define J 4'b1011
    `define K 4'b1100
    `define CLOSED 4'b1101


module lab3(input [9:0] SW, input [3:0] KEY,
            output reg [6:0] HEX0, output reg [6:0] HEX1, output reg [6:0] HEX2,
            output reg [6:0] HEX3, output reg [6:0] HEX4, output reg[6:0] HEX5,
            output reg [9:0] LEDR);
    wire clk = ~KEY[0]; // this is your clock
    wire rst_n = KEY[3]; // this is your reset; your reset should be synchronous and active-low

    // YOUR SOLUTION HERE
 

    reg [3:0] state;


    always_comb begin // output combination block

        case (SW [3:0]) //cases for potential number inputs
            `zero: begin
                HEX5 = `displayoff;
                HEX4 = `displayoff;
                HEX3 = `displayoff;
                HEX2 = `displayoff;
                HEX1 = `displayoff;
                HEX0 = `display0;
            end
            `one: begin
                HEX5 = `displayoff;
                HEX4 = `displayoff;
                HEX3 = `displayoff;
                HEX2 = `displayoff;
                HEX1 = `displayoff;
                HEX0 = `display1;
            end
            `two: begin
                HEX5 = `displayoff;
                HEX4 = `displayoff;
                HEX3 = `displayoff;
                HEX2 = `displayoff;
                HEX1 = `displayoff;
                HEX0 = `display2;
            end
            `three: begin
                HEX5 = `displayoff;
                HEX4 = `displayoff;
                HEX3 = `displayoff;
                HEX2 = `displayoff;
                HEX1 = `displayoff;
                HEX0 = `display3;
            end
            `four: begin
                HEX5 = `displayoff;
                HEX4 = `displayoff;
                HEX3 = `displayoff;
                HEX2 = `displayoff;
                HEX1 = `displayoff;
                HEX0 = `display4;
            end
            `five: begin
                HEX5 = `displayoff;
                HEX4 = `displayoff;
                HEX3 = `displayoff;
                HEX2 = `displayoff;
                HEX1 = `displayoff;
                HEX0 = `display5;
            end
            `six: begin
                HEX5 = `displayoff;
                HEX4 = `displayoff;
                HEX3 = `displayoff;
                HEX2 = `displayoff;
                HEX1 = `displayoff;
                HEX0 = `display6;
            end
            `seven: begin
                HEX5 = `displayoff;
                HEX4 = `displayoff;
                HEX3 = `displayoff;
                HEX2 = `displayoff;
                HEX1 = `displayoff;
                HEX0 = `display7;
            end
            `eight: begin
                HEX5 = `displayoff;
                HEX4 = `displayoff;
                HEX3 = `displayoff;
                HEX2 = `displayoff;
                HEX1 = `displayoff;
                HEX0 = `display8;
            end
            `nine: begin
                HEX5 = `displayoff;
                HEX4 = `displayoff;
                HEX3 = `displayoff;
                HEX2 = `displayoff;
                HEX1 = `displayoff;
                HEX0 = `display9;
            end

	default: begin
             	HEX5 = `displayE;
                HEX4 = `displayr;
                HEX3 = `displayr;
                HEX2 = `displayo;
                HEX1 = `displayr;
                HEX0 = `displayoff;
            end

        endcase

//open

	if (state == `OPEN) begin
		HEX5 = `displayO;
		HEX4 = `displayP;
		HEX3 = `displayE;
		HEX2 = `displayN;
		HEX1 =`displayoff;
		HEX0 =`displayoff;
	end
	
	if (state == `CLOSED) begin
		HEX5 = `displayC;
		HEX4 = `displayL;
		HEX3 = `displayO;
		HEX2 = `displayS;
		HEX1 = `displayE;
		HEX0 = `displayd;
	end
        
    end

    always @(posedge clk) begin
        if (~rst_n) 
            state <= `A;

        else

            casex ({SW[3:0], state})

                //OPEN path
                {`one, `A} :state <= `B;
                {4'bxxxx, `A} :state <= `G;

                {`zero, `B}: state <= `C;
                {4'bxxxx, `B} :state <= `H;

                {`zero, `C} :state <= `D;
                {4'bxxxx, `C} :state <= `I;

                {`five, `D} :state <= `E;
                {4'bxxxx, `D} :state <= `J;

                {`one, `E} :state <= `F;
                {4'bxxxx, `E} :state <= `K;

                {`eight, `F} :state <= `OPEN;
                {4'bxxxx, `F}: state <= `CLOSED;

                //CLOSED path
                {4'bxxxx, `G} :state <= `H;
                {4'bxxxx, `H} :state <= `I;
                {4'bxxxx, `I} :state <= `J;
                {4'bxxxx, `J} :state <= `K;
                {4'bxxxx, `K} :state <= `CLOSED;

            endcase
        
    end



endmodule: lab3
