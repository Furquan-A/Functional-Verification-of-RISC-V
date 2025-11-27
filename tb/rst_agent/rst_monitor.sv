class msrv32_rst_monitor extends uvm_monitor; // purpose : to collect the signal from the Design which we drived using the driver 

	// factory registration 

	`uvm_component_utils("msrv32_rst_monitor");
	
	// Properties 
	
	msrv32_rst_trans rst_xtn;
	msrv32_rst_agent_config r_cfg;
	
	
	// Interface 
	
	virtual msrv32_ahb_rst_if.MON_MP vif;
	
	// Analysis Port
	uvm_analysis_port#(msrv32_rst_trans) rst_monitor_port;
	
	// Methods
	
	extern function new (string name = "msrv32_rst_monitor", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern function void monitor();
	
endclass 

// ===================================== new ========================================================================

function msrv32_rst_monitor :: new(string name = "msrv32_rst_monitor", uvm_component parent);
	super.new(name,parent);
	rst_monitor_port = new("rst_monitor_port", this);
endfunction 

// ================================================================================================================
// =================================== build_phase ================================================================

function msrv32_rst_monitor :: build_phase(uvm_phase phase);
	super.build_phase(phase);

	if(!uvm_config_db#(msrv32_rst_agent_config)::get(this,"","msrv32_rst_agent_config"r_cfg))
		`uvm_fatal("RST MONITOR CONFIG","configuration is not yet set() properly")
		
		rst_xtn = msrv32_rst_trans::type_id::create("rst_xtn"); // doubt . why dont we use :this: here in this object creation ?
		
endfunction : build_phase

// ================================================================================================================
// ===================================== connect_phase ============================================================

function msrv32_rst_monitor :: connect_phase(uvm_phase phase);

	super.connect_phase(phase);
	vif = r_cfg.vif;

endfunction : connect_phase

// ================================================================================================================
// ===================================== run_phase ================================================================

task msrv32_rst_monitor :: run_phase(uvm_phase phase);

	forever 	
		begin 
			@(vif.ms_riscv32_mp_rst_in);
			monitor();
		end 
		
endtask : run_phase

// ================================================================================================================
// ================================== monitor =====================================================================

task msrv32_rst_monitor :: monitor();

	if(vif.ms_riscv32_mp_rst_in = 1'b1)
		begin 
			// when the reset signal is high collect that reset signal from the interface and store to verify in the scoreboard 
			rst_xtn.ms_riscv32_mp_rst_in = vif.ms_riscv32_mp_rst_in;
		end 
		
	rst_monitor_port.write(rst_xtn);
endtask : monitor