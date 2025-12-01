/*********************************
//File Name: wr_en_generator.v

//Module Name: wr_en_generator

//Description: This module will be used to generate write enable signal for integer file and CSR file

//Version: 1.0

//Engineer: Prasanna

//Email: tech_support@maven-silicon.com

//************************************/


module msrv32_wr_en_generator(input flush_in,rf_wr_en_reg_in,csr_wr_en_reg_in,
                       output wr_en_integer_file_out,wr_en_csr_file_out
                      );
   //Generation of write enable signals for CSR file and Integer file based on flush
   assign wr_en_integer_file_out = flush_in ? 1'b0 : rf_wr_en_reg_in;
   assign wr_en_csr_file_out = flush_in ? 1'b0 : csr_wr_en_reg_in;

endmodule
