/*********************************

//File Name: msrv32_pc.v

//Module Name: msrv32_pc

//Description: This module will be used to hold the address of next instruction to be executed.

//Dependencies: msrv32_gdef.vh

//Version: 1.0

//Engineer: Nishikant

//Email: tech_support@maven-silicon.com

//************************************/

module msrv32_pc (input              branch_taken_in,rst_in,
                  input              ahb_ready_in,
                  input       [1:0 ] pc_src_in,
                  input       [31:0] epc_in,trap_address_in,pc_in,
                  input       [31:1] iaddr_in,
                  output      [31:0] pc_plus_4_out,i_addr_out,
		  output             misaligned_instr_out,
                  output  reg [31:0] pc_mux_out
		 );
   reg [31:0] i_addr;
   parameter BOOT_ADDRESS = 0;

   // Internal wires
   wire [31:0] next_pc;   //It is used to drive new address
   //misaligned instruction indication.
   assign misaligned_instr_out=next_pc[1] & branch_taken_in;   
   assign pc_plus_4_out = pc_in + 32'h00000004;   //Byte addressable

   //Calculating next_pc address depending upon the branch instruction
   assign next_pc=branch_taken_in ? {iaddr_in,1'b0} : pc_plus_4_out; 

   //assigning instruction address which is calculated based on current state instruction address signal
   assign i_addr_out = i_addr;

   /*Depending upon the current state 'pc_mux_out' will get value
      pc_src_in=2'b00 :-> Reset_state
      pc_src_in=2'b01 :-> Trap_return
      pc_src_in=2'b10 :-> Trap_taken 
      pc_src_in=2'b11 :-> Operating State
      Default :-> Operating State */ 

   always@(*)
   begin
      case(pc_src_in)
         2'b00  : pc_mux_out = BOOT_ADDRESS;
         2'b01  : pc_mux_out = epc_in;
	 2'b10  : pc_mux_out = trap_address_in;
         2'b11  : pc_mux_out = next_pc;
	 default: pc_mux_out = next_pc;
      endcase
    end

   always @(*)
   begin
      if(rst_in)
      i_addr = BOOT_ADDRESS;
      else if(ahb_ready_in)
      i_addr =  pc_mux_out;
   end

endmodule
