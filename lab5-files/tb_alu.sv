module tb_ALU(output err);

reg [15:0] val_A;
reg [15:0] val_B;
reg [1:0] ALU_op;
wire [15:0] ALU_out;
wire Z;

  ALU dut (.val_A(val_A), .val_B(val_B), .ALU_op(ALU_op), .ALU_out(ALU_out), .Z(Z));


initial begin
val_A = 16'd1;
val_B = 16'd1;
ALU_op = 2'b00;
#10;

assert(ALU_out === 16'd2 ) $display("[PASS] Addition");
else $error ("[FAIL] Addition");
assert(Z === 1'b0) $display("[PASS] Z=0");
else $error ("[FAIL] Z");


ALU_op = 2'b01;
#10;
assert(ALU_out === 16'd0 ) $display("[PASS] Subtraction");
else $error ("[FAIL] Subtraction");

assert(Z === 1'b1) $display("[PASS] Z=1");
else $error ("[FAIL] Z=1");



ALU_op = 2'b10;
#10;
assert(ALU_out === (val_A & val_B )) $display("[PASS] Bitwise AND");
else $error ("[FAIL] Bitwise AND");
assert(Z === 1'b0) $display("[PASS] Z=0");
else $error ("[FAIL] Z=0");



ALU_op = 2'b11;
#10;
assert(ALU_out === ~val_B) $display("[PASS] Bitwise negation");
else $error ("[FAIL] Bitwise negation");
assert(Z === 1'b0) $display("[PASS] Z=0");
else $error ("[FAIL] Z=0");


$stop;
end
endmodule: tb_ALU

