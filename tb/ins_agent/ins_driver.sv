class msrv32_instr_driver extends uvm_driver #(msrv32_instr_trans);

	// Factory registration 
	`uvm_component_utils("msrv32_instr_driver")

	// Properties 
	msrv32_instr_trans instr_txn;
	msrv32_env_config env_cfg;
	msrv32_instr_agent_config in_cfg;
	
	bit [7:0] mem [bit[31;0]];
	
	virtual msrv32_ahb_instr_if.DRV_MP vif;
	
	// methods 
	extern function new (string name = "msrv32_instr_driver", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task send_to_dut();
	extern task storage(msrv32_instr_trans req);

endclass 

// ============================ new ==============================================================

function msrv32_instr_driver :: new (string name = "msrv32_instr_driver", uvm_component parent);
super.new(name,parent);
endfunction 

// ============================ build_phase =====================================================

function void msrv32_instr_driver :: build_phase(uvm_phase phase);
	super.build_phase(phase);
	
	if(!uvm_config_db#(msrvv32_instr_agent_config) :: get(this, "","msrv32_instr_agent_config",in_cfg))
		`uvm_fatal("INSTR_CONFIG","cannot get the in_cfg from db. did you set() it ?")
	
	if(!uvm_config_db#(msrv32_env_config) :: get(this, "","msrv32_env_config",env_cfg))
		`uvm_fatal(get_full_name(),"is not set in the referance model. set properly")
endfunction 

// ======================= connect_phase ========================================================

function void msrv32_instr_driver :: connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	vif = in_cfg.vif;
endfunction 

// ===================== run_phase ==============================================================

task msrv32_instr_driver :: run_phase(uvm_phase phase);
	forever 
		begin 
			seq_item_port.get_next_item(req);
			storage(req);
			send_to_dut();
			seq_item_port.item_done(req);
		end 
endtask 

// ===================== storage ================================================================

task msrv32_instr_driver :: storage(msrv32_instr_trans req);
	begin 
		$display("addr in driver = %0d", req.instr_addr);
		mem[req.instr_addr + 32'h0] = req.instruction[7:0];
		mem[req.instr_addr + 32'h1] = req.instruction[15:8];
		mem[req.instr_addr + 32'h2] = req.instruction[23:16];
		mem[req.instr_addr + 32'h3] = req.instruction[31:24];
		
		req.instr_addr = req.instr_addr = 32'h4;
	end 
endtask 

// =================== send_to_dut ==============================================================

task msrv32_instr_driver :: send_to_dut ();
	begin 
		wait(~((vif.drv_cb.ms_riscv32_mp_imaddr_out == 32'hz)||(vif.drv_cb.ms_riscv32_mp_imaddr_out == 32'hx)));
		`uvm_info(get_full_name().$sformat("pc value im_addr_out from design : %0d".vif.drv_cb.ms_riscv32_mp_imaddr_out). UVM_LOW)
		
		env_cfg.pc_reg = vif.drv_cb.ms_riscv32_mp_imaddr_out;
		
		vif.drv_cb.ms_riscv32_mp_instr_hready_in<= 1'b1;
		vif.drv_cb.ms_riscv32_mp_instr_in[7:0]=mem[vif.drv_cb.ms_riscv32_mp_imaddr_out + 32'h00000000];
		vif.drv_cb.ms_riscv32_mp_instr_in[15:8]=mem[vif.drv_cb.ms_riscv32_mp_imaddr_out + 32'h00000000];
		vif.drv_cb.ms_riscv32_mp_instr_in[23:16]=mem[vif.drv_cb.ms_riscv32_mp_imaddr_out + 32'h00000000];
		vif.drv_cb.ms_riscv32_mp_instr_in[31:24]=mem[vif.drv_cb.ms_riscv32_mp_imaddr_out + 32'h00000000];
		
		@(vif.drv_cb);
		
		vif.drv_cb.ms_riscv32_mp_instr_in<=1'b0;
		`uvm_info(get_full_name(),$sformat("instruction driver : %b " vif.drv_cb.ms_riscv32_mp_instr_in),UVM_LOW)
	end 
endtask
		