class msrv32_instr_trans extends uvm_sequence_item;
	
	`uvm_object_utils(msrv32_instr_trans)
	
	// Properties
	typedef enum { r_type,i_type,u_type,s_type,b_type,j_type} instruction_type; // list of Instructions 
	typedef enum { add =0, sub,xor_op,or_op,and_op,sll,srl,sra,slt,sltu,
					addi = 10,xori,ori,andi,slli,srli,srai,slti,sltiu,
					lb = 19, lh,lw,lbu,lhu,
					sb=24,sh,sw,
					beq=27,bne,blt,bge,bltu,bgeu,
					jal=33,jalr,
					lui=35,auipc,
					ecall=37,ebreak
				} command_type;
				
	rand instruction_type instr_type;
	rand command_type command ;
	
	bit [31:0] instruction ;
	bit nop;
	
	int instr_addr;
	int instr_addr_next;
	
	rand bit[6:0] opcode;
	
	rand bit[6:0] opcode'
	rand bit[4:0] rd;
	rand bit[2:0] funct;
	rand bit[4:0] rs1;
	rand bit[4:0] rs2
	rand bit[6:0] funct7;
	rand bit[31:0] imm;
	
	comm cmd;
	
	// constraints
	constraint instruction_type_constraint { if(int'(command)<=9)
													instr_type ==r_type;
											else if(int'(command) inside {[18:23],34,37,38}
													instr_type == i_type;
											else if (int'(command)>24 && int'(command)<=26)
													instr_type == s_type;
											else if (int'(command)>=27 && int'(command)<=32)
													instr_type == b_type;
											else if (int'(command)==33)
													instr_type == j_type;
											else if (int'(command)==35 || int'(command) ==36)
													instr_type == u_type;
											}
										
	constraint funct3_value {	if (command inside {add,addi,sub,lb,sb,beq,jalr,ecall,ebreak})
									funct3 == 3'b000;
								else if(command inside {sll,slli,lh,sh,bne})
									funct3 == 3'b010;
								else if(command inside {sltu,sltiu})
									funct3 == 3'b011;
								else if(command inside {xor_op,xori,lbu,blt})
									funct3 == 3'b100;
								else if (command inside {srl,sra,srli,srai,lhu,bge})
									funct3 == 3'b110;
								else if(command inside {and_op,andi,bgeu})
									funct3 == 3;b111;
							}
							
	constraint funct7_value {	if(command inside {add,sll,slt,xor_op,or_op,and_op,srl,sltu,srli,slli})
									funct7 == 'h00;
								else 
									soft funct7 == 'h20;
							}
							
	constraint opcode_value {	if(instr_type ==r_type)
									opcode == 7'b0110011;
								else if (instr_type ==i_type)
									opcode inside {7'b0010011,7'b0000011,7'b11--111,7'b1110011};
								else if (instr_type ==s_type)
									opcode == 7'b0100011;
								else if (instr_type ==b_type)
									opcode == 7'b1100011;
								else if (instr_type ==u_type)
									opcode inside  {7'0110111,7'b0010111};
								else if (instr_type ==j_type)
									opcode == 7'b1101111;
							}
	
	// Methods 
	extern function new(string name = "msrv32_instr_trans");
	extern function void post_randomize();
	extern function void do_print(uvm_printer printer);

endclass 

// ============================ New ===================================================================

function msrv32_instr_trans :: new (string name = "msrv32_instr_trans");
	super.new(name);
endfunction 

// ========================== post_randomize ==========================================================

function void msrv32_instr_trans :: post_randomize();

	if(instr_type == r_type)
		instruction = {funct7,rs2,rs1,funct3,rd,opcode};
	else if(instr_type == i_type)
		if(command inside {slli,srai,srli})
			instruction = {funct7,imm[4:0],rs1,funct3,rd,opcode};
		else 
			instruction = {imm[11:0],rs1,funct3,rd,opcode};
	else if(instr_type ==s_type)
		instruction = {imm[11:5],rs2,rs1,funct3,imm[4:0],opcode};
	else if(instr_type == b_type)
		instruction = {imm[12],imm[10:5],rs2,rs1,funct3,imm[4:1],imm[11],opcode}
	else if(instr_type == u_type)
		instruction = {imm[31:12].rd,opcode};
	else if(instr_type == j_type)
		instruction = {imm[20],imm[10:1],imm[11],imm[19:12],rd,opcode};
	
endfunction 
	
							
							
	
													