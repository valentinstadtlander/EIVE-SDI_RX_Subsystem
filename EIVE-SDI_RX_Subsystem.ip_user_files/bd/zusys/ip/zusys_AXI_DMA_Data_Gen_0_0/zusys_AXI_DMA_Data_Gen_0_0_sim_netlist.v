// Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2017.4 (win64) Build 2086221 Fri Dec 15 20:55:39 MST 2017
// Date        : Fri May  8 09:19:50 2020
// Host        : ILH-517 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               C:/Users/st143005/Desktop/EIVE-SDI_RX_Subsystem/EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/zusys/ip/zusys_AXI_DMA_Data_Gen_0_0/zusys_AXI_DMA_Data_Gen_0_0_sim_netlist.v
// Design      : zusys_AXI_DMA_Data_Gen_0_0
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xczu9eg-ffvc900-1-i-es1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "zusys_AXI_DMA_Data_Gen_0_0,AXI_DMA_Data_Gen_v1_0,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "AXI_DMA_Data_Gen_v1_0,Vivado 2017.4" *) 
(* NotValidForBitStream *)
module zusys_AXI_DMA_Data_Gen_0_0
   (axi_aclk,
    axi_aresetn,
    m00_axis_tvalid,
    m00_axis_tdata,
    m00_axis_tkeep,
    m00_axis_tlast,
    m00_axis_tready,
    s00_axi_awaddr,
    s00_axi_awprot,
    s00_axi_awvalid,
    s00_axi_awready,
    s00_axi_wdata,
    s00_axi_wstrb,
    s00_axi_wvalid,
    s00_axi_wready,
    s00_axi_bresp,
    s00_axi_bvalid,
    s00_axi_bready,
    s00_axi_araddr,
    s00_axi_arprot,
    s00_axi_arvalid,
    s00_axi_arready,
    s00_axi_rdata,
    s00_axi_rresp,
    s00_axi_rvalid,
    s00_axi_rready);
  (* x_interface_info = "xilinx.com:signal:clock:1.0 AXI_CLK CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME AXI_CLK, ASSOCIATED_BUSIF S00_AXI:M00_AXIS, ASSOCIATED_RESET axi_aresetn, FREQ_HZ 100000000, PHASE 0.000, CLK_DOMAIN zusys_zynq_ultra_ps_e_0_0_pl_clk0" *) input axi_aclk;
  (* x_interface_info = "xilinx.com:signal:reset:1.0 AXI_RSTN RST" *) (* x_interface_parameter = "XIL_INTERFACENAME AXI_RSTN, POLARITY ACTIVE_LOW" *) input axi_aresetn;
  (* x_interface_info = "xilinx.com:interface:axis:1.0 M00_AXIS TVALID" *) (* x_interface_parameter = "XIL_INTERFACENAME M00_AXIS, TDATA_NUM_BYTES 4, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0, HAS_TREADY 1, HAS_TSTRB 0, HAS_TKEEP 1, HAS_TLAST 1, FREQ_HZ 100000000, PHASE 0.000, CLK_DOMAIN zusys_zynq_ultra_ps_e_0_0_pl_clk0, LAYERED_METADATA undef" *) output m00_axis_tvalid;
  (* x_interface_info = "xilinx.com:interface:axis:1.0 M00_AXIS TDATA" *) output [31:0]m00_axis_tdata;
  (* x_interface_info = "xilinx.com:interface:axis:1.0 M00_AXIS TKEEP" *) output [3:0]m00_axis_tkeep;
  (* x_interface_info = "xilinx.com:interface:axis:1.0 M00_AXIS TLAST" *) output m00_axis_tlast;
  (* x_interface_info = "xilinx.com:interface:axis:1.0 M00_AXIS TREADY" *) input m00_axis_tready;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 S00_AXI AWADDR" *) (* x_interface_parameter = "XIL_INTERFACENAME S00_AXI, WIZ_DATA_WIDTH 32, WIZ_NUM_REG 4, SUPPORTS_NARROW_BURST 0, DATA_WIDTH 32, PROTOCOL AXI4LITE, FREQ_HZ 100000000, ID_WIDTH 0, ADDR_WIDTH 4, AWUSER_WIDTH 0, ARUSER_WIDTH 0, WUSER_WIDTH 0, RUSER_WIDTH 0, BUSER_WIDTH 0, READ_WRITE_MODE READ_WRITE, HAS_BURST 0, HAS_LOCK 0, HAS_PROT 1, HAS_CACHE 0, HAS_QOS 0, HAS_REGION 0, HAS_WSTRB 1, HAS_BRESP 1, HAS_RRESP 1, NUM_READ_OUTSTANDING 2, NUM_WRITE_OUTSTANDING 2, MAX_BURST_LENGTH 1, PHASE 0.000, CLK_DOMAIN zusys_zynq_ultra_ps_e_0_0_pl_clk0, NUM_READ_THREADS 1, NUM_WRITE_THREADS 1, RUSER_BITS_PER_BYTE 0, WUSER_BITS_PER_BYTE 0" *) input [3:0]s00_axi_awaddr;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 S00_AXI AWPROT" *) input [2:0]s00_axi_awprot;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 S00_AXI AWVALID" *) input s00_axi_awvalid;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 S00_AXI AWREADY" *) output s00_axi_awready;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 S00_AXI WDATA" *) input [31:0]s00_axi_wdata;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 S00_AXI WSTRB" *) input [3:0]s00_axi_wstrb;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 S00_AXI WVALID" *) input s00_axi_wvalid;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 S00_AXI WREADY" *) output s00_axi_wready;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 S00_AXI BRESP" *) output [1:0]s00_axi_bresp;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 S00_AXI BVALID" *) output s00_axi_bvalid;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 S00_AXI BREADY" *) input s00_axi_bready;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 S00_AXI ARADDR" *) input [3:0]s00_axi_araddr;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 S00_AXI ARPROT" *) input [2:0]s00_axi_arprot;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 S00_AXI ARVALID" *) input s00_axi_arvalid;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 S00_AXI ARREADY" *) output s00_axi_arready;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 S00_AXI RDATA" *) output [31:0]s00_axi_rdata;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 S00_AXI RRESP" *) output [1:0]s00_axi_rresp;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 S00_AXI RVALID" *) output s00_axi_rvalid;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 S00_AXI RREADY" *) input s00_axi_rready;

  wire \<const0> ;
  wire axi_aclk;
  wire axi_aresetn;
  wire [31:0]m00_axis_tdata;
  wire [2:2]\^m00_axis_tkeep ;
  wire m00_axis_tlast;
  wire m00_axis_tvalid;
  wire [3:0]s00_axi_araddr;
  wire s00_axi_arready;
  wire s00_axi_arvalid;
  wire [3:0]s00_axi_awaddr;
  wire s00_axi_awready;
  wire s00_axi_awvalid;
  wire s00_axi_bready;
  wire s00_axi_bvalid;
  wire [31:0]s00_axi_rdata;
  wire s00_axi_rready;
  wire s00_axi_rvalid;
  wire [31:0]s00_axi_wdata;
  wire s00_axi_wready;
  wire [3:0]s00_axi_wstrb;
  wire s00_axi_wvalid;

  assign m00_axis_tkeep[3] = \^m00_axis_tkeep [2];
  assign m00_axis_tkeep[2] = \^m00_axis_tkeep [2];
  assign m00_axis_tkeep[1] = \^m00_axis_tkeep [2];
  assign m00_axis_tkeep[0] = \^m00_axis_tkeep [2];
  assign s00_axi_bresp[1] = \<const0> ;
  assign s00_axi_bresp[0] = \<const0> ;
  assign s00_axi_rresp[1] = \<const0> ;
  assign s00_axi_rresp[0] = \<const0> ;
  GND GND
       (.G(\<const0> ));
  zusys_AXI_DMA_Data_Gen_0_0_AXI_DMA_Data_Gen_v1_0 U0
       (.Q(m00_axis_tdata),
        .S_AXI_ARREADY(s00_axi_arready),
        .S_AXI_AWREADY(s00_axi_awready),
        .S_AXI_WREADY(s00_axi_wready),
        .axi_aclk(axi_aclk),
        .axi_aresetn(axi_aresetn),
        .m00_axis_tkeep(\^m00_axis_tkeep ),
        .m00_axis_tlast(m00_axis_tlast),
        .m_axis_tvalid(m00_axis_tvalid),
        .s00_axi_araddr(s00_axi_araddr[3:2]),
        .s00_axi_arvalid(s00_axi_arvalid),
        .s00_axi_awaddr(s00_axi_awaddr[3:2]),
        .s00_axi_awvalid(s00_axi_awvalid),
        .s00_axi_bready(s00_axi_bready),
        .s00_axi_bvalid(s00_axi_bvalid),
        .s00_axi_rdata(s00_axi_rdata),
        .s00_axi_rready(s00_axi_rready),
        .s00_axi_rvalid(s00_axi_rvalid),
        .s00_axi_wdata(s00_axi_wdata),
        .s00_axi_wstrb(s00_axi_wstrb),
        .s00_axi_wvalid(s00_axi_wvalid));
endmodule

(* ORIG_REF_NAME = "AXI_DMA_Data_Gen_v1_0" *) 
module zusys_AXI_DMA_Data_Gen_0_0_AXI_DMA_Data_Gen_v1_0
   (S_AXI_AWREADY,
    S_AXI_WREADY,
    S_AXI_ARREADY,
    s00_axi_rvalid,
    m_axis_tvalid,
    Q,
    m00_axis_tkeep,
    m00_axis_tlast,
    s00_axi_rdata,
    s00_axi_bvalid,
    s00_axi_wvalid,
    s00_axi_awvalid,
    s00_axi_arvalid,
    axi_aclk,
    s00_axi_awaddr,
    s00_axi_wdata,
    s00_axi_araddr,
    s00_axi_wstrb,
    axi_aresetn,
    s00_axi_bready,
    s00_axi_rready);
  output S_AXI_AWREADY;
  output S_AXI_WREADY;
  output S_AXI_ARREADY;
  output s00_axi_rvalid;
  output m_axis_tvalid;
  output [31:0]Q;
  output [0:0]m00_axis_tkeep;
  output m00_axis_tlast;
  output [31:0]s00_axi_rdata;
  output s00_axi_bvalid;
  input s00_axi_wvalid;
  input s00_axi_awvalid;
  input s00_axi_arvalid;
  input axi_aclk;
  input [1:0]s00_axi_awaddr;
  input [31:0]s00_axi_wdata;
  input [1:0]s00_axi_araddr;
  input [3:0]s00_axi_wstrb;
  input axi_aresetn;
  input s00_axi_bready;
  input s00_axi_rready;

  wire [31:0]Q;
  wire S_AXI_ARREADY;
  wire S_AXI_AWREADY;
  wire S_AXI_WREADY;
  wire axi_aclk;
  wire axi_aresetn;
  wire [0:0]m00_axis_tkeep;
  wire m00_axis_tlast;
  wire m_axis_tvalid;
  wire [1:0]s00_axi_araddr;
  wire s00_axi_arvalid;
  wire [1:0]s00_axi_awaddr;
  wire s00_axi_awvalid;
  wire s00_axi_bready;
  wire s00_axi_bvalid;
  wire [31:0]s00_axi_rdata;
  wire s00_axi_rready;
  wire s00_axi_rvalid;
  wire [31:0]s00_axi_wdata;
  wire [3:0]s00_axi_wstrb;
  wire s00_axi_wvalid;

  zusys_AXI_DMA_Data_Gen_0_0_AXI_DMA_Data_Gen_v1_0_S00_AXI AXI_DMA_Data_Gen_v1_0_S00_AXI_inst
       (.S_AXI_ARREADY(S_AXI_ARREADY),
        .S_AXI_AWREADY(S_AXI_AWREADY),
        .S_AXI_WREADY(S_AXI_WREADY),
        .axi_aclk(axi_aclk),
        .axi_aresetn(axi_aresetn),
        .m00_axis_tkeep(m00_axis_tkeep),
        .m00_axis_tlast(m00_axis_tlast),
        .m_axis_tdata(Q),
        .m_axis_tvalid(m_axis_tvalid),
        .s00_axi_araddr(s00_axi_araddr),
        .s00_axi_arvalid(s00_axi_arvalid),
        .s00_axi_awaddr(s00_axi_awaddr),
        .s00_axi_awvalid(s00_axi_awvalid),
        .s00_axi_bready(s00_axi_bready),
        .s00_axi_bvalid(s00_axi_bvalid),
        .s00_axi_rdata(s00_axi_rdata),
        .s00_axi_rready(s00_axi_rready),
        .s00_axi_rvalid(s00_axi_rvalid),
        .s00_axi_wdata(s00_axi_wdata),
        .s00_axi_wstrb(s00_axi_wstrb),
        .s00_axi_wvalid(s00_axi_wvalid));
endmodule

