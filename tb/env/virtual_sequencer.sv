class msrv32_virtual_sequencer extends uvm_sequencer#(uvm_sequence_item);

	`uvm_object_utils(msrv32_virtual_sequencer)

	msrv32_rst_sequencer r_seqrh;
	msrv32_env_config m_cfg;
	
	// standard methods 
	extern function new (string name = " msrv32_virtual_sequencer");
	extern function void build_phase(uvm_phase phase );
	
endclass 

// =================================== new =========================================

function msrv32_virtual_sequencer :: new(string name = " msrv32_virtual_sequencer" );
	super.new(name);
endfunction 

// =================================== build_phase =================================

function void msrv32_virtual_sequencer :: build_phase(uvm_phase phase );
	super.build_phase(phase);
	
	if(!uvm_config_db#(msrv32_env_config)::get(this,"","msrv32_env_config",m_cfg))
		`uvm_fatal("V_seq CONFIG","cannot get the config, did you set() it ?")
		
	r_seqrh = new[m_cfg.no_of_rst_agent];
	
endfunction : build_phase



