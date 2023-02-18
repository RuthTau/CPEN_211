module tb_regfile(output err);
 reg clk;
 reg w_en;
 reg [2:0] r_addr;
 reg[2:0] w_addr;
 reg [15:0] w_data;
 wire[15:0] r_data;

 regfile dut (.w_data(w_data), .w_addr(w_addr), .w_en(w_en), .r_addr(r_addr), .clk(clk), .r_data(r_data));

 initial begin
 	forever begin 
	clk=0;
	#10;
	clk =1;
	#10;
	end
end

 initial begin
	//test writing, set w_en as high
	w_en = 1'b1;
	w_addr = 3'b000;
	w_data = 16'd0;
	
 	#20;
	
	assert (w_data === 16'd0) $display ("[Pass] Writing Value Correct at register 0");
	else $error("[Fail] Wrong value!");
        assert (w_addr === 3'b000) $display ("[Pass] Writing at register 0");
	else $error("[Fail] Wrong value!");
	
	//reading write 
 	r_addr = 3'b000;
	#20;

	assert (r_data === 16'd0) $display ("[Pass] Reading Value Correct at register 0");
	else $error("[Fail] Wrong value!");
        assert (r_addr === 3'b000) $display ("[Pass] Reading Correct register 0");
	else $error("[Fail] Wrong value!");

	//test in register r1
	w_addr = 3'b001;
	w_data = 16'd1;
	
 	#20;
	
	assert (w_data === 16'd1) $display ("[Pass] Writing Value Correct at register 1");
	else $error("[Fail] Wrong value!");
        assert (w_addr === 3'b001) $display ("[Pass] Writing at register 1");
	else $error("[Fail] Wrong value!");
	
	//reading write 
 	r_addr = 3'b001;
	#20;

	assert (r_data === 16'd1) $display ("[Pass] Reading Value Correct at register 1");
	else $error("[Fail] Wrong value!");
        assert (r_addr === 3'b001) $display ("[Pass] Reading Correct register 1");
	else $error("[Fail] Wrong value!");

	//test in register r2
	w_addr = 3'b010;
	w_data = 16'd2;
	
 	#20;
	
	assert (w_data === 16'd2) $display ("[Pass] Writing Value Correct at register 2");
	else $error("[Fail] Wrong value!");
        assert (w_addr === 3'b010) $display ("[Pass] Writing at register 2");
	else $error("[Fail] Wrong value!");
	
	//reading write 
 	r_addr = 3'b010;
	#20;

	assert (r_data === 16'd2) $display ("[Pass] Reading Value Correct at register 2");
	else $error("[Fail] Wrong value!");
        assert (r_addr === 3'b010) $display ("[Pass] Reading Correct register 2");
	else $error("[Fail] Wrong value!");

	//test in register r3
	w_addr = 3'b011;
	w_data = 16'd3;
	
 	#20;
	
	assert (w_data === 16'd3) $display ("[Pass] Writing Value Correct at register 3");
	else $error("[Fail] Wrong value!");
        assert (w_addr === 3'b011) $display ("[Pass] Writing at register 3");
	else $error("[Fail] Wrong value!");
	
	//reading write 
 	r_addr = 3'b011;
	#20;

	assert (r_data === 16'd3) $display ("[Pass] Reading Value Correct at register 3");
	else $error("[Fail] Wrong value!");
        assert (r_addr === 3'b011) $display ("[Pass] Reading Correct register 3");
	else $error("[Fail] Wrong value!");

	//test in register r4
	w_addr = 3'b100;
	w_data = 16'd4;
	
 	#20;
	
	assert (w_data === 16'd4) $display ("[Pass] Writing Value Correct at register 4");
	else $error("[Fail] Wrong value!");
        assert (w_addr === 3'b100) $display ("[Pass] Writing at register 4");
	else $error("[Fail] Wrong value!");
	
	//reading write 
 	r_addr = 3'b100;
	#20;

	assert (r_data === 16'd3) $display ("[Pass] Reading Value Correct at register 4");
	else $error("[Fail] Wrong value!");
        assert (r_addr === 3'b011) $display ("[Pass] Reading Correct register 4");
	else $error("[Fail] Wrong value!");

	//test in register r5
	w_addr = 3'b101;
	w_data = 16'd5;
	
 	#20;
	
	assert (w_data === 16'd5) $display ("[Pass] Writing Value Correct at register 5");
	else $error("[Fail] Wrong value!");
        assert (w_addr === 3'b101) $display ("[Pass] Writing at register 5");
	else $error("[Fail] Wrong value!");
	
	//reading write 
 	r_addr = 3'b101;
	#20;

	assert (r_data === 16'd5) $display ("[Pass] Reading Value Correct at register 5");
	else $error("[Fail] Wrong value!");
        assert (r_addr === 3'b101) $display ("[Pass] Reading Correct register 5");
	else $error("[Fail] Wrong value!");

	//test in register r6
	w_addr = 3'b110;
	w_data = 16'd6;
	
 	#20;
	
	assert (w_data === 16'd6) $display ("[Pass] Writing Value Correct at register 6");
	else $error("[Fail] Wrong value!");
        assert (w_addr === 3'b110) $display ("[Pass] Writing at register 6");
	else $error("[Fail] Wrong value!");
	
	//reading write 
 	r_addr = 3'b110;
	#20;

	assert (r_data === 16'd6) $display ("[Pass] Reading Value Correct at register 6");
	else $error("[Fail] Wrong value!");
        assert (r_addr === 3'b110) $display ("[Pass] Reading Correct register 6");
	else $error("[Fail] Wrong value!");

	//test in register r7
	w_addr = 3'b111;
	w_data = 16'd7;
	
 	#20;
	
	assert (w_data === 16'd7) $display ("[Pass] Writing Value Correct at register 7");
	else $error("[Fail] Wrong value!");
        assert (w_addr === 3'b111) $display ("[Pass] Writing at register 7");
	else $error("[Fail] Wrong value!");
	
	//reading write 
 	r_addr = 3'b111;
	#20;

	assert (r_data === 16'd7) $display ("[Pass] Reading Value Correct at register 7");
	else $error("[Fail] Wrong value!");
        assert (r_addr === 3'b111) $display ("[Pass] Reading Correct register 7");
	else $error("[Fail] Wrong value!");

	//error case, no writing
	w_en =1'b0;
	#20

        w_addr = 3'b000;
	w_data = 16'd3;	 // a value that was not previously stored
	r_addr = 3'b000;
	
 	#20;
	
	assert (r_data === w_data) $display ("[Pass] Writing Value Correct at register 0");
	else $error("[Fail] Wrong value!");
        assert (r_addr === w_addr) $display ("[Pass] Writing at register 0");
	else $error("[Fail] Wrong value!");
	

    #20;
   $stop;

	
end

endmodule: tb_regfile