(* ORIG_REF_NAME = "AXI_DMA_Data_Gen_v1_0_S00_AXI" *) 
module zusys_AXI_DMA_Data_Gen_0_0_AXI_DMA_Data_Gen_v1_0_S00_AXI
   (S_AXI_AWREADY,
    S_AXI_WREADY,
    S_AXI_ARREADY,
    s00_axi_rvalid,
    m_axis_tvalid,
    m_axis_tdata,
    m00_axis_tkeep,
    m00_axis_tlast,
    s00_axi_rdata,
    s00_axi_bvalid,
    s00_axi_wvalid,
    s00_axi_awvalid,
    s00_axi_arvalid,
    axi_aclk,
    s00_axi_awaddr,
    s00_axi_wdata,
    s00_axi_araddr,
    s00_axi_wstrb,
    axi_aresetn,
    s00_axi_bready,
    s00_axi_rready);
  output S_AXI_AWREADY;
  output S_AXI_WREADY;
  output S_AXI_ARREADY;
  output s00_axi_rvalid;
  output m_axis_tvalid;
  output [31:0]m_axis_tdata;
  output [0:0]m00_axis_tkeep;
  output m00_axis_tlast;
  output [31:0]s00_axi_rdata;
  output s00_axi_bvalid;
  input s00_axi_wvalid;
  input s00_axi_awvalid;
  input s00_axi_arvalid;
  input axi_aclk;
  input [1:0]s00_axi_awaddr;
  input [31:0]s00_axi_wdata;
  input [1:0]s00_axi_araddr;
  input [3:0]s00_axi_wstrb;
  input axi_aresetn;
  input s00_axi_bready;
  input s00_axi_rready;

  wire S_AXI_ARREADY;
  wire S_AXI_AWREADY;
  wire S_AXI_WREADY;
  wire aw_en_i_1_n_0;
  wire aw_en_reg_n_0;
  wire axi_aclk;
  wire [3:2]axi_araddr;
  wire axi_aresetn;
  wire axi_arready_i_1_n_0;
  wire [3:2]axi_awaddr;
  wire axi_awready_i_1_n_0;
  wire axi_awready_i_2_n_0;
  wire axi_bvalid_i_1_n_0;
  wire \axi_rdata[31]_i_1_n_0 ;
  wire axi_rvalid_i_1_n_0;
  wire axi_wready_i_1_n_0;
  wire i__carry__0_i_1_n_0;
  wire i__carry__0_i_2_n_0;
  wire i__carry__0_i_3_n_0;
  wire i__carry__0_i_4_n_0;
  wire i__carry__0_i_5_n_0;
  wire i__carry__0_i_6_n_0;
  wire i__carry__0_i_7_n_0;
  wire i__carry_i_10_n_0;
  wire i__carry_i_11_n_0;
  wire i__carry_i_12_n_0;
  wire i__carry_i_13_n_0;
  wire i__carry_i_14_n_0;
  wire i__carry_i_15_n_0;
  wire i__carry_i_16_n_0;
  wire i__carry_i_17_n_0;
  wire i__carry_i_18_n_0;
  wire i__carry_i_19_n_0;
  wire i__carry_i_1_n_0;
  wire i__carry_i_20_n_0;
  wire i__carry_i_21_n_0;
  wire i__carry_i_22_n_0;
  wire i__carry_i_23_n_0;
  wire i__carry_i_24_n_0;
  wire i__carry_i_25_n_0;
  wire i__carry_i_2_n_0;
  wire i__carry_i_3_n_0;
  wire i__carry_i_4_n_0;
  wire i__carry_i_5_n_0;
  wire i__carry_i_6_n_0;
  wire i__carry_i_7_n_0;
  wire i__carry_i_8_n_0;
  wire i__carry_i_9_n_0;
  wire [0:0]m00_axis_tkeep;
  wire m00_axis_tlast;
  wire [31:0]m_axis_tdata;
  wire m_axis_tvalid;
  wire [31:1]minusOp;
  wire minusOp_carry__0_i_1_n_0;
  wire minusOp_carry__0_i_2_n_0;
  wire minusOp_carry__0_i_3_n_0;
  wire minusOp_carry__0_i_4_n_0;
  wire minusOp_carry__0_i_5_n_0;
  wire minusOp_carry__0_i_6_n_0;
  wire minusOp_carry__0_i_7_n_0;
  wire minusOp_carry__0_i_8_n_0;
  wire minusOp_carry__0_n_0;
  wire minusOp_carry__0_n_1;
  wire minusOp_carry__0_n_2;
  wire minusOp_carry__0_n_3;
  wire minusOp_carry__0_n_5;
  wire minusOp_carry__0_n_6;
  wire minusOp_carry__0_n_7;
  wire minusOp_carry__1_i_1_n_0;
  wire minusOp_carry__1_i_2_n_0;
  wire minusOp_carry__1_i_3_n_0;
  wire minusOp_carry__1_i_4_n_0;
  wire minusOp_carry__1_i_5_n_0;
  wire minusOp_carry__1_i_6_n_0;
  wire minusOp_carry__1_i_7_n_0;
  wire minusOp_carry__1_i_8_n_0;
  wire minusOp_carry__1_n_0;
  wire minusOp_carry__1_n_1;
  wire minusOp_carry__1_n_2;
  wire minusOp_carry__1_n_3;
  wire minusOp_carry__1_n_5;
  wire minusOp_carry__1_n_6;
  wire minusOp_carry__1_n_7;
  wire minusOp_carry__2_i_1_n_0;
  wire minusOp_carry__2_i_2_n_0;
  wire minusOp_carry__2_i_3_n_0;
  wire minusOp_carry__2_i_4_n_0;
  wire minusOp_carry__2_i_5_n_0;
  wire minusOp_carry__2_i_6_n_0;
  wire minusOp_carry__2_i_7_n_0;
  wire minusOp_carry__2_n_2;
  wire minusOp_carry__2_n_3;
  wire minusOp_carry__2_n_5;
  wire minusOp_carry__2_n_6;
  wire minusOp_carry__2_n_7;
  wire minusOp_carry_i_1_n_0;
  wire minusOp_carry_i_2_n_0;
  wire minusOp_carry_i_3_n_0;
  wire minusOp_carry_i_4_n_0;
  wire minusOp_carry_i_5_n_0;
  wire minusOp_carry_i_6_n_0;
  wire minusOp_carry_i_7_n_0;
  wire minusOp_carry_i_8_n_0;
  wire minusOp_carry_n_0;
  wire minusOp_carry_n_1;
  wire minusOp_carry_n_2;
  wire minusOp_carry_n_3;
  wire minusOp_carry_n_5;
  wire minusOp_carry_n_6;
  wire minusOp_carry_n_7;
  wire [31:1]plusOp;
  wire [31:0]reg_data_out;
  wire [1:0]s00_axi_araddr;
  wire s00_axi_arvalid;
  wire [1:0]s00_axi_awaddr;
  wire s00_axi_awvalid;
  wire s00_axi_bready;
  wire s00_axi_bvalid;
  wire [31:0]s00_axi_rdata;
  wire s00_axi_rready;
  wire s00_axi_rvalid;
  wire [31:0]s00_axi_wdata;
  wire [3:0]s00_axi_wstrb;
  wire s00_axi_wvalid;
  wire s_M_AXIS_TVALID_int1_carry__0_i_10_n_0;
  wire s_M_AXIS_TVALID_int1_carry__0_i_11_n_0;
  wire s_M_AXIS_TVALID_int1_carry__0_i_12_n_0;
  wire s_M_AXIS_TVALID_int1_carry__0_i_13_n_0;
  wire s_M_AXIS_TVALID_int1_carry__0_i_14_n_0;
  wire s_M_AXIS_TVALID_int1_carry__0_i_15_n_0;
  wire s_M_AXIS_TVALID_int1_carry__0_i_16_n_0;
  wire s_M_AXIS_TVALID_int1_carry__0_i_1_n_0;
  wire s_M_AXIS_TVALID_int1_carry__0_i_2_n_0;
  wire s_M_AXIS_TVALID_int1_carry__0_i_3_n_0;
  wire s_M_AXIS_TVALID_int1_carry__0_i_4_n_0;
  wire s_M_AXIS_TVALID_int1_carry__0_i_5_n_0;
  wire s_M_AXIS_TVALID_int1_carry__0_i_6_n_0;
  wire s_M_AXIS_TVALID_int1_carry__0_i_7_n_0;
  wire s_M_AXIS_TVALID_int1_carry__0_i_8_n_0;
  wire s_M_AXIS_TVALID_int1_carry__0_i_9_n_0;
  wire s_M_AXIS_TVALID_int1_carry__0_n_0;
  wire s_M_AXIS_TVALID_int1_carry__0_n_1;
  wire s_M_AXIS_TVALID_int1_carry__0_n_2;
  wire s_M_AXIS_TVALID_int1_carry__0_n_3;
  wire s_M_AXIS_TVALID_int1_carry__0_n_5;
  wire s_M_AXIS_TVALID_int1_carry__0_n_6;
  wire s_M_AXIS_TVALID_int1_carry__0_n_7;
  wire s_M_AXIS_TVALID_int1_carry_i_10_n_0;
  wire s_M_AXIS_TVALID_int1_carry_i_11_n_0;
  wire s_M_AXIS_TVALID_int1_carry_i_12_n_0;
  wire s_M_AXIS_TVALID_int1_carry_i_13_n_0;
  wire s_M_AXIS_TVALID_int1_carry_i_14_n_0;
  wire s_M_AXIS_TVALID_int1_carry_i_15_n_0;
  wire s_M_AXIS_TVALID_int1_carry_i_16_n_0;
  wire s_M_AXIS_TVALID_int1_carry_i_1_n_0;
  wire s_M_AXIS_TVALID_int1_carry_i_2_n_0;
  wire s_M_AXIS_TVALID_int1_carry_i_3_n_0;
  wire s_M_AXIS_TVALID_int1_carry_i_4_n_0;
  wire s_M_AXIS_TVALID_int1_carry_i_5_n_0;
  wire s_M_AXIS_TVALID_int1_carry_i_6_n_0;
  wire s_M_AXIS_TVALID_int1_carry_i_7_n_0;
  wire s_M_AXIS_TVALID_int1_carry_i_8_n_0;
  wire s_M_AXIS_TVALID_int1_carry_i_9_n_0;
  wire s_M_AXIS_TVALID_int1_carry_n_0;
  wire s_M_AXIS_TVALID_int1_carry_n_1;
  wire s_M_AXIS_TVALID_int1_carry_n_2;
  wire s_M_AXIS_TVALID_int1_carry_n_3;
  wire s_M_AXIS_TVALID_int1_carry_n_5;
  wire s_M_AXIS_TVALID_int1_carry_n_6;
  wire s_M_AXIS_TVALID_int1_carry_n_7;
  wire \s_M_AXIS_TVALID_int1_inferred__0/i__carry__0_n_5 ;
  wire \s_M_AXIS_TVALID_int1_inferred__0/i__carry__0_n_6 ;
  wire \s_M_AXIS_TVALID_int1_inferred__0/i__carry__0_n_7 ;
  wire \s_M_AXIS_TVALID_int1_inferred__0/i__carry_n_0 ;
  wire \s_M_AXIS_TVALID_int1_inferred__0/i__carry_n_1 ;
  wire \s_M_AXIS_TVALID_int1_inferred__0/i__carry_n_2 ;
  wire \s_M_AXIS_TVALID_int1_inferred__0/i__carry_n_3 ;
  wire \s_M_AXIS_TVALID_int1_inferred__0/i__carry_n_5 ;
  wire \s_M_AXIS_TVALID_int1_inferred__0/i__carry_n_6 ;
  wire \s_M_AXIS_TVALID_int1_inferred__0/i__carry_n_7 ;
  wire s_M_AXIS_TVALID_int_i_1_n_0;
  wire s_M_AXIS_TVALID_int_i_2_n_0;
  wire [0:0]slv_reg0;
  wire \slv_reg0[15]_i_1_n_0 ;
  wire \slv_reg0[23]_i_1_n_0 ;
  wire \slv_reg0[31]_i_1_n_0 ;
  wire \slv_reg0[7]_i_1_n_0 ;
  wire \slv_reg0_reg_n_0_[10] ;
  wire \slv_reg0_reg_n_0_[11] ;
  wire \slv_reg0_reg_n_0_[12] ;
  wire \slv_reg0_reg_n_0_[13] ;
  wire \slv_reg0_reg_n_0_[14] ;
  wire \slv_reg0_reg_n_0_[15] ;
  wire \slv_reg0_reg_n_0_[16] ;
  wire \slv_reg0_reg_n_0_[17] ;
  wire \slv_reg0_reg_n_0_[18] ;
  wire \slv_reg0_reg_n_0_[19] ;
  wire \slv_reg0_reg_n_0_[1] ;
  wire \slv_reg0_reg_n_0_[20] ;
  wire \slv_reg0_reg_n_0_[21] ;
  wire \slv_reg0_reg_n_0_[22] ;
  wire \slv_reg0_reg_n_0_[23] ;
  wire \slv_reg0_reg_n_0_[24] ;
  wire \slv_reg0_reg_n_0_[25] ;
  wire \slv_reg0_reg_n_0_[26] ;
  wire \slv_reg0_reg_n_0_[27] ;
  wire \slv_reg0_reg_n_0_[28] ;
  wire \slv_reg0_reg_n_0_[29] ;
  wire \slv_reg0_reg_n_0_[2] ;
  wire \slv_reg0_reg_n_0_[30] ;
  wire \slv_reg0_reg_n_0_[31] ;
  wire \slv_reg0_reg_n_0_[3] ;
  wire \slv_reg0_reg_n_0_[4] ;
  wire \slv_reg0_reg_n_0_[5] ;
  wire \slv_reg0_reg_n_0_[6] ;
  wire \slv_reg0_reg_n_0_[7] ;
  wire \slv_reg0_reg_n_0_[8] ;
  wire \slv_reg0_reg_n_0_[9] ;
  wire [31:0]slv_reg1;
  wire \slv_reg1[15]_i_1_n_0 ;
  wire \slv_reg1[23]_i_1_n_0 ;
  wire \slv_reg1[31]_i_1_n_0 ;
  wire \slv_reg1[7]_i_1_n_0 ;
  wire [31:0]slv_reg2;
  wire \slv_reg2[15]_i_1_n_0 ;
  wire \slv_reg2[23]_i_1_n_0 ;
  wire \slv_reg2[31]_i_1_n_0 ;
  wire \slv_reg2[7]_i_1_n_0 ;
  wire [31:0]slv_reg3;
  wire \slv_reg3[15]_i_1_n_0 ;
  wire \slv_reg3[23]_i_1_n_0 ;
  wire \slv_reg3[31]_i_1_n_0 ;
  wire \slv_reg3[7]_i_1_n_0 ;
  wire slv_reg_wren__2;
  wire [31:0]v_cnt;
  wire \v_cnt[28]_i_2_n_0 ;
  wire \v_cnt[31]_i_10_n_0 ;
  wire \v_cnt[31]_i_2_n_0 ;
  wire \v_cnt[31]_i_3_n_0 ;
  wire \v_cnt[31]_i_4_n_0 ;
  wire \v_cnt[31]_i_6_n_0 ;
  wire \v_cnt[31]_i_7_n_0 ;
  wire \v_cnt[31]_i_8_n_0 ;
  wire \v_cnt[31]_i_9_n_0 ;
  wire \v_cnt_reg[16]_i_2_n_0 ;
  wire \v_cnt_reg[16]_i_2_n_1 ;
  wire \v_cnt_reg[16]_i_2_n_2 ;
  wire \v_cnt_reg[16]_i_2_n_3 ;
  wire \v_cnt_reg[16]_i_2_n_5 ;
  wire \v_cnt_reg[16]_i_2_n_6 ;
  wire \v_cnt_reg[16]_i_2_n_7 ;
  wire \v_cnt_reg[24]_i_2_n_0 ;
  wire \v_cnt_reg[24]_i_2_n_1 ;
  wire \v_cnt_reg[24]_i_2_n_2 ;
  wire \v_cnt_reg[24]_i_2_n_3 ;
  wire \v_cnt_reg[24]_i_2_n_5 ;
  wire \v_cnt_reg[24]_i_2_n_6 ;
  wire \v_cnt_reg[24]_i_2_n_7 ;
  wire \v_cnt_reg[31]_i_5_n_2 ;
  wire \v_cnt_reg[31]_i_5_n_3 ;
  wire \v_cnt_reg[31]_i_5_n_5 ;
  wire \v_cnt_reg[31]_i_5_n_6 ;
  wire \v_cnt_reg[31]_i_5_n_7 ;
  wire \v_cnt_reg[8]_i_2_n_0 ;
  wire \v_cnt_reg[8]_i_2_n_1 ;
  wire \v_cnt_reg[8]_i_2_n_2 ;
  wire \v_cnt_reg[8]_i_2_n_3 ;
  wire \v_cnt_reg[8]_i_2_n_5 ;
  wire \v_cnt_reg[8]_i_2_n_6 ;
  wire \v_cnt_reg[8]_i_2_n_7 ;
  wire [3:3]NLW_minusOp_carry_CO_UNCONNECTED;
  wire [3:3]NLW_minusOp_carry__0_CO_UNCONNECTED;
  wire [3:3]NLW_minusOp_carry__1_CO_UNCONNECTED;
  wire [7:3]NLW_minusOp_carry__2_CO_UNCONNECTED;
  wire [7:7]NLW_minusOp_carry__2_DI_UNCONNECTED;
  wire [7:7]NLW_minusOp_carry__2_O_UNCONNECTED;
  wire [7:7]NLW_minusOp_carry__2_S_UNCONNECTED;
  wire [3:3]NLW_s_M_AXIS_TVALID_int1_carry_CO_UNCONNECTED;
  wire [7:0]NLW_s_M_AXIS_TVALID_int1_carry_O_UNCONNECTED;
  wire [3:3]NLW_s_M_AXIS_TVALID_int1_carry__0_CO_UNCONNECTED;
  wire [7:0]NLW_s_M_AXIS_TVALID_int1_carry__0_O_UNCONNECTED;
  wire [3:3]\NLW_s_M_AXIS_TVALID_int1_inferred__0/i__carry_CO_UNCONNECTED ;
  wire [7:0]\NLW_s_M_AXIS_TVALID_int1_inferred__0/i__carry_O_UNCONNECTED ;
  wire [7:3]\NLW_s_M_AXIS_TVALID_int1_inferred__0/i__carry__0_CO_UNCONNECTED ;
  wire [7:3]\NLW_s_M_AXIS_TVALID_int1_inferred__0/i__carry__0_DI_UNCONNECTED ;
  wire [7:0]\NLW_s_M_AXIS_TVALID_int1_inferred__0/i__carry__0_O_UNCONNECTED ;
  wire [7:3]\NLW_s_M_AXIS_TVALID_int1_inferred__0/i__carry__0_S_UNCONNECTED ;
  wire [3:3]\NLW_v_cnt_reg[16]_i_2_CO_UNCONNECTED ;
  wire [3:3]\NLW_v_cnt_reg[24]_i_2_CO_UNCONNECTED ;
  wire [7:3]\NLW_v_cnt_reg[31]_i_5_CO_UNCONNECTED ;
  wire [7:7]\NLW_v_cnt_reg[31]_i_5_DI_UNCONNECTED ;
  wire [7:7]\NLW_v_cnt_reg[31]_i_5_O_UNCONNECTED ;
  wire [7:7]\NLW_v_cnt_reg[31]_i_5_S_UNCONNECTED ;
  wire [3:3]\NLW_v_cnt_reg[8]_i_2_CO_UNCONNECTED ;

  LUT6 #(
    .INIT(64'hBFFF8CCC8CCC8CCC)) 
    aw_en_i_1
       (.I0(S_AXI_AWREADY),
        .I1(aw_en_reg_n_0),
        .I2(s00_axi_awvalid),
        .I3(s00_axi_wvalid),
        .I4(s00_axi_bready),
        .I5(s00_axi_bvalid),
        .O(aw_en_i_1_n_0));
  FDSE aw_en_reg
       (.C(axi_aclk),
        .CE(1'b1),
        .D(aw_en_i_1_n_0),
        .Q(aw_en_reg_n_0),
        .S(axi_awready_i_1_n_0));
  FDSE \axi_araddr_reg[2] 
       (.C(axi_aclk),
        .CE(axi_arready_i_1_n_0),
        .D(s00_axi_araddr[0]),
        .Q(axi_araddr[2]),
        .S(axi_awready_i_1_n_0));
  FDSE \axi_araddr_reg[3] 
       (.C(axi_aclk),
        .CE(axi_arready_i_1_n_0),
        .D(s00_axi_araddr[1]),
        .Q(axi_araddr[3]),
        .S(axi_awready_i_1_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    axi_arready_i_1
       (.I0(s00_axi_arvalid),
        .I1(S_AXI_ARREADY),
        .O(axi_arready_i_1_n_0));
  FDRE axi_arready_reg
       (.C(axi_aclk),
        .CE(1'b1),
        .D(axi_arready_i_1_n_0),
        .Q(S_AXI_ARREADY),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_awaddr_reg[2] 
       (.C(axi_aclk),
        .CE(axi_awready_i_2_n_0),
        .D(s00_axi_awaddr[0]),
        .Q(axi_awaddr[2]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_awaddr_reg[3] 
       (.C(axi_aclk),
        .CE(axi_awready_i_2_n_0),
        .D(s00_axi_awaddr[1]),
        .Q(axi_awaddr[3]),
        .R(axi_awready_i_1_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    axi_awready_i_1
       (.I0(axi_aresetn),
        .O(axi_awready_i_1_n_0));
  LUT4 #(
    .INIT(16'h0080)) 
    axi_awready_i_2
       (.I0(s00_axi_wvalid),
        .I1(s00_axi_awvalid),
        .I2(aw_en_reg_n_0),
        .I3(S_AXI_AWREADY),
        .O(axi_awready_i_2_n_0));
  FDRE axi_awready_reg
       (.C(axi_aclk),
        .CE(1'b1),
        .D(axi_awready_i_2_n_0),
        .Q(S_AXI_AWREADY),
        .R(axi_awready_i_1_n_0));
  LUT6 #(
    .INIT(64'h0000FFFF80008000)) 
    axi_bvalid_i_1
       (.I0(S_AXI_WREADY),
        .I1(s00_axi_wvalid),
        .I2(S_AXI_AWREADY),
        .I3(s00_axi_awvalid),
        .I4(s00_axi_bready),
        .I5(s00_axi_bvalid),
        .O(axi_bvalid_i_1_n_0));
  FDRE axi_bvalid_reg
       (.C(axi_aclk),
        .CE(1'b1),
        .D(axi_bvalid_i_1_n_0),
        .Q(s00_axi_bvalid),
        .R(axi_awready_i_1_n_0));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \axi_rdata[0]_i_1 
       (.I0(slv_reg2[0]),
        .I1(slv_reg3[0]),
        .I2(slv_reg0),
        .I3(axi_araddr[3]),
        .I4(axi_araddr[2]),
        .I5(slv_reg1[0]),
        .O(reg_data_out[0]));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \axi_rdata[10]_i_1 
       (.I0(slv_reg2[10]),
        .I1(slv_reg3[10]),
        .I2(\slv_reg0_reg_n_0_[10] ),
        .I3(axi_araddr[3]),
        .I4(axi_araddr[2]),
        .I5(slv_reg1[10]),
        .O(reg_data_out[10]));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \axi_rdata[11]_i_1 
       (.I0(slv_reg2[11]),
        .I1(slv_reg3[11]),
        .I2(\slv_reg0_reg_n_0_[11] ),
        .I3(axi_araddr[3]),
        .I4(axi_araddr[2]),
        .I5(slv_reg1[11]),
        .O(reg_data_out[11]));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \axi_rdata[12]_i_1 
       (.I0(slv_reg2[12]),
        .I1(slv_reg3[12]),
        .I2(\slv_reg0_reg_n_0_[12] ),
        .I3(axi_araddr[3]),
        .I4(axi_araddr[2]),
        .I5(slv_reg1[12]),
        .O(reg_data_out[12]));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \axi_rdata[13]_i_1 
       (.I0(slv_reg2[13]),
        .I1(slv_reg3[13]),
        .I2(\slv_reg0_reg_n_0_[13] ),
        .I3(axi_araddr[3]),
        .I4(axi_araddr[2]),
        .I5(slv_reg1[13]),
        .O(reg_data_out[13]));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \axi_rdata[14]_i_1 
       (.I0(slv_reg2[14]),
        .I1(slv_reg3[14]),
        .I2(\slv_reg0_reg_n_0_[14] ),
        .I3(axi_araddr[3]),
        .I4(axi_araddr[2]),
        .I5(slv_reg1[14]),
        .O(reg_data_out[14]));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \axi_rdata[15]_i_1 
       (.I0(slv_reg2[15]),
        .I1(slv_reg3[15]),
        .I2(\slv_reg0_reg_n_0_[15] ),
        .I3(axi_araddr[3]),
        .I4(axi_araddr[2]),
        .I5(slv_reg1[15]),
        .O(reg_data_out[15]));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \axi_rdata[16]_i_1 
       (.I0(slv_reg2[16]),
        .I1(slv_reg3[16]),
        .I2(\slv_reg0_reg_n_0_[16] ),
        .I3(axi_araddr[3]),
        .I4(axi_araddr[2]),
        .I5(slv_reg1[16]),
        .O(reg_data_out[16]));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \axi_rdata[17]_i_1 
       (.I0(slv_reg2[17]),
        .I1(slv_reg3[17]),
        .I2(\slv_reg0_reg_n_0_[17] ),
        .I3(axi_araddr[3]),
        .I4(axi_araddr[2]),
        .I5(slv_reg1[17]),
        .O(reg_data_out[17]));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \axi_rdata[18]_i_1 
       (.I0(slv_reg2[18]),
        .I1(slv_reg3[18]),
        .I2(\slv_reg0_reg_n_0_[18] ),
        .I3(axi_araddr[3]),
        .I4(axi_araddr[2]),
        .I5(slv_reg1[18]),
        .O(reg_data_out[18]));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \axi_rdata[19]_i_1 
       (.I0(slv_reg2[19]),
        .I1(slv_reg3[19]),
        .I2(\slv_reg0_reg_n_0_[19] ),
        .I3(axi_araddr[3]),
        .I4(axi_araddr[2]),
        .I5(slv_reg1[19]),
        .O(reg_data_out[19]));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \axi_rdata[1]_i_1 
       (.I0(slv_reg2[1]),
        .I1(slv_reg3[1]),
        .I2(\slv_reg0_reg_n_0_[1] ),
        .I3(axi_araddr[3]),
        .I4(axi_araddr[2]),
        .I5(slv_reg1[1]),
        .O(reg_data_out[1]));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \axi_rdata[20]_i_1 
       (.I0(slv_reg2[20]),
        .I1(slv_reg3[20]),
        .I2(\slv_reg0_reg_n_0_[20] ),
        .I3(axi_araddr[3]),
        .I4(axi_araddr[2]),
        .I5(slv_reg1[20]),
        .O(reg_data_out[20]));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \axi_rdata[21]_i_1 
       (.I0(slv_reg2[21]),
        .I1(slv_reg3[21]),
        .I2(\slv_reg0_reg_n_0_[21] ),
        .I3(axi_araddr[3]),
        .I4(axi_araddr[2]),
        .I5(slv_reg1[21]),
        .O(reg_data_out[21]));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \axi_rdata[22]_i_1 
       (.I0(slv_reg2[22]),
        .I1(slv_reg3[22]),
        .I2(\slv_reg0_reg_n_0_[22] ),
        .I3(axi_araddr[3]),
        .I4(axi_araddr[2]),
        .I5(slv_reg1[22]),
        .O(reg_data_out[22]));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \axi_rdata[23]_i_1 
       (.I0(slv_reg2[23]),
        .I1(slv_reg3[23]),
        .I2(\slv_reg0_reg_n_0_[23] ),
        .I3(axi_araddr[3]),
        .I4(axi_araddr[2]),
        .I5(slv_reg1[23]),
        .O(reg_data_out[23]));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \axi_rdata[24]_i_1 
       (.I0(slv_reg2[24]),
        .I1(slv_reg3[24]),
        .I2(\slv_reg0_reg_n_0_[24] ),
        .I3(axi_araddr[3]),
        .I4(axi_araddr[2]),
        .I5(slv_reg1[24]),
        .O(reg_data_out[24]));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \axi_rdata[25]_i_1 
       (.I0(slv_reg2[25]),
        .I1(slv_reg3[25]),
        .I2(\slv_reg0_reg_n_0_[25] ),
        .I3(axi_araddr[3]),
        .I4(axi_araddr[2]),
        .I5(slv_reg1[25]),
        .O(reg_data_out[25]));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \axi_rdata[26]_i_1 
       (.I0(slv_reg2[26]),
        .I1(slv_reg3[26]),
        .I2(\slv_reg0_reg_n_0_[26] ),
        .I3(axi_araddr[3]),
        .I4(axi_araddr[2]),
        .I5(slv_reg1[26]),
        .O(reg_data_out[26]));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \axi_rdata[27]_i_1 
       (.I0(slv_reg2[27]),
        .I1(slv_reg3[27]),
        .I2(\slv_reg0_reg_n_0_[27] ),
        .I3(axi_araddr[3]),
        .I4(axi_araddr[2]),
        .I5(slv_reg1[27]),
        .O(reg_data_out[27]));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \axi_rdata[28]_i_1 
       (.I0(slv_reg2[28]),
        .I1(slv_reg3[28]),
        .I2(\slv_reg0_reg_n_0_[28] ),
        .I3(axi_araddr[3]),
        .I4(axi_araddr[2]),
        .I5(slv_reg1[28]),
        .O(reg_data_out[28]));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \axi_rdata[29]_i_1 
       (.I0(slv_reg2[29]),
        .I1(slv_reg3[29]),
        .I2(\slv_reg0_reg_n_0_[29] ),
        .I3(axi_araddr[3]),
        .I4(axi_araddr[2]),
        .I5(slv_reg1[29]),
        .O(reg_data_out[29]));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \axi_rdata[2]_i_1 
       (.I0(slv_reg2[2]),
        .I1(slv_reg3[2]),
        .I2(\slv_reg0_reg_n_0_[2] ),
        .I3(axi_araddr[3]),
        .I4(axi_araddr[2]),
        .I5(slv_reg1[2]),
        .O(reg_data_out[2]));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \axi_rdata[30]_i_1 
       (.I0(slv_reg2[30]),
        .I1(slv_reg3[30]),
        .I2(\slv_reg0_reg_n_0_[30] ),
        .I3(axi_araddr[3]),
        .I4(axi_araddr[2]),
        .I5(slv_reg1[30]),
        .O(reg_data_out[30]));
  LUT3 #(
    .INIT(8'h08)) 
    \axi_rdata[31]_i_1 
       (.I0(S_AXI_ARREADY),
        .I1(s00_axi_arvalid),
        .I2(s00_axi_rvalid),
        .O(\axi_rdata[31]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \axi_rdata[31]_i_2 
       (.I0(slv_reg2[31]),
        .I1(slv_reg3[31]),
        .I2(\slv_reg0_reg_n_0_[31] ),
        .I3(axi_araddr[3]),
        .I4(axi_araddr[2]),
        .I5(slv_reg1[31]),
        .O(reg_data_out[31]));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \axi_rdata[3]_i_1 
       (.I0(slv_reg2[3]),
        .I1(slv_reg3[3]),
        .I2(\slv_reg0_reg_n_0_[3] ),
        .I3(axi_araddr[3]),
        .I4(axi_araddr[2]),
        .I5(slv_reg1[3]),
        .O(reg_data_out[3]));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \axi_rdata[4]_i_1 
       (.I0(slv_reg2[4]),
        .I1(slv_reg3[4]),
        .I2(\slv_reg0_reg_n_0_[4] ),
        .I3(axi_araddr[3]),
        .I4(axi_araddr[2]),
        .I5(slv_reg1[4]),
        .O(reg_data_out[4]));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \axi_rdata[5]_i_1 
       (.I0(slv_reg2[5]),
        .I1(slv_reg3[5]),
        .I2(\slv_reg0_reg_n_0_[5] ),
        .I3(axi_araddr[3]),
        .I4(axi_araddr[2]),
        .I5(slv_reg1[5]),
        .O(reg_data_out[5]));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \axi_rdata[6]_i_1 
       (.I0(slv_reg2[6]),
        .I1(slv_reg3[6]),
        .I2(\slv_reg0_reg_n_0_[6] ),
        .I3(axi_araddr[3]),
        .I4(axi_araddr[2]),
        .I5(slv_reg1[6]),
        .O(reg_data_out[6]));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \axi_rdata[7]_i_1 
       (.I0(slv_reg2[7]),
        .I1(slv_reg3[7]),
        .I2(\slv_reg0_reg_n_0_[7] ),
        .I3(axi_araddr[3]),
        .I4(axi_araddr[2]),
        .I5(slv_reg1[7]),
        .O(reg_data_out[7]));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \axi_rdata[8]_i_1 
       (.I0(slv_reg2[8]),
        .I1(slv_reg3[8]),
        .I2(\slv_reg0_reg_n_0_[8] ),
        .I3(axi_araddr[3]),
        .I4(axi_araddr[2]),
        .I5(slv_reg1[8]),
        .O(reg_data_out[8]));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    \axi_rdata[9]_i_1 
       (.I0(slv_reg2[9]),
        .I1(slv_reg3[9]),
        .I2(\slv_reg0_reg_n_0_[9] ),
        .I3(axi_araddr[3]),
        .I4(axi_araddr[2]),
        .I5(slv_reg1[9]),
        .O(reg_data_out[9]));
  FDRE \axi_rdata_reg[0] 
       (.C(axi_aclk),
        .CE(\axi_rdata[31]_i_1_n_0 ),
        .D(reg_data_out[0]),
        .Q(s00_axi_rdata[0]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[10] 
       (.C(axi_aclk),
        .CE(\axi_rdata[31]_i_1_n_0 ),
        .D(reg_data_out[10]),
        .Q(s00_axi_rdata[10]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[11] 
       (.C(axi_aclk),
        .CE(\axi_rdata[31]_i_1_n_0 ),
        .D(reg_data_out[11]),
        .Q(s00_axi_rdata[11]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[12] 
       (.C(axi_aclk),
        .CE(\axi_rdata[31]_i_1_n_0 ),
        .D(reg_data_out[12]),
        .Q(s00_axi_rdata[12]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[13] 
       (.C(axi_aclk),
        .CE(\axi_rdata[31]_i_1_n_0 ),
        .D(reg_data_out[13]),
        .Q(s00_axi_rdata[13]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[14] 
       (.C(axi_aclk),
        .CE(\axi_rdata[31]_i_1_n_0 ),
        .D(reg_data_out[14]),
        .Q(s00_axi_rdata[14]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[15] 
       (.C(axi_aclk),
        .CE(\axi_rdata[31]_i_1_n_0 ),
        .D(reg_data_out[15]),
        .Q(s00_axi_rdata[15]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[16] 
       (.C(axi_aclk),
        .CE(\axi_rdata[31]_i_1_n_0 ),
        .D(reg_data_out[16]),
        .Q(s00_axi_rdata[16]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[17] 
       (.C(axi_aclk),
        .CE(\axi_rdata[31]_i_1_n_0 ),
        .D(reg_data_out[17]),
        .Q(s00_axi_rdata[17]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[18] 
       (.C(axi_aclk),
        .CE(\axi_rdata[31]_i_1_n_0 ),
        .D(reg_data_out[18]),
        .Q(s00_axi_rdata[18]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[19] 
       (.C(axi_aclk),
        .CE(\axi_rdata[31]_i_1_n_0 ),
        .D(reg_data_out[19]),
        .Q(s00_axi_rdata[19]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[1] 
       (.C(axi_aclk),
        .CE(\axi_rdata[31]_i_1_n_0 ),
        .D(reg_data_out[1]),
        .Q(s00_axi_rdata[1]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[20] 
       (.C(axi_aclk),
        .CE(\axi_rdata[31]_i_1_n_0 ),
        .D(reg_data_out[20]),
        .Q(s00_axi_rdata[20]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[21] 
       (.C(axi_aclk),
        .CE(\axi_rdata[31]_i_1_n_0 ),
        .D(reg_data_out[21]),
        .Q(s00_axi_rdata[21]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[22] 
       (.C(axi_aclk),
        .CE(\axi_rdata[31]_i_1_n_0 ),
        .D(reg_data_out[22]),
        .Q(s00_axi_rdata[22]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[23] 
       (.C(axi_aclk),
        .CE(\axi_rdata[31]_i_1_n_0 ),
        .D(reg_data_out[23]),
        .Q(s00_axi_rdata[23]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[24] 
       (.C(axi_aclk),
        .CE(\axi_rdata[31]_i_1_n_0 ),
        .D(reg_data_out[24]),
        .Q(s00_axi_rdata[24]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[25] 
       (.C(axi_aclk),
        .CE(\axi_rdata[31]_i_1_n_0 ),
        .D(reg_data_out[25]),
        .Q(s00_axi_rdata[25]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[26] 
       (.C(axi_aclk),
        .CE(\axi_rdata[31]_i_1_n_0 ),
        .D(reg_data_out[26]),
        .Q(s00_axi_rdata[26]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[27] 
       (.C(axi_aclk),
        .CE(\axi_rdata[31]_i_1_n_0 ),
        .D(reg_data_out[27]),
        .Q(s00_axi_rdata[27]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[28] 
       (.C(axi_aclk),
        .CE(\axi_rdata[31]_i_1_n_0 ),
        .D(reg_data_out[28]),
        .Q(s00_axi_rdata[28]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[29] 
       (.C(axi_aclk),
        .CE(\axi_rdata[31]_i_1_n_0 ),
        .D(reg_data_out[29]),
        .Q(s00_axi_rdata[29]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[2] 
       (.C(axi_aclk),
        .CE(\axi_rdata[31]_i_1_n_0 ),
        .D(reg_data_out[2]),
        .Q(s00_axi_rdata[2]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[30] 
       (.C(axi_aclk),
        .CE(\axi_rdata[31]_i_1_n_0 ),
        .D(reg_data_out[30]),
        .Q(s00_axi_rdata[30]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[31] 
       (.C(axi_aclk),
        .CE(\axi_rdata[31]_i_1_n_0 ),
        .D(reg_data_out[31]),
        .Q(s00_axi_rdata[31]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[3] 
       (.C(axi_aclk),
        .CE(\axi_rdata[31]_i_1_n_0 ),
        .D(reg_data_out[3]),
        .Q(s00_axi_rdata[3]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[4] 
       (.C(axi_aclk),
        .CE(\axi_rdata[31]_i_1_n_0 ),
        .D(reg_data_out[4]),
        .Q(s00_axi_rdata[4]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[5] 
       (.C(axi_aclk),
        .CE(\axi_rdata[31]_i_1_n_0 ),
        .D(reg_data_out[5]),
        .Q(s00_axi_rdata[5]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[6] 
       (.C(axi_aclk),
        .CE(\axi_rdata[31]_i_1_n_0 ),
        .D(reg_data_out[6]),
        .Q(s00_axi_rdata[6]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[7] 
       (.C(axi_aclk),
        .CE(\axi_rdata[31]_i_1_n_0 ),
        .D(reg_data_out[7]),
        .Q(s00_axi_rdata[7]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[8] 
       (.C(axi_aclk),
        .CE(\axi_rdata[31]_i_1_n_0 ),
        .D(reg_data_out[8]),
        .Q(s00_axi_rdata[8]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[9] 
       (.C(axi_aclk),
        .CE(\axi_rdata[31]_i_1_n_0 ),
        .D(reg_data_out[9]),
        .Q(s00_axi_rdata[9]),
        .R(axi_awready_i_1_n_0));
  LUT4 #(
    .INIT(16'h08F8)) 
    axi_rvalid_i_1
       (.I0(s00_axi_arvalid),
        .I1(S_AXI_ARREADY),
        .I2(s00_axi_rvalid),
        .I3(s00_axi_rready),
        .O(axi_rvalid_i_1_n_0));
  FDRE axi_rvalid_reg
       (.C(axi_aclk),
        .CE(1'b1),
        .D(axi_rvalid_i_1_n_0),
        .Q(s00_axi_rvalid),
        .R(axi_awready_i_1_n_0));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT4 #(
    .INIT(16'h0080)) 
    axi_wready_i_1
       (.I0(s00_axi_wvalid),
        .I1(s00_axi_awvalid),
        .I2(aw_en_reg_n_0),
        .I3(S_AXI_WREADY),
        .O(axi_wready_i_1_n_0));
  FDRE axi_wready_reg
       (.C(axi_aclk),
        .CE(1'b1),
        .D(axi_wready_i_1_n_0),
        .Q(S_AXI_WREADY),
        .R(axi_awready_i_1_n_0));
  LUT6 #(
    .INIT(64'hB84700000000B847)) 
    i__carry__0_i_1
       (.I0(m_axis_tdata[31]),
        .I1(\v_cnt[28]_i_2_n_0 ),
        .I2(plusOp[31]),
        .I3(minusOp[31]),
        .I4(v_cnt[30]),
        .I5(minusOp[30]),
        .O(i__carry__0_i_1_n_0));
  LUT6 #(
    .INIT(64'h8882228200000000)) 
    i__carry__0_i_2
       (.I0(i__carry__0_i_4_n_0),
        .I1(minusOp[28]),
        .I2(plusOp[28]),
        .I3(\v_cnt[28]_i_2_n_0 ),
        .I4(m_axis_tdata[28]),
        .I5(i__carry__0_i_5_n_0),
        .O(i__carry__0_i_2_n_0));
  LUT6 #(
    .INIT(64'hA959000000000000)) 
    i__carry__0_i_3
       (.I0(minusOp[26]),
        .I1(plusOp[26]),
        .I2(\v_cnt[28]_i_2_n_0 ),
        .I3(m_axis_tdata[26]),
        .I4(i__carry__0_i_6_n_0),
        .I5(i__carry__0_i_7_n_0),
        .O(i__carry__0_i_3_n_0));
  LUT6 #(
    .INIT(64'h999AAAAA99955555)) 
    i__carry__0_i_4
       (.I0(minusOp[29]),
        .I1(plusOp[29]),
        .I2(\v_cnt[31]_i_4_n_0 ),
        .I3(i__carry_i_24_n_0),
        .I4(m_axis_tvalid),
        .I5(m_axis_tdata[29]),
        .O(i__carry__0_i_4_n_0));
  LUT6 #(
    .INIT(64'h999AAAAA99955555)) 
    i__carry__0_i_5
       (.I0(minusOp[27]),
        .I1(plusOp[27]),
        .I2(\v_cnt[31]_i_4_n_0 ),
        .I3(i__carry_i_24_n_0),
        .I4(m_axis_tvalid),
        .I5(m_axis_tdata[27]),
        .O(i__carry__0_i_5_n_0));
  LUT6 #(
    .INIT(64'h999AAAAA99955555)) 
    i__carry__0_i_6
       (.I0(minusOp[25]),
        .I1(plusOp[25]),
        .I2(\v_cnt[31]_i_4_n_0 ),
        .I3(i__carry_i_24_n_0),
        .I4(m_axis_tvalid),
        .I5(m_axis_tdata[25]),
        .O(i__carry__0_i_6_n_0));
  LUT6 #(
    .INIT(64'h999AAAAA99955555)) 
    i__carry__0_i_7
       (.I0(minusOp[24]),
        .I1(plusOp[24]),
        .I2(\v_cnt[31]_i_4_n_0 ),
        .I3(i__carry_i_24_n_0),
        .I4(m_axis_tvalid),
        .I5(m_axis_tdata[24]),
        .O(i__carry__0_i_7_n_0));
  LUT6 #(
    .INIT(64'h8882228200000000)) 
    i__carry_i_1
       (.I0(i__carry_i_9_n_0),
        .I1(minusOp[22]),
        .I2(plusOp[22]),
        .I3(\v_cnt[28]_i_2_n_0 ),
        .I4(m_axis_tdata[22]),
        .I5(i__carry_i_10_n_0),
        .O(i__carry_i_1_n_0));
  LUT6 #(
    .INIT(64'h999AAAAA99955555)) 
    i__carry_i_10
       (.I0(minusOp[21]),
        .I1(plusOp[21]),
        .I2(\v_cnt[31]_i_4_n_0 ),
        .I3(i__carry_i_24_n_0),
        .I4(m_axis_tvalid),
        .I5(m_axis_tdata[21]),
        .O(i__carry_i_10_n_0));
  LUT6 #(
    .INIT(64'h999AAAAA99955555)) 
    i__carry_i_11
       (.I0(minusOp[19]),
        .I1(plusOp[19]),
        .I2(\v_cnt[31]_i_4_n_0 ),
        .I3(i__carry_i_24_n_0),
        .I4(m_axis_tvalid),
        .I5(m_axis_tdata[19]),
        .O(i__carry_i_11_n_0));
  LUT6 #(
    .INIT(64'h999AAAAA99955555)) 
    i__carry_i_12
       (.I0(minusOp[18]),
        .I1(plusOp[18]),
        .I2(\v_cnt[31]_i_4_n_0 ),
        .I3(i__carry_i_24_n_0),
        .I4(m_axis_tvalid),
        .I5(m_axis_tdata[18]),
        .O(i__carry_i_12_n_0));
  LUT6 #(
    .INIT(64'h999AAAAA99955555)) 
    i__carry_i_13
       (.I0(minusOp[17]),
        .I1(plusOp[17]),
        .I2(\v_cnt[31]_i_4_n_0 ),
        .I3(i__carry_i_24_n_0),
        .I4(m_axis_tvalid),
        .I5(m_axis_tdata[17]),
        .O(i__carry_i_13_n_0));
  LUT6 #(
    .INIT(64'h999AAAAA99955555)) 
    i__carry_i_14
       (.I0(minusOp[15]),
        .I1(plusOp[15]),
        .I2(\v_cnt[31]_i_4_n_0 ),
        .I3(i__carry_i_24_n_0),
        .I4(m_axis_tvalid),
        .I5(m_axis_tdata[15]),
        .O(i__carry_i_14_n_0));
  LUT6 #(
    .INIT(64'h999AAAAA99955555)) 
    i__carry_i_15
       (.I0(minusOp[13]),
        .I1(plusOp[13]),
        .I2(\v_cnt[31]_i_4_n_0 ),
        .I3(i__carry_i_24_n_0),
        .I4(m_axis_tvalid),
        .I5(m_axis_tdata[13]),
        .O(i__carry_i_15_n_0));
  LUT6 #(
    .INIT(64'h999AAAAA99955555)) 
    i__carry_i_16
       (.I0(minusOp[12]),
        .I1(plusOp[12]),
        .I2(\v_cnt[31]_i_4_n_0 ),
        .I3(i__carry_i_24_n_0),
        .I4(m_axis_tvalid),
        .I5(m_axis_tdata[12]),
        .O(i__carry_i_16_n_0));
  LUT6 #(
    .INIT(64'h999AAAAA99955555)) 
    i__carry_i_17
       (.I0(minusOp[11]),
        .I1(plusOp[11]),
        .I2(\v_cnt[31]_i_4_n_0 ),
        .I3(i__carry_i_24_n_0),
        .I4(m_axis_tvalid),
        .I5(m_axis_tdata[11]),
        .O(i__carry_i_17_n_0));
  LUT6 #(
    .INIT(64'h999AAAAA99955555)) 
    i__carry_i_18
       (.I0(minusOp[9]),
        .I1(plusOp[9]),
        .I2(\v_cnt[31]_i_4_n_0 ),
        .I3(i__carry_i_24_n_0),
        .I4(m_axis_tvalid),
        .I5(m_axis_tdata[9]),
        .O(i__carry_i_18_n_0));
  LUT6 #(
    .INIT(64'h999AAAAA99955555)) 
    i__carry_i_19
       (.I0(minusOp[7]),
        .I1(plusOp[7]),
        .I2(\v_cnt[31]_i_4_n_0 ),
        .I3(i__carry_i_24_n_0),
        .I4(m_axis_tvalid),
        .I5(m_axis_tdata[7]),
        .O(i__carry_i_19_n_0));
  LUT6 #(
    .INIT(64'hA959000000000000)) 
    i__carry_i_2
       (.I0(minusOp[20]),
        .I1(plusOp[20]),
        .I2(\v_cnt[28]_i_2_n_0 ),
        .I3(m_axis_tdata[20]),
        .I4(i__carry_i_11_n_0),
        .I5(i__carry_i_12_n_0),
        .O(i__carry_i_2_n_0));
  LUT6 #(
    .INIT(64'h999AAAAA99955555)) 
    i__carry_i_20
       (.I0(minusOp[6]),
        .I1(plusOp[6]),
        .I2(\v_cnt[31]_i_4_n_0 ),
        .I3(i__carry_i_24_n_0),
        .I4(m_axis_tvalid),
        .I5(m_axis_tdata[6]),
        .O(i__carry_i_20_n_0));
  LUT6 #(
    .INIT(64'h999AAAAA99955555)) 
    i__carry_i_21
       (.I0(minusOp[5]),
        .I1(plusOp[5]),
        .I2(\v_cnt[31]_i_4_n_0 ),
        .I3(i__carry_i_24_n_0),
        .I4(m_axis_tvalid),
        .I5(m_axis_tdata[5]),
        .O(i__carry_i_21_n_0));
  LUT6 #(
    .INIT(64'h999AAAAA99955555)) 
    i__carry_i_22
       (.I0(minusOp[3]),
        .I1(plusOp[3]),
        .I2(\v_cnt[31]_i_4_n_0 ),
        .I3(i__carry_i_24_n_0),
        .I4(m_axis_tvalid),
        .I5(m_axis_tdata[3]),
        .O(i__carry_i_22_n_0));
  LUT6 #(
    .INIT(64'h999AAAAA99955555)) 
    i__carry_i_23
       (.I0(minusOp[1]),
        .I1(plusOp[1]),
        .I2(\v_cnt[31]_i_4_n_0 ),
        .I3(i__carry_i_24_n_0),
        .I4(m_axis_tvalid),
        .I5(m_axis_tdata[1]),
        .O(i__carry_i_23_n_0));
  LUT6 #(
    .INIT(64'hFFFFFFFFBFFFFFFF)) 
    i__carry_i_24
       (.I0(\v_cnt[31]_i_2_n_0 ),
        .I1(\v_cnt[31]_i_9_n_0 ),
        .I2(\v_cnt[31]_i_8_n_0 ),
        .I3(\v_cnt[31]_i_7_n_0 ),
        .I4(\v_cnt[31]_i_6_n_0 ),
        .I5(i__carry_i_25_n_0),
        .O(i__carry_i_24_n_0));
  LUT2 #(
    .INIT(4'h7)) 
    i__carry_i_25
       (.I0(m_axis_tdata[28]),
        .I1(m_axis_tdata[29]),
        .O(i__carry_i_25_n_0));
  LUT6 #(
    .INIT(64'h8882228200000000)) 
    i__carry_i_3
       (.I0(i__carry_i_13_n_0),
        .I1(minusOp[16]),
        .I2(plusOp[16]),
        .I3(\v_cnt[28]_i_2_n_0 ),
        .I4(m_axis_tdata[16]),
        .I5(i__carry_i_14_n_0),
        .O(i__carry_i_3_n_0));
  LUT6 #(
    .INIT(64'hA959000000000000)) 
    i__carry_i_4
       (.I0(minusOp[14]),
        .I1(plusOp[14]),
        .I2(\v_cnt[28]_i_2_n_0 ),
        .I3(m_axis_tdata[14]),
        .I4(i__carry_i_15_n_0),
        .I5(i__carry_i_16_n_0),
        .O(i__carry_i_4_n_0));
  LUT6 #(
    .INIT(64'h8882228200000000)) 
    i__carry_i_5
       (.I0(i__carry_i_17_n_0),
        .I1(minusOp[10]),
        .I2(plusOp[10]),
        .I3(\v_cnt[28]_i_2_n_0 ),
        .I4(m_axis_tdata[10]),
        .I5(i__carry_i_18_n_0),
        .O(i__carry_i_5_n_0));
  LUT6 #(
    .INIT(64'hA959000000000000)) 
    i__carry_i_6
       (.I0(minusOp[8]),
        .I1(plusOp[8]),
        .I2(\v_cnt[28]_i_2_n_0 ),
        .I3(m_axis_tdata[8]),
        .I4(i__carry_i_19_n_0),
        .I5(i__carry_i_20_n_0),
        .O(i__carry_i_6_n_0));
  LUT6 #(
    .INIT(64'h8882228200000000)) 
    i__carry_i_7
       (.I0(i__carry_i_21_n_0),
        .I1(minusOp[4]),
        .I2(plusOp[4]),
        .I3(\v_cnt[28]_i_2_n_0 ),
        .I4(m_axis_tdata[4]),
        .I5(i__carry_i_22_n_0),
        .O(i__carry_i_7_n_0));
  LUT6 #(
    .INIT(64'h0090900090000090)) 
    i__carry_i_8
       (.I0(minusOp[2]),
        .I1(v_cnt[2]),
        .I2(i__carry_i_23_n_0),
        .I3(\v_cnt[28]_i_2_n_0 ),
        .I4(m_axis_tdata[0]),
        .I5(slv_reg1[0]),
        .O(i__carry_i_8_n_0));
  LUT6 #(
    .INIT(64'h999AAAAA99955555)) 
    i__carry_i_9
       (.I0(minusOp[23]),
        .I1(plusOp[23]),
        .I2(\v_cnt[31]_i_4_n_0 ),
        .I3(i__carry_i_24_n_0),
        .I4(m_axis_tvalid),
        .I5(m_axis_tdata[23]),
        .O(i__carry_i_9_n_0));
  FDRE \m_axis_tkeep_reg[3] 
       (.C(axi_aclk),
        .CE(1'b1),
        .D(s_M_AXIS_TVALID_int_i_2_n_0),
        .Q(m00_axis_tkeep),
        .R(s_M_AXIS_TVALID_int_i_1_n_0));
  FDRE m_axis_tlast_reg
       (.C(axi_aclk),
        .CE(1'b1),
        .D(\s_M_AXIS_TVALID_int1_inferred__0/i__carry__0_n_5 ),
        .Q(m00_axis_tlast),
        .R(s_M_AXIS_TVALID_int_i_1_n_0));
  CARRY8 minusOp_carry
       (.CI(slv_reg1[0]),
        .CI_TOP(1'b0),
        .CO({minusOp_carry_n_0,minusOp_carry_n_1,minusOp_carry_n_2,minusOp_carry_n_3,NLW_minusOp_carry_CO_UNCONNECTED[3],minusOp_carry_n_5,minusOp_carry_n_6,minusOp_carry_n_7}),
        .DI(slv_reg1[8:1]),
        .O(minusOp[8:1]),
        .S({minusOp_carry_i_1_n_0,minusOp_carry_i_2_n_0,minusOp_carry_i_3_n_0,minusOp_carry_i_4_n_0,minusOp_carry_i_5_n_0,minusOp_carry_i_6_n_0,minusOp_carry_i_7_n_0,minusOp_carry_i_8_n_0}));
  CARRY8 minusOp_carry__0
       (.CI(minusOp_carry_n_0),
        .CI_TOP(1'b0),
        .CO({minusOp_carry__0_n_0,minusOp_carry__0_n_1,minusOp_carry__0_n_2,minusOp_carry__0_n_3,NLW_minusOp_carry__0_CO_UNCONNECTED[3],minusOp_carry__0_n_5,minusOp_carry__0_n_6,minusOp_carry__0_n_7}),
        .DI(slv_reg1[16:9]),
        .O(minusOp[16:9]),
        .S({minusOp_carry__0_i_1_n_0,minusOp_carry__0_i_2_n_0,minusOp_carry__0_i_3_n_0,minusOp_carry__0_i_4_n_0,minusOp_carry__0_i_5_n_0,minusOp_carry__0_i_6_n_0,minusOp_carry__0_i_7_n_0,minusOp_carry__0_i_8_n_0}));
  LUT1 #(
    .INIT(2'h1)) 
    minusOp_carry__0_i_1
       (.I0(slv_reg1[16]),
        .O(minusOp_carry__0_i_1_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    minusOp_carry__0_i_2
       (.I0(slv_reg1[15]),
        .O(minusOp_carry__0_i_2_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    minusOp_carry__0_i_3
       (.I0(slv_reg1[14]),
        .O(minusOp_carry__0_i_3_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    minusOp_carry__0_i_4
       (.I0(slv_reg1[13]),
        .O(minusOp_carry__0_i_4_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    minusOp_carry__0_i_5
       (.I0(slv_reg1[12]),
        .O(minusOp_carry__0_i_5_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    minusOp_carry__0_i_6
       (.I0(slv_reg1[11]),
        .O(minusOp_carry__0_i_6_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    minusOp_carry__0_i_7
       (.I0(slv_reg1[10]),
        .O(minusOp_carry__0_i_7_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    minusOp_carry__0_i_8
       (.I0(slv_reg1[9]),
        .O(minusOp_carry__0_i_8_n_0));
  CARRY8 minusOp_carry__1
       (.CI(minusOp_carry__0_n_0),
        .CI_TOP(1'b0),
        .CO({minusOp_carry__1_n_0,minusOp_carry__1_n_1,minusOp_carry__1_n_2,minusOp_carry__1_n_3,NLW_minusOp_carry__1_CO_UNCONNECTED[3],minusOp_carry__1_n_5,minusOp_carry__1_n_6,minusOp_carry__1_n_7}),
        .DI(slv_reg1[24:17]),
        .O(minusOp[24:17]),
        .S({minusOp_carry__1_i_1_n_0,minusOp_carry__1_i_2_n_0,minusOp_carry__1_i_3_n_0,minusOp_carry__1_i_4_n_0,minusOp_carry__1_i_5_n_0,minusOp_carry__1_i_6_n_0,minusOp_carry__1_i_7_n_0,minusOp_carry__1_i_8_n_0}));
  LUT1 #(
    .INIT(2'h1)) 
    minusOp_carry__1_i_1
       (.I0(slv_reg1[24]),
        .O(minusOp_carry__1_i_1_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    minusOp_carry__1_i_2
       (.I0(slv_reg1[23]),
        .O(minusOp_carry__1_i_2_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    minusOp_carry__1_i_3
       (.I0(slv_reg1[22]),
        .O(minusOp_carry__1_i_3_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    minusOp_carry__1_i_4
       (.I0(slv_reg1[21]),
        .O(minusOp_carry__1_i_4_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    minusOp_carry__1_i_5
       (.I0(slv_reg1[20]),
        .O(minusOp_carry__1_i_5_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    minusOp_carry__1_i_6
       (.I0(slv_reg1[19]),
        .O(minusOp_carry__1_i_6_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    minusOp_carry__1_i_7
       (.I0(slv_reg1[18]),
        .O(minusOp_carry__1_i_7_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    minusOp_carry__1_i_8
       (.I0(slv_reg1[17]),
        .O(minusOp_carry__1_i_8_n_0));
  CARRY8 minusOp_carry__2
       (.CI(minusOp_carry__1_n_0),
        .CI_TOP(1'b0),
        .CO({NLW_minusOp_carry__2_CO_UNCONNECTED[7:6],minusOp_carry__2_n_2,minusOp_carry__2_n_3,NLW_minusOp_carry__2_CO_UNCONNECTED[3],minusOp_carry__2_n_5,minusOp_carry__2_n_6,minusOp_carry__2_n_7}),
        .DI({NLW_minusOp_carry__2_DI_UNCONNECTED[7],1'b0,slv_reg1[30:25]}),
        .O({NLW_minusOp_carry__2_O_UNCONNECTED[7],minusOp[31:25]}),
        .S({NLW_minusOp_carry__2_S_UNCONNECTED[7],minusOp_carry__2_i_1_n_0,minusOp_carry__2_i_2_n_0,minusOp_carry__2_i_3_n_0,minusOp_carry__2_i_4_n_0,minusOp_carry__2_i_5_n_0,minusOp_carry__2_i_6_n_0,minusOp_carry__2_i_7_n_0}));
  LUT1 #(
    .INIT(2'h1)) 
    minusOp_carry__2_i_1
       (.I0(slv_reg1[31]),
        .O(minusOp_carry__2_i_1_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    minusOp_carry__2_i_2
       (.I0(slv_reg1[30]),
        .O(minusOp_carry__2_i_2_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    minusOp_carry__2_i_3
       (.I0(slv_reg1[29]),
        .O(minusOp_carry__2_i_3_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    minusOp_carry__2_i_4
       (.I0(slv_reg1[28]),
        .O(minusOp_carry__2_i_4_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    minusOp_carry__2_i_5
       (.I0(slv_reg1[27]),
        .O(minusOp_carry__2_i_5_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    minusOp_carry__2_i_6
       (.I0(slv_reg1[26]),
        .O(minusOp_carry__2_i_6_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    minusOp_carry__2_i_7
       (.I0(slv_reg1[25]),
        .O(minusOp_carry__2_i_7_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    minusOp_carry_i_1
       (.I0(slv_reg1[8]),
        .O(minusOp_carry_i_1_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    minusOp_carry_i_2
       (.I0(slv_reg1[7]),
        .O(minusOp_carry_i_2_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    minusOp_carry_i_3
       (.I0(slv_reg1[6]),
        .O(minusOp_carry_i_3_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    minusOp_carry_i_4
       (.I0(slv_reg1[5]),
        .O(minusOp_carry_i_4_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    minusOp_carry_i_5
       (.I0(slv_reg1[4]),
        .O(minusOp_carry_i_5_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    minusOp_carry_i_6
       (.I0(slv_reg1[3]),
        .O(minusOp_carry_i_6_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    minusOp_carry_i_7
       (.I0(slv_reg1[2]),
        .O(minusOp_carry_i_7_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    minusOp_carry_i_8
       (.I0(slv_reg1[1]),
        .O(minusOp_carry_i_8_n_0));
  CARRY8 s_M_AXIS_TVALID_int1_carry
       (.CI(1'b0),
        .CI_TOP(1'b0),
        .CO({s_M_AXIS_TVALID_int1_carry_n_0,s_M_AXIS_TVALID_int1_carry_n_1,s_M_AXIS_TVALID_int1_carry_n_2,s_M_AXIS_TVALID_int1_carry_n_3,NLW_s_M_AXIS_TVALID_int1_carry_CO_UNCONNECTED[3],s_M_AXIS_TVALID_int1_carry_n_5,s_M_AXIS_TVALID_int1_carry_n_6,s_M_AXIS_TVALID_int1_carry_n_7}),
        .DI({s_M_AXIS_TVALID_int1_carry_i_1_n_0,s_M_AXIS_TVALID_int1_carry_i_2_n_0,s_M_AXIS_TVALID_int1_carry_i_3_n_0,s_M_AXIS_TVALID_int1_carry_i_4_n_0,s_M_AXIS_TVALID_int1_carry_i_5_n_0,s_M_AXIS_TVALID_int1_carry_i_6_n_0,s_M_AXIS_TVALID_int1_carry_i_7_n_0,s_M_AXIS_TVALID_int1_carry_i_8_n_0}),
        .O(NLW_s_M_AXIS_TVALID_int1_carry_O_UNCONNECTED[7:0]),
        .S({s_M_AXIS_TVALID_int1_carry_i_9_n_0,s_M_AXIS_TVALID_int1_carry_i_10_n_0,s_M_AXIS_TVALID_int1_carry_i_11_n_0,s_M_AXIS_TVALID_int1_carry_i_12_n_0,s_M_AXIS_TVALID_int1_carry_i_13_n_0,s_M_AXIS_TVALID_int1_carry_i_14_n_0,s_M_AXIS_TVALID_int1_carry_i_15_n_0,s_M_AXIS_TVALID_int1_carry_i_16_n_0}));
  CARRY8 s_M_AXIS_TVALID_int1_carry__0
       (.CI(s_M_AXIS_TVALID_int1_carry_n_0),
        .CI_TOP(1'b0),
        .CO({s_M_AXIS_TVALID_int1_carry__0_n_0,s_M_AXIS_TVALID_int1_carry__0_n_1,s_M_AXIS_TVALID_int1_carry__0_n_2,s_M_AXIS_TVALID_int1_carry__0_n_3,NLW_s_M_AXIS_TVALID_int1_carry__0_CO_UNCONNECTED[3],s_M_AXIS_TVALID_int1_carry__0_n_5,s_M_AXIS_TVALID_int1_carry__0_n_6,s_M_AXIS_TVALID_int1_carry__0_n_7}),
        .DI({s_M_AXIS_TVALID_int1_carry__0_i_1_n_0,s_M_AXIS_TVALID_int1_carry__0_i_2_n_0,s_M_AXIS_TVALID_int1_carry__0_i_3_n_0,s_M_AXIS_TVALID_int1_carry__0_i_4_n_0,s_M_AXIS_TVALID_int1_carry__0_i_5_n_0,s_M_AXIS_TVALID_int1_carry__0_i_6_n_0,s_M_AXIS_TVALID_int1_carry__0_i_7_n_0,s_M_AXIS_TVALID_int1_carry__0_i_8_n_0}),
        .O(NLW_s_M_AXIS_TVALID_int1_carry__0_O_UNCONNECTED[7:0]),
        .S({s_M_AXIS_TVALID_int1_carry__0_i_9_n_0,s_M_AXIS_TVALID_int1_carry__0_i_10_n_0,s_M_AXIS_TVALID_int1_carry__0_i_11_n_0,s_M_AXIS_TVALID_int1_carry__0_i_12_n_0,s_M_AXIS_TVALID_int1_carry__0_i_13_n_0,s_M_AXIS_TVALID_int1_carry__0_i_14_n_0,s_M_AXIS_TVALID_int1_carry__0_i_15_n_0,s_M_AXIS_TVALID_int1_carry__0_i_16_n_0}));
  LUT6 #(
    .INIT(64'h00E2FFFF000000E2)) 
    s_M_AXIS_TVALID_int1_carry__0_i_1
       (.I0(plusOp[30]),
        .I1(\v_cnt[28]_i_2_n_0 ),
        .I2(m_axis_tdata[30]),
        .I3(minusOp[30]),
        .I4(minusOp[31]),
        .I5(v_cnt[31]),
        .O(s_M_AXIS_TVALID_int1_carry__0_i_1_n_0));
  LUT6 #(
    .INIT(64'hB84700000000B847)) 
    s_M_AXIS_TVALID_int1_carry__0_i_10
       (.I0(m_axis_tdata[28]),
        .I1(\v_cnt[28]_i_2_n_0 ),
        .I2(plusOp[28]),
        .I3(minusOp[28]),
        .I4(v_cnt[29]),
        .I5(minusOp[29]),
        .O(s_M_AXIS_TVALID_int1_carry__0_i_10_n_0));
  LUT6 #(
    .INIT(64'hB84700000000B847)) 
    s_M_AXIS_TVALID_int1_carry__0_i_11
       (.I0(m_axis_tdata[26]),
        .I1(\v_cnt[28]_i_2_n_0 ),
        .I2(plusOp[26]),
        .I3(minusOp[26]),
        .I4(v_cnt[27]),
        .I5(minusOp[27]),
        .O(s_M_AXIS_TVALID_int1_carry__0_i_11_n_0));
  LUT6 #(
    .INIT(64'hB84700000000B847)) 
    s_M_AXIS_TVALID_int1_carry__0_i_12
       (.I0(m_axis_tdata[24]),
        .I1(\v_cnt[28]_i_2_n_0 ),
        .I2(plusOp[24]),
        .I3(minusOp[24]),
        .I4(v_cnt[25]),
        .I5(minusOp[25]),
        .O(s_M_AXIS_TVALID_int1_carry__0_i_12_n_0));
  LUT6 #(
    .INIT(64'hB84700000000B847)) 
    s_M_AXIS_TVALID_int1_carry__0_i_13
       (.I0(m_axis_tdata[22]),
        .I1(\v_cnt[28]_i_2_n_0 ),
        .I2(plusOp[22]),
        .I3(minusOp[22]),
        .I4(v_cnt[23]),
        .I5(minusOp[23]),
        .O(s_M_AXIS_TVALID_int1_carry__0_i_13_n_0));
  LUT6 #(
    .INIT(64'hB84700000000B847)) 
    s_M_AXIS_TVALID_int1_carry__0_i_14
       (.I0(m_axis_tdata[20]),
        .I1(\v_cnt[28]_i_2_n_0 ),
        .I2(plusOp[20]),
        .I3(minusOp[20]),
        .I4(v_cnt[21]),
        .I5(minusOp[21]),
        .O(s_M_AXIS_TVALID_int1_carry__0_i_14_n_0));
  LUT6 #(
    .INIT(64'hB84700000000B847)) 
    s_M_AXIS_TVALID_int1_carry__0_i_15
       (.I0(m_axis_tdata[18]),
        .I1(\v_cnt[28]_i_2_n_0 ),
        .I2(plusOp[18]),
        .I3(minusOp[18]),
        .I4(v_cnt[19]),
        .I5(minusOp[19]),
        .O(s_M_AXIS_TVALID_int1_carry__0_i_15_n_0));
  LUT6 #(
    .INIT(64'hB84700000000B847)) 
    s_M_AXIS_TVALID_int1_carry__0_i_16
       (.I0(m_axis_tdata[16]),
        .I1(\v_cnt[28]_i_2_n_0 ),
        .I2(plusOp[16]),
        .I3(minusOp[16]),
        .I4(v_cnt[17]),
        .I5(minusOp[17]),
        .O(s_M_AXIS_TVALID_int1_carry__0_i_16_n_0));
  LUT6 #(
    .INIT(64'h00E2FFFF000000E2)) 
    s_M_AXIS_TVALID_int1_carry__0_i_2
       (.I0(plusOp[28]),
        .I1(\v_cnt[28]_i_2_n_0 ),
        .I2(m_axis_tdata[28]),
        .I3(minusOp[28]),
        .I4(minusOp[29]),
        .I5(v_cnt[29]),
        .O(s_M_AXIS_TVALID_int1_carry__0_i_2_n_0));
  LUT6 #(
    .INIT(64'h00E2FFFF000000E2)) 
    s_M_AXIS_TVALID_int1_carry__0_i_3
       (.I0(plusOp[26]),
        .I1(\v_cnt[28]_i_2_n_0 ),
        .I2(m_axis_tdata[26]),
        .I3(minusOp[26]),
        .I4(minusOp[27]),
        .I5(v_cnt[27]),
        .O(s_M_AXIS_TVALID_int1_carry__0_i_3_n_0));
  LUT6 #(
    .INIT(64'h00E2FFFF000000E2)) 
    s_M_AXIS_TVALID_int1_carry__0_i_4
       (.I0(plusOp[24]),
        .I1(\v_cnt[28]_i_2_n_0 ),
        .I2(m_axis_tdata[24]),
        .I3(minusOp[24]),
        .I4(minusOp[25]),
        .I5(v_cnt[25]),
        .O(s_M_AXIS_TVALID_int1_carry__0_i_4_n_0));
  LUT6 #(
    .INIT(64'h00E2FFFF000000E2)) 
    s_M_AXIS_TVALID_int1_carry__0_i_5
       (.I0(plusOp[22]),
        .I1(\v_cnt[28]_i_2_n_0 ),
        .I2(m_axis_tdata[22]),
        .I3(minusOp[22]),
        .I4(minusOp[23]),
        .I5(v_cnt[23]),
        .O(s_M_AXIS_TVALID_int1_carry__0_i_5_n_0));
  LUT6 #(
    .INIT(64'h00E2FFFF000000E2)) 
    s_M_AXIS_TVALID_int1_carry__0_i_6
       (.I0(plusOp[20]),
        .I1(\v_cnt[28]_i_2_n_0 ),
        .I2(m_axis_tdata[20]),
        .I3(minusOp[20]),
        .I4(minusOp[21]),
        .I5(v_cnt[21]),
        .O(s_M_AXIS_TVALID_int1_carry__0_i_6_n_0));
  LUT6 #(
    .INIT(64'h00E2FFFF000000E2)) 
    s_M_AXIS_TVALID_int1_carry__0_i_7
       (.I0(plusOp[18]),
        .I1(\v_cnt[28]_i_2_n_0 ),
        .I2(m_axis_tdata[18]),
        .I3(minusOp[18]),
        .I4(minusOp[19]),
        .I5(v_cnt[19]),
        .O(s_M_AXIS_TVALID_int1_carry__0_i_7_n_0));
  LUT6 #(
    .INIT(64'h00E2FFFF000000E2)) 
    s_M_AXIS_TVALID_int1_carry__0_i_8
       (.I0(plusOp[16]),
        .I1(\v_cnt[28]_i_2_n_0 ),
        .I2(m_axis_tdata[16]),
        .I3(minusOp[16]),
        .I4(minusOp[17]),
        .I5(v_cnt[17]),
        .O(s_M_AXIS_TVALID_int1_carry__0_i_8_n_0));
  LUT6 #(
    .INIT(64'hB84700000000B847)) 
    s_M_AXIS_TVALID_int1_carry__0_i_9
       (.I0(m_axis_tdata[30]),
        .I1(\v_cnt[28]_i_2_n_0 ),
        .I2(plusOp[30]),
        .I3(minusOp[30]),
        .I4(v_cnt[31]),
        .I5(minusOp[31]),
        .O(s_M_AXIS_TVALID_int1_carry__0_i_9_n_0));
  LUT6 #(
    .INIT(64'h00E2FFFF000000E2)) 
    s_M_AXIS_TVALID_int1_carry_i_1
       (.I0(plusOp[14]),
        .I1(\v_cnt[28]_i_2_n_0 ),
        .I2(m_axis_tdata[14]),
        .I3(minusOp[14]),
        .I4(minusOp[15]),
        .I5(v_cnt[15]),
        .O(s_M_AXIS_TVALID_int1_carry_i_1_n_0));
  LUT6 #(
    .INIT(64'hB84700000000B847)) 
    s_M_AXIS_TVALID_int1_carry_i_10
       (.I0(m_axis_tdata[12]),
        .I1(\v_cnt[28]_i_2_n_0 ),
        .I2(plusOp[12]),
        .I3(minusOp[12]),
        .I4(v_cnt[13]),
        .I5(minusOp[13]),
        .O(s_M_AXIS_TVALID_int1_carry_i_10_n_0));
  LUT6 #(
    .INIT(64'hB84700000000B847)) 
    s_M_AXIS_TVALID_int1_carry_i_11
       (.I0(m_axis_tdata[10]),
        .I1(\v_cnt[28]_i_2_n_0 ),
        .I2(plusOp[10]),
        .I3(minusOp[10]),
        .I4(v_cnt[11]),
        .I5(minusOp[11]),
        .O(s_M_AXIS_TVALID_int1_carry_i_11_n_0));
  LUT6 #(
    .INIT(64'hB84700000000B847)) 
    s_M_AXIS_TVALID_int1_carry_i_12
       (.I0(m_axis_tdata[8]),
        .I1(\v_cnt[28]_i_2_n_0 ),
        .I2(plusOp[8]),
        .I3(minusOp[8]),
        .I4(v_cnt[9]),
        .I5(minusOp[9]),
        .O(s_M_AXIS_TVALID_int1_carry_i_12_n_0));
  LUT6 #(
    .INIT(64'hB84700000000B847)) 
    s_M_AXIS_TVALID_int1_carry_i_13
       (.I0(m_axis_tdata[6]),
        .I1(\v_cnt[28]_i_2_n_0 ),
        .I2(plusOp[6]),
        .I3(minusOp[6]),
        .I4(v_cnt[7]),
        .I5(minusOp[7]),
        .O(s_M_AXIS_TVALID_int1_carry_i_13_n_0));
  LUT6 #(
    .INIT(64'hB84700000000B847)) 
    s_M_AXIS_TVALID_int1_carry_i_14
       (.I0(m_axis_tdata[4]),
        .I1(\v_cnt[28]_i_2_n_0 ),
        .I2(plusOp[4]),
        .I3(minusOp[4]),
        .I4(v_cnt[5]),
        .I5(minusOp[5]),
        .O(s_M_AXIS_TVALID_int1_carry_i_14_n_0));
  LUT6 #(
    .INIT(64'hB84700000000B847)) 
    s_M_AXIS_TVALID_int1_carry_i_15
       (.I0(m_axis_tdata[2]),
        .I1(\v_cnt[28]_i_2_n_0 ),
        .I2(plusOp[2]),
        .I3(minusOp[2]),
        .I4(v_cnt[3]),
        .I5(minusOp[3]),
        .O(s_M_AXIS_TVALID_int1_carry_i_15_n_0));
  LUT6 #(
    .INIT(64'h6099600006000699)) 
    s_M_AXIS_TVALID_int1_carry_i_16
       (.I0(m_axis_tdata[0]),
        .I1(slv_reg1[0]),
        .I2(m_axis_tdata[1]),
        .I3(\v_cnt[28]_i_2_n_0 ),
        .I4(plusOp[1]),
        .I5(minusOp[1]),
        .O(s_M_AXIS_TVALID_int1_carry_i_16_n_0));
  LUT6 #(
    .INIT(64'h00E2FFFF000000E2)) 
    s_M_AXIS_TVALID_int1_carry_i_2
       (.I0(plusOp[12]),
        .I1(\v_cnt[28]_i_2_n_0 ),
        .I2(m_axis_tdata[12]),
        .I3(minusOp[12]),
        .I4(minusOp[13]),
        .I5(v_cnt[13]),
        .O(s_M_AXIS_TVALID_int1_carry_i_2_n_0));
  LUT6 #(
    .INIT(64'h00E2FFFF000000E2)) 
    s_M_AXIS_TVALID_int1_carry_i_3
       (.I0(plusOp[10]),
        .I1(\v_cnt[28]_i_2_n_0 ),
        .I2(m_axis_tdata[10]),
        .I3(minusOp[10]),
        .I4(minusOp[11]),
        .I5(v_cnt[11]),
        .O(s_M_AXIS_TVALID_int1_carry_i_3_n_0));
  LUT6 #(
    .INIT(64'h00E2FFFF000000E2)) 
    s_M_AXIS_TVALID_int1_carry_i_4
       (.I0(plusOp[8]),
        .I1(\v_cnt[28]_i_2_n_0 ),
        .I2(m_axis_tdata[8]),
        .I3(minusOp[8]),
        .I4(minusOp[9]),
        .I5(v_cnt[9]),
        .O(s_M_AXIS_TVALID_int1_carry_i_4_n_0));
  LUT6 #(
    .INIT(64'h00E2FFFF000000E2)) 
    s_M_AXIS_TVALID_int1_carry_i_5
       (.I0(plusOp[6]),
        .I1(\v_cnt[28]_i_2_n_0 ),
        .I2(m_axis_tdata[6]),
        .I3(minusOp[6]),
        .I4(minusOp[7]),
        .I5(v_cnt[7]),
        .O(s_M_AXIS_TVALID_int1_carry_i_5_n_0));
  LUT6 #(
    .INIT(64'h00E2FFFF000000E2)) 
    s_M_AXIS_TVALID_int1_carry_i_6
       (.I0(plusOp[4]),
        .I1(\v_cnt[28]_i_2_n_0 ),
        .I2(m_axis_tdata[4]),
        .I3(minusOp[4]),
        .I4(minusOp[5]),
        .I5(v_cnt[5]),
        .O(s_M_AXIS_TVALID_int1_carry_i_6_n_0));
  LUT6 #(
    .INIT(64'h00E2FFFF000000E2)) 
    s_M_AXIS_TVALID_int1_carry_i_7
       (.I0(plusOp[2]),
        .I1(\v_cnt[28]_i_2_n_0 ),
        .I2(m_axis_tdata[2]),
        .I3(minusOp[2]),
        .I4(minusOp[3]),
        .I5(v_cnt[3]),
        .O(s_M_AXIS_TVALID_int1_carry_i_7_n_0));
  LUT6 #(
    .INIT(64'h8F084F4F8F080404)) 
    s_M_AXIS_TVALID_int1_carry_i_8
       (.I0(m_axis_tdata[0]),
        .I1(slv_reg1[0]),
        .I2(minusOp[1]),
        .I3(m_axis_tdata[1]),
        .I4(\v_cnt[28]_i_2_n_0 ),
        .I5(plusOp[1]),
        .O(s_M_AXIS_TVALID_int1_carry_i_8_n_0));
  LUT6 #(
    .INIT(64'hB84700000000B847)) 
    s_M_AXIS_TVALID_int1_carry_i_9
       (.I0(m_axis_tdata[14]),
        .I1(\v_cnt[28]_i_2_n_0 ),
        .I2(plusOp[14]),
        .I3(minusOp[14]),
        .I4(v_cnt[15]),
        .I5(minusOp[15]),
        .O(s_M_AXIS_TVALID_int1_carry_i_9_n_0));
  CARRY8 \s_M_AXIS_TVALID_int1_inferred__0/i__carry 
       (.CI(1'b1),
        .CI_TOP(1'b0),
        .CO({\s_M_AXIS_TVALID_int1_inferred__0/i__carry_n_0 ,\s_M_AXIS_TVALID_int1_inferred__0/i__carry_n_1 ,\s_M_AXIS_TVALID_int1_inferred__0/i__carry_n_2 ,\s_M_AXIS_TVALID_int1_inferred__0/i__carry_n_3 ,\NLW_s_M_AXIS_TVALID_int1_inferred__0/i__carry_CO_UNCONNECTED [3],\s_M_AXIS_TVALID_int1_inferred__0/i__carry_n_5 ,\s_M_AXIS_TVALID_int1_inferred__0/i__carry_n_6 ,\s_M_AXIS_TVALID_int1_inferred__0/i__carry_n_7 }),
        .DI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .O(\NLW_s_M_AXIS_TVALID_int1_inferred__0/i__carry_O_UNCONNECTED [7:0]),
        .S({i__carry_i_1_n_0,i__carry_i_2_n_0,i__carry_i_3_n_0,i__carry_i_4_n_0,i__carry_i_5_n_0,i__carry_i_6_n_0,i__carry_i_7_n_0,i__carry_i_8_n_0}));
  CARRY8 \s_M_AXIS_TVALID_int1_inferred__0/i__carry__0 
       (.CI(\s_M_AXIS_TVALID_int1_inferred__0/i__carry_n_0 ),
        .CI_TOP(1'b0),
        .CO({\NLW_s_M_AXIS_TVALID_int1_inferred__0/i__carry__0_CO_UNCONNECTED [7:3],\s_M_AXIS_TVALID_int1_inferred__0/i__carry__0_n_5 ,\s_M_AXIS_TVALID_int1_inferred__0/i__carry__0_n_6 ,\s_M_AXIS_TVALID_int1_inferred__0/i__carry__0_n_7 }),
        .DI({\NLW_s_M_AXIS_TVALID_int1_inferred__0/i__carry__0_DI_UNCONNECTED [7:3],1'b0,1'b0,1'b0}),
        .O(\NLW_s_M_AXIS_TVALID_int1_inferred__0/i__carry__0_O_UNCONNECTED [7:0]),
        .S({\NLW_s_M_AXIS_TVALID_int1_inferred__0/i__carry__0_S_UNCONNECTED [7:3],i__carry__0_i_1_n_0,i__carry__0_i_2_n_0,i__carry__0_i_3_n_0}));
  LUT2 #(
    .INIT(4'h7)) 
    s_M_AXIS_TVALID_int_i_1
       (.I0(axi_aresetn),
        .I1(slv_reg0),
        .O(s_M_AXIS_TVALID_int_i_1_n_0));
  LUT2 #(
    .INIT(4'hB)) 
    s_M_AXIS_TVALID_int_i_2
       (.I0(\s_M_AXIS_TVALID_int1_inferred__0/i__carry__0_n_5 ),
        .I1(s_M_AXIS_TVALID_int1_carry__0_n_0),
        .O(s_M_AXIS_TVALID_int_i_2_n_0));
  FDRE #(
    .INIT(1'b0)) 
    s_M_AXIS_TVALID_int_reg
       (.C(axi_aclk),
        .CE(1'b1),
        .D(s_M_AXIS_TVALID_int_i_2_n_0),
        .Q(m_axis_tvalid),
        .R(s_M_AXIS_TVALID_int_i_1_n_0));
  LUT4 #(
    .INIT(16'h0200)) 
    \slv_reg0[15]_i_1 
       (.I0(slv_reg_wren__2),
        .I1(axi_awaddr[3]),
        .I2(axi_awaddr[2]),
        .I3(s00_axi_wstrb[1]),
        .O(\slv_reg0[15]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'h0200)) 
    \slv_reg0[23]_i_1 
       (.I0(slv_reg_wren__2),
        .I1(axi_awaddr[3]),
        .I2(axi_awaddr[2]),
        .I3(s00_axi_wstrb[2]),
        .O(\slv_reg0[23]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'h0200)) 
    \slv_reg0[31]_i_1 
       (.I0(slv_reg_wren__2),
        .I1(axi_awaddr[3]),
        .I2(axi_awaddr[2]),
        .I3(s00_axi_wstrb[3]),
        .O(\slv_reg0[31]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT4 #(
    .INIT(16'h8000)) 
    \slv_reg0[31]_i_2 
       (.I0(S_AXI_WREADY),
        .I1(s00_axi_wvalid),
        .I2(S_AXI_AWREADY),
        .I3(s00_axi_awvalid),
        .O(slv_reg_wren__2));
  LUT4 #(
    .INIT(16'h0200)) 
    \slv_reg0[7]_i_1 
       (.I0(slv_reg_wren__2),
        .I1(axi_awaddr[3]),
        .I2(axi_awaddr[2]),
        .I3(s00_axi_wstrb[0]),
        .O(\slv_reg0[7]_i_1_n_0 ));
  FDRE \slv_reg0_reg[0] 
       (.C(axi_aclk),
        .CE(\slv_reg0[7]_i_1_n_0 ),
        .D(s00_axi_wdata[0]),
        .Q(slv_reg0),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg0_reg[10] 
       (.C(axi_aclk),
        .CE(\slv_reg0[15]_i_1_n_0 ),
        .D(s00_axi_wdata[10]),
        .Q(\slv_reg0_reg_n_0_[10] ),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg0_reg[11] 
       (.C(axi_aclk),
        .CE(\slv_reg0[15]_i_1_n_0 ),
        .D(s00_axi_wdata[11]),
        .Q(\slv_reg0_reg_n_0_[11] ),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg0_reg[12] 
       (.C(axi_aclk),
        .CE(\slv_reg0[15]_i_1_n_0 ),
        .D(s00_axi_wdata[12]),
        .Q(\slv_reg0_reg_n_0_[12] ),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg0_reg[13] 
       (.C(axi_aclk),
        .CE(\slv_reg0[15]_i_1_n_0 ),
        .D(s00_axi_wdata[13]),
        .Q(\slv_reg0_reg_n_0_[13] ),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg0_reg[14] 
       (.C(axi_aclk),
        .CE(\slv_reg0[15]_i_1_n_0 ),
        .D(s00_axi_wdata[14]),
        .Q(\slv_reg0_reg_n_0_[14] ),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg0_reg[15] 
       (.C(axi_aclk),
        .CE(\slv_reg0[15]_i_1_n_0 ),
        .D(s00_axi_wdata[15]),
        .Q(\slv_reg0_reg_n_0_[15] ),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg0_reg[16] 
       (.C(axi_aclk),
        .CE(\slv_reg0[23]_i_1_n_0 ),
        .D(s00_axi_wdata[16]),
        .Q(\slv_reg0_reg_n_0_[16] ),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg0_reg[17] 
       (.C(axi_aclk),
        .CE(\slv_reg0[23]_i_1_n_0 ),
        .D(s00_axi_wdata[17]),
        .Q(\slv_reg0_reg_n_0_[17] ),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg0_reg[18] 
       (.C(axi_aclk),
        .CE(\slv_reg0[23]_i_1_n_0 ),
        .D(s00_axi_wdata[18]),
        .Q(\slv_reg0_reg_n_0_[18] ),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg0_reg[19] 
       (.C(axi_aclk),
        .CE(\slv_reg0[23]_i_1_n_0 ),
        .D(s00_axi_wdata[19]),
        .Q(\slv_reg0_reg_n_0_[19] ),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg0_reg[1] 
       (.C(axi_aclk),
        .CE(\slv_reg0[7]_i_1_n_0 ),
        .D(s00_axi_wdata[1]),
        .Q(\slv_reg0_reg_n_0_[1] ),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg0_reg[20] 
       (.C(axi_aclk),
        .CE(\slv_reg0[23]_i_1_n_0 ),
        .D(s00_axi_wdata[20]),
        .Q(\slv_reg0_reg_n_0_[20] ),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg0_reg[21] 
       (.C(axi_aclk),
        .CE(\slv_reg0[23]_i_1_n_0 ),
        .D(s00_axi_wdata[21]),
        .Q(\slv_reg0_reg_n_0_[21] ),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg0_reg[22] 
       (.C(axi_aclk),
        .CE(\slv_reg0[23]_i_1_n_0 ),
        .D(s00_axi_wdata[22]),
        .Q(\slv_reg0_reg_n_0_[22] ),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg0_reg[23] 
       (.C(axi_aclk),
        .CE(\slv_reg0[23]_i_1_n_0 ),
        .D(s00_axi_wdata[23]),
        .Q(\slv_reg0_reg_n_0_[23] ),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg0_reg[24] 
       (.C(axi_aclk),
        .CE(\slv_reg0[31]_i_1_n_0 ),
        .D(s00_axi_wdata[24]),
        .Q(\slv_reg0_reg_n_0_[24] ),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg0_reg[25] 
       (.C(axi_aclk),
        .CE(\slv_reg0[31]_i_1_n_0 ),
        .D(s00_axi_wdata[25]),
        .Q(\slv_reg0_reg_n_0_[25] ),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg0_reg[26] 
       (.C(axi_aclk),
        .CE(\slv_reg0[31]_i_1_n_0 ),
        .D(s00_axi_wdata[26]),
        .Q(\slv_reg0_reg_n_0_[26] ),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg0_reg[27] 
       (.C(axi_aclk),
        .CE(\slv_reg0[31]_i_1_n_0 ),
        .D(s00_axi_wdata[27]),
        .Q(\slv_reg0_reg_n_0_[27] ),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg0_reg[28] 
       (.C(axi_aclk),
        .CE(\slv_reg0[31]_i_1_n_0 ),
        .D(s00_axi_wdata[28]),
        .Q(\slv_reg0_reg_n_0_[28] ),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg0_reg[29] 
       (.C(axi_aclk),
        .CE(\slv_reg0[31]_i_1_n_0 ),
        .D(s00_axi_wdata[29]),
        .Q(\slv_reg0_reg_n_0_[29] ),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg0_reg[2] 
       (.C(axi_aclk),
        .CE(\slv_reg0[7]_i_1_n_0 ),
        .D(s00_axi_wdata[2]),
        .Q(\slv_reg0_reg_n_0_[2] ),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg0_reg[30] 
       (.C(axi_aclk),
        .CE(\slv_reg0[31]_i_1_n_0 ),
        .D(s00_axi_wdata[30]),
        .Q(\slv_reg0_reg_n_0_[30] ),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg0_reg[31] 
       (.C(axi_aclk),
        .CE(\slv_reg0[31]_i_1_n_0 ),
        .D(s00_axi_wdata[31]),
        .Q(\slv_reg0_reg_n_0_[31] ),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg0_reg[3] 
       (.C(axi_aclk),
        .CE(\slv_reg0[7]_i_1_n_0 ),
        .D(s00_axi_wdata[3]),
        .Q(\slv_reg0_reg_n_0_[3] ),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg0_reg[4] 
       (.C(axi_aclk),
        .CE(\slv_reg0[7]_i_1_n_0 ),
        .D(s00_axi_wdata[4]),
        .Q(\slv_reg0_reg_n_0_[4] ),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg0_reg[5] 
       (.C(axi_aclk),
        .CE(\slv_reg0[7]_i_1_n_0 ),
        .D(s00_axi_wdata[5]),
        .Q(\slv_reg0_reg_n_0_[5] ),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg0_reg[6] 
       (.C(axi_aclk),
        .CE(\slv_reg0[7]_i_1_n_0 ),
        .D(s00_axi_wdata[6]),
        .Q(\slv_reg0_reg_n_0_[6] ),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg0_reg[7] 
       (.C(axi_aclk),
        .CE(\slv_reg0[7]_i_1_n_0 ),
        .D(s00_axi_wdata[7]),
        .Q(\slv_reg0_reg_n_0_[7] ),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg0_reg[8] 
       (.C(axi_aclk),
        .CE(\slv_reg0[15]_i_1_n_0 ),
        .D(s00_axi_wdata[8]),
        .Q(\slv_reg0_reg_n_0_[8] ),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg0_reg[9] 
       (.C(axi_aclk),
        .CE(\slv_reg0[15]_i_1_n_0 ),
        .D(s00_axi_wdata[9]),
        .Q(\slv_reg0_reg_n_0_[9] ),
        .R(axi_awready_i_1_n_0));
  LUT4 #(
    .INIT(16'h0080)) 
    \slv_reg1[15]_i_1 
       (.I0(slv_reg_wren__2),
        .I1(s00_axi_wstrb[1]),
        .I2(axi_awaddr[2]),
        .I3(axi_awaddr[3]),
        .O(\slv_reg1[15]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'h0080)) 
    \slv_reg1[23]_i_1 
       (.I0(slv_reg_wren__2),
        .I1(s00_axi_wstrb[2]),
        .I2(axi_awaddr[2]),
        .I3(axi_awaddr[3]),
        .O(\slv_reg1[23]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'h0080)) 
    \slv_reg1[31]_i_1 
       (.I0(slv_reg_wren__2),
        .I1(s00_axi_wstrb[3]),
        .I2(axi_awaddr[2]),
        .I3(axi_awaddr[3]),
        .O(\slv_reg1[31]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'h0080)) 
    \slv_reg1[7]_i_1 
       (.I0(slv_reg_wren__2),
        .I1(s00_axi_wstrb[0]),
        .I2(axi_awaddr[2]),
        .I3(axi_awaddr[3]),
        .O(\slv_reg1[7]_i_1_n_0 ));
  FDRE \slv_reg1_reg[0] 
       (.C(axi_aclk),
        .CE(\slv_reg1[7]_i_1_n_0 ),
        .D(s00_axi_wdata[0]),
        .Q(slv_reg1[0]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg1_reg[10] 
       (.C(axi_aclk),
        .CE(\slv_reg1[15]_i_1_n_0 ),
        .D(s00_axi_wdata[10]),
        .Q(slv_reg1[10]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg1_reg[11] 
       (.C(axi_aclk),
        .CE(\slv_reg1[15]_i_1_n_0 ),
        .D(s00_axi_wdata[11]),
        .Q(slv_reg1[11]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg1_reg[12] 
       (.C(axi_aclk),
        .CE(\slv_reg1[15]_i_1_n_0 ),
        .D(s00_axi_wdata[12]),
        .Q(slv_reg1[12]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg1_reg[13] 
       (.C(axi_aclk),
        .CE(\slv_reg1[15]_i_1_n_0 ),
        .D(s00_axi_wdata[13]),
        .Q(slv_reg1[13]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg1_reg[14] 
       (.C(axi_aclk),
        .CE(\slv_reg1[15]_i_1_n_0 ),
        .D(s00_axi_wdata[14]),
        .Q(slv_reg1[14]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg1_reg[15] 
       (.C(axi_aclk),
        .CE(\slv_reg1[15]_i_1_n_0 ),
        .D(s00_axi_wdata[15]),
        .Q(slv_reg1[15]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg1_reg[16] 
       (.C(axi_aclk),
        .CE(\slv_reg1[23]_i_1_n_0 ),
        .D(s00_axi_wdata[16]),
        .Q(slv_reg1[16]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg1_reg[17] 
       (.C(axi_aclk),
        .CE(\slv_reg1[23]_i_1_n_0 ),
        .D(s00_axi_wdata[17]),
        .Q(slv_reg1[17]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg1_reg[18] 
       (.C(axi_aclk),
        .CE(\slv_reg1[23]_i_1_n_0 ),
        .D(s00_axi_wdata[18]),
        .Q(slv_reg1[18]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg1_reg[19] 
       (.C(axi_aclk),
        .CE(\slv_reg1[23]_i_1_n_0 ),
        .D(s00_axi_wdata[19]),
        .Q(slv_reg1[19]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg1_reg[1] 
       (.C(axi_aclk),
        .CE(\slv_reg1[7]_i_1_n_0 ),
        .D(s00_axi_wdata[1]),
        .Q(slv_reg1[1]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg1_reg[20] 
       (.C(axi_aclk),
        .CE(\slv_reg1[23]_i_1_n_0 ),
        .D(s00_axi_wdata[20]),
        .Q(slv_reg1[20]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg1_reg[21] 
       (.C(axi_aclk),
        .CE(\slv_reg1[23]_i_1_n_0 ),
        .D(s00_axi_wdata[21]),
        .Q(slv_reg1[21]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg1_reg[22] 
       (.C(axi_aclk),
        .CE(\slv_reg1[23]_i_1_n_0 ),
        .D(s00_axi_wdata[22]),
        .Q(slv_reg1[22]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg1_reg[23] 
       (.C(axi_aclk),
        .CE(\slv_reg1[23]_i_1_n_0 ),
        .D(s00_axi_wdata[23]),
        .Q(slv_reg1[23]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg1_reg[24] 
       (.C(axi_aclk),
        .CE(\slv_reg1[31]_i_1_n_0 ),
        .D(s00_axi_wdata[24]),
        .Q(slv_reg1[24]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg1_reg[25] 
       (.C(axi_aclk),
        .CE(\slv_reg1[31]_i_1_n_0 ),
        .D(s00_axi_wdata[25]),
        .Q(slv_reg1[25]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg1_reg[26] 
       (.C(axi_aclk),
        .CE(\slv_reg1[31]_i_1_n_0 ),
        .D(s00_axi_wdata[26]),
        .Q(slv_reg1[26]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg1_reg[27] 
       (.C(axi_aclk),
        .CE(\slv_reg1[31]_i_1_n_0 ),
        .D(s00_axi_wdata[27]),
        .Q(slv_reg1[27]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg1_reg[28] 
       (.C(axi_aclk),
        .CE(\slv_reg1[31]_i_1_n_0 ),
        .D(s00_axi_wdata[28]),
        .Q(slv_reg1[28]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg1_reg[29] 
       (.C(axi_aclk),
        .CE(\slv_reg1[31]_i_1_n_0 ),
        .D(s00_axi_wdata[29]),
        .Q(slv_reg1[29]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg1_reg[2] 
       (.C(axi_aclk),
        .CE(\slv_reg1[7]_i_1_n_0 ),
        .D(s00_axi_wdata[2]),
        .Q(slv_reg1[2]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg1_reg[30] 
       (.C(axi_aclk),
        .CE(\slv_reg1[31]_i_1_n_0 ),
        .D(s00_axi_wdata[30]),
        .Q(slv_reg1[30]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg1_reg[31] 
       (.C(axi_aclk),
        .CE(\slv_reg1[31]_i_1_n_0 ),
        .D(s00_axi_wdata[31]),
        .Q(slv_reg1[31]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg1_reg[3] 
       (.C(axi_aclk),
        .CE(\slv_reg1[7]_i_1_n_0 ),
        .D(s00_axi_wdata[3]),
        .Q(slv_reg1[3]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg1_reg[4] 
       (.C(axi_aclk),
        .CE(\slv_reg1[7]_i_1_n_0 ),
        .D(s00_axi_wdata[4]),
        .Q(slv_reg1[4]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg1_reg[5] 
       (.C(axi_aclk),
        .CE(\slv_reg1[7]_i_1_n_0 ),
        .D(s00_axi_wdata[5]),
        .Q(slv_reg1[5]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg1_reg[6] 
       (.C(axi_aclk),
        .CE(\slv_reg1[7]_i_1_n_0 ),
        .D(s00_axi_wdata[6]),
        .Q(slv_reg1[6]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg1_reg[7] 
       (.C(axi_aclk),
        .CE(\slv_reg1[7]_i_1_n_0 ),
        .D(s00_axi_wdata[7]),
        .Q(slv_reg1[7]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg1_reg[8] 
       (.C(axi_aclk),
        .CE(\slv_reg1[15]_i_1_n_0 ),
        .D(s00_axi_wdata[8]),
        .Q(slv_reg1[8]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg1_reg[9] 
       (.C(axi_aclk),
        .CE(\slv_reg1[15]_i_1_n_0 ),
        .D(s00_axi_wdata[9]),
        .Q(slv_reg1[9]),
        .R(axi_awready_i_1_n_0));
  LUT4 #(
    .INIT(16'h0080)) 
    \slv_reg2[15]_i_1 
       (.I0(slv_reg_wren__2),
        .I1(axi_awaddr[3]),
        .I2(s00_axi_wstrb[1]),
        .I3(axi_awaddr[2]),
        .O(\slv_reg2[15]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'h0080)) 
    \slv_reg2[23]_i_1 
       (.I0(slv_reg_wren__2),
        .I1(axi_awaddr[3]),
        .I2(s00_axi_wstrb[2]),
        .I3(axi_awaddr[2]),
        .O(\slv_reg2[23]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'h0080)) 
    \slv_reg2[31]_i_1 
       (.I0(slv_reg_wren__2),
        .I1(axi_awaddr[3]),
        .I2(s00_axi_wstrb[3]),
        .I3(axi_awaddr[2]),
        .O(\slv_reg2[31]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'h0080)) 
    \slv_reg2[7]_i_1 
       (.I0(slv_reg_wren__2),
        .I1(axi_awaddr[3]),
        .I2(s00_axi_wstrb[0]),
        .I3(axi_awaddr[2]),
        .O(\slv_reg2[7]_i_1_n_0 ));
  FDRE \slv_reg2_reg[0] 
       (.C(axi_aclk),
        .CE(\slv_reg2[7]_i_1_n_0 ),
        .D(s00_axi_wdata[0]),
        .Q(slv_reg2[0]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg2_reg[10] 
       (.C(axi_aclk),
        .CE(\slv_reg2[15]_i_1_n_0 ),
        .D(s00_axi_wdata[10]),
        .Q(slv_reg2[10]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg2_reg[11] 
       (.C(axi_aclk),
        .CE(\slv_reg2[15]_i_1_n_0 ),
        .D(s00_axi_wdata[11]),
        .Q(slv_reg2[11]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg2_reg[12] 
       (.C(axi_aclk),
        .CE(\slv_reg2[15]_i_1_n_0 ),
        .D(s00_axi_wdata[12]),
        .Q(slv_reg2[12]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg2_reg[13] 
       (.C(axi_aclk),
        .CE(\slv_reg2[15]_i_1_n_0 ),
        .D(s00_axi_wdata[13]),
        .Q(slv_reg2[13]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg2_reg[14] 
       (.C(axi_aclk),
        .CE(\slv_reg2[15]_i_1_n_0 ),
        .D(s00_axi_wdata[14]),
        .Q(slv_reg2[14]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg2_reg[15] 
       (.C(axi_aclk),
        .CE(\slv_reg2[15]_i_1_n_0 ),
        .D(s00_axi_wdata[15]),
        .Q(slv_reg2[15]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg2_reg[16] 
       (.C(axi_aclk),
        .CE(\slv_reg2[23]_i_1_n_0 ),
        .D(s00_axi_wdata[16]),
        .Q(slv_reg2[16]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg2_reg[17] 
       (.C(axi_aclk),
        .CE(\slv_reg2[23]_i_1_n_0 ),
        .D(s00_axi_wdata[17]),
        .Q(slv_reg2[17]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg2_reg[18] 
       (.C(axi_aclk),
        .CE(\slv_reg2[23]_i_1_n_0 ),
        .D(s00_axi_wdata[18]),
        .Q(slv_reg2[18]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg2_reg[19] 
       (.C(axi_aclk),
        .CE(\slv_reg2[23]_i_1_n_0 ),
        .D(s00_axi_wdata[19]),
        .Q(slv_reg2[19]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg2_reg[1] 
       (.C(axi_aclk),
        .CE(\slv_reg2[7]_i_1_n_0 ),
        .D(s00_axi_wdata[1]),
        .Q(slv_reg2[1]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg2_reg[20] 
       (.C(axi_aclk),
        .CE(\slv_reg2[23]_i_1_n_0 ),
        .D(s00_axi_wdata[20]),
        .Q(slv_reg2[20]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg2_reg[21] 
       (.C(axi_aclk),
        .CE(\slv_reg2[23]_i_1_n_0 ),
        .D(s00_axi_wdata[21]),
        .Q(slv_reg2[21]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg2_reg[22] 
       (.C(axi_aclk),
        .CE(\slv_reg2[23]_i_1_n_0 ),
        .D(s00_axi_wdata[22]),
        .Q(slv_reg2[22]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg2_reg[23] 
       (.C(axi_aclk),
        .CE(\slv_reg2[23]_i_1_n_0 ),
        .D(s00_axi_wdata[23]),
        .Q(slv_reg2[23]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg2_reg[24] 
       (.C(axi_aclk),
        .CE(\slv_reg2[31]_i_1_n_0 ),
        .D(s00_axi_wdata[24]),
        .Q(slv_reg2[24]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg2_reg[25] 
       (.C(axi_aclk),
        .CE(\slv_reg2[31]_i_1_n_0 ),
        .D(s00_axi_wdata[25]),
        .Q(slv_reg2[25]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg2_reg[26] 
       (.C(axi_aclk),
        .CE(\slv_reg2[31]_i_1_n_0 ),
        .D(s00_axi_wdata[26]),
        .Q(slv_reg2[26]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg2_reg[27] 
       (.C(axi_aclk),
        .CE(\slv_reg2[31]_i_1_n_0 ),
        .D(s00_axi_wdata[27]),
        .Q(slv_reg2[27]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg2_reg[28] 
       (.C(axi_aclk),
        .CE(\slv_reg2[31]_i_1_n_0 ),
        .D(s00_axi_wdata[28]),
        .Q(slv_reg2[28]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg2_reg[29] 
       (.C(axi_aclk),
        .CE(\slv_reg2[31]_i_1_n_0 ),
        .D(s00_axi_wdata[29]),
        .Q(slv_reg2[29]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg2_reg[2] 
       (.C(axi_aclk),
        .CE(\slv_reg2[7]_i_1_n_0 ),
        .D(s00_axi_wdata[2]),
        .Q(slv_reg2[2]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg2_reg[30] 
       (.C(axi_aclk),
        .CE(\slv_reg2[31]_i_1_n_0 ),
        .D(s00_axi_wdata[30]),
        .Q(slv_reg2[30]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg2_reg[31] 
       (.C(axi_aclk),
        .CE(\slv_reg2[31]_i_1_n_0 ),
        .D(s00_axi_wdata[31]),
        .Q(slv_reg2[31]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg2_reg[3] 
       (.C(axi_aclk),
        .CE(\slv_reg2[7]_i_1_n_0 ),
        .D(s00_axi_wdata[3]),
        .Q(slv_reg2[3]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg2_reg[4] 
       (.C(axi_aclk),
        .CE(\slv_reg2[7]_i_1_n_0 ),
        .D(s00_axi_wdata[4]),
        .Q(slv_reg2[4]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg2_reg[5] 
       (.C(axi_aclk),
        .CE(\slv_reg2[7]_i_1_n_0 ),
        .D(s00_axi_wdata[5]),
        .Q(slv_reg2[5]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg2_reg[6] 
       (.C(axi_aclk),
        .CE(\slv_reg2[7]_i_1_n_0 ),
        .D(s00_axi_wdata[6]),
        .Q(slv_reg2[6]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg2_reg[7] 
       (.C(axi_aclk),
        .CE(\slv_reg2[7]_i_1_n_0 ),
        .D(s00_axi_wdata[7]),
        .Q(slv_reg2[7]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg2_reg[8] 
       (.C(axi_aclk),
        .CE(\slv_reg2[15]_i_1_n_0 ),
        .D(s00_axi_wdata[8]),
        .Q(slv_reg2[8]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg2_reg[9] 
       (.C(axi_aclk),
        .CE(\slv_reg2[15]_i_1_n_0 ),
        .D(s00_axi_wdata[9]),
        .Q(slv_reg2[9]),
        .R(axi_awready_i_1_n_0));
  LUT4 #(
    .INIT(16'h8000)) 
    \slv_reg3[15]_i_1 
       (.I0(slv_reg_wren__2),
        .I1(s00_axi_wstrb[1]),
        .I2(axi_awaddr[2]),
        .I3(axi_awaddr[3]),
        .O(\slv_reg3[15]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'h8000)) 
    \slv_reg3[23]_i_1 
       (.I0(slv_reg_wren__2),
        .I1(s00_axi_wstrb[2]),
        .I2(axi_awaddr[2]),
        .I3(axi_awaddr[3]),
        .O(\slv_reg3[23]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'h8000)) 
    \slv_reg3[31]_i_1 
       (.I0(slv_reg_wren__2),
        .I1(s00_axi_wstrb[3]),
        .I2(axi_awaddr[2]),
        .I3(axi_awaddr[3]),
        .O(\slv_reg3[31]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'h8000)) 
    \slv_reg3[7]_i_1 
       (.I0(slv_reg_wren__2),
        .I1(s00_axi_wstrb[0]),
        .I2(axi_awaddr[2]),
        .I3(axi_awaddr[3]),
        .O(\slv_reg3[7]_i_1_n_0 ));
  FDRE \slv_reg3_reg[0] 
       (.C(axi_aclk),
        .CE(\slv_reg3[7]_i_1_n_0 ),
        .D(s00_axi_wdata[0]),
        .Q(slv_reg3[0]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg3_reg[10] 
       (.C(axi_aclk),
        .CE(\slv_reg3[15]_i_1_n_0 ),
        .D(s00_axi_wdata[10]),
        .Q(slv_reg3[10]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg3_reg[11] 
       (.C(axi_aclk),
        .CE(\slv_reg3[15]_i_1_n_0 ),
        .D(s00_axi_wdata[11]),
        .Q(slv_reg3[11]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg3_reg[12] 
       (.C(axi_aclk),
        .CE(\slv_reg3[15]_i_1_n_0 ),
        .D(s00_axi_wdata[12]),
        .Q(slv_reg3[12]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg3_reg[13] 
       (.C(axi_aclk),
        .CE(\slv_reg3[15]_i_1_n_0 ),
        .D(s00_axi_wdata[13]),
        .Q(slv_reg3[13]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg3_reg[14] 
       (.C(axi_aclk),
        .CE(\slv_reg3[15]_i_1_n_0 ),
        .D(s00_axi_wdata[14]),
        .Q(slv_reg3[14]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg3_reg[15] 
       (.C(axi_aclk),
        .CE(\slv_reg3[15]_i_1_n_0 ),
        .D(s00_axi_wdata[15]),
        .Q(slv_reg3[15]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg3_reg[16] 
       (.C(axi_aclk),
        .CE(\slv_reg3[23]_i_1_n_0 ),
        .D(s00_axi_wdata[16]),
        .Q(slv_reg3[16]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg3_reg[17] 
       (.C(axi_aclk),
        .CE(\slv_reg3[23]_i_1_n_0 ),
        .D(s00_axi_wdata[17]),
        .Q(slv_reg3[17]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg3_reg[18] 
       (.C(axi_aclk),
        .CE(\slv_reg3[23]_i_1_n_0 ),
        .D(s00_axi_wdata[18]),
        .Q(slv_reg3[18]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg3_reg[19] 
       (.C(axi_aclk),
        .CE(\slv_reg3[23]_i_1_n_0 ),
        .D(s00_axi_wdata[19]),
        .Q(slv_reg3[19]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg3_reg[1] 
       (.C(axi_aclk),
        .CE(\slv_reg3[7]_i_1_n_0 ),
        .D(s00_axi_wdata[1]),
        .Q(slv_reg3[1]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg3_reg[20] 
       (.C(axi_aclk),
        .CE(\slv_reg3[23]_i_1_n_0 ),
        .D(s00_axi_wdata[20]),
        .Q(slv_reg3[20]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg3_reg[21] 
       (.C(axi_aclk),
        .CE(\slv_reg3[23]_i_1_n_0 ),
        .D(s00_axi_wdata[21]),
        .Q(slv_reg3[21]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg3_reg[22] 
       (.C(axi_aclk),
        .CE(\slv_reg3[23]_i_1_n_0 ),
        .D(s00_axi_wdata[22]),
        .Q(slv_reg3[22]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg3_reg[23] 
       (.C(axi_aclk),
        .CE(\slv_reg3[23]_i_1_n_0 ),
        .D(s00_axi_wdata[23]),
        .Q(slv_reg3[23]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg3_reg[24] 
       (.C(axi_aclk),
        .CE(\slv_reg3[31]_i_1_n_0 ),
        .D(s00_axi_wdata[24]),
        .Q(slv_reg3[24]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg3_reg[25] 
       (.C(axi_aclk),
        .CE(\slv_reg3[31]_i_1_n_0 ),
        .D(s00_axi_wdata[25]),
        .Q(slv_reg3[25]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg3_reg[26] 
       (.C(axi_aclk),
        .CE(\slv_reg3[31]_i_1_n_0 ),
        .D(s00_axi_wdata[26]),
        .Q(slv_reg3[26]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg3_reg[27] 
       (.C(axi_aclk),
        .CE(\slv_reg3[31]_i_1_n_0 ),
        .D(s00_axi_wdata[27]),
        .Q(slv_reg3[27]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg3_reg[28] 
       (.C(axi_aclk),
        .CE(\slv_reg3[31]_i_1_n_0 ),
        .D(s00_axi_wdata[28]),
        .Q(slv_reg3[28]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg3_reg[29] 
       (.C(axi_aclk),
        .CE(\slv_reg3[31]_i_1_n_0 ),
        .D(s00_axi_wdata[29]),
        .Q(slv_reg3[29]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg3_reg[2] 
       (.C(axi_aclk),
        .CE(\slv_reg3[7]_i_1_n_0 ),
        .D(s00_axi_wdata[2]),
        .Q(slv_reg3[2]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg3_reg[30] 
       (.C(axi_aclk),
        .CE(\slv_reg3[31]_i_1_n_0 ),
        .D(s00_axi_wdata[30]),
        .Q(slv_reg3[30]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg3_reg[31] 
       (.C(axi_aclk),
        .CE(\slv_reg3[31]_i_1_n_0 ),
        .D(s00_axi_wdata[31]),
        .Q(slv_reg3[31]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg3_reg[3] 
       (.C(axi_aclk),
        .CE(\slv_reg3[7]_i_1_n_0 ),
        .D(s00_axi_wdata[3]),
        .Q(slv_reg3[3]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg3_reg[4] 
       (.C(axi_aclk),
        .CE(\slv_reg3[7]_i_1_n_0 ),
        .D(s00_axi_wdata[4]),
        .Q(slv_reg3[4]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg3_reg[5] 
       (.C(axi_aclk),
        .CE(\slv_reg3[7]_i_1_n_0 ),
        .D(s00_axi_wdata[5]),
        .Q(slv_reg3[5]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg3_reg[6] 
       (.C(axi_aclk),
        .CE(\slv_reg3[7]_i_1_n_0 ),
        .D(s00_axi_wdata[6]),
        .Q(slv_reg3[6]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg3_reg[7] 
       (.C(axi_aclk),
        .CE(\slv_reg3[7]_i_1_n_0 ),
        .D(s00_axi_wdata[7]),
        .Q(slv_reg3[7]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg3_reg[8] 
       (.C(axi_aclk),
        .CE(\slv_reg3[15]_i_1_n_0 ),
        .D(s00_axi_wdata[8]),
        .Q(slv_reg3[8]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg3_reg[9] 
       (.C(axi_aclk),
        .CE(\slv_reg3[15]_i_1_n_0 ),
        .D(s00_axi_wdata[9]),
        .Q(slv_reg3[9]),
        .R(axi_awready_i_1_n_0));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT2 #(
    .INIT(4'h9)) 
    \v_cnt[0]_i_1 
       (.I0(\v_cnt[28]_i_2_n_0 ),
        .I1(m_axis_tdata[0]),
        .O(v_cnt[0]));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \v_cnt[10]_i_1 
       (.I0(m_axis_tdata[10]),
        .I1(\v_cnt[28]_i_2_n_0 ),
        .I2(plusOp[10]),
        .O(v_cnt[10]));
  LUT6 #(
    .INIT(64'hEEEEEEEA2222222A)) 
    \v_cnt[11]_i_1 
       (.I0(m_axis_tdata[11]),
        .I1(m_axis_tvalid),
        .I2(\v_cnt[31]_i_2_n_0 ),
        .I3(\v_cnt[31]_i_3_n_0 ),
        .I4(\v_cnt[31]_i_4_n_0 ),
        .I5(plusOp[11]),
        .O(v_cnt[11]));
  LUT6 #(
    .INIT(64'hEEEEEEEA2222222A)) 
    \v_cnt[12]_i_1 
       (.I0(m_axis_tdata[12]),
        .I1(m_axis_tvalid),
        .I2(\v_cnt[31]_i_2_n_0 ),
        .I3(\v_cnt[31]_i_3_n_0 ),
        .I4(\v_cnt[31]_i_4_n_0 ),
        .I5(plusOp[12]),
        .O(v_cnt[12]));
  LUT6 #(
    .INIT(64'hEEEEEEEA2222222A)) 
    \v_cnt[13]_i_1 
       (.I0(m_axis_tdata[13]),
        .I1(m_axis_tvalid),
        .I2(\v_cnt[31]_i_2_n_0 ),
        .I3(\v_cnt[31]_i_3_n_0 ),
        .I4(\v_cnt[31]_i_4_n_0 ),
        .I5(plusOp[13]),
        .O(v_cnt[13]));
  LUT3 #(
    .INIT(8'hB8)) 
    \v_cnt[14]_i_1 
       (.I0(m_axis_tdata[14]),
        .I1(\v_cnt[28]_i_2_n_0 ),
        .I2(plusOp[14]),
        .O(v_cnt[14]));
  LUT6 #(
    .INIT(64'hEEEEEEEA2222222A)) 
    \v_cnt[15]_i_1 
       (.I0(m_axis_tdata[15]),
        .I1(m_axis_tvalid),
        .I2(\v_cnt[31]_i_2_n_0 ),
        .I3(\v_cnt[31]_i_3_n_0 ),
        .I4(\v_cnt[31]_i_4_n_0 ),
        .I5(plusOp[15]),
        .O(v_cnt[15]));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \v_cnt[16]_i_1 
       (.I0(m_axis_tdata[16]),
        .I1(\v_cnt[28]_i_2_n_0 ),
        .I2(plusOp[16]),
        .O(v_cnt[16]));
  LUT6 #(
    .INIT(64'hEEEEEEEA2222222A)) 
    \v_cnt[17]_i_1 
       (.I0(m_axis_tdata[17]),
        .I1(m_axis_tvalid),
        .I2(\v_cnt[31]_i_2_n_0 ),
        .I3(\v_cnt[31]_i_3_n_0 ),
        .I4(\v_cnt[31]_i_4_n_0 ),
        .I5(plusOp[17]),
        .O(v_cnt[17]));
  LUT6 #(
    .INIT(64'hEEEEEEEA2222222A)) 
    \v_cnt[18]_i_1 
       (.I0(m_axis_tdata[18]),
        .I1(m_axis_tvalid),
        .I2(\v_cnt[31]_i_2_n_0 ),
        .I3(\v_cnt[31]_i_3_n_0 ),
        .I4(\v_cnt[31]_i_4_n_0 ),
        .I5(plusOp[18]),
        .O(v_cnt[18]));
  LUT6 #(
    .INIT(64'hEEEEEEEA2222222A)) 
    \v_cnt[19]_i_1 
       (.I0(m_axis_tdata[19]),
        .I1(m_axis_tvalid),
        .I2(\v_cnt[31]_i_2_n_0 ),
        .I3(\v_cnt[31]_i_3_n_0 ),
        .I4(\v_cnt[31]_i_4_n_0 ),
        .I5(plusOp[19]),
        .O(v_cnt[19]));
  LUT6 #(
    .INIT(64'hEEEEEEEA2222222A)) 
    \v_cnt[1]_i_1 
       (.I0(m_axis_tdata[1]),
        .I1(m_axis_tvalid),
        .I2(\v_cnt[31]_i_2_n_0 ),
        .I3(\v_cnt[31]_i_3_n_0 ),
        .I4(\v_cnt[31]_i_4_n_0 ),
        .I5(plusOp[1]),
        .O(v_cnt[1]));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \v_cnt[20]_i_1 
       (.I0(m_axis_tdata[20]),
        .I1(\v_cnt[28]_i_2_n_0 ),
        .I2(plusOp[20]),
        .O(v_cnt[20]));
  LUT6 #(
    .INIT(64'hEEEEEEEA2222222A)) 
    \v_cnt[21]_i_1 
       (.I0(m_axis_tdata[21]),
        .I1(m_axis_tvalid),
        .I2(\v_cnt[31]_i_2_n_0 ),
        .I3(\v_cnt[31]_i_3_n_0 ),
        .I4(\v_cnt[31]_i_4_n_0 ),
        .I5(plusOp[21]),
        .O(v_cnt[21]));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \v_cnt[22]_i_1 
       (.I0(m_axis_tdata[22]),
        .I1(\v_cnt[28]_i_2_n_0 ),
        .I2(plusOp[22]),
        .O(v_cnt[22]));
  LUT6 #(
    .INIT(64'hEEEEEEEA2222222A)) 
    \v_cnt[23]_i_1 
       (.I0(m_axis_tdata[23]),
        .I1(m_axis_tvalid),
        .I2(\v_cnt[31]_i_2_n_0 ),
        .I3(\v_cnt[31]_i_3_n_0 ),
        .I4(\v_cnt[31]_i_4_n_0 ),
        .I5(plusOp[23]),
        .O(v_cnt[23]));
  LUT6 #(
    .INIT(64'hEEEEEEEA2222222A)) 
    \v_cnt[24]_i_1 
       (.I0(m_axis_tdata[24]),
        .I1(m_axis_tvalid),
        .I2(\v_cnt[31]_i_2_n_0 ),
        .I3(\v_cnt[31]_i_3_n_0 ),
        .I4(\v_cnt[31]_i_4_n_0 ),
        .I5(plusOp[24]),
        .O(v_cnt[24]));
  LUT6 #(
    .INIT(64'hEEEEEEEA2222222A)) 
    \v_cnt[25]_i_1 
       (.I0(m_axis_tdata[25]),
        .I1(m_axis_tvalid),
        .I2(\v_cnt[31]_i_2_n_0 ),
        .I3(\v_cnt[31]_i_3_n_0 ),
        .I4(\v_cnt[31]_i_4_n_0 ),
        .I5(plusOp[25]),
        .O(v_cnt[25]));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \v_cnt[26]_i_1 
       (.I0(m_axis_tdata[26]),
        .I1(\v_cnt[28]_i_2_n_0 ),
        .I2(plusOp[26]),
        .O(v_cnt[26]));
  LUT6 #(
    .INIT(64'hEEEEEEEA2222222A)) 
    \v_cnt[27]_i_1 
       (.I0(m_axis_tdata[27]),
        .I1(m_axis_tvalid),
        .I2(\v_cnt[31]_i_2_n_0 ),
        .I3(\v_cnt[31]_i_3_n_0 ),
        .I4(\v_cnt[31]_i_4_n_0 ),
        .I5(plusOp[27]),
        .O(v_cnt[27]));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \v_cnt[28]_i_1 
       (.I0(m_axis_tdata[28]),
        .I1(\v_cnt[28]_i_2_n_0 ),
        .I2(plusOp[28]),
        .O(v_cnt[28]));
  LUT4 #(
    .INIT(16'h5557)) 
    \v_cnt[28]_i_2 
       (.I0(m_axis_tvalid),
        .I1(\v_cnt[31]_i_2_n_0 ),
        .I2(\v_cnt[31]_i_3_n_0 ),
        .I3(\v_cnt[31]_i_4_n_0 ),
        .O(\v_cnt[28]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hEEEEEEEA2222222A)) 
    \v_cnt[29]_i_1 
       (.I0(m_axis_tdata[29]),
        .I1(m_axis_tvalid),
        .I2(\v_cnt[31]_i_2_n_0 ),
        .I3(\v_cnt[31]_i_3_n_0 ),
        .I4(\v_cnt[31]_i_4_n_0 ),
        .I5(plusOp[29]),
        .O(v_cnt[29]));
  LUT6 #(
    .INIT(64'hEEEEEEEA2222222A)) 
    \v_cnt[2]_i_1 
       (.I0(m_axis_tdata[2]),
        .I1(m_axis_tvalid),
        .I2(\v_cnt[31]_i_2_n_0 ),
        .I3(\v_cnt[31]_i_3_n_0 ),
        .I4(\v_cnt[31]_i_4_n_0 ),
        .I5(plusOp[2]),
        .O(v_cnt[2]));
  LUT6 #(
    .INIT(64'hEEEEEEEA2222222A)) 
    \v_cnt[30]_i_1 
       (.I0(m_axis_tdata[30]),
        .I1(m_axis_tvalid),
        .I2(\v_cnt[31]_i_2_n_0 ),
        .I3(\v_cnt[31]_i_3_n_0 ),
        .I4(\v_cnt[31]_i_4_n_0 ),
        .I5(plusOp[30]),
        .O(v_cnt[30]));
  LUT6 #(
    .INIT(64'hEEEEEEEA2222222A)) 
    \v_cnt[31]_i_1 
       (.I0(m_axis_tdata[31]),
        .I1(m_axis_tvalid),
        .I2(\v_cnt[31]_i_2_n_0 ),
        .I3(\v_cnt[31]_i_3_n_0 ),
        .I4(\v_cnt[31]_i_4_n_0 ),
        .I5(plusOp[31]),
        .O(v_cnt[31]));
  LUT6 #(
    .INIT(64'h7FFFFFFFFFFFFFFF)) 
    \v_cnt[31]_i_10 
       (.I0(m_axis_tdata[31]),
        .I1(m_axis_tdata[30]),
        .I2(m_axis_tdata[24]),
        .I3(m_axis_tdata[25]),
        .I4(m_axis_tdata[23]),
        .I5(m_axis_tdata[22]),
        .O(\v_cnt[31]_i_10_n_0 ));
  LUT4 #(
    .INIT(16'h7FFF)) 
    \v_cnt[31]_i_2 
       (.I0(m_axis_tdata[17]),
        .I1(m_axis_tdata[16]),
        .I2(m_axis_tdata[27]),
        .I3(m_axis_tdata[26]),
        .O(\v_cnt[31]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h7FFFFFFFFFFFFFFF)) 
    \v_cnt[31]_i_3 
       (.I0(m_axis_tdata[29]),
        .I1(m_axis_tdata[28]),
        .I2(\v_cnt[31]_i_6_n_0 ),
        .I3(\v_cnt[31]_i_7_n_0 ),
        .I4(\v_cnt[31]_i_8_n_0 ),
        .I5(\v_cnt[31]_i_9_n_0 ),
        .O(\v_cnt[31]_i_3_n_0 ));
  LUT5 #(
    .INIT(32'hBFFFFFFF)) 
    \v_cnt[31]_i_4 
       (.I0(\v_cnt[31]_i_10_n_0 ),
        .I1(m_axis_tdata[18]),
        .I2(m_axis_tdata[19]),
        .I3(m_axis_tdata[20]),
        .I4(m_axis_tdata[21]),
        .O(\v_cnt[31]_i_4_n_0 ));
  LUT4 #(
    .INIT(16'h8000)) 
    \v_cnt[31]_i_6 
       (.I0(m_axis_tdata[15]),
        .I1(m_axis_tdata[14]),
        .I2(m_axis_tdata[13]),
        .I3(m_axis_tdata[12]),
        .O(\v_cnt[31]_i_6_n_0 ));
  LUT4 #(
    .INIT(16'h8000)) 
    \v_cnt[31]_i_7 
       (.I0(m_axis_tdata[11]),
        .I1(m_axis_tdata[10]),
        .I2(m_axis_tdata[9]),
        .I3(m_axis_tdata[8]),
        .O(\v_cnt[31]_i_7_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT4 #(
    .INIT(16'h8000)) 
    \v_cnt[31]_i_8 
       (.I0(m_axis_tdata[1]),
        .I1(m_axis_tdata[0]),
        .I2(m_axis_tdata[3]),
        .I3(m_axis_tdata[2]),
        .O(\v_cnt[31]_i_8_n_0 ));
  LUT4 #(
    .INIT(16'h8000)) 
    \v_cnt[31]_i_9 
       (.I0(m_axis_tdata[7]),
        .I1(m_axis_tdata[6]),
        .I2(m_axis_tdata[5]),
        .I3(m_axis_tdata[4]),
        .O(\v_cnt[31]_i_9_n_0 ));
  LUT6 #(
    .INIT(64'hEEEEEEEA2222222A)) 
    \v_cnt[3]_i_1 
       (.I0(m_axis_tdata[3]),
        .I1(m_axis_tvalid),
        .I2(\v_cnt[31]_i_2_n_0 ),
        .I3(\v_cnt[31]_i_3_n_0 ),
        .I4(\v_cnt[31]_i_4_n_0 ),
        .I5(plusOp[3]),
        .O(v_cnt[3]));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \v_cnt[4]_i_1 
       (.I0(m_axis_tdata[4]),
        .I1(\v_cnt[28]_i_2_n_0 ),
        .I2(plusOp[4]),
        .O(v_cnt[4]));
  LUT6 #(
    .INIT(64'hEEEEEEEA2222222A)) 
    \v_cnt[5]_i_1 
       (.I0(m_axis_tdata[5]),
        .I1(m_axis_tvalid),
        .I2(\v_cnt[31]_i_2_n_0 ),
        .I3(\v_cnt[31]_i_3_n_0 ),
        .I4(\v_cnt[31]_i_4_n_0 ),
        .I5(plusOp[5]),
        .O(v_cnt[5]));
  LUT6 #(
    .INIT(64'hEEEEEEEA2222222A)) 
    \v_cnt[6]_i_1 
       (.I0(m_axis_tdata[6]),
        .I1(m_axis_tvalid),
        .I2(\v_cnt[31]_i_2_n_0 ),
        .I3(\v_cnt[31]_i_3_n_0 ),
        .I4(\v_cnt[31]_i_4_n_0 ),
        .I5(plusOp[6]),
        .O(v_cnt[6]));
  LUT6 #(
    .INIT(64'hEEEEEEEA2222222A)) 
    \v_cnt[7]_i_1 
       (.I0(m_axis_tdata[7]),
        .I1(m_axis_tvalid),
        .I2(\v_cnt[31]_i_2_n_0 ),
        .I3(\v_cnt[31]_i_3_n_0 ),
        .I4(\v_cnt[31]_i_4_n_0 ),
        .I5(plusOp[7]),
        .O(v_cnt[7]));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \v_cnt[8]_i_1 
       (.I0(m_axis_tdata[8]),
        .I1(\v_cnt[28]_i_2_n_0 ),
        .I2(plusOp[8]),
        .O(v_cnt[8]));
  LUT6 #(
    .INIT(64'hEEEEEEEA2222222A)) 
    \v_cnt[9]_i_1 
       (.I0(m_axis_tdata[9]),
        .I1(m_axis_tvalid),
        .I2(\v_cnt[31]_i_2_n_0 ),
        .I3(\v_cnt[31]_i_3_n_0 ),
        .I4(\v_cnt[31]_i_4_n_0 ),
        .I5(plusOp[9]),
        .O(v_cnt[9]));
  FDRE #(
    .INIT(1'b0)) 
    \v_cnt_reg[0] 
       (.C(axi_aclk),
        .CE(1'b1),
        .D(v_cnt[0]),
        .Q(m_axis_tdata[0]),
        .R(s_M_AXIS_TVALID_int_i_1_n_0));
  FDRE #(
    .INIT(1'b0)) 
    \v_cnt_reg[10] 
       (.C(axi_aclk),
        .CE(1'b1),
        .D(v_cnt[10]),
        .Q(m_axis_tdata[10]),
        .R(s_M_AXIS_TVALID_int_i_1_n_0));
  FDRE #(
    .INIT(1'b0)) 
    \v_cnt_reg[11] 
       (.C(axi_aclk),
        .CE(1'b1),
        .D(v_cnt[11]),
        .Q(m_axis_tdata[11]),
        .R(s_M_AXIS_TVALID_int_i_1_n_0));
  FDRE #(
    .INIT(1'b0)) 
    \v_cnt_reg[12] 
       (.C(axi_aclk),
        .CE(1'b1),
        .D(v_cnt[12]),
        .Q(m_axis_tdata[12]),
        .R(s_M_AXIS_TVALID_int_i_1_n_0));
  FDRE #(
    .INIT(1'b0)) 
    \v_cnt_reg[13] 
       (.C(axi_aclk),
        .CE(1'b1),
        .D(v_cnt[13]),
        .Q(m_axis_tdata[13]),
        .R(s_M_AXIS_TVALID_int_i_1_n_0));
  FDRE #(
    .INIT(1'b0)) 
    \v_cnt_reg[14] 
       (.C(axi_aclk),
        .CE(1'b1),
        .D(v_cnt[14]),
        .Q(m_axis_tdata[14]),
        .R(s_M_AXIS_TVALID_int_i_1_n_0));
  FDRE #(
    .INIT(1'b0)) 
    \v_cnt_reg[15] 
       (.C(axi_aclk),
        .CE(1'b1),
        .D(v_cnt[15]),
        .Q(m_axis_tdata[15]),
        .R(s_M_AXIS_TVALID_int_i_1_n_0));
  FDRE #(
    .INIT(1'b0)) 
    \v_cnt_reg[16] 
       (.C(axi_aclk),
        .CE(1'b1),
        .D(v_cnt[16]),
        .Q(m_axis_tdata[16]),
        .R(s_M_AXIS_TVALID_int_i_1_n_0));
  CARRY8 \v_cnt_reg[16]_i_2 
       (.CI(\v_cnt_reg[8]_i_2_n_0 ),
        .CI_TOP(1'b0),
        .CO({\v_cnt_reg[16]_i_2_n_0 ,\v_cnt_reg[16]_i_2_n_1 ,\v_cnt_reg[16]_i_2_n_2 ,\v_cnt_reg[16]_i_2_n_3 ,\NLW_v_cnt_reg[16]_i_2_CO_UNCONNECTED [3],\v_cnt_reg[16]_i_2_n_5 ,\v_cnt_reg[16]_i_2_n_6 ,\v_cnt_reg[16]_i_2_n_7 }),
        .DI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .O(plusOp[16:9]),
        .S(m_axis_tdata[16:9]));
  FDRE #(
    .INIT(1'b0)) 
    \v_cnt_reg[17] 
       (.C(axi_aclk),
        .CE(1'b1),
        .D(v_cnt[17]),
        .Q(m_axis_tdata[17]),
        .R(s_M_AXIS_TVALID_int_i_1_n_0));
  FDRE #(
    .INIT(1'b0)) 
    \v_cnt_reg[18] 
       (.C(axi_aclk),
        .CE(1'b1),
        .D(v_cnt[18]),
        .Q(m_axis_tdata[18]),
        .R(s_M_AXIS_TVALID_int_i_1_n_0));
  FDRE #(
    .INIT(1'b0)) 
    \v_cnt_reg[19] 
       (.C(axi_aclk),
        .CE(1'b1),
        .D(v_cnt[19]),
        .Q(m_axis_tdata[19]),
        .R(s_M_AXIS_TVALID_int_i_1_n_0));
  FDRE #(
    .INIT(1'b0)) 
    \v_cnt_reg[1] 
       (.C(axi_aclk),
        .CE(1'b1),
        .D(v_cnt[1]),
        .Q(m_axis_tdata[1]),
        .R(s_M_AXIS_TVALID_int_i_1_n_0));
  FDRE #(
    .INIT(1'b0)) 
    \v_cnt_reg[20] 
       (.C(axi_aclk),
        .CE(1'b1),
        .D(v_cnt[20]),
        .Q(m_axis_tdata[20]),
        .R(s_M_AXIS_TVALID_int_i_1_n_0));
  FDRE #(
    .INIT(1'b0)) 
    \v_cnt_reg[21] 
       (.C(axi_aclk),
        .CE(1'b1),
        .D(v_cnt[21]),
        .Q(m_axis_tdata[21]),
        .R(s_M_AXIS_TVALID_int_i_1_n_0));
  FDRE #(
    .INIT(1'b0)) 
    \v_cnt_reg[22] 
       (.C(axi_aclk),
        .CE(1'b1),
        .D(v_cnt[22]),
        .Q(m_axis_tdata[22]),
        .R(s_M_AXIS_TVALID_int_i_1_n_0));
  FDRE #(
    .INIT(1'b0)) 
    \v_cnt_reg[23] 
       (.C(axi_aclk),
        .CE(1'b1),
        .D(v_cnt[23]),
        .Q(m_axis_tdata[23]),
        .R(s_M_AXIS_TVALID_int_i_1_n_0));
  FDRE #(
    .INIT(1'b0)) 
    \v_cnt_reg[24] 
       (.C(axi_aclk),
        .CE(1'b1),
        .D(v_cnt[24]),
        .Q(m_axis_tdata[24]),
        .R(s_M_AXIS_TVALID_int_i_1_n_0));
  CARRY8 \v_cnt_reg[24]_i_2 
       (.CI(\v_cnt_reg[16]_i_2_n_0 ),
        .CI_TOP(1'b0),
        .CO({\v_cnt_reg[24]_i_2_n_0 ,\v_cnt_reg[24]_i_2_n_1 ,\v_cnt_reg[24]_i_2_n_2 ,\v_cnt_reg[24]_i_2_n_3 ,\NLW_v_cnt_reg[24]_i_2_CO_UNCONNECTED [3],\v_cnt_reg[24]_i_2_n_5 ,\v_cnt_reg[24]_i_2_n_6 ,\v_cnt_reg[24]_i_2_n_7 }),
        .DI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .O(plusOp[24:17]),
        .S(m_axis_tdata[24:17]));
  FDRE #(
    .INIT(1'b0)) 
    \v_cnt_reg[25] 
       (.C(axi_aclk),
        .CE(1'b1),
        .D(v_cnt[25]),
        .Q(m_axis_tdata[25]),
        .R(s_M_AXIS_TVALID_int_i_1_n_0));
  FDRE #(
    .INIT(1'b0)) 
    \v_cnt_reg[26] 
       (.C(axi_aclk),
        .CE(1'b1),
        .D(v_cnt[26]),
        .Q(m_axis_tdata[26]),
        .R(s_M_AXIS_TVALID_int_i_1_n_0));
  FDRE #(
    .INIT(1'b0)) 
    \v_cnt_reg[27] 
       (.C(axi_aclk),
        .CE(1'b1),
        .D(v_cnt[27]),
        .Q(m_axis_tdata[27]),
        .R(s_M_AXIS_TVALID_int_i_1_n_0));
  FDRE #(
    .INIT(1'b0)) 
    \v_cnt_reg[28] 
       (.C(axi_aclk),
        .CE(1'b1),
        .D(v_cnt[28]),
        .Q(m_axis_tdata[28]),
        .R(s_M_AXIS_TVALID_int_i_1_n_0));
  FDRE #(
    .INIT(1'b0)) 
    \v_cnt_reg[29] 
       (.C(axi_aclk),
        .CE(1'b1),
        .D(v_cnt[29]),
        .Q(m_axis_tdata[29]),
        .R(s_M_AXIS_TVALID_int_i_1_n_0));
  FDRE #(
    .INIT(1'b0)) 
    \v_cnt_reg[2] 
       (.C(axi_aclk),
        .CE(1'b1),
        .D(v_cnt[2]),
        .Q(m_axis_tdata[2]),
        .R(s_M_AXIS_TVALID_int_i_1_n_0));
  FDRE #(
    .INIT(1'b0)) 
    \v_cnt_reg[30] 
       (.C(axi_aclk),
        .CE(1'b1),
        .D(v_cnt[30]),
        .Q(m_axis_tdata[30]),
        .R(s_M_AXIS_TVALID_int_i_1_n_0));
  FDRE #(
    .INIT(1'b0)) 
    \v_cnt_reg[31] 
       (.C(axi_aclk),
        .CE(1'b1),
        .D(v_cnt[31]),
        .Q(m_axis_tdata[31]),
        .R(s_M_AXIS_TVALID_int_i_1_n_0));
  CARRY8 \v_cnt_reg[31]_i_5 
       (.CI(\v_cnt_reg[24]_i_2_n_0 ),
        .CI_TOP(1'b0),
        .CO({\NLW_v_cnt_reg[31]_i_5_CO_UNCONNECTED [7:6],\v_cnt_reg[31]_i_5_n_2 ,\v_cnt_reg[31]_i_5_n_3 ,\NLW_v_cnt_reg[31]_i_5_CO_UNCONNECTED [3],\v_cnt_reg[31]_i_5_n_5 ,\v_cnt_reg[31]_i_5_n_6 ,\v_cnt_reg[31]_i_5_n_7 }),
        .DI({\NLW_v_cnt_reg[31]_i_5_DI_UNCONNECTED [7],1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .O({\NLW_v_cnt_reg[31]_i_5_O_UNCONNECTED [7],plusOp[31:25]}),
        .S({\NLW_v_cnt_reg[31]_i_5_S_UNCONNECTED [7],m_axis_tdata[31:25]}));
  FDRE #(
    .INIT(1'b0)) 
    \v_cnt_reg[3] 
       (.C(axi_aclk),
        .CE(1'b1),
        .D(v_cnt[3]),
        .Q(m_axis_tdata[3]),
        .R(s_M_AXIS_TVALID_int_i_1_n_0));
  FDRE #(
    .INIT(1'b0)) 
    \v_cnt_reg[4] 
       (.C(axi_aclk),
        .CE(1'b1),
        .D(v_cnt[4]),
        .Q(m_axis_tdata[4]),
        .R(s_M_AXIS_TVALID_int_i_1_n_0));
  FDRE #(
    .INIT(1'b0)) 
    \v_cnt_reg[5] 
       (.C(axi_aclk),
        .CE(1'b1),
        .D(v_cnt[5]),
        .Q(m_axis_tdata[5]),
        .R(s_M_AXIS_TVALID_int_i_1_n_0));
  FDRE #(
    .INIT(1'b0)) 
    \v_cnt_reg[6] 
       (.C(axi_aclk),
        .CE(1'b1),
        .D(v_cnt[6]),
        .Q(m_axis_tdata[6]),
        .R(s_M_AXIS_TVALID_int_i_1_n_0));
  FDRE #(
    .INIT(1'b0)) 
    \v_cnt_reg[7] 
       (.C(axi_aclk),
        .CE(1'b1),
        .D(v_cnt[7]),
        .Q(m_axis_tdata[7]),
        .R(s_M_AXIS_TVALID_int_i_1_n_0));
  FDRE #(
    .INIT(1'b0)) 
    \v_cnt_reg[8] 
       (.C(axi_aclk),
        .CE(1'b1),
        .D(v_cnt[8]),
        .Q(m_axis_tdata[8]),
        .R(s_M_AXIS_TVALID_int_i_1_n_0));
  CARRY8 \v_cnt_reg[8]_i_2 
       (.CI(m_axis_tdata[0]),
        .CI_TOP(1'b0),
        .CO({\v_cnt_reg[8]_i_2_n_0 ,\v_cnt_reg[8]_i_2_n_1 ,\v_cnt_reg[8]_i_2_n_2 ,\v_cnt_reg[8]_i_2_n_3 ,\NLW_v_cnt_reg[8]_i_2_CO_UNCONNECTED [3],\v_cnt_reg[8]_i_2_n_5 ,\v_cnt_reg[8]_i_2_n_6 ,\v_cnt_reg[8]_i_2_n_7 }),
        .DI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .O(plusOp[8:1]),
        .S(m_axis_tdata[8:1]));
  FDRE #(
    .INIT(1'b0)) 
    \v_cnt_reg[9] 
       (.C(axi_aclk),
        .CE(1'b1),
        .D(v_cnt[9]),
        .Q(m_axis_tdata[9]),
        .R(s_M_AXIS_TVALID_int_i_1_n_0));
endmodule
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

endmodule
`endif
