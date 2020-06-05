// Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2017.4 (win64) Build 2086221 Fri Dec 15 20:55:39 MST 2017
// Date        : Wed May 27 17:33:24 2020
// Host        : DESKTOP-URKU7BU running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               c:/SDI_RX/EIVE-SDI_RX_Subsystem_t_v/EIVE-SDI_RX_Subsystem.ipdefs/SDI_RX_Subsystem_1.0_0/src/vio_0/vio_0_stub.v
// Design      : vio_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xczu9eg-ffvc900-1-i-es1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "vio,Vivado 2017.4" *)
module vio_0(clk, probe_in0, probe_in1, probe_in2, probe_out0, 
  probe_out1, probe_out2, probe_out3, probe_out4, probe_out5, probe_out6, probe_out7)
/* synthesis syn_black_box black_box_pad_pin="clk,probe_in0[0:0],probe_in1[0:0],probe_in2[2:0],probe_out0[0:0],probe_out1[0:0],probe_out2[2:0],probe_out3[1:0],probe_out4[2:0],probe_out5[0:0],probe_out6[0:0],probe_out7[0:0]" */;
  input clk;
  input [0:0]probe_in0;
  input [0:0]probe_in1;
  input [2:0]probe_in2;
  output [0:0]probe_out0;
  output [0:0]probe_out1;
  output [2:0]probe_out2;
  output [1:0]probe_out3;
  output [2:0]probe_out4;
  output [0:0]probe_out5;
  output [0:0]probe_out6;
  output [0:0]probe_out7;
endmodule
