class dcu_scoreboard extends uvm_test;
  `uvm_component_utils(dcu_scoreboard)
  
  uvm_analysis_imp#(sequence_item, dcu_scoreboard) scoreboard_port;
  sequence_item transactions[$];
  
  int failedAnd = 0;
  int failedXor = 0;
  int failedNot = 0;
  int failedOr = 0;
  int failedLoad = 0;
  int failedAdd = 0;
  int failedSub = 0;
  int failedNop = 0;
  
  int passedAnd = 0;
  int passedXor = 0;
  int passedNot = 0;
  int passedOr = 0;
  int passedLoad = 0;
  int passedAdd = 0;
  int passedSub = 0;
  int passedNop = 0;

  
  int lastGrant = 0;
  int lastExp = 0;
  
  
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

    logic[7:0] res = curr_tx.out;

    `uvm_info("DCU_SBOARD_CMP", $sformatf("op=%d, tgt=%d, src1=%d, src2=%d, data=%d", op, tgt, src1, src2, data), UVM_HIGH)
    case (op)
      0, 8: begin
        // NOP
        if (res != 8'b0000_0000) begin
          failedNop++;
          if (lastGrant != res && lastExp != data) begin
          	`uvm_error("DCU_SBOARD_CMP", $sformatf("noop validation failed: got=%d, exp=%d", data, 8'b0000_0000))
          end
        end else begin
          passedNop++;
        end
      end
      1, 9: begin
        // Load
        if (res != data) begin
          failedLoad++;
          if (lastGrant != res && lastExp != data) begin
          	`uvm_error("DCU_SBOARD_CMP", $sformatf("load validation failed: got=%d, exp=%d", data, res))
          end
        end else begin
          passedLoad++;
        end
      end
      2, 10: begin
        // Add
        if (res != (src1 + src2)) begin
          failedAdd++;
          if (lastGrant != res && lastExp != data) begin
          	`uvm_error("DCU_SBOARD_CMP", $sformatf("add validation failed: got=%d, exp=%d", data, res))
          end
        end else begin
          passedAdd++;
        end
      end
      3, 11: begin
        // Sub
        if (res != (src1 - src2)) begin
          failedSub++;
          if (lastGrant != res && lastExp != data) begin
          	`uvm_error("DCU_SBOARD_CMP", $sformatf("sub validation failed: got=%d, exp=%d", data, res))
          end
        end else begin
          passedSub++;
        end
      end
      4, 12: begin
        // And
        if (res != (src1 && src2)) begin
          failedAnd++;
          if (lastGrant != res && lastExp != data) begin
          	`uvm_error("DCU_SBOARD_CMP", $sformatf("and validation failed: got=%d, exp=%d", data, res))
          end
        end else begin
          passedAnd++;
        end
      end
      5, 13: begin
        // Or
        if (res != (src1 || src2)) begin
          failedOr++;
          if (lastGrant != res && lastExp != data) begin
          	`uvm_error("DCU_SBOARD_CMP", $sformatf("or validation failed: got=%d, exp=%d", data, res))
          end
        end else begin
          passedOr++;
        end
      end
      6, 14: begin
        // Not
        if (res != ~src1) begin
          failedNot++;
          if (lastGrant != res && lastExp != data) begin
          	`uvm_error("DCU_SBOARD_CMP", $sformatf("not validation failed: got=%d, exp=%d", data, res))
          end
        end else begin
          passedNot++;
        end
      end
      7, 15: begin
        // Xor
        if (res != (src1 ^ src2)) begin
          failedXor++;
          if (lastGrant != res && lastExp != data) begin
          	`uvm_error("DCU_SBOARD_CMP", $sformatf("xor validation failed: got=%d, exp=%d", data, res))
          end
        end else begin
          passedXor++;
        end
      end
      default: begin
        if (res != 8'b0000_0000) begin
          `uvm_error("DCU_SBOARD_CMP", $sformatf("got invalid opcode with nonzero data: op=%d, data=%d", op, res))
        end
      end
    endcase    
    
    lastGrant = res;
    lastExp = data;
    
  endtask: compare
  
  function void check_phase(uvm_phase phase);
    `uvm_info("DCU_SBOARD_CMP", $sformatf("AND tests: fail=%d, pass=%d", failedAnd, passedAnd), UVM_LOW)
    `uvm_info("DCU_SBOARD_CMP", $sformatf("XOR tests: fail=%d, pass=%d", failedXor, passedXor), UVM_LOW)
    `uvm_info("DCU_SBOARD_CMP", $sformatf("NOT tests: fail=%d, pass=%d", failedNot, passedNot), UVM_LOW)
    `uvm_info("DCU_SBOARD_CMP", $sformatf("OR tests: fail=%d, pass=%d", failedOr, passedOr), UVM_LOW)
    `uvm_info("DCU_SBOARD_CMP", $sformatf("Load tests: fail=%d, pass=%d", failedLoad, passedLoad), UVM_LOW)
    `uvm_info("DCU_SBOARD_CMP", $sformatf("Add tests: fail=%d, pass=%d", failedAdd, passedAdd), UVM_LOW)
    `uvm_info("DCU_SBOARD_CMP", $sformatf("Sub tests: fail=%d, pass=%d", failedSub, passedSub), UVM_LOW)
    `uvm_info("DCU_SBOARD_CMP", $sformatf("Nop tests: fail=%d, pass=%d", failedNop, passedNop), UVM_LOW)
  endfunction: check_phase
  
endclass: dcu_scoreboard