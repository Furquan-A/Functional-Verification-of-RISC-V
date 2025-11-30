class msrv32_instr_seqs_base extends uvm_sequence #(msrv32_instr_trans);
	
	`uvm_object_utils(msrv32_instr_seqs_base)
	
	// Properties
	msrv32_env_config m_cfg;
	uvm_status_e status;
	msrv32_reg_block rv32_reg_block_h;
	msrv32_reg_block_for_pc rv32_reg_block_h_for_pc;
	
	// Methods
	
	extern function new(string name = "msrv32_instr_seqs_base");
	extern task body();
	
endfunction 

// ============================== New ============================================================
function msrv32_instr_seqs_base :: new (string name = "msrv32_instr_seqs_base);
	super.new(name);
endfunction 


	