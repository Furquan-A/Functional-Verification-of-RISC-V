class msrv32_instr_monitor extends uvm_monitor;

	// factory registration 

	`uvm_component_utils("msrv32_instr_monitor");
	
	// Properties 
	
	msrv32_instr_trans instr_xtn;
	msrv32_instr_agent_config in_cfg;
	
	bit [31:0] instruction;
	
	// Interface 
	
	virtual msrv32_ahb_instr_if.MON_MP vif;
	
	// Analysis Port
	uvm_analysis_port#(msrv32_instr_trans) instr_monitor_port;
	
	// Methods
	
	extern function new (string name = "msrv32_instr_monitor", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern function void decode_instruction();
	
endclass 

// ============================ new ====================================================================

function msrv32_instr_monitor :: new(string name = "msrv32_instr_monitor", uvm_component parent);
super.new(name,parent);
instr_monitor_port = new("instr_monitor_port", this);
endfunction 

// ========================= build_phase ==============================================================

function msrv32_instr_monitor :: build_phase(uvm_phase phase);
super.build_phase(phase);

if(!uvm_config_db#(msrv32_instr_agent_config)::get(this,"","msrv32_instr_agent_config"in_cfg))
	`uvm_fatal("instr MONITOR CONFIG","configuration is not yet set() properly")
	
	instr_xtn = msrv32_instr_trans::type_id::create("instr_xtn"); // doubt . why dont we use :this: here in this object creation ?
	
endfunction : build_phase

// ============================= connect_phase =========================================================

function msrv32_instr_monitor :: connect_phase(uvm_phase phase);
	
	super.connect_phase(uvm_phase phase );
	vif = in_cfg.vif;
endfunction : connect_phase

// ========================== run_phase ================================================================

task msrv32_instr_monitor :: run_phase(uvm_phase phase);
	forever
		begin
			instruction[31:0] = vif.mon_cb.ms_riscv32_mp_instr_in;
			if((!instruction==32'h00000013)|| instruction == 32'h0)
				instr_xtn.nop = 1'b1;
			else 
				begin 
					decode_instruction();
				end
			instr_monitor_port.write(instr_xtn);
			@(vif.mon_cb);
		end 
endtask : run_phase

// ======================= decode_instruction =========================================================

function void msrv32_instr_monitor :: decode_instruction();
	
	case(instruction [6:0] ) // opcode 
	7'b0010011: begin 
					case(instruction[14:12] // funct3
					3'b000: begin 
								instr_xtn.cmd = ADDI;
							end 
					3'b100: begin 
								instr_xtn.cmd = XORI;
							end 
					3'b110: begin 
								instr_xtn.cmd = ORI;
							end 
					3'b111: begin 
								instr_xtn.cmd = ANDI;
							end 
					3'001: begin 
								instr_xtn.cmd = SLLI;
							end 
					3'b101: begin 
								case(instruction[31:25])
									7'b00000000: instr_xtn.cmd = SRLI;
									7'b01000000: instr_xtn.cmd = SRAI;
								endcase 
							end
					3'010: begin 
								instr_xtn.cmd = SLTI;
							end 
					3'011: begin 
								instr_xtn.cmd = SLTUI;
							end 
					endcase 
					
					instr_xtn.rd = instruction[11:7];
					instr_xtn.rs1 = instruction[19:15];
					instr_xtn.imm[11:0] = instruction[31:20];
					instr_xtn.funct3=instruction[14:12];
					`uvm_info(get_full_name(),"I type instructions ", UVM_DEBUG)
				end 
					
	7'b0110011: begin // r - type 
					case(instruction[14:12]) // funct3
					3'b000: begin 
								case(instruction[31:25])
									7'b00000000: instr_xtn.cmd = ADD;
									7'b01000000: instr_xtn.cmd = SUB;
								endcase 
							end 
					3'b100: begin 
								instr_xtn.cmd = XOR;
							end 
					3'b110: begin 
								instr_xtn.cmd = OR;
							end
					3'b111: begin 
								instr_xtn.cmd = AND;
							end
					3'b001: begin 
								instr_xtn.cmd = SLL;
							end
					3'b101: begin 
								case(instruction[31:25])
									instr_xtn.cmd = SRL;
									instr_xtn.cmd = SRA;
								endcase
							end
					3'b010: begin 
								instr_xtn.cmd = SLT;
							end
					3'b011: begin 
								instr_xtn.cmd = SLTU;
							end
					endcase 
					
					instr_xtn.rd=instruction[11:7];
					instr_xtn.rs1=instruction[19:15];
					instr_xtn_rs2=instruction[24:20];
					instr_xtn.funct7=instruction[31:25];
					instr_xtn.funct3=instruction[14:12];
					`uvm_info(get_full_name(),"R type instructions ", UVM_DEBUG)
				
				end
				
	7'b00000011: begin // l_type
					case (instruction[14:12]) // funct3 
					3'b000: instr_xtn.cmd = LB;
					3'b001: instr_xtn.cmd = LH;
					3'b010: instr_xtn.cmd = LW;
					3'b100: instr_xtn.cmd = LBU;
					3'b101: instr_xtn.cmd = LHU;
					endcase 
					
					instr_xtn.rd=instruction[11:7];
					instr_xtn.rs1=instruction[19:15];
					instr_xtn.imm[11:0]=instruction[31:20];
					instr_xtn.funct3=instruction[14:12];
					`uvm_info(get_full_name(),"LOAD type instructions ", UVM_DEBUG)
					
				end 
				
	7'b0100011: begin // s-type
					case (instruction[14:0]) // funct3 
					3'b000: instr_xtn.cmd=SB;
					3'b001: instr_xtn.cmd=SH;
					3'b010: instr_xtn.cmd=SW;
					endcase 
					
					instr_xtn.rs2=instruction[24:20];
					instr_xtn.rs1=instruction[19:15];
					instr_xtn.imm[4:0]=instruction[11:7];
					instr_xtn.funct3=instructon[14:12];
					instr_xtn.imm[11:15]=instruction[31:25];
					

				