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
	
// ===============================================================================================
// i_type_sequence 

class i_type_sequence extends msrv32_instr_seqs_base;

	`uvm_object_utils(i_type_sequence)
	
	extern function new(string name = "i_type_sequence");
	extern task body();
	
endclass 

// ========================== new ================================================================

function i_type_sequence :: new(string name = " i_type_sequence");
	super.new(name);
endfunction

// ========================== body ===============================================================

task i_type_sequence :: body();
	super.body();
	
	req = msrv32_instr_trans ::type_id :: create("req");
	
	// ---------------- no operation NOP ---------------------------------------------------------
	repeat(env_cfg.nop) // NOP instruction 
		begin 
			start_item(req);
			assert(req.randomize() with {instr_type == i_type; command == addi; rs1 == 0; imm[11:0] == 12'b0; funct3 == 3'b000; opcode == 'b0010011;});
			finish_item(req);
				`uvm_info(get_full_name(),"NOP sequence is completed",UVM_DEBUG);
		end 
		
		
	// --------------------- addi operation -------------------------------------------------------
	// ADDI x7,x5,23; //x7 =x5+23;
		
		this.rv32_reg_block_h.reg_file.write(status.env_cfg.addr_rs_1, env_cfg.data1, .path(UVM_BACKDOOR), .map(rv32_reg_block_h.rv32_reg_map), .parent(this));
		start_item(req);
		assert(req.randomize() with {instr_type == i_type; command == addi; imm == env_cfg.imm_temp_value; rs1 == env_cfg.addr_rs_1; rd == env_cfg.addr_rd; funct3 == 3'b