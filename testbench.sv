`timescale 1ns/1ns

import uvm_pkg::*;
`include "uvm_macros.svh"

`include "interface.sv"
`include "sequence_item.sv"
`include "sequences.sv"
`include "sequencer.sv"
`include "driver.sv"
`include "monitor.sv"
`include "agent.sv"
`include "scoreboard.sv"
`include "env.sv"
`include "dcu_test.sv"
`include "reset_test.sv"

module test_top();
  
  logic clock;
  
  ttdcu_interface iface(.clk(clock));
  
  tt_um_himanshu5_prog_chipTop dut(
    .clk(iface.clk),
    .rst_n(iface.rst),
    .ena(iface.ena),
    .ui_in(iface.in),
    .uo_out(iface.out),
    .uio_in(iface.io_in),
    .uio_out(iface.io_out),
    .uio_oe(iface.bidir_ena)
  );
  
  initial begin
    uvm_config_db#(virtual ttdcu_interface)::set(null, "*", "vinf", iface);
  end
  
  initial begin
    run_test("reset_test");
    run_test("dcu_test");
  end
  
  // clock generator
  initial begin
    clock = 0;
    #5;
    forever begin
      clock = ~clock;
      #2;
    end
  end

  // timeout logic
  initial begin
    #500_000;
    $display("Timeout triggered. Test ran for 50_000_000 cycles without finishing.");
    $finish();
  end

  // output waveform data
  initial begin
    $dumpfile("d.vcd");
    $dumpvars();
  end
  
  final begin
      $display("overall coverage = %0f", $get_coverage());
      //$display("Op Code coverage = %0f", cg.get_coverage());
      //$display("Result coverage = %0f", cg.get_coverage());
  end
  
endmodule: test_top