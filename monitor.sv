class dcu_monitor extends uvm_monitor;
  `uvm_component_utils(dcu_monitor)
  
  virtual ttdcu_interface vinf;
  sequence_item item;
  
  uvm_analysis_port#(sequence_item) monitor_port;
  
  function new(string name="dcu_monitor", uvm_component parent);
    super.new(name, parent);
  endfunction: new
  
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    if (!uvm_config_db#(virtual ttdcu_interface)::get(this, "*", "vinf", vinf)) begin
      `uvm_error("DCU_MONITOR", "Unable to get virtual interface")
    end
    
    monitor_port = new("monitor_port", this);
    
  endfunction: build_phase
  
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
  endfunction: connect_phase
  
  
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    
    forever begin
      item = sequence_item::type_id::create("item");
      
      // sample inputs
      //wait(!vinf.rst);
      @(posedge vinf.clk);
      item.rst = vinf.rst;
      item.ena = vinf.ena;
      item.in = vinf.in;
      item.io_in = vinf.io_in;
      
      // sample outputs
      #15 // delay from spec
      @(posedge vinf.clk);
      item.out = vinf.out;
      item.io_out = vinf.io_out;
      item.bidir_ena = vinf.bidir_ena;
      
      monitor_port.write(item);
      
    end
    
  endtask: run_phase
  
endclass: dcu_monitor