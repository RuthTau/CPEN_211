module pc(input clk, input load_pc, input clear_pc, input [7:0] start_pc, output [7:0]pc);

`define zero 1'b0
`define one 1'b1

reg [7:0] out;
assign pc = out;

reg [7:0] next_pc;

always_ff @(posedge clk) 
begin
 if(clear_pc)
  out <= next_pc;
 else
  out <= out;
end

always @(*) 
begin
    case(clear_pc)
    `one: next_pc = start_pc;
    `zero: next_pc = out + 1;
    default: next_pc = out +1;
    endcase
end


endmodule: pc