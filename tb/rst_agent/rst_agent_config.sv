class msrv32_rst_agent_config extends uvm_object;
	`uvm_object_utils(msrv32_rst_agent_config)
	
	// virtual Interface 
	virtual msrv32_rst_if vif;
	
	static int drv_rst_count = 0;
	static int tmon_rst_count = 0;
	
	// standard method
	function new(string name = "msrv32_rst_agent_config");
		super.new(name);
	endfunction 

endclass 
