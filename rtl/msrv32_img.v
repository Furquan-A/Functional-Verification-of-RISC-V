/***********************************
//
//File Name: msrv32_img.v
//
//Module Name: msrv32_img
//
//Description: An immediate generator expands the 12 bit immediate value in the instruction to it equivalent 32 bit value.
//             The immediate generation is unique of each type of instruction.
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

module msrv32_img(
                  input  [31:7] instr_in,   //core instruction excluding the opcode
                  input  [2:0] imm_type_in, //immediate type (from the decoder)
                  output reg [31:0] imm_out // immediate value
                 );
   
// immediate format selection

   parameter R_TYPE          =    3'b000;
   parameter I_TYPE          =    3'b001;
   parameter S_TYPE          =    3'b010;
   parameter B_TYPE          =    3'b011;
   parameter U_TYPE          =    3'b100;
   parameter J_TYPE          =    3'b101;
   parameter CSR_TYPE        =    3'b110;

    
//immediate generation based on the type of instruction   
   always @(*)
   begin
      case (imm_type_in)
         3'b000   : imm_out = { {20{instr_in[31]}}, instr_in[31:20] }; 
         I_TYPE   : imm_out = { {20{instr_in[31]}}, instr_in[31:20] };
         S_TYPE   : imm_out = { {20{instr_in[31]}}, instr_in[31:25], instr_in[11:7] };
         B_TYPE   : imm_out = { {19{instr_in[31]}}, instr_in[31], instr_in[7], instr_in[30:25], instr_in[11:8], 1'b0 };
         U_TYPE   : imm_out = { instr_in[31:12], 12'h000 };
         J_TYPE   : imm_out = { {11{instr_in[31]}}, instr_in[31], instr_in[19:12], instr_in[20], instr_in[30:21], 1'b0 };
         CSR_TYPE : imm_out = { 27'b0, instr_in[19:15] };
         3'b111   : imm_out = { {20{instr_in[31]}}, instr_in[31:20] };
      endcase
   end
    
endmodule
