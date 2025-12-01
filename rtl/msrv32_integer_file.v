
/************************************

//File Name: msrv32_integer_file.v

//Module Name: msrv32_integer_file

//Description:  The msrv32_integer_file  has 32 general-purpose registers and supports read and write operations. 

//Dependencies:

//Version: 1.0

//Engineer: Prasanna

//Email: tech_support@maven-silicon.com

//************************************/

module msrv32_integer_file( input clk_in, reset_in,
                            // connections with pipeline stage 2
                            input  [4:0]  rs_1_addr_in,rs_2_addr_in, 
                            output [31:0] rs_1_out,rs_2_out,
                            // connections with pipeline stage 3
                            input  [4:0]  rd_addr_in,
                            input         wr_en_in,
                            input  [31:0] rd_in
			   );

    
    // Declaring 32*32 Reg File
    reg [31:0] reg_file [31:0];

    // Internal wires to enable data forwaring
    wire fwd_op1_enable, fwd_op2_enable;
    integer i;
    
   // reg_file initialization 
/*   initial
   begin
      for(i = 0; i < 32; i = i+1) 
         reg_file[i]  = 32'b0;
   end  
*/	   
    //Check if stage 3 requests to write to a register which is being read by stage 2 
    assign fwd_op1_enable = (rs_1_addr_in == rd_addr_in && wr_en_in == 1'b1) ? 1'b1 : 1'b0;
    assign fwd_op2_enable = (rs_2_addr_in == rd_addr_in && wr_en_in == 1'b1) ? 1'b1 : 1'b0;
        
    
   // Sequential write   
   always@(posedge clk_in or posedge reset_in)
   begin
      if(reset_in)
      begin
      for(i = 0; i < 32; i = i+1) 
         reg_file[i]  = 32'b0;
      end  

      else if(wr_en_in && rd_addr_in) // Doesn't allow write operation for X0 Register
      begin
         reg_file[rd_addr_in] <= rd_in;
	 $strobe("at time t = %t, the data in location %0d is %0d", $time, rd_addr_in, reg_file[rd_addr_in]);
      end 
   end	
   // Combinational read operation	
   assign rs_1_out = fwd_op1_enable == 1'b1 ? rd_in : reg_file[rs_1_addr_in]; 
   assign rs_2_out = fwd_op2_enable == 1'b1 ? rd_in : reg_file[rs_2_addr_in];
    
endmodule
