class msrv32_rst_seqs_base extends uvm_sequence #(msrv32_rst_trans);

	`uvm_object_utils(msrv32_rst_seqs_base)
	
	function new(string name = "msrv32_rst_seqs_base");
		super.new(name);
	endfunction 
	
endclass 

// ===================================================================================
// ======================== reset sequence ===========================================

class msrv32_rst_seq extends msrv32_rst_seqs_base;

	`uvm_object_utils(msrv32_rst_seq)
	
	extern function new (string name = "msrv32_rst_seq");
	extern task body();
	
endclass 

 // ====================================== new =========================================

function msrv32_rst_seq :: new (string name = " msrv32_rst_seq");
	super.new(name);
endfunction 

// ======================================= body ========================================

task msrv32_rst_seq :: body();

	req = msrv32_rst_trans ::type_id :: create("req");
	
	// wait for the request from the driver 
	start_item(req);
	
	// Generate the transaction (randomize it) using ASSERT and the constraints 
	assert(req.randomize() with {ms_riscv32_mp_rst_in == 1'b1;});
	
	// give the sequence to the driver 
	// wait for thr acknowladgement 
	// finish the item 
	
	finish_item(req);
	
endtask : body


