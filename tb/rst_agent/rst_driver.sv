class msrv32_rst_driver extends uvm_driver #(msrv32_data_trans);

// Factory registration 

`uvm_component_utils("msrv32_rst_driver")

extern function new (string name = "msrv32_rst_driver", uvm_component parent);

endclass 

function msrv32_rst_driver :: new (string name = "msrv32_rst_driver", uvm_component parent);
super.new(name,parent);
endfunction 
