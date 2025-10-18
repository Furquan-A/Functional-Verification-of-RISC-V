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

function void  msrv32_test_base :: build_phase(uvm_phase phase );
super.build_phase(phase);


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
	
