class msrv32_vseq_base extends uvm_sequence#(uvm_sequence_item);

	`uvm_object_utils(msrv32_vseq_base)
	
	msrv32_instr_sequencer in_seqrh[];
	msrv32_rst_sequencer r_seqrh[];
	msrv32_virtual_sequencer vseqrh;
	msrv32_env_config m_cfg;
	
	rand uvm_reg_data_t data1,data2;
	randc bit[4:0] addr_rs_1,adddr_rs_2,addr_rd;
	rand bit[31:0] imm_temp_value;
	int instr_addr_temp = 0;
	
	constraint addr_c { addr_rs_1 inside {[1:31]};
						addr_rs_2 inside {[1:31]]};
						addr_rd inside {[1:31]};
						addr_rs_1 != addr_rs_2;
						addr_rd != addr_rs_1;
						addr_rd != addr_rs_2;
						}
						
	
	// Standard Methods 
	extern function new(string name = "msrv32_vseq_base");
	extern task body();
	
endclass : msrv32_vseq_base

// ============================== new ===================================================

function msrv32_vseq_base :: new (string name = "msrv32_vseq_base");
	super.new(name);
endfunction 

// ============================= body ==================================================

task msrv32_vseq_base :: body();
	$display("----------------> %s", get_full_name());
	if(!uvm_config_db #(msrv32_env_config) :: get(null,get(full_name(),"msrv32_env_config",m_cfg))
		`uvm_fatal(get_full_name(),"cannot get() m_cfg from the uvm_config_db. have you set it ?")
		
		r_seqrh = new[m_cfg.no_of_rst_agents];
		assert($cast(vseqrh.m_sequencer))
			else  
				begin 
					uvm_error("BODY","Error in $cast of the virtual sequencer")
				end 

		foreach(r_seqrh[i])
			r_seqrh[i] = vseqrh.r_seqrh[i]; // connecting the r_seqrh to the r_seqrh of the virtal_sequencer 
endtask 

// =====================================================================================

class reset_vseq extends msrv32_vseq_base;

	`uvm_object_utils(reset_vseq)
	
	msrv32_rst_seq rst_seq1,rst_seq2;
	
	extern function new(string name = "reset_vseq");
	extern task body();
	
endclass 

// ========================== new =======================================================

function reset_vseq :: new (string name = "reset_vseq");
	super.new(name);
endfunction

// ============================== body =================================================

task reset_vseq :: body();

	super. body();
	
	if(m_cfg.has_rst_agent)
		begin 
			rst_seq1 = msrv32_rst_seq :: type_id :: create("rst_seq1");
			rst_seq2 = msrv32_rst_seq :: type_id :: create("rst_seq2");
		end 
		
	fork 
		rst_seq1.start(r_seqrh[0]);
		rst_seq2.start(r_seqrh[1]);
	join 
	
endtask 

// =====================================================================================
// ======================== i_type_vseq ================================================

class i_type_vseq extends msrv32_vseq_base;

	`uvm_object_utils(i_type_vseq)
	
	i_type_sequence i_instr_seq1,i_instr_seq2;
	
	// methods 
	
	extern function new(string name = "i_type_vseq");
	extern task body();
	
endclass ; i_type_vseq 

// ========================= new =======================================================

function i_type_vseq :: new (string name = "i_type_vseq");
	super.new(name);
endfunction 

// ======================== body =======================================================

task i_type_vseq :: body();

	begin 
		super.body();
		if(m_cfg.has_instr_agent)
			begin 
				`uvm_info(get_full_name(),$sformatf("has_instr_agent = %0d",m_cfg.has_instr_agent),UVM_LOW)
				i_instr_seq1 = i_type_sequence :: type_id :: create("i_instr_seq1");
				i_instr_seq2 =i_type_sequence :: type_id  :: create("i_instr_seq2");
				if(!this.randomize() with {data1 inside {[1:100]|; imm_temp_value inside {[1:100]};})
					`uvm_fatal(get_type_name(), "randomization is not happening")
					
				m_cfg.data1=data1;
				m_cfg.data2 = data2;
				m_cfg.addr_rs_1 = addr_rs_1;
				m_cfg.addr_rs_2 = addr_rs_2;
				m_cfg.addr_rd = addr_rd;
				m_cfg.imm_temp_value = imm_temp_value;
			end 
			
			fork
				i_instr_seq1.start(in_seqrh[0]); // dut 
				i_instr_seq2.start(in_seqrh[1]); // referance model 
			join 
	end 
endtask 