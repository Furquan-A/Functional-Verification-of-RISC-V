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