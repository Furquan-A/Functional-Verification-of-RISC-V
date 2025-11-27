// The ref model should Act like the actual design . Like in Our case it should act like the RISC-V processor with all the 36 registers 

class msrv32_ref_model extends uvm_component;

	`uvm_component_utils(msrv32_ref_model)
	
	virtual msrv32_rst_if.RM_MP vif_2;
	
	uvm_analysis_port#(internal_reg_model) ref2sb_ap; // ref model to scoreboard 
	
	internal_reg_model register_model;
	msrv32_env_config env_cfg;
	
	// local variables for the instructions 
	
	msrv32_rst_trans rst_xtn;
	
	extern function new(string name = "msrv32_ref_model", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase);
	extern task run_phase(uvm_phase phase);
	extern task get_rst();
	extern function void rst_ip();
	
endclass 

// =================================================== new ================================================

function msrv32_ref_model :: new (string name = "msrv32_ref_model", uvm_component parent);
	super.new(name,parent);
	ref2sb_ap = new("ref2sb_ap",this);
endfunction 

// =======================================================================================================
//========================================== build_phase =================================================

function void msrv32_ref_model :: build_phase(uvm_phase phase);
	super.build_phase(phase);
	
	if(!uvm_config_db#(msrv32_env_config)::get(this,"","msrv32_env_config",env_cfg)
		`uvm_fatal("REF_MODEL CONFIG","Cannot get() the config from the config_db. did you set() it?")
	
	register_model = new();
	rst_xtn = msrv32_rst_trans::type_id::create("rst_xtn");
endfunction 

// ========================================================================================================
// ========================================= connect_phase ================================================

function void msrv32_ref_model :: connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	vif_2 = env_cfg.r_cfg[1].vif; // connect the rst and rst if 
endfunction

// ========================================================================================================
// ======================================== run_phase =====================================================

task msrv32_ref_model :: run_phase(uvm_phase phase);

	forever 
		begin 
			@(vif_2.rm_cb);
						fork : F1 
									begin 
										get_rst();
									end 
									
									begin 
										if(rst_xtn.ms_riscv32_mp_rst_in)
														begin 
															`uvm_info(get_item_name,"------------------------------ reset in the ref_model ---------------------------", UVM_NONE)
															$display("RESET CALLED --------------------- %t ", $time);
															rst_ip();
														end 
									end 
						join_any;
		end 
endtask 
	