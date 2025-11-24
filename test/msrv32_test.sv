class msrv32_test_base extends uvm_test;

	`uvm_component_utils("msrv32_test_base")

	msrv32_env env;
	msrv32_env_config m_cfg;
	uvm_status_e status; // Returns status for the register operations

	bit has_data_agent = 1;
	bit has_instr_agent = 1;
	bit has_irq_agent = 1;
	bit has_rst_agent = 1;
	bit has_instr_subscriber = 1;
	
	int no_of_data_agents = 2;
	int no_of_instr_agents = 2;
	int no_of_irq_agents = 2;
	int no_of_rst_agents = 2;
	int a = 23;
	int b;
	
	
	msrv32_data_agent_config d_cfg[];
	msrv32_instr_agent_config in_cfg[];
	msrv32_irq_agent_config i_cfg[];
	msrv32_rst_agent_config r_cfg[];
	
	msrv32_reg_block rv32_reg_block_h;
	msrv32_reg_block_for_pc rv32_reg_block_h_for_pc;
	
	string test_case_name;
	
	extern function new(string name = "msrv32_test_base", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void config_riscv();
	extern function void end_of_elaboration_phase(uvm_phase phase);
	extern function void report_phase (uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	
endclass 


//====================================== new =============================

function msrv32_test_base :: new(string name = "msrv32_test_base" uvm_component parent);
	super.new(name,parent);
endfunction

//====================================== end_of_elaboration_phase ===================

function void msrv32_test_base :: end_of_elaboration_phase(uvm_phase phase);
	super.end_of_elaboration_phase(phase);
	uvm_top.print_topology();
endfunction 

// ==================================== run task ====================================

task msrv32_test_base :: run_phase(uvm_phase phase)l
	begin
		this.rv32_reg_block_h.reg_file.write(status, 15, a, .path(UVM_BACKDOOR), .map(rv32_reg_block_h.rv32_reg_map));
		this.rv32_reg_block_h.reg_file.read(status, 15, b,.path(UVM_BACKDOOR), .map(rv32_reg_block_h.rv32_reg_map));
		$display("this value of b is %0d",b);
		end
endtask 

// ===================================== config ==========================

function void msrv32_test_base :: config_riscv();

	if(has_data_agent)
		begin 
			d_cfg = new[no_of_data_agents];
			foreach(d_cfg[i])
				begin 
					d_cfg[i]= msrv32_data_agent_config ::type_id :: create($sformatf("d_cfg[%0d]",i),this);
					
					if(!uvm_config_db#(virtual msrv32_ahb_data_if)::get(this,"",$sformatf("msrv32_ahb_data_if_%0d",i),d_cfg[i].vif))
						`uvm_fatal("DATA_CONFIG.WRITE","cannot get() the interface vif from the uvm_config_db. have you set() it?")
						
					d_cfg[i].is_active = UVM_ACTIVE;
					m_cfg.d_cfg[i]=d_cfg[i];
				end 
		end 

	if(has_instr_agent)
		begin 
			in_cfg = new[no_of_instr_agents];
			foreach(in_cfg[i])
				begin 
					in_cfg[i]= msrv32_instr_config ::type_id :: create($sformatf("in_cfg[%0d]",i),this);
						
					if(!uvm_config_db#(virtual msrv32_ahb_instr_if)::get(this,"",$sformatf("msrv32_ahb_instr_if_%0d",i),in_cfg[i].vif))
						`uvm_fatal("INSTR_CONFIG.WRITE","cannot get() the interface vif from the uvm_config_db. have you set() it?")
							
					in_cfg[i].is_active = UVM_ACTIVE;
					m_cfg.in_cfg[i]=in_cfg[i];
					end 
			end 
			
	if(has_irq_agent)
		begin 
			i_cfg = new[no_of_instr_agents];
			foreach(i_cfg[i])
				begin 
					i_cfg[i]= msrv32_irq_config ::type_id :: create($sformatf("i_cfg[%0d]",i),this);
						
					if(!uvm_config_db#(virtual msrv32_ahb_irq_if)::get(this,"",$sformatf("msrv32_ahb_irq_if_%0d",i),i_cfg[i].vif))
						`uvm_fatal("INSTR_CONFIG.WRITE","cannot get() the interface vif from the uvm_config_db. have you set() it?")
							
					i_cfg[i].is_active = UVM_ACTIVE;
					m_cfg.i_cfg[i]=i_cfg[i];
					end 
			end
					
	if(has_rst_agent)
		begin 
			r_cfg = new[no_of_rst_agents];
			foreach(r_cfg[i])
				begin 
					r_cfg[i]= msrv32_irq_config ::type_id :: create($sformatf("r_cfg[%0d]",i),this);
						
					if(!uvm_config_db#(virtual msrv32_ahb_rst_if)::get(this,"",$sformatf("msrv32_ahb_rst_if_%0d",i),r_cfg[i].vif))
						`uvm_fatal("INSTR_CONFIG.WRITE","cannot get() the interface vif from the uvm_config_db. have you set() it?")
							
					r_cfg[i].is_active = UVM_ACTIVE;
					m_cfg.r_cfg[i]=r_cfg[i];
					end 
			end
			
	m_cfg.has_data_agent = has_data_agent;
	m_cfg.has_instr_agent = has_instr_agent;
	m_cfg.has_irq_agent = has_irq_agent;
	m_cfg.has_rst_agent = has_rst_agent;
	m_cfg.has_instr_subscriber = has_instr_subscriber;
	
	m_cfg.no_of_data_agents = no_of_data_agents;
	m_cfg.no_of_instr_agents = no_of_instr_agents;
	m_cfg.no_of_irq_agents = no_of_irq_agents;
	m_cfg.no_of_rst_agents = no_of_rst_agents;
	
endfunction 

// ========================================== build phase ===========================================

function void  msrv32_test_base :: build_phase(uvm_phase phase );
	super.build_phase(phase);
	m_cfg = msrv32_env :: type_id::create("m_cfg");
	
	rv32_reg_block_h = msrv32_reg_block :: type_id :: create ("rv32_reg_block_h");
	rv32_reg_block_h.build();
	m_cfg.rv32_reg_block_h = this.rv32_reg_block_h; // putting reg block into configuration
	
	rv32_reg_block_h_for_pc = msrv32_reg_block_for_pc :: type_id :: create ("msrv32_reg_block_for_pc");
	rv32_reg_block_h.build();
	m_cfg.rv32_reg_block_h = this.rv32_reg_block_h_for_pc;

	if(has_data_agent)
		begin 
		m_cfg.d_cfg = new[no_of_data_agents];
		end 

	if(has_instr_agent)
		begin 
		m_cfg.in_cfg = new[no_of_instr_agents];
		end 
		
	if(has_irq_agent)
		begin 
		m_cfg.ir_cfg = new[no_of_irq_agents];
		end 

	if(has_rst_agent) 
		begin 
		m_cfg.r_cfg = new[no_of_rst_agents];
		end 
		
		config_riscv();
		
		uvm_config_db #(msrv32_env_config)::set(this,"*","msrv32_env_config",m_cfg);
		env =  msrv32_env::type_id::create("env",this);
endfunction

function void msrv32_test_base :: report_phase(uvm_phase phase);
super.report_phase(phase);

endfunction : report_phase


// =========================================================================================================================

// Reset Test ==============================================================================================================

class msrv32_reset_test extends msrv32_test_base;

	`uvm_component_utils(msrv32_reset_test)
	
	reset_vseq rst_seqh;
	
	// Standard Methods 
	
	extern function new (string name = "msrv32_reset_test", uvm_component parent);
	extern function void build_phase(uvm_phase phase );
	extern task run_phase(uvm_phase phase);
	
endclass 

//====================================== new ========================================================

function msrv32_reset_test :: new (string name = "msrv32_reset_test", uvm_component parent);
super.new(name,parent);
endfunction 


// ========================================== build phase ===========================================

function void msrv32_reset_test :: build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction : bui;d_phase

// =========================================run_phase================================================

task msrv32_reset_test :: run_phase(uvm_phase phase);
	
	begin 
		phase.raise_objection(this);
		`uvm_info(get_type_name(),"msrv32_reset_test run phase ", UVM_DEBUG)
		rst_seqh = reset_vseq::type_id::create("rst_seqh",this);
		rst_seqh.start(env.v_sequencer);
		phase.drop_objection(this);
	end 
endtask  : run_phase     	

