module DAR (input clk, input load_addr, input [15:0]datapath_out, input [7:0] pc, input sel_addr, output [7:0]ram_addr);

`define one 1'b1
`define zero 1'b0
reg[7:0] tmp;
reg [7:0] out;
assign ram_addr = out;

always_ff @(posedge clk) 
begin
    if(load_addr) //load_addr is present 1'b1
    tmp <= datapath_out[7:0]; //only assign first 8 bits
    else
    tmp <= tmp;
end

always @(*)
begin
 case(sel_addr)
 `one: out = pc;
 `zero: out =tmp;
 default: out = tmp;
 endcase

end

endmodule: DAR 