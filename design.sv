// OSS https://github.com/himanshu5-prog/tt_um_myChip/tree/main
// Licensed under Apache 2.0

`include "computeUnit_0.v"
`include "computeUnit_1.v"

module tt_um_himanshu5_prog_chipTop ( input clk,
                    input rst_n, 
                    input ena,
                    input  wire [7:0] ui_in,    // Dedicated inputs - connected to the input switches
                    output wire [7:0] uo_out,   // Dedicated outputs - connected to the 7 segment display
                    input  wire [7:0] uio_in,   // IOs: Bidirectional Input path
                    output wire [7:0] uio_out,  // IOs: Bidirectional Output path
                    output wire [7:0] uio_oe   // IOs: Bidirectional Enable path (active high: 0=input, 1=output)
);
    wire [7:0] uo_out_comp0;
    wire [7:0] uo_out_comp1;

    wire [7:0] uio_out_comp0;
    wire [7:0] uio_out_comp1;

    wire [7:0] uio_oe_comp0;
    wire [7:0] uio_oe_comp1;

    computeUnit_0 compU_0 (.clk(clk), .rst_n(rst_n), .ena(ena), .ui_in(ui_in), .uo_out(uo_out_comp0), .uio_in(uio_in), .uio_out(uio_out_comp0), .uio_oe(uio_oe_comp0));
    computeUnit_1 compU_1 (.clk(clk), .rst_n(rst_n), .ena(ena), .ui_in(ui_in), .uo_out(uo_out_comp1), .uio_in(uio_in), .uio_out(uio_out_comp1), .uio_oe(uio_oe_comp1));

    assign uio_oe = uio_oe_comp0 | uio_oe_comp1;
    assign uio_out = uio_out_comp0 | uio_out_comp1;
    assign uo_out = uo_out_comp0 ^ uo_out_comp1;

endmodule