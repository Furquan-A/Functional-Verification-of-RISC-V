class msrv32_rst_sequencer extends uvm_sequencer#(msrv32_inter_trans);

`uvm_component_utils(msrv32_rst_sequencer);

extern function new (string name = "msrv32_rst_sequencer", uvm_component parent);

endclass 

function msrv32_rst_sequencer :: new (string name = "msrv32_rst_sequencer", uvm_component parent);
super.new(name, parent);
endfunction 
