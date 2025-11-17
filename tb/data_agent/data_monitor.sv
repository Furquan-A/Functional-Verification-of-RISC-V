class msrv32_data_monitor extends uvm_monitor;

	// factory registration 

	`uvm_component_utils("msrv32_data_monitor");
	
	// Properties 
	
	msrv32_data_trans data_xtn;
	msrv32_data_agent_config d_cfg;
	bit [31:0] instruction;
	
	// Interface 
	
	virtual msrv32_ahb_data_if.MON_MP vif;
	
	// Analysis Port
	uvm_analysis_port#(msrv32_data_trans) data_monitor_port;
	
	// Methods
	
	extern function new (string name = "msrv32_data_monitor", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern function void decode_instruction();
	
endclass 

function msrv32_data_monitor :: new(string name = "msrv32_data_monitor", uvm_component parent);
super.new(name,parent);
data_monitor_port = new("data_monitor_port", this);
endfunction 

function msrv32_data_monitor :: build_phase(uvm_phase phase);
super.build_phase(phase);

if(!uvm_config_db#(msrv32_data_agent_config)::get(this,"","msrv32_data_agent_config"d_cfg))
	`uvm_fatal("DATA MONITOR CONFIG","configuration is not yet set() properly")
	
	data_xtn = msrv32_data_trans::type_id::create("data_xtn"); // doubt . why dont we use :this: here in this object creation ?
	
endfunction : build_phase

function msrv32_data_monitor :: connect_phase(uvm_phase phase)l

// Functionality 

endfunction : connect_phase


task msrv32_data_monitor :: run_phase(uvm_phase phase);

// functionality 

endtask : run_phase
