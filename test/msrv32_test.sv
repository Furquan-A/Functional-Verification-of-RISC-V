class msrv32_test_base extends uvm_test;

`uvm_component_utils(msrv32_test_base)

msrv32_env env;
msrv32_env_config m_cfg;

bit has_data_agent = 1;
bit has_instr_agent = 1;
bit has_irq_agent = 1;
bit has_rst_agent = 1;
bit has_instr_subscriber = 1;

int no_of_data_agents = 2;
int no_of_rst_agents = 2;
int no_of_instr_agents = 2;
int no_of_irq_agents = 2;

msrv32_data_agent_config d_cfg[];
msrv32_instr_agent_config in_cfg[];
msrv32_rst_agent_config r_cfg[]'
msrv32_irq_agent_config ir_cfg[];


string test_case_name;

extern function new (string name = "msrv32_test_base", uvm_component parent );
extern function void build_phase ( uvm_phase phase );
extern function void end_of_elaboration_phase (uvm_phase phase );
extern function void config_riscv();

endclass 

function msrv32_test_base :: new (string name = " msrv32_test_base", uvm_component parent);
super.new(name,parent);
endfunction 



function void msrv32_test_base :: end_of_elaboration_phase(uvm_phase phase);
super.end_of_elaboration_phase(phase);
uvm_top.print_topology();
endfunction

function void msrv32_test_base :: config_riscv();

if(has_data_agent)
	begin 
	d_cfg = new [no_of_data_agents];
	foreach(d_cfg[i])
	begin 
	d_cfg[i] = msrv32_test_base :: type_id :: create($sformat("d_cfg[%0d]",i));
		
		if(!uvm_config_db #(virtual msrv32_ahb_data_if) :: get (this,"",$sformat("msrv32_ahb_data_if_%0d",i),d_cfg[i].vif))
			`uvm_fatal(" VIF CONFIG, WRITE ", "Cannot get() interface vif from uvm_config_db. have you set() it ?")
		
		d_cfg[i].is_active = UVM_ACTIVE;
		m_cfg.d_cfg[i] = d_cfg[i];
	end 
end 


if(has_rst_agent)
	begin 
	r_cfg = new [no_of_rst_agents];
	foreach(r_cfg[i])
	begin 
	r_cfg[i] = msrv32_test_base :: type_id :: create($sformat("r_cfg[%0d]",i));
		
		if(!uvm_config_db #(virtual msrv32_ahb_rest_if) :: get (this,"",$sformat("msrv32_ahb_rest_if_%0d",i),r_cfg[i].vif))
			`uvm_fatal(" VIF CONFIG, WRITE ", "Cannot get() interface vif from uvm_config_db. have you set() it ?")
		
		r_cfg[i].is_active = UVM_ACTIVE;
		m_cfg.r_cfg[i] = r_cfg[i];
	end 
end 


if(has_irq_agent)
	begin 
	d_cfg = new [no_of_irq_agents];
	foreach(ir_cfg[i])
	begin 
	ir_cfg[i] = msrv32_test_base :: type_id :: create($sformat("ir_cfg[%0d]",i));
		
		if(!uvm_config_db #(virtual msrv32_ahb_irq_if) :: get (this,"",$sformat("msrv32_ahb_irq_if_%0d",i),ir_cfg[i].vif))
			`uvm_fatal(" VIF CONFIG, WRITE ", "Cannot get() interface vif from uvm_config_db. have you set() it ?")
		
		ir_cfg[i].is_active = UVM_ACTIVE;
		m_cfg.ir_cfg[i] = ir_cfg[i];
	end 
end 

if(has_instr_agent)
	begin 
	in_cfg = new [no_of_instr_agents];
	foreach(in_cfg[i])
	begin 
	in_cfg[i] = msrv32_test_base :: type_id :: create($sformat("in_cfg[%0d]",i));
		
		if(!uvm_config_db #(virtual msrv32_ahb_instr_if) :: get (this,"",$sformat("msrv32_ahb_instr_if_%0d",i),in_cfg[i].vif))
			`uvm_fatal(" VIF CONFIG, WRITE ", "Cannot get() interface vif from uvm_config_db. have you set() it ?")
		
		in_cfg[i].is_active = UVM_ACTIVE;
		m_cfg.in_cfg[i] = in_cfg[i];
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

function void  msrv32_test_base :: build_phase(uvm_phase phase );
super.build_phase(phase);
m_cfg = msrv32_env :: type_id::create("m_cfg");

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