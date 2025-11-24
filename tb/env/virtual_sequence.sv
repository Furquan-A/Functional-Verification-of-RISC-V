class msrv32_vseq_base extends uvm_sequence#(uvm_sequence_item);

	`uvm_object_utils(msrv32_vseq_base)
	
	msrv32_rst_sequencer r_seqrh[];
	msrv32_virtual_sequencer vseqrh;
	msrv32_env_config m_cfg;
	
	
	// Standard Methods 
	extern function new(string name = "msrv32_vseq_base");
	extern task body();
	
endclass : msrv32_vseq_base

// ============================== new =======================================

function msrv32_vseq_base :: new (string name = "msrv32_vseq_base");
	super.new(name);
endfunction 

// ============================= body =======================================

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

// ===========================================================================

class reset_vseq extends msrv32_vseq_base;

	`uvm_object_utils(reset_vseq)
	
	msrv32_rst_seq rst_seq1,rst_seq2;
	
	extern function new(string name = "reset_vseq");
	extern task body();
	
endclass 

// ========================== new =======================================

function reset_vseq :: new (string name = "reset_vseq");
	super.new(name);
endfunction

// ============================== body ==================================

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