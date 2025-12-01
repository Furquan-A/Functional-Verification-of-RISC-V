 
/*********************************
  
//File Name: msrv32_store_unit.v
  
//Module Name: msrv32_store_unit
  
//Description: This module drives the signals that interface with memory. 
  
//Dependencies:
  
//Version: 1.0
  
//Engineer: Nishikant
  
//Email: tech_support@maven-silicon.com
  
************************************/
 
module msrv32_store_unit(input      [1:0 ] funct3_in,
		         input      [31:0] iadder_in,rs2_in,
                         input             mem_wr_req_in,ahb_ready_in,
			 output     [31:0] d_addr_out,
			 output reg [31:0] data_out,
			 output reg [3 :0] wr_mask_out,
                         output reg [1:0]  ahb_htrans_out,
		         output            wr_req_out
);
 
   //Internal variables
   reg [31:0] byte_dout,halfword_dout;   //used for byte of data and halfword of data storage respectively. 
   reg [3:0 ] byte_wr_mask,halfword_wr_mask;   //used for byte of data enable and halfword of data enable storage respectively.
   reg [31:0] d_addr=0; 
   //address logic to store the data in memory.
   assign d_addr_out= {iadder_in[31:2],2'b00};
 
 
   //wr_req logic to write in the memory.
   assign wr_req_out=mem_wr_req_in;
 
   //calculation of byte_out depending upon iadder_in
   always@(*)
   begin
      case(iadder_in[1:0])
         2'b00   : byte_dout = {8'b0,8'b0,8'b0,rs2_in[7:0]};
         2'b01   : byte_dout = {8'b0,8'b0,rs2_in[7:0],8'b0};
         2'b10   : byte_dout = {8'b0,rs2_in[7:0],8'b0,8'b0};
         2'b11   : byte_dout = {rs2_in[7:0],8'b0,8'b0,8'b0};
         default : byte_dout = 32'b0;
      endcase
   end
 
   //calculation of halfword_dout depending upon iadder_in
   always@(*)
   begin
      case(iadder_in[1])
         1'b0    : halfword_dout = {16'b0,rs2_in[15:0]};
         1'b1    : halfword_dout = {rs2_in[15:0],16'b0};
         default : halfword_dout = 32'b0;
      endcase
   end

   //calculating data_out value depending upon funct3_in
   /*
    For funct3_in = 2'b00 :-> Byte of data to be written
    For funct3_in = 2'b01 :-> Half Word of data to be written
    For default           :-> Word of data to be written
   */
 
   always@(*)
   begin 
     if(ahb_ready_in)
      begin
         case(funct3_in)
            2'b00   : data_out = byte_dout;
            2'b01   : data_out = halfword_dout;
            default : data_out = rs2_in;
         endcase
         ahb_htrans_out = 2'b10;
      end
      else
         ahb_htrans_out = 2'b00;         
   end
 
   //calculation of wr_mask_out depending upon funct3_in
   /*
    For funct3_in = 2'b00 :-> Byte of data enable
    For funct3_in = 2'b01 :-> Half Word of data enable
    For default           :-> Word of data enable
   */
 
   always@(*)
   begin
      case(funct3_in)
         2'b00   : wr_mask_out = byte_wr_mask;
         2'b01   : wr_mask_out = halfword_wr_mask;
         default : wr_mask_out = {4{mem_wr_req_in}};
      endcase 
   end
 

   //calculation of byte_wr_mask depending upon iadder_in 
   always@(*)
   begin
      case(iadder_in[1:0])
         2'b00   : byte_wr_mask = {3'b0,mem_wr_req_in};
         2'b01   : byte_wr_mask = {2'b0,mem_wr_req_in,1'b0};
         2'b10   : byte_wr_mask = {1'b0,mem_wr_req_in,2'b0};
         2'b11   : byte_wr_mask = {mem_wr_req_in,3'b0};
	 default : byte_wr_mask = {4{mem_wr_req_in}};
      endcase 
   end
 
   //calculation of halfword_wr_mask depending upon iadder_in
   always@(*)
   begin
      case(iadder_in[1])
         1'b0    : halfword_wr_mask = {2'b0,{2{mem_wr_req_in}}};
         1'b1    : halfword_wr_mask = {{2{mem_wr_req_in}},2'b0};
	 default : halfword_wr_mask = {4{mem_wr_req_in}};
      endcase 
   end 

  /* always@(*)
   begin
      if(ahb_ready_in)
      begin
         d_addr = iadder_in;
        // d_addr_next = d_addr;
      end
      //else
        // d_addr = d_addr_next;
   end
   */
endmodule
