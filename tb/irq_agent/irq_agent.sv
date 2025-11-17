class msrv32_irq_agent extends uvm_agent;

`uvm_component_utils(msrv32_data_agent)

msrv32_data_driver drvh;
msrv32_data_monitor monh;
msrv32_data_sequencer seqrh;
msrv32_data_agent_config d_cfg;

//Methods 

extern funtion new(string name = "msrv32_data_agent", uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);

endclass 

function msrv32_data_agent ::  new (string name = "msrv32_data_agent", uvm_component parent); 
super.new(name,parent);
endfunction 

// Build phase 
function void msrv32_data_agent :: build_phase(uvm_phase phase);
super.build_phase(phase);
if(!uvm_config_db#(msrv32_data_agent_config)::get(this,"","msrv32_data_agent_config",d_cfg))
	`uvm_fatal("INSTR AGENT CONFIG","Cannot get() the in_cfg from the config_db. did you set() it ?")

	// always create the monitor and then check if the agent is active or passive and then create the driver and sequencer 
	monh = msrv32_data_monitor::type_id::create("monh",this);
	
	if(d_cfg.is_active == UVM_ACTIVE) 
		begin 
			drvh = msrv32_data_driver::type_id::create("drvh",this);
			seqrh = msrv32_data_sequencer::type_id::create("seqrh",this);
		end 
endfunction 


// Connect phase 
function void msrv32_data_agent :: connect_phase(uvm_phase phase);
super.connect_phase(phase); // optional we dont usualy need to call this in the connect phase 

if(d_cfg.is_active == UVM_ACTIVE) 
	begin 
		drvh.seq_item_port.connect(seqrh.seq_item_export);
	end 
endfunction 


	
