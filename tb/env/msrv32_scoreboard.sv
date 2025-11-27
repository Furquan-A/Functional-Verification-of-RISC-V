class msrv32_scoreboard extends uvm_scoreboard;

	`uvm_component_utils(msrv32_scoreboard)
	
	uvm_tlm_analysis_fifo#(msrv32_rst_trans) fifo_rst[]; // from rst monitor of DUT and ref 
	uvm_tlm_analysis_fifo##(internal_reg_model) fifo_ref_h; // this is from the ref model 
	
	msrv32_env_config env_cfg;
	
	msrv32_reg_block rv32_reg_block_h;
	msrv32_reg_block_for_pc rv32_reg_block_h_for_pc;
	
	uvm_status_e status; // return status for the register operations 
	
	msrv32_rst_trans dut_rst_xtn, ref_rst_xtn;
	
	bit check = 1; // registers are equal 
	
	uvm_reg_data_t rd_data;
	
	bit[31:0] pc_reg;
	
	internal_reg_model register_model;
	
	// methods 
	
	extern function new (string name = "msrv32_scoreboard",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	
endclass 

// ================================================= new =========================================================

function msrv32_scoreboard :: new(string name = "msrv32_scoreboard", uvm_component parent);
	super.new(name,parent);
	fifo_ref_h = new("fifo_ref_h",this);
endfunction 

// ===============================================================================================================
// ================================================ build_phase ==================================================

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	
	if(!uvm_config_db#(msrv32_env_config)::get(this,"","msrv32_env_config",env_cfg)
		`uvm_fatal("SB CONFIG","Cannot get() the config from the config_db. did you set() it?")
		
	fifo_rst =new[env_cfg.no_of_rst_agent];
	
	foreach(fifo_rst[i])
		begin 
			fifo_rst[i] = new($sformatf("fifo_rst[%0d]",i),this);
		end 
endfunction 

// ================================================================================================================
// ================================================ connect_phase =================================================

function void msrv32_scoreboard :: connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	
	rv32_reg_block_h = env_cfg.rv32_reg_block_h;
	rv32_reg_block_h_for_pc = env_cfg.rv32_reg_block_h_for_pc;
	
endfunction 

// ===============================================================================================================
// ================================================= run_phase ===================================================

task msrv32_scoreboard :: run_phase(uvm_phase phase);

	fork 
		begin 
			forever 
				begin 
					fork 
						fifo_rst[0].get(dut_rst_xtn);
						fifo_rst[1].get(dut_rst_xtn);
					join 
				
				if(ref_rst_xtn.ms_riscv32_mp_rst_in == 1'b1 && dut_rst_xtn.ms_riscv32_mp_rst_in == 1'b1)
					begin 
						fifo_ref_h.get(register_model);
						for (int i = 0; i<32;i++)
							begin 
								this.rv32_reg_block_h.reg_file.read(status,i,rd_data, .path(UVM_BACKDOOR), .map(rv32_reg_block_h.rv32_reg_map));
								if(register_model.reg_file[i] != rd_data)
									begin 
										check = 0;
										break;
									end 
							end 
						if(check == 0)
							`uvm_info(get_item_name(), "\nRESET OPERATION FAILED\n ", UVM_LOW);
						else 
							`uvm_info(get_item_name(), "\nRESET OPERATION SUCCESSFUL\n ", UVM_LOW);
						end 
					end 
				end 
	join_none
	
endtask
			