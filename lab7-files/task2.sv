module task2(input clk, input rst_n, input [7:0] start_pc, output[15:0] out);

reg [1:0] ALU_op, shift_op, reg_sel, wb_sel;
reg [15:0] datapath_out, ram_r_data, ir_reg, sximm5, sximm8;
reg Z_out, N_out, V_out;
reg [2:0] opcode, r_addr, w_addr;
reg [7:0] pc, ram_addr;
reg clear_pc, w_en, en_A, en_B, en_C, en_status, sel_A, sel_B, load_ir, load_addr, load_pc, sel_addr; //not done


    controller inst0 (.clk(clk),  .rst_n(rst_n), .opcode(opcode), 
                  .ALU_op(ALU_op), .shift_op(shift_op),
                  
                   //outputs
                   .clear_pc(clear_pc),
                   .reg_sel(reg_sel), .wb_sel(wb_sel),  .w_en(w_en),
                   .en_A(en_A),  .en_B(en_B),  .en_C(en_C),  .en_status(en_status),
                   .sel_A(sel_A),  .sel_B(sel_B), .load_ir(load_ir), 
                   .load_addr(load_addr), .load_pc(load_pc), .sel_addr(sel_addr));
    
    idecoder inst1(.ir(ir_reg), .reg_sel(reg_sel), .opcode(opcode), .ALU_op(ALU_op), .shift_op(shift_op), 
                  .sximm5(sximm5), .sximm8(sximm8), .r_addr(r_addr), .w_addr(w_addr));


    pc inst2(.clk(clk), .load_pc(load_pc), .clear_pc(clear_pc), .start_pc(start_pc), .pc(pc));

    datapath inst3(.clk(clk), .mdata(ram_r_data), .pc(pc), .wb_sel(wb_sel),
                .w_addr(w_addr), .w_en(w_en), .r_addr(r_addr), .en_A(en_A),
                .en_B(en_B), .shift_op(shift_op), .sel_A(sel_A), .sel_B(sel_B),
                 .ALU_op(ALU_op), .en_C(en_C), .en_status(en_status),
                .sximm8(sximm8), .sximm5(sximm5), 
                //outputs
                .datapath_out(datapath_out), .Z_out(Z_out), .N_out(N_out), .V_out(V_out));

    DAR inst4(.clk(clk), .load_addr(load_addr), .datapath_out(datapath_out), .pc(pc), .sel_addr(sel_addr), .ram_addr(ram_addr));

    ram inst5 (.clk(clk), .ram_w_en(w_en), .ram_r_addr(ram_addr), .ram_w_addr(ram_addr), .ram_w_data(datapath_out), .ram_r_data(ram_r_data));


always @(posedge clk) begin

      //for instruction register
      if(load_ir) begin
        ir_reg <= ram_r_data;
    end
end

// adding RF writeback mux and assert the RF writeback enable at the right time, before next cycle, update data

endmodule: task2
