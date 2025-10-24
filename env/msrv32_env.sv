class msrv32_env extends uvm_env;

`uvm_component_utils(msrv32_env)

virtual can_if;

data_agent d_agent[];
ins_agent in_agent[];
irq_agent i_agent[];
rst_agent r_agent[];

extern function new(string name = " msrv32_env", uvm_component parent);
extern function void build_phase(uvm_phase phase);

endclass


function msrv32_env :: new (string name = "msrv32_env", uvm_component parent);
super.new(name,parent);
endfunction 


function void msrv32_env :: build_phase(uvm_phase phase);
super.build_phase(phase);
endfunction