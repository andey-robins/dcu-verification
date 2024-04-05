#!/usr/bin/bash
export UVM_HOME=/home/synopsys/installs/verdi/U-2023.03-SP2/etc/uvm-1.2
export VSC_ARCH_OVERRIDE=linux
vcs -licqueue '-timescale=1ns/1ns' '+vcs+flush+all' '+warn=all' '-sverilog' '-ntb_opts' 'dtm' +incdir+$UVM_HOME/src $UVM_HOME/src/uvm.sv $UVM_HOME/src/dpi/uvm_dpi.cc -CFLAGS -DVCS +vcs+vcdpluson design.sv testbench.sv
./simv +vcs+lic+wait
ls
urg  -dir simv.vdb
ls -l urgReport/
cat urgReport/*txt