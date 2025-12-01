/***********************************
//
//File Name: msrv32_branch_unit.v
//
//Module Name: msrv32_bu
//
//Description: Branch Unit is the block that generates a branch_taken signal so as
//             to select a new address in the program counter in case of jump or 
//             branch instructions.
//
//Dependencies: 
//
//Version: 1.0
//
//Engineer: Alistair
//
//Email: tech_support@maven-silicon.com
//
************************************/

`timescale 1ns / 1ps

module msrv32_bu(
                 input  [6:2] opcode_6_to_2_in,//used for selecting between branch and jump instructions
                 input  [2:0] funct3_in,       //used for selecting between various branch conditions
                 input  [31:0] rs1_in,rs2_in,         
                 output branch_taken_out      
                );    
//Implemented instruction type opcodes
   parameter  OPCODE_BRANCH   =    5'b11000;
   parameter  OPCODE_JAL      =    5'b11011;
   parameter  OPCODE_JALR     =    5'b11001;

    
   wire pc_mux_sel;
   wire pc_mux_sel_en; 
   reg is_branch;      //Branch instruction flag
   reg is_jal;         //Jump and Link flag
   reg is_jalr;        //Jump and Link reg flag
   wire is_jump;       //Jump instruction flag
   reg take;           // triggers if the branch condition is true

   assign is_jump = is_jal | is_jalr; 
   assign pc_mux_sel_en = is_branch | is_jal | is_jalr;
   assign pc_mux_sel = (is_jump == 1'b1) ? 1'b1 : take;
   assign branch_taken_out = pc_mux_sel_en & pc_mux_sel;
    
//Checks the branch conditions based on the type of branch instructions    
   always @(*)
   begin
      case (funct3_in)

         3'b000  : take = (rs1_in == rs2_in);
         3'b001  : take = !(rs1_in == rs2_in);
         3'b100  : take = rs1_in[31] ^ rs2_in[31] ? rs1_in[31] : (rs1_in < rs2_in);
         3'b101  : take = rs1_in[31] ^ rs2_in[31] ? ~rs1_in[31] : !(rs1_in < rs2_in);
         3'b110  : take = (rs1_in < rs2_in);
         3'b111  : take = !(rs1_in < rs2_in);
         default : take = 1'b0;

      endcase
   end
    
//Identifies the type of instruction
   always @(*)
   begin
      case (opcode_6_to_2_in [6:2])

         OPCODE_JAL    : is_jal =1'b1;
         OPCODE_JALR   : is_jalr =1'b1;
         OPCODE_BRANCH : is_branch = 1'b1;
         default       : {is_jal,is_jalr,is_branch} = 3'b000; 

      endcase
   end
    
endmodule
