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
											
													