class msrv32_env_config extends uvm_object;

	`uvm_object_utils(msrvv32_env_config)
	
	bit has_data_agent   = 1;
	bit has_rst_agent    = 1;
	bit has_instr_agent  = 1;
	bit has_irq_agent    = 1;
	
	int no_of_data_agent  = 2;
	int no_of_rst_agent   = 2;
	int no_of_instr_agent = 2;
	int no_of_irq_agent   = 2;
	
	bit has_virtual_sequencer = 1;
	bit has_scoreboard        = 1;
	bit has_referance_model   = 1;
	bit has_instr_subscriber  = 1;
	
	msrv32_data_agent_config  d_cfg[];
	msrv32_instr_agent_config in_cfg[];
	msrv32_irq_agent_config   i_cfg[];
	msrv32_rst_agent_config   r_cfg[];
	
	msrv32_reg_block         rv32_reg_block_h;
	msrv32_reg_block_for_pc  rv32_reg_block_h_for_pc;
	
	static comm passed_commands[$];
	static comm failed_commands[$];
	
	uvm_reg_data_t data1, data2;
	
	bit [4:0] addr_rs_1, addr_rs_2, addr_rd;
	
	bit [31:0]imm_temp_value;
	
	// for instruction agent 
	int no_of_instructions = 1;
	int nop = 3;
	bit d_hready_in;
	int store_mem[bit[31:0]];
	bit [31:0]pc_reg;
	
	extern function new(string name = "msrvv32_env_config");

endclass

function msrv32_env_config :: new(string name = " msrv32_env_config");
	super.new(name);
endfunction 

	