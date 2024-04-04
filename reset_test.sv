class reset_test extends uvm_test;
  `uvm_component_utils(reset_test)
  
  dcu_env env;
  
  
  function new(string name="reset_test", uvm_component parent);
    super.new(name, parent);
  endfunction: new
  
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    env = dcu_env::type_id::create("env", this);
    
  endfunction: build_phase
  
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
  endfunction: connect_phase
  
  
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this);
    `uvm_info("RESET_TEST", "Top of run_phase", UVM_HIGH)
    
    phase.drop_objection(this);
  endtask: run_phase
  
endclass: reset_test