// objects again, not components

// BASE DCU
class dcu_base_sequence extends uvm_sequence;
  `uvm_object_utils(dcu_base_sequence)
  
  sequence_item pkt;
  
  function new(string name="dcu_base_sequence");
    super.new(name);
  endfunction: new
  
  
  task body();
    pkt = sequence_item::type_id::create("base_pkt");
    start_item(pkt);
    pkt.randomize() with { rst == 0; };
    finish_item(pkt);
  endtask: body
  
endclass: dcu_base_sequence

/*****************************************************************************************************************/
// INITIALIZATION
class init_sequence extends uvm_sequence;
  `uvm_object_utils(init_sequence)
  
  load_sequence_item load_pkt;
  sequence_item enable_pkt;

  function new(string name="dcu_init_sequence");
    super.new(name);
  endfunction: new
  
  task body();
    `uvm_info("sequences", "body", UVM_LOW)
    // create load packet
    enable_pkt = sequence_item::type_id::create("enable_pkt");
    start_item(enable_pkt);
    enable_pkt.randomize() with { rst == 1 && ena == 1; };
    // covergroup sample packet here
    finish_item(enable_pkt);
    for (int i = 0; i <= 15; i++) begin
      load_pkt = load_sequence_item::type_id::create("load_pkt");
      start_item(load_pkt);
      load_pkt.randomize() with {in[3:0] == i && io_in == i;};
      finish_item(load_pkt);
    end
    
  endtask: body
  
  task post_body();
    `uvm_info("Sequences", "post_body", UVM_LOW)
  endtask: post_body
  
endclass: init_sequence

