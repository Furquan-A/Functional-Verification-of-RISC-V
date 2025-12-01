/************************************

//File Name: msrv32_immediate_adder.v

//Module Name: msrv32_immediate_adder

//Description: The output of immediate_adder module will be the 32 bit address depending on the instruction format (instruction to the core).

//Dependencies:

//Version: 1.0

//Engineer: Nishikant

//Email: tech_support@maven-silicon.com

//************************************/


module msrv32_immediate_adder(input  [31:0] pc_in,rs1_in,imm_in,
                              input         iadder_src_in,
                              output [31:0] iadder_out
                             );

   /*
   For load or store or jump_and_link_reg(jalr) instructions rs1_in is added with imm_in and for other instructions pc_in is added with imm_in.
   */
   assign iadder_out = iadder_src_in ? (rs1_in+imm_in) : (pc_in + imm_in);
endmodule
