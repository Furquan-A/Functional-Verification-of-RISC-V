class msrv32_reg_block extends uvm_reg_block;

	`uvm_object_utils("msrv32_reg_block");

	rand msrv32_reg_integer_file reg_file;

	uvm_reg_map rv32_reg_map; // as uvm_reg_map is non virtual class we will directly create an object fot the base class 

	function new(string name = " msrv32_reg_block");
		super.new(name,UVM_NO_COVERAGE);
	endfunction 
	
	
	function void build();
		reg_file = msrv32_reg_integer_file::type_id::create("reg_file");
		reg_file.configure(this,"");
		addd_hdl_path("msrv32_tb_top.DUT","RTL");
		reg_file.add_hdl_path_slice("rv32_reg_map",'h0,4,UVM_LITTLE_ENDIAN,0);
		rv32_reg_map.add_mem(reg_file,5'h0,"RW");
	endfunction
endclass : msrv32_reg_block

class msrv32_reg_block_for_pc extends uvm_reg_block;
endclass :msrv32_reg_block_for_pc