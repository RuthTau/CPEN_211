`define WAIT_STATE 3'b000
`define DECODE_STATE 3'b001
`define LOAD_A 3'b010
`define LOAD_B 3'b011
`define ALU_STATE 3'b100
`define WRITE_STATE 3'b101

module controller(input clk, input rst_n, 
                  input start,
                  input [2:0] opcode, 
                  input [1:0] ALU_op, input [1:0] shift_op,
                  input Z, input N, input V,

                  output waiting,
                  output [1:0] reg_sel, output [1:0] wb_sel, output w_en,
                  output en_A, output en_B, output en_C, output en_status,
                  output sel_A, output sel_B);


// include decoder:
// atapath
// start=0 and waiting =1\
//op = shift_op

reg [2:0] state, next_state;
reg [14:0] next;
reg op;

always_ff @(posedge clk) begin
  if (~rst_n)
  state <= `WAIT_STATE;
 else
  state <= next_state;
end

//Rn 10; Rd 01; Rm 00
always @(*) begin
casex({start, opcode, ALU_op, shift_op, state}) //11 bits

//wait state
{8'b0xxxxxxx, `WAIT_STATE}: next = {`WAIT_STATE, 12'b100000000000};
{8'b1xxxxxxx, `WAIT_STATE}: next = {`DECODE_STATE,12'b100000000000};

//decode state
{8'bx11010xx, `DECODE_STATE}: next  = {`WRITE_STATE, 12'b0}; //if in decode and operation is MOV Rn -> go to WRITE and output nothing
{8'bx11000xx, `DECODE_STATE}, {8'bx10111xx, `DECODE_STATE}: next = {`LOAD_B, 12'b0}; //MVN, MOV
{8'bx1010xxx, `DECODE_STATE}, {8'bx10110xx, `DECODE_STATE}: next  = {`LOAD_A, 12'b0}; //ADD,CMP,AND

//Load A state
{8'bxxxxxxxx, `LOAD_A}: next  = {`LOAD_B, 12'b010000001000}; //Rn, en_A, 

//if in DECODE and operation is CMP, ADD or AND, then go to LOAD_A and output nothing
//if in DECODE and operation is MOV Rd Rm or MVN, then go to LOAD_B and output nothing 

//Load B state
{8'bxxxxxxxx, `LOAD_B}: next  = {`ALU_STATE, 12'b001000000000}; //wb_sel = Rm, en_B

// ALU state (ADD,SUB,AND etc.)
{8'bx11000xx, `ALU_STATE}: next  = {`WRITE_STATE, 12'b000101001100}; //ALU and MOV operation, sel_A =1, sel_B=0, en_C=1, not in RN
{8'bx1010xxx, `ALU_STATE},{8'bx101x0xx, `ALU_STATE}: next  = {`WRITE_STATE,  12'b000100001100 };  // seL_A = sel_B = 0, en_C = 1
{8'bx10101xx, `ALU_STATE}: next  = {`WAIT_STATE, 12'b000010001100}; //a_sel = b_sel = 0, en_status =1


//write state (source of data to write in result)
//R[Rn] = sx(im8)
{8'bx11010xx, `WRITE_STATE}: next  = {`WAIT_STATE, 12'b000000011010}; //write MOV Rn, Rn =2'b10, write =1, sx(im8)= wb_sel= 2'b10
//output data from path_C
{8'hx, `WRITE_STATE}: next  = {`WAIT_STATE, 12'b000000010100}; // write Rd=2'b01, write =1, use C_data, wb_sel =2'b00
default : next = {15{1'bx}};
endcase
end

assign {next_state, waiting, en_A, en_B, en_C, en_status, sel_A, sel_B, w_en, reg_sel,wb_sel} = next; //15bit

endmodule: controller
