-- (c) Copyright 1995-2020 Xilinx, Inc. All rights reserved.
-- 
-- This file contains confidential and proprietary information
-- of Xilinx, Inc. and is protected under U.S. and
-- international copyright and other intellectual property
-- laws.
-- 
-- DISCLAIMER
-- This disclaimer is not a license and does not grant any
-- rights to the materials distributed herewith. Except as
-- otherwise provided in a valid license issued to you by
-- Xilinx, and to the maximum extent permitted by applicable
-- law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
-- WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
-- AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
-- BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
-- INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
-- (2) Xilinx shall not be liable (whether in contract or tort,
-- including negligence, or under any other theory of
-- liability) for any loss or damage of any kind or nature
-- related to, arising under or in connection with these
-- materials, including for any direct, or any indirect,
-- special, incidental, or consequential loss or damage
-- (including loss of data, profits, goodwill, or any type of
-- loss or damage suffered as a result of any action brought
-- by a third party) even if such damage or loss was
-- reasonably foreseeable or Xilinx had been advised of the
-- possibility of the same.
-- 
-- CRITICAL APPLICATIONS
-- Xilinx products are not designed or intended to be fail-
-- safe, or for use in any application requiring fail-safe
-- performance, such as life-support or safety devices or
-- systems, Class III medical devices, nuclear facilities,
-- applications related to the deployment of airbags, or any
-- other applications that could lead to death, personal
-- injury, or severe property or environmental damage
-- (individually and collectively, "Critical
-- Applications"). Customer assumes the sole risk and
-- liability of any use of Xilinx products in Critical
-- Applications, subject only to applicable laws and
-- regulations governing limitations on product liability.
-- 
-- THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
-- PART OF THIS FILE AT ALL TIMES.
-- 
-- DO NOT MODIFY THIS FILE.

-- IP VLNV: xilinx.com:ip:system_ila:1.1
-- IP Revision: 1

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY zusys_system_ila_0_2 IS
  PORT (
    clk : IN STD_LOGIC;
    SLOT_0_AXIS_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    SLOT_0_AXIS_tkeep : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    SLOT_0_AXIS_tlast : IN STD_LOGIC;
    SLOT_0_AXIS_tvalid : IN STD_LOGIC;
    SLOT_0_AXIS_tready : IN STD_LOGIC;
    SLOT_1_AXI_awaddr : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    SLOT_1_AXI_awlen : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    SLOT_1_AXI_awsize : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    SLOT_1_AXI_awvalid : IN STD_LOGIC;
    SLOT_1_AXI_awready : IN STD_LOGIC;
    SLOT_1_AXI_wdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    SLOT_1_AXI_wstrb : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    SLOT_1_AXI_wlast : IN STD_LOGIC;
    SLOT_1_AXI_wvalid : IN STD_LOGIC;
    SLOT_1_AXI_wready : IN STD_LOGIC;
    SLOT_1_AXI_bresp : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
    SLOT_1_AXI_bvalid : IN STD_LOGIC;
    SLOT_1_AXI_bready : IN STD_LOGIC;
    SLOT_1_AXI_araddr : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    SLOT_1_AXI_arlen : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    SLOT_1_AXI_arsize : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    SLOT_1_AXI_arvalid : IN STD_LOGIC;
    SLOT_1_AXI_arready : IN STD_LOGIC;
    SLOT_1_AXI_rdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    SLOT_1_AXI_rlast : IN STD_LOGIC;
    SLOT_1_AXI_rvalid : IN STD_LOGIC;
    SLOT_1_AXI_rready : IN STD_LOGIC;
    resetn : IN STD_LOGIC
  );
END zusys_system_ila_0_2;

ARCHITECTURE zusys_system_ila_0_2_arch OF zusys_system_ila_0_2 IS
  ATTRIBUTE DowngradeIPIdentifiedWarnings : STRING;
  ATTRIBUTE DowngradeIPIdentifiedWarnings OF zusys_system_ila_0_2_arch: ARCHITECTURE IS "yes";
  COMPONENT bd_b04d IS
    PORT (
      clk : IN STD_LOGIC;
      SLOT_0_AXIS_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      SLOT_0_AXIS_tkeep : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      SLOT_0_AXIS_tlast : IN STD_LOGIC;
      SLOT_0_AXIS_tvalid : IN STD_LOGIC;
      SLOT_0_AXIS_tready : IN STD_LOGIC;
      SLOT_1_AXI_awaddr : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      SLOT_1_AXI_awlen : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
      SLOT_1_AXI_awsize : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
      SLOT_1_AXI_awvalid : IN STD_LOGIC;
      SLOT_1_AXI_awready : IN STD_LOGIC;
      SLOT_1_AXI_wdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      SLOT_1_AXI_wstrb : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      SLOT_1_AXI_wlast : IN STD_LOGIC;
      SLOT_1_AXI_wvalid : IN STD_LOGIC;
      SLOT_1_AXI_wready : IN STD_LOGIC;
      SLOT_1_AXI_bresp : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
      SLOT_1_AXI_bvalid : IN STD_LOGIC;
      SLOT_1_AXI_bready : IN STD_LOGIC;
      SLOT_1_AXI_araddr : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      SLOT_1_AXI_arlen : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
      SLOT_1_AXI_arsize : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
      SLOT_1_AXI_arvalid : IN STD_LOGIC;
      SLOT_1_AXI_arready : IN STD_LOGIC;
      SLOT_1_AXI_rdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      SLOT_1_AXI_rlast : IN STD_LOGIC;
      SLOT_1_AXI_rvalid : IN STD_LOGIC;
      SLOT_1_AXI_rready : IN STD_LOGIC;
      resetn : IN STD_LOGIC
    );
  END COMPONENT bd_b04d;
  ATTRIBUTE X_INTERFACE_INFO : STRING;
  ATTRIBUTE X_INTERFACE_PARAMETER : STRING;
  ATTRIBUTE X_INTERFACE_PARAMETER OF resetn: SIGNAL IS "XIL_INTERFACENAME RST.resetn, POLARITY ACTIVE_LOW";
  ATTRIBUTE X_INTERFACE_INFO OF resetn: SIGNAL IS "xilinx.com:signal:reset:1.0 RST.resetn RST";
  ATTRIBUTE X_INTERFACE_INFO OF SLOT_1_AXI_rready: SIGNAL IS "xilinx.com:interface:aximm:1.0 SLOT_1_AXI RREADY";
  ATTRIBUTE X_INTERFACE_INFO OF SLOT_1_AXI_rvalid: SIGNAL IS "xilinx.com:interface:aximm:1.0 SLOT_1_AXI RVALID";
  ATTRIBUTE X_INTERFACE_INFO OF SLOT_1_AXI_rlast: SIGNAL IS "xilinx.com:interface:aximm:1.0 SLOT_1_AXI RLAST";
  ATTRIBUTE X_INTERFACE_INFO OF SLOT_1_AXI_rdata: SIGNAL IS "xilinx.com:interface:aximm:1.0 SLOT_1_AXI RDATA";
  ATTRIBUTE X_INTERFACE_INFO OF SLOT_1_AXI_arready: SIGNAL IS "xilinx.com:interface:aximm:1.0 SLOT_1_AXI ARREADY";
  ATTRIBUTE X_INTERFACE_INFO OF SLOT_1_AXI_arvalid: SIGNAL IS "xilinx.com:interface:aximm:1.0 SLOT_1_AXI ARVALID";
  ATTRIBUTE X_INTERFACE_INFO OF SLOT_1_AXI_arsize: SIGNAL IS "xilinx.com:interface:aximm:1.0 SLOT_1_AXI ARSIZE";
  ATTRIBUTE X_INTERFACE_INFO OF SLOT_1_AXI_arlen: SIGNAL IS "xilinx.com:interface:aximm:1.0 SLOT_1_AXI ARLEN";
  ATTRIBUTE X_INTERFACE_INFO OF SLOT_1_AXI_araddr: SIGNAL IS "xilinx.com:interface:aximm:1.0 SLOT_1_AXI ARADDR";
  ATTRIBUTE X_INTERFACE_INFO OF SLOT_1_AXI_bready: SIGNAL IS "xilinx.com:interface:aximm:1.0 SLOT_1_AXI BREADY";
  ATTRIBUTE X_INTERFACE_INFO OF SLOT_1_AXI_bvalid: SIGNAL IS "xilinx.com:interface:aximm:1.0 SLOT_1_AXI BVALID";
  ATTRIBUTE X_INTERFACE_INFO OF SLOT_1_AXI_bresp: SIGNAL IS "xilinx.com:interface:aximm:1.0 SLOT_1_AXI BRESP";
  ATTRIBUTE X_INTERFACE_INFO OF SLOT_1_AXI_wready: SIGNAL IS "xilinx.com:interface:aximm:1.0 SLOT_1_AXI WREADY";
  ATTRIBUTE X_INTERFACE_INFO OF SLOT_1_AXI_wvalid: SIGNAL IS "xilinx.com:interface:aximm:1.0 SLOT_1_AXI WVALID";
  ATTRIBUTE X_INTERFACE_INFO OF SLOT_1_AXI_wlast: SIGNAL IS "xilinx.com:interface:aximm:1.0 SLOT_1_AXI WLAST";
  ATTRIBUTE X_INTERFACE_INFO OF SLOT_1_AXI_wstrb: SIGNAL IS "xilinx.com:interface:aximm:1.0 SLOT_1_AXI WSTRB";
  ATTRIBUTE X_INTERFACE_INFO OF SLOT_1_AXI_wdata: SIGNAL IS "xilinx.com:interface:aximm:1.0 SLOT_1_AXI WDATA";
  ATTRIBUTE X_INTERFACE_INFO OF SLOT_1_AXI_awready: SIGNAL IS "xilinx.com:interface:aximm:1.0 SLOT_1_AXI AWREADY";
  ATTRIBUTE X_INTERFACE_INFO OF SLOT_1_AXI_awvalid: SIGNAL IS "xilinx.com:interface:aximm:1.0 SLOT_1_AXI AWVALID";
  ATTRIBUTE X_INTERFACE_INFO OF SLOT_1_AXI_awsize: SIGNAL IS "xilinx.com:interface:aximm:1.0 SLOT_1_AXI AWSIZE";
  ATTRIBUTE X_INTERFACE_INFO OF SLOT_1_AXI_awlen: SIGNAL IS "xilinx.com:interface:aximm:1.0 SLOT_1_AXI AWLEN";
  ATTRIBUTE X_INTERFACE_PARAMETER OF SLOT_1_AXI_awaddr: SIGNAL IS "XIL_INTERFACENAME SLOT_1_AXI, DATA_WIDTH 32, PROTOCOL AXI4, FREQ_HZ 100000000, ID_WIDTH 0, ADDR_WIDTH 32, AWUSER_WIDTH 0, ARUSER_WIDTH 0, WUSER_WIDTH 0, RUSER_WIDTH 0, BUSER_WIDTH 0, READ_WRITE_MODE WRITE_ONLY, HAS_BURST 0, HAS_LOCK 0, HAS_PROT 0, HAS_CACHE 0, HAS_QOS 0, HAS_REGION 0, HAS_WSTRB 1, HAS_BRESP 1, HAS_RRESP 0, SUPPORTS_NARROW_BURST 0, NUM_READ_OUTSTANDING 2, NUM_WRITE_OUTSTANDING 2, MAX_BURST_LENGTH 256, PHASE 0.000, CLK_DOMAIN zusys_zynq_ultra_ps_e_0_0_pl_clk0, NUM_READ_THREADS 1, NUM_WRITE_THREADS 1, RUSER_BITS_PER_BYTE 0, WUSER_BITS_PER_BYTE 0";
  ATTRIBUTE X_INTERFACE_INFO OF SLOT_1_AXI_awaddr: SIGNAL IS "xilinx.com:interface:aximm:1.0 SLOT_1_AXI AWADDR";
  ATTRIBUTE X_INTERFACE_INFO OF SLOT_0_AXIS_tready: SIGNAL IS "xilinx.com:interface:axis:1.0 SLOT_0_AXIS TREADY";
  ATTRIBUTE X_INTERFACE_INFO OF SLOT_0_AXIS_tvalid: SIGNAL IS "xilinx.com:interface:axis:1.0 SLOT_0_AXIS TVALID";
  ATTRIBUTE X_INTERFACE_INFO OF SLOT_0_AXIS_tlast: SIGNAL IS "xilinx.com:interface:axis:1.0 SLOT_0_AXIS TLAST";
  ATTRIBUTE X_INTERFACE_INFO OF SLOT_0_AXIS_tkeep: SIGNAL IS "xilinx.com:interface:axis:1.0 SLOT_0_AXIS TKEEP";
  ATTRIBUTE X_INTERFACE_PARAMETER OF SLOT_0_AXIS_tdata: SIGNAL IS "XIL_INTERFACENAME SLOT_0_AXIS, TDATA_NUM_BYTES 4, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0, HAS_TREADY 1, HAS_TSTRB 0, HAS_TKEEP 1, HAS_TLAST 1, FREQ_HZ 100000000, PHASE 0.000, CLK_DOMAIN zusys_zynq_ultra_ps_e_0_0_pl_clk0, LAYERED_METADATA undef";
  ATTRIBUTE X_INTERFACE_INFO OF SLOT_0_AXIS_tdata: SIGNAL IS "xilinx.com:interface:axis:1.0 SLOT_0_AXIS TDATA";
  ATTRIBUTE X_INTERFACE_PARAMETER OF clk: SIGNAL IS "XIL_INTERFACENAME CLK.clk, FREQ_HZ 100000000, PHASE 0.000, CLK_DOMAIN zusys_zynq_ultra_ps_e_0_0_pl_clk0, ASSOCIATED_BUSIF SLOT_0_AXIS:SLOT_1_AXI, ASSOCIATED_RESET resetn";
  ATTRIBUTE X_INTERFACE_INFO OF clk: SIGNAL IS "xilinx.com:signal:clock:1.0 CLK.clk CLK";
BEGIN
  U0 : bd_b04d
    PORT MAP (
      clk => clk,
      SLOT_0_AXIS_tdata => SLOT_0_AXIS_tdata,
      SLOT_0_AXIS_tkeep => SLOT_0_AXIS_tkeep,
      SLOT_0_AXIS_tlast => SLOT_0_AXIS_tlast,
      SLOT_0_AXIS_tvalid => SLOT_0_AXIS_tvalid,
      SLOT_0_AXIS_tready => SLOT_0_AXIS_tready,
      SLOT_1_AXI_awaddr => SLOT_1_AXI_awaddr,
      SLOT_1_AXI_awlen => SLOT_1_AXI_awlen,
      SLOT_1_AXI_awsize => SLOT_1_AXI_awsize,
      SLOT_1_AXI_awvalid => SLOT_1_AXI_awvalid,
      SLOT_1_AXI_awready => SLOT_1_AXI_awready,
      SLOT_1_AXI_wdata => SLOT_1_AXI_wdata,
      SLOT_1_AXI_wstrb => SLOT_1_AXI_wstrb,
      SLOT_1_AXI_wlast => SLOT_1_AXI_wlast,
      SLOT_1_AXI_wvalid => SLOT_1_AXI_wvalid,
      SLOT_1_AXI_wready => SLOT_1_AXI_wready,
      SLOT_1_AXI_bresp => SLOT_1_AXI_bresp,
      SLOT_1_AXI_bvalid => SLOT_1_AXI_bvalid,
      SLOT_1_AXI_bready => SLOT_1_AXI_bready,
      SLOT_1_AXI_araddr => SLOT_1_AXI_araddr,
      SLOT_1_AXI_arlen => SLOT_1_AXI_arlen,
      SLOT_1_AXI_arsize => SLOT_1_AXI_arsize,
      SLOT_1_AXI_arvalid => SLOT_1_AXI_arvalid,
      SLOT_1_AXI_arready => SLOT_1_AXI_arready,
      SLOT_1_AXI_rdata => SLOT_1_AXI_rdata,
      SLOT_1_AXI_rlast => SLOT_1_AXI_rlast,
      SLOT_1_AXI_rvalid => SLOT_1_AXI_rvalid,
      SLOT_1_AXI_rready => SLOT_1_AXI_rready,
      resetn => resetn
    );
END zusys_system_ila_0_2_arch;
