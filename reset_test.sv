class reset_test extends uvm_test;
  `uvm_component_utils(reset_test)
  
  dcu_env env;

  reset_sequence seq;
  arithmetic_sequence arth_seq;
  logic_sequence logic_seq;
  not_sequence not_seq;
  
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
  
  
  // this uses ~70_000 cycles of tests
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this);
    
    repeat(500) begin
      seq = reset_sequence::type_id::create("reset_seq");
      seq.start(env.agent.sequencer);
      #30;

      arth_seq = arithmetic_sequence::type_id::create("arth_seq");
      arth_seq.start(env.agent.sequencer);
      #15;
    end

    repeat(500) begin
      seq = reset_sequence::type_id::create("reset_seq");
      seq.start(env.agent.sequencer);
      #30;

      logic_seq = logic_sequence::type_id::create("logic_seq");
      logic_seq.start(env.agent.sequencer);
      #15;
    end

    repeat(500) begin
      seq = reset_sequence::type_id::create("reset_seq");
      seq.start(env.agent.sequencer);
      #30;

      not_seq = not_sequence::type_id::create("not_seq");
      not_seq.start(env.agent.sequencer);
      #15;
    end

    phase.drop_objection(this);
  endtask: run_phase
  
endclass: reset_test