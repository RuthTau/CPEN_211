`define WAIT_STATE 4'b0000
`define DECODE_STATE 4'b0001
`define LOAD_A 4'b0010
`define LOAD_B 4'b0011
`define ALU_STATE 4'b0100
`define WRITE_STATE 4'b0101
`define HALT_STATE 4'b0110
`define MEMORY_STATE 4'b0111
`define RETRIEVE_STATE 4'b1000
`define BUFFER_STATE 4'b1001
`define A1 4'b1010
`define A2 4'b1011


module controller(input clk, input rst_n, 
                   //input start remove
                  input [2:0] opcode, 
                  input [1:0] ALU_op, input [1:0] shift_op,
                 

                  output clear_pc, //change waiting to clear pc
                  output [1:0] reg_sel, output [1:0] wb_sel, output w_en, //w_en = ram_w_en
                  output en_A, output en_B, output en_C, output en_status,
                  output sel_A, output sel_B, output load_ir,
                  output load_addr, output load_pc, output sel_addr);


// include decoder:
// atapath
// start=0 and waiting =1\
//op = shift_op

reg [3:0] state, next_state;
reg [19:0] next;
reg op;

always_ff @(posedge clk) begin
  if (~rst_n)
  state <= `WAIT_STATE;
 else
  state <= next_state;
end

//Rn 10; Rd 01; Rm 00
always @(*) begin
casex({opcode, ALU_op, shift_op, state}) //7 bit

//wait state, load_addr =0 , sel_addr =0, load_pc = 0, load_ir =1 
{7'bxxxxxxx, `WAIT_STATE}: next = {`DECODE_STATE,16'b1000000000000000}; //load ir

//add a RETRIEVE state, cycle for memory to retrieve, load pc only
{7'bxxxxxxx, `DECODE_STATE}: next = {`RETRIEVE_STATE, 16'b0000000000001000};

{7'bxxxxxxx, `RETRIEVE_STATE}: next ={`BUFFER_STATE, 16'b0000000000000010};

{7'bxxxxxxx, `BUFFER_STATE}: next = {`A1, 16'b0000000000000000};
{7'bxxxxxxx, `A1}: next = {`A2, 16'b0000000000000000};

//decode state, load_pc=1 , sel_addr = 0, load_addr = 1, for load state
//if in decode and operation is MOV Rn -> go to WRITE and output nothing
{7'b11010xx, `A2}: next  = {`WRITE_STATE, 16'b0000000000000111}; 
//MVN, MOV
{7'b11000xx, `A2}, {7'b10111xx, `A2}: next = {`LOAD_B, 16'b0000000000000110}; 
//ADD,CMP,AND
{7'b1010xxx, `A2}, {7'b10110xx, `A2}: next  = {`LOAD_A, 16'b0000000000000110}; 

//HALT
{7'b111xxxx, `A2} : next = {`HALT_STATE, 16'b100000000000000};


//Load A state, load_addr= 0 , load_pc, counter++, sel_addr =0
{7'bxxxxxxx, `LOAD_A}: next  = {`LOAD_B, 16'b0100000010000010}; //Rn, en_A

//if in DECODE and operation is CMP, ADD or AND, then go to LOAD_A and output nothing
//if in DECODE and operation is MOV Rd Rm or MVN, then go to LOAD_B and output nothing 

//Load B state, load_addr=0,  load_pc, counter++ ,sel_addr =0
{7'bxxxxxxx, `LOAD_B}: next  = {`ALU_STATE, 16'b0010000000000010}; //wb_sel = Rm, en_B


//HALT state, stops everything
{7'bxxxxxxx, `HALT_STATE}: next ={`HALT_STATE, 16'b100000000000000}; //clear pc

// ALU state (ADD,SUB,AND etc.), load_addr = 0, load_pc = 1 
//sel_addr = 1 , en_C =1, sel_A =1, reg_sel =2'b11

{7'b11000xx, `ALU_STATE}: next  = {`WRITE_STATE, 16'b0001010011000011};

//ALU and MOV operation, sel_A =1, sel_B=0, en_C=1, not in RN
{7'b1010xxx, `ALU_STATE},{7'b101x0xx, `ALU_STATE}: next  = {`WRITE_STATE,  16'b0001000011000011};  
// seL_A = sel_B = 0, en_C = 1
{7'b10101xx, `ALU_STATE}: next  = {`WAIT_STATE, 16'b0000100011000011}; //a_sel = b_sel = 0, en_status =


//write state (source of data to write in result)
// load_addr = 1, load_pc =1 ,sel_addr = 1 , writing address to ram
//R[Rn] = sx(im8)
{7'b11010xx, `WRITE_STATE}: next  = {`WAIT_STATE, 16'b0000000110100111}; //write MOV Rn, Rn =2'b10, write =1, sx(im8)= wb_sel= 2'b10
//output data from path_C
{7'bxxxxxxx, `WRITE_STATE}: next  = {`WAIT_STATE, 16'b0000000101000111}; // write Rd=2'b01, write =1, use C_data, wb_sel =2'b00

/*LDR states*/
// for LDR, load register address 
{7'b01100xx, `DECODE_STATE}: next = {`LOAD_A, 16'b0000000000000010}; // R[Rn]

//for LDR load sx(im5), write in sx(im5), sel_B =1 , load_addr =0
{7'b01100xx, `LOAD_A}: next ={`LOAD_B, 16'b0100000010000010}; //Rn, en_A

// for sximm5, sel_B =1, write into rm, reg_sel = 2'b00, sel_addr =0
{7'b01100xx, `LOAD_B}: next ={`ALU_STATE, 16'b0010001000000010};

//for LDR, sel_A = 0, sel_B =0, en_C = 1, w_en=1, load_addr =1, load_pc =1, sel_addr =1, Rd=reg_sel 2'b01, wb_sel=00 fromC, 
{7'b01100xx, `ALU_STATE}: next = {`MEMORY_STATE, 16'b0001000101000011};

{7'b01100xx, `MEMORY_STATE}: next= {`WAIT_STATE, 16'b0000000000000110}; //load the addr back to main, to wait

/*STR states*/
//first laod value of Rd, sel_addr =0, reg_sel= 2'b01, sel_addr = 0, load_addr =0
{7'b10000xx, `DECODE_STATE}: next = {`LOAD_A, 16'b0100000001000010};

//load addr =1, sel_addr =0 , load value to Rd as in A
{7'b10000xx, `LOAD_A}: next = {`MEMORY_STATE, 16'b0000000010000111};

//write back to sxim5 plus Rn, load_B which is load the register to be written, previously in C_en
//ALU where load memory of A and B 
{7'b10000xx, `MEMORY_STATE}: next = {`ALU_STATE, 16'b0000000001000110};

//load for simm5
 {7'b10000xx, `ALU_STATE}:next = {`LOAD_B, 16'b0000001001100110};

 //write 
 {7'b10000xx, `LOAD_B}: next = {`WRITE_STATE, 16'b0000000111000011};

 {7'b10000xx, `WAIT_STATE}: next = {`WAIT_STATE,16'b0000000000000010};

default : next = {20{1'bx}};
endcase
end

assign {next_state, clear_pc, en_A, en_B, en_C, en_status, sel_A, sel_B, w_en, reg_sel,wb_sel, load_ir,load_addr, load_pc,sel_addr} = next; //16bit

endmodule: controller

