interface ttdcu_interface(input logic clk);
  
  logic rst;
  logic ena;
  
  logic [7:0] in;
  logic [7:0] out;
  logic [7:0] io_in;
  logic [7:0] io_out;
  logic [7:0] bidir_ena; // active high
  
endinterface : ttdcu_interface

