class dcu_env extends uvm_env;
  `uvm_component_utils(dcu_env)
  
  dcu_agent agent;
  dcu_scoreboard scoreboard;
  
  function new(string name="dcu_env", uvm_component parent);
    super.new(name, parent);
  endfunction: new
  
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    agent = dcu_agent::type_id::create("agent", this);
    scoreboard = dcu_scoreboard::type_id::create("scoreboard", this);
    
  endfunction: build_phase
  
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    
    agent.monitor.monitor_port.connect(scoreboard.scoreboard_port);
    
  endfunction: connect_phase
  
  
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
  endtask: run_phase
  
endclass: dcu_env