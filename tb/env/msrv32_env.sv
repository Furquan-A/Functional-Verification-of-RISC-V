class msrv32_env extends uvm_env;

`uvm_component_utils(msrv32_env)

virtual can_if;

data_agent d_agent[];
instr_agent in_agent[];
irq_agent i_agent[];
rst_agent r_agent[];

msrv32_virtual_sequencer v_sequencer;

msrv32_scoreboard sb;
msrv32_env_config m_cfg;
msrv32_ref_model ref_model;

msrv32_instr_subscriber instr_subscriber;

extern function new(string name = " msrv32_env", uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);


endclass


function msrv32_env :: new (string name = "msrv32_env", uvm_component parent);
super.new(name,parent);
endfunction 


function void msrv32_env :: build_phase(uvm_phase phase);
super.build_phase(phase);

// get the config
if(!uvm_config_db#(msrv32_env_config) :: get(this,"","msrv32_env_config",m_cfg))
	`uvm_fatal("CONFIG","Cannot get() m_cfg from uvm_config_db here. Have you set() it in the higher class ?")
	
	//Agents
	if(m_cfg.has_data_agent)
		begin 
			d_agent = new[m_cfg.no_of_data_agent];
			foreach(d_agent[i])
				begin 
					d_agent[i] = data_agent::type_id::create($sformatf("d_agent[%0d]",i),this);
					uvm_config_db#(data_agent)::set(this,$sformatf("d_agent[%0d]*"),"data_agent",m_cfg.d_cfg[i]);
				end 
		end 
		
	if(m_cfg.has_instr_agent)
		begin 
			in_agent = new[m_cfg.no_of_instr_agent];
			foreach(in_agent[i])
				begin 
					in_agent[i] = irq_agent::type_id::create($sformatf("in_agent[%0d]",i),this);
					uvm_config_db#(irq_agent)::set(this,$sformatf("in_agent[%0d]*"),"irq_agent",m_cfg.in_cfg[i]);
				end 
		end
		
	if(m_cfg.has_irq_agent)
		begin 
			i_agent = new[m_cfg.no_of_irq_agent];
			foreach(i_agent[i])
				begin 
					i_agent[i] = irq_agent::type_id::create($sformatf("i_agent[%0d]",i),this);
					uvm_config_db#(irq_agent)::set(this,$sformatf("i_agent[%0d]*"),"irq_agent",m_cfg.i_cfg[i]);
				end 
		end
				
	if(m_cfg.has_rst_agent)
		begin 
			r_agent = new[m_cfg.no_of_rst_agent];
			foreach(r_agent[i])
				begin 
					r_agent[i] = rst_agent::type_id::create($sformatf("r_agent[%0d]",i),this);
					uvm_config_db#(rst_agent)::set(this,$sformatf("r_agent[%0d]*"),"rst_agent",m_cfg.r_cfg[i]);
				end 
		end
		
	// virtual Sequencer 
	if(m_cfg.has_virtual_sequencer)
		begin 
			v_sequencer = msrv32_virtual_sequencer::type_id::create("v_sequencer",this);
		end 
		
	// Scoreboard 
	if(m_cfg.has_scoreboard)
		begin 
			sb = msrv32_scoreboard :: type_id :: create("sb",this);
		end 
		
	// Reference Model 
	if(m_cfg.has_ref_model)
		begin 
			ref_model = msrv32_ref_model::type_id::create("ref_model",this);
		end
endfunction