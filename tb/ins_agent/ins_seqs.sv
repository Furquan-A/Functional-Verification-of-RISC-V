class msrv32_instr_seqs_base extends uvm_sequence #(msrv32_instr_trans);
	
	`uvm_object_utils(msrv32_instr_seqs_base)
	
	// Properties
	msrv32_env_config env_cfg;
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

// ============================ body ============================================================

task msrv32_instr_seqs_base :: body();
	if(!uvm_config_db #(msrv32_env_config) :: get(null,get_full_name(),"msrv32_env_config",env_cfg))
		`uvm_fatal(get_full_name(),"configuration in instr_sequence base is not available, did you set() it ?")
	
	this.rv32_reg_block_h = env_cfg.rv32_reg_block_h;
	this.rv32_reg_block_h_for_pc = env_cfg.rv32_reg_block_h_for_pc;

endtask 
	