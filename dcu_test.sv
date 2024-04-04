class dcu_test extends uvm_test;
  `uvm_component_utils(dcu_test)
  
  dcu_env env;
  init_sequence seq;
  load_sequence load_seq;
  arithmetic_sequence arth_seq;
  logic_sequence logic_seq;
  noop_sequence noop_seq;
  not_sequence not_seq;
  
  
  function new(string name="dcu_test", uvm_component parent);
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
    // `uvm_info("DCU_TEST", "Top of run_phase", UVM_HIGH)
    
    repeat(50) begin
      load_seq = load_sequence::type_id::create("load_seq");
      load_seq.start(env.agent.sequencer);
      #15;
    end

    seq = init_sequence::type_id::create("init_seq");
    seq.start(env.agent.sequencer);
    
    repeat(50) begin
      arth_seq = arithmetic_sequence::type_id::create("arth_seq");
      arth_seq.start(env.agent.sequencer);
      #15;
    end
    
    repeat(100) begin
      logic_seq = logic_sequence::type_id::create("logic_seq");
      logic_seq.start(env.agent.sequencer);
      #15;
    end
    
    repeat(50) begin
      noop_seq = noop_sequence::type_id::create("noop_seq");
      noop_seq.start(env.agent.sequencer);
      #15;
    end
    
    repeat(50) begin
      not_seq = not_sequence::type_id::create("not_seq");
      not_seq.start(env.agent.sequencer);
      #15;
    end
    
    #30
    phase.drop_objection(this);
    `uvm_info("DCU_TEST", "Finished DCU Testing.", UVM_LOW)
  endtask: run_phase
  
endclass: dcu_test