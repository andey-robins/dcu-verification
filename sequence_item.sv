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
  
  constraint ena_c { ena == 1 && rst == 1; }
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

class logic_sequence_item extends sequence_item;
  `uvm_object_utils(logic_sequence_item)
  
  constraint ena_c { ena == 1 && rst == 1; }
  constraint op_c { in[7:4] == 4'b0100 || in[7:4] == 4'b0101 || in[7:4] == 4'b0111 || // CU0 addresses
                    in[7:4] == 4'b1100 || in[7:4] == 4'b1101 || in[7:4] == 4'b1111; } // CU1 addresses
  constraint op_bin_distribution {
    in[7:4] dist {
      4'b0100 :/ 1,
      4'b0101 :/ 1,
      4'b0111 :/ 1,
      4'b1100 :/ 1,
      4'b1101 :/ 1,
      4'b1111 :/ 1
    };
   }
  
  function new(string name="logic_seq_item");
    super.new(name);
  endfunction: new
  
endclass: logic_sequence_item