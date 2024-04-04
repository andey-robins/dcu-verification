class dcu_driver extends uvm_driver#(sequence_item);
  `uvm_component_utils(dcu_driver)
  
  virtual ttdcu_interface vinf;
  sequence_item item;
  
  function new(string name="dcu_driver", uvm_component parent);
    super.new(name, parent);
  endfunction: new
  
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    if (!uvm_config_db#(virtual ttdcu_interface)::get(this, "*", "vinf", vinf)) begin
      `uvm_error("DCU_DRIVER", "Unable to get virtual interface")
    end
  endfunction: build_phase
  
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
  endfunction: connect_phase
  
  
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    
    forever begin
      item = sequence_item::type_id::create("item");
      
      // this handle gets exposed after we connect the port from the
      // sequencer to the port in the agent connect_phase
      seq_item_port.get_next_item(item);
      drive(item);
      seq_item_port.item_done();
    end
    
    //cg_load.stop();
  endtask
 
  
  task drive(sequence_item item);
    // i think we only need to drive the non-output ports...
    // which would be these five and then we would check the other
    // outputs in the monitor...
    @(posedge vinf.clk);
    vinf.rst <= item.rst;
    vinf.ena <= item.ena;
    vinf.in <= item.in;
    vinf.io_in <= item.io_in;
  endtask: drive
  
endclass: dcu_driver