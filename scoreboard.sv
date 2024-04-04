class dcu_scoreboard extends uvm_test;
  `uvm_component_utils(dcu_scoreboard)
  
  uvm_analysis_imp#(sequence_item, dcu_scoreboard) scoreboard_port;
  sequence_item transactions[$];
  
  
  function new(string name="dcu_scoreboard", uvm_component parent);
    super.new(name, parent);
  endfunction: new
  
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    scoreboard_port = new("scoreboard_port", this);
    
  endfunction: build_phase
  
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);  
  endfunction: connect_phase
  
  
  function void write(sequence_item item);
    transactions.push_back(item);
  endfunction: write
  
  
  task run_phase(uvm_phase phase);
    super.run_phase(phase);  
    `uvm_info("DCU_SCOREBOARD", "Running scoreboard", UVM_HIGH)
    `uvm_info("DCU_SBOARD", "Started SBOARD run", UVM_LOW)
    
    forever begin
      sequence_item curr_tx;
      wait(transactions.size() != 0);
      curr_tx = transactions.pop_front();
      
      compare(curr_tx);
    end
  endtask: run_phase
  
  
  task compare(sequence_item curr_tx);
    logic[7:0] exp;
    logic[7:0] act;
    
    logic[3:0] op = curr_tx.in[7:4];
    logic[3:0] tgt = curr_tx.in[3:0];
    logic[3:0] src1 = curr_tx.io_in[7:4];
    logic[3:0] src2 = curr_tx.io_in[3:0];
    logic[7:0] data = curr_tx.io_in;

    logic[7:0] res = curr_tx.io_out;

    `uvm_info("DCU_SBOARD_CMP", $sformatf("op=%d, tgt=%d, src1=%d, src2=%d, data=%d", op, tgt, src1, src2, data), UVM_HIGH)
    case (op)
      0, 8: begin
        // NOP
        if (res != 8'b0000_0000) begin
          `uvm_error("DCU_SBOARD_CMP", $sformatf("noop validation failed: got=%d, exp=%d", data, 8'b0000_0000))
        end
      end
      1, 9: begin
        // Load
        if (res != data) begin
          `uvm_error("DCU_SBOARD_CMP", $sformatf("load validation failed: got=%d, exp=%d", data, res))
        end
      end
      2, 10: begin
        // Add
        if (res != (src1 + src2)) begin
          `uvm_error("DCU_SBOARD_CMP", $sformatf("add validation failed: got=%d, exp=%d", data, res))
        end
      end
      3, 11: begin
        // Sub
        if (res != (src1 - src2)) begin
          `uvm_error("DCU_SBOARD_CMP", $sformatf("sub validation failed: got=%d, exp=%d", data, res))
        end
      end
      4, 12: begin
        // And
        if (res != (src1 && src2)) begin
          `uvm_error("DCU_SBOARD_CMP", $sformatf("and validation failed: got=%d, exp=%d", data, res))
        end
      end
      5, 13: begin
        // Or
        if (res != (src1 || src2)) begin
          `uvm_error("DCU_SBOARD_CMP", $sformatf("or validation failed: got=%d, exp=%d", data, res))
        end
      end
      6, 14: begin
        // Not
        if (res != ~src1) begin
          `uvm_error("DCU_SBOARD_CMP", $sformatf("not validation failed: got=%d, exp=%d", data, res))
        end
      end
      7, 15: begin
        // Xor
        if (res != (src1 ^ src2)) begin
          `uvm_error("DCU_SBOARD_CMP", $sformatf("xor validation failed: got=%d, exp=%d", data, res))
        end
      end
      default: begin
        `uvm_error("DCU_SBOARD_CMP", $sformatf("got invalid opcode: %d", op))
      end
    endcase    
  endtask: compare
  
endclass: dcu_scoreboard