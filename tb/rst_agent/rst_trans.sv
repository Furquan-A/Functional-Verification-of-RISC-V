class msrv32_rst_trans extends uvm_sequence_item;

	`uvm_object_utils(msrv32_rst_trans)
	
	rand bit ms_riscv32_mp_rst_in;
	
	extern function new(string name = "msrv32_rst_trans");
	extern function void do_print(uvm_printer printer);

endclass 

function :: msrv32_rst_trans :: new (string name = "msrv32_rst_trans");
	super.new(name);
endfunction 

function void :: msrv32_rst_trans :: do_print(uvm_printer printer);
	super.do_print(printer);
	
	printer.print_field("ms_riscv32_mp_rst_in", this.ms_riscv32_mp_rst_in, 1 , UVM_BIN );
endfunction 