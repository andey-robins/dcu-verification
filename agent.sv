class dcu_agent extends uvm_agent;
  `uvm_component_utils(dcu_agent)
  
  dcu_driver driver;
  dcu_monitor monitor;
  dcu_sequencer sequencer;
  
  function new(string name="dcu_agent", uvm_component parent);
    super.new(name, parent);
  endfunction: new
  
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    driver = dcu_driver::type_id::create("driver", this);
    monitor = dcu_monitor::type_id::create("monitor", this);
    sequencer = dcu_sequencer::type_id::create("sequencer", this);
    
  endfunction: build_phase
  
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    
    driver.seq_item_port.connect(sequencer.seq_item_export);
    
  endfunction: connect_phase
  
  
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
  endtask: run_phase
  
endclass: dcu_agent