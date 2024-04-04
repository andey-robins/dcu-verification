// this is an object class, not a component class
class sequence_item extends uvm_sequence_item;
  `uvm_object_utils(sequence_item)
  
  
  rand logic rst;
  rand logic ena;
  
  rand logic [7:0] in;
  rand logic [7:0] io_in;
  
  
  // outputs
  logic [7:0] out;
  logic [7:0] io_out;
  logic [7:0] bidir_ena;

  
  // sequence constraints
  //constraint test_c { rst inside {[0:1]}; }
  
  function new(string name="seq_item");
    super.new(name);
  endfunction: new
  	
  
endclass: sequence_item

class load_sequence_item extends sequence_item;
  `uvm_object_utils(load_sequence_item)
  
  constraint op_c { in[7:4] == 0'b0001 || in[7:4] == 0'b1001; }
  constraint data_bin_distribution {
    io_in dist {
      8'b00000000 :/ 1,
      [1:127] :/ 1,
      [128:254] :/ 1,
      8'b11111111 :/ 1
    };
   }
  
  function new(string name="load_seq_item");
    super.new(name);
  endfunction: new
  
endclass: load_sequence_item