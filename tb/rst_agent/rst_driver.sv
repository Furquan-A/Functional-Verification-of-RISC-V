class msrv32_rst_driver extends uvm_driver #(msrv32_data_trans);

	// Factory registration 
	`uvm_component_utils("msrv32_rst_driver")
	
	// properties  
	msrv32_req_trans rst_xtn;
	msrv32_rst_agent_config r_cfg;
	
	// virtual Interface 
	virtual msrv32_rst_if.DRV_MP vif;
	
	// standard methods 
	extern function new (string name = "msrv32_rst_driver", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task send_to_dut(msrv32_data_trans rst_xtn);
	
endclass 

// ===================================== new =========================================================

function msrv32_rst_driver :: new (string name = "msrv32_rst_driver", uvm_component parent);
	super.new(name,parent);
endfunction 

// ===================================================================================================
// ================================= build_phase =====================================================

function void msrv32_rst_driver :: build_phase(uvm_phase phase);
	super.build_phase(phase);
	
	if(!uvm_config_db#(msrv32_rst_agent_config)::get(this."","msrv32_rst_agent_config",r_cfg))
		`uvm_fatal("DRV_CONFIG","cannot get() the r_cfg from config_db. Did you set() it ?")
		
endfunction : build_phase

// ===================================================================================================
// =============================== connect_phase =====================================================

function void msrv32_rst_driver :: connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	vif = r_cfg.vif;
endfunction : connect_phase 