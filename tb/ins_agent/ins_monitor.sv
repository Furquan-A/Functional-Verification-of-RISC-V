class msrv32_instr_monitor extends uvm_monitor;

	// factory registration 

	`uvm_component_utils("msrv32_instr_monitor");
	
	// Properties 
	
	msrv32_instr_trans instr_xtn;
	msrv32_instr_agent_config in_cfg;
	bit [31:0] instruction;
	
	// Interface 
	
	virtual msrv32_ahb_instr_if.MON_MP vif;
	
	// Analysis Port
	uvm_analysis_port#(msrv32_instr_trans) instr_monitor_port;
	
	// Methods
	
	extern function new (string name = "msrv32_instr_monitor", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern function void decode_instruction();
	
endclass 

function msrv32_instr_monitor :: new(string name = "msrv32_instr_monitor", uvm_component parent);
super.new(name,parent);
instr_monitor_port = new("instr_monitor_port", this);
endfunction 

function msrv32_instr_monitor :: build_phase(uvm_phase phase);
super.build_phase(phase);

if(!uvm_config_db#(msrv32_instr_agent_config)::get(this,"","msrv32_instr_agent_config"in_cfg))
	`uvm_fatal("instr MONITOR CONFIG","configuration is not yet set() properly")
	
	instr_xtn = msrv32_instr_trans::type_id::create("instr_xtn"); // doubt . why dont we use :this: here in this object creation ?
	
endfunction : build_phase

function msrv32_instr_monitor :: connect_phase(uvm_phase phase)l

// Functionality 

endfunction : connect_phase


task msrv32_instr_monitor :: run_phase(uvm_phase phase);

// functionality 

endtask : run_phase
