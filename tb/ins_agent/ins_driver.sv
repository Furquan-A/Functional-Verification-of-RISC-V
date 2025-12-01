class msrv32_instr_driver extends uvm_driver #(msrv32_instr_trans);

	// Factory registration 
	`uvm_component_utils("msrv32_instr_driver")

	// Properties 
	msrv32_instr_trans instr_txn;
	msrv32_env_config env_cfg;
	msrv32_instr_agent_config in_cfg;
	
	// methods 
	extern function new (string name = "msrv32_instr_driver", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task send_to_dut();
	extern task storage(msrv32_instr_trans req);

endclass 

// ============================ new ==============================================================

function msrv32_instr_driver :: new (string name = "msrv32_instr_driver", uvm_component parent);
super.new(name,parent);
endfunction 

// ============================ build_phase =====================================================

function void msrv32_instr_driver :: build_phase(uvm_phase phase);
	super.build_phase(phase);
	
	if(!uvm_config_db#(msrvv32_instr_agent_config) :: get(this, "","msrv32_instr_agent_config",in_cfg))
		`uvm_fatal("INSTR_CONFIG","cannot get the in_cfg from db. did you set() it ?")
	
endfunction 

// ======================= connect_phase ========================================================

function void msrv32_instr_driver :: connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	vif = 