/*****************************************************************************************************************/
// LOAD
class load_sequence extends uvm_sequence;
  `uvm_object_utils(load_sequence)
  
  load_sequence_item load_pkt;
  sequence_item enable_pkt;
  
  covergroup cg_load_seq with function sample(logic[3:0] tgt, logic[7:0] data);
    target_cp: coverpoint tgt
    	{option.auto_bin_max = 16;}
    
   data_cp: coverpoint data {
     bins zeroes = {8'b00000000};
      bins low = {[1:127]};
      bins high = {[128:254]};
      bins ones = {8'b11111111};
   }
  endgroup: cg_load_seq

  function new(string name="dcu_load_sequence");
    super.new(name);
    cg_load_seq = new();
  endfunction: new
  
  task body();
    `uvm_info("sequences", "body", UVM_LOW)
    // create load packet
    enable_pkt = sequence_item::type_id::create("enable_pkt");
    start_item(enable_pkt);
    enable_pkt.randomize() with { rst == 1 && ena == 1; };
    // covergroup sample packet here
    finish_item(enable_pkt);
    
    load_pkt = load_sequence_item::type_id::create("load_pkt");
    start_item(load_pkt);
    load_pkt.randomize();
    // covergroup sample packet here
    cg_load_seq.sample(load_pkt.in[3:0], load_pkt.io_in);
    finish_item(load_pkt);
  endtask: body
  
  task post_body();
    `uvm_info("Sequences", "post_body", UVM_LOW)
    cg_load_seq.stop();
  endtask: post_body
  
endclass: load_sequence

/*****************************************************************************************************************/
// ARITHMETIC (ADD/SUB)
class arithmetic_sequence extends uvm_sequence;
  `uvm_object_utils(arithmetic_sequence)
  
  sequence_item arith_pkt;
  
  covergroup cg_arith_seq with function sample(logic [3:0] op, logic [3:0] s0, logic [3:0] s1);
    op_cp: coverpoint op {
      bins add = {4'b0010};
      bins sub = {4'b0011};
    }
    
    source0_cp: coverpoint s0
    	{option.auto_bin_max = 16;}
    
    source1_cp: coverpoint s1
    	{option.auto_bin_max = 16;}
  endgroup: cg_arith_seq
  
  function new(string name="dcu_arithmetic_sequence");
    super.new(name);  
    cg_arith_seq = new();
  endfunction: new
  
  task body();
    `uvm_info("sequences", "body", UVM_LOW)
    // packet
    arith_pkt = sequence_item::type_id::create("arith_pkt");
    start_item(arith_pkt);
    // constraints
    arith_pkt.randomize() with { in[7:4] == 0'b0010 || in[7:4] == 0'b0011; }; 
    // covergroup
    cg_arith_seq.sample(arith_pkt.in[7:4], arith_pkt.io_in[7:4], arith_pkt.io_in[3:0]);
    finish_item(arith_pkt);
  endtask: body
  
  task post_body();
    `uvm_info("Sequences", "post_body", UVM_LOW)
    cg_arith_seq.stop();
  endtask: post_body
  
endclass: arithmetic_sequence

/*****************************************************************************************************************/
// LOGIC (AND/OR/XOR)
class logic_sequence extends uvm_sequence;
  `uvm_object_utils(logic_sequence)
  
  sequence_item logic_pkt;
  
  covergroup cg_logic_seq with function sample(logic [3:0] op, logic [3:0] s0, logic [3:0] s1);
    op_cp: coverpoint op {
      bins and_op = {4'b0100};
      bins or_op = {4'b0101};
      bins xor_op = {4'b0110};
    }
    
    source0_cp: coverpoint s0
    	{option.auto_bin_max = 16;}
    
    source1_cp: coverpoint s1
    	{option.auto_bin_max = 16;}
  endgroup: cg_logic_seq
  
  function new(string name="dcu_logic_sequence");
    super.new(name);
    cg_logic_seq = new();
  endfunction: new
  
  task body();
    `uvm_info("sequences", "body", UVM_LOW)
    // packet
    logic_pkt = sequence_item::type_id::create("logic_pkt");
    start_item(logic_pkt);
    // constraints
    logic_pkt.randomize() with { in[7:4] == 0'b0100 || in[7:4] == 0'b0101 || in[7:4] == 0'b0110; }; 
    // covergroup
    cg_logic_seq.sample(logic_pkt.in[7:4], logic_pkt.io_in[7:4], logic_pkt.io_in[3:0]);
    finish_item(logic_pkt);
  endtask: body
  
  task post_body();
    `uvm_info("Sequences", "post_body", UVM_LOW)
    cg_logic_seq.stop();
  endtask: post_body  
  
endclass: logic_sequence

/*****************************************************************************************************************/
// NO-OP
class noop_sequence extends uvm_sequence;
  `uvm_object_utils(noop_sequence)
  
  sequence_item noop_pkt;
  
  covergroup cg_noop_seq with function sample();
    
  endgroup: cg_noop_seq
  
  function new(string name="dcu_noop_sequence");
    super.new(name);
    cg_noop_seq = new();
  endfunction: new
  
  task body();
    `uvm_info("sequences","body", UVM_LOW)
    // packet
    noop_pkt = sequence_item::type_id::create("noop_pkt");
    start_item(noop_pkt);
    // constraints
    noop_pkt.randomize() with {};
    //covergroup
    cg_noop_seq.sample();
    finish_item(noop_pkt);
  endtask: body
  
  task post_body();
    `uvm_info("sequences", "post_body", UVM_LOW)
    cg_noop_seq.stop();
  endtask: post_body
endclass: noop_sequence

/*****************************************************************************************************************/
//NOT
class not_sequence extends uvm_sequence;
  `uvm_object_utils(not_sequence)
  
  sequence_item not_pkt;
  
  covergroup cg_not_seq with function sample();
  endgroup: cg_not_seq
  
  function new(string name="dcu_not_sequence");
    super.new(name);
    cg_not_seq = new();
  endfunction: new
  
  task body();
    `uvm_info("sequences", "body", UVM_LOW)
    //packet
    not_pkt = sequence_item::type_id::create("not_pkt");
    start_item(not_pkt);
    //constraints
    not_pkt.randomize() with {in[7:4] == 0'b0110 || in[7:4] == 0'b1110 ;};
    //covergroup
    cg_not_seq.sample();
    finish_item(not_pkt);
  endtask: body
  
  task post_body();
    `uvm_info("sequences", "post_body", UVM_LOW)
    cg_not_seq.stop();
  endtask: post_body
endclass: not_sequence

/*****************************************************************************************************************/
// DEFAULT
// class default_sequence extends uvm_sequence;
//   `uvm_object_utils(default_sequence)
// endclass: default_sequence