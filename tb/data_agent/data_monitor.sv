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
	
	
	
	