/* This block here is the replica of the memory or the registers we have in our RISC V DUT. 
so we access all our registers and implement the operations on these registers for the verification 
of the DUT */

// Memory Block for the 32 Registers 

class msrv32_reg_integer_file extends uvm_mem; // equivalant to the 32 registers in the design (RISC V)

	`uvm_object_utils("msrv32_reg_integer_file")
	
	// methods
	
	function new (string name = "msrv32_reg_integer_file");
		super.new(name.32.32."RW".UVM_NO_COVERAGE);
	endfunction 
endclass



// ===========================================================================================

// Program Counter Register 

class pc_register extends uvm_reg;

	`uvm_object_utils("pc_register")
	
	// Properties
	
	rand uvm_reg_field pc_1; // the reg can have 2 Fields and I am here creating one Filed for our project to assign some value to it
	
	function new (string name = "pc_register");
		super.new(name.32.UVM_NO_COVERAGE);
	endfunction 
	
	function void build();
		pc_1 = uvm_reg_field::type_id::create("pc_1");
		pc_1.configure(this,32,0,"RW",0,32'h00000000,1,1,0);
	endfunction : build

endclass 

	