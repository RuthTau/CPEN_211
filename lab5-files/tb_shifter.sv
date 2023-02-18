module tb_shifter(output err);
 reg [15:0] shift_in;
 reg [1:0] shift_op;
 wire [15:0] shift_out;

 shifter dut(.shift_in(shift_in), .shift_op(shift_op), .shift_out(shift_out));
 
 initial begin

 shift_in = 16'b1111000011001111;
 shift_op = 2'b00;
 #10;

 assert( shift_out ===  16'b1111000011001111) $display("[Pass] No shift");
 else $error ("[Fail] No shift");


 shift_op = 2'b01;
 #10;
 
 assert( shift_out === 16'b1110000110011110) $display("[Pass] Left shift");
 else $error ("[Fail] Left shift");

 shift_op = 2'b10;
 #10;

 assert( shift_out === 16'b0111100001100111) $display("[Pass] Right shift");
 else $error ("[Fail] Right shift");

 shift_op = 2'b11;
 #10;

 assert( shift_out === 16'b1111100001100111) $display("[Pass] Arithemetic Right shift");
 else $error ("[Fail] Arithemetic Right shift");
 
 $stop;

 end

endmodule: tb_shifter
