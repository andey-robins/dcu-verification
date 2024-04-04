class dcu_sequencer extends uvm_sequencer#(sequence_item);
  `uvm_component_utils(dcu_sequencer)
  
  function new(string name="dcu_sequencer", uvm_component parent);
    super.new(name, parent);
  endfunction
  
endclass: dcu_sequencer