class msrv32_rst_driver extends uvm_driver #(msrv32_data_trans); // Purpose : Driving the RESET signal to the Design 

	// Factory registration 
	`uvm_component_utils("msrv32_rst_driver")
	
	// properties  
	msrv32_req_trans rst_xtn;
	msrv32_rst_agent_config r_cfg;
	
	// virtual Interface 
	virtual msrv32_rst_if.DRV_MP vif;
	
	// standard methods 
	extern function new (string name = "msrv32_rst_driver", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task send_to_dut(msrv32_data_trans rst_xtn);
	
endclass 

// ===================================== new =========================================================

function msrv32_rst_driver :: new (string name = "msrv32_rst_driver", uvm_component parent);
	super.new(name,parent);
endfunction 

// ===================================================================================================
// ================================= build_phase =====================================================

function void msrv32_rst_driver :: build_phase(uvm_phase phase);
	super.build_phase(phase);
	
	if(!uvm_config_db#(msrv32_rst_agent_config)::get(this."","msrv32_rst_agent_config",r_cfg))
		`uvm_fatal("DRV_CONFIG","cannot get() the r_cfg from config_db. Did you set() it ?")
		
endfunction : build_phase

// ===================================================================================================
// =============================== connect_phase =====================================================

function void msrv32_rst_driver :: connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	vif = r_cfg.vif;
endfunction : connect_phase 

// ===================================================================================================
// ================================ run_phase ========================================================

task msrv32_rst_driver :: run_phase(uvm_phase phase);
	
	forever 	
		begin 
			// send a rquest to get the next sequence_item fro the sequencer 
			seq_item_port.get_next_item(req);
			// drive the sequecne in the DUT 
			send_to_dut(req);
			// send the ack/response 
			seq_item_port_item_done();
		end 
endtask 

// ====================================================================================================
// =============================== send_to_dut ========================================================

task msrv32_rst_driver :: send_to_dut(msrv32_data_trans rst_xtn);
	`uvm_info(get_type_name(),$sformatf("send data : \n %s ", rst_xtn.sprint()), UVM_DEBUG)
	
	@(vif.drv_cb);
	if(rst_xtn.ms_riscv32_mp_rst_in == 1'b1)
		// if the reset is one then I am sending that reset signal to the design via interface
		vif.drv_cb.ms_riscv32_mp_rst_in <= rst_xtn.ms_riscv32_mp_rst_in;
		
		repeat(1) 
		@(vif.drv_cb);
		vif.drv_cb.ms_riscv32_mp_rst_in <= 1'b0;
		r_cfg.drv_rst_count++; // a counter to keep the count of how many times the reset has been changed 
		
endtask : send_to_dut
