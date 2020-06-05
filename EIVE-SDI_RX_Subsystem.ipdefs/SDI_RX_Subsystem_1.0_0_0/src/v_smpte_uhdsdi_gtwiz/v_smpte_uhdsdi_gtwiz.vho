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

-- IP VLNV: xilinx.com:ip:gtwizard_ultrascale:1.7
-- IP Revision: 2

-- The following code must appear in the VHDL architecture header.

------------- Begin Cut here for COMPONENT Declaration ------ COMP_TAG
COMPONENT v_smpte_uhdsdi_gtwiz
  PORT (
    gtwiz_userclk_tx_reset_in : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    gtwiz_userclk_tx_srcclk_out : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    gtwiz_userclk_tx_usrclk_out : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    gtwiz_userclk_tx_usrclk2_out : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    gtwiz_userclk_tx_active_out : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    gtwiz_userclk_rx_reset_in : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    gtwiz_userclk_rx_srcclk_out : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    gtwiz_userclk_rx_usrclk_out : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    gtwiz_userclk_rx_usrclk2_out : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    gtwiz_userclk_rx_active_out : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    gtwiz_reset_clk_freerun_in : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    gtwiz_reset_all_in : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    gtwiz_reset_tx_pll_and_datapath_in : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    gtwiz_reset_tx_datapath_in : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    gtwiz_reset_rx_pll_and_datapath_in : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    gtwiz_reset_rx_datapath_in : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    gtwiz_reset_rx_cdr_stable_out : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    gtwiz_reset_tx_done_out : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    gtwiz_reset_rx_done_out : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    gtwiz_userdata_tx_in : IN STD_LOGIC_VECTOR(19 DOWNTO 0);
    gtwiz_userdata_rx_out : OUT STD_LOGIC_VECTOR(19 DOWNTO 0);
    drpaddr_in : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
    drpclk_in : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    drpdi_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    drpen_in : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    drpwe_in : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    gthrxn_in : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    gthrxp_in : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    gtrefclk0_in : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    rxcdrhold_in : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    rxdfeagcovrden_in : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    rxdfelfovrden_in : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    rxdfetap10ovrden_in : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    rxdfetap11ovrden_in : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    rxdfetap12ovrden_in : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    rxdfetap13ovrden_in : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    rxdfetap14ovrden_in : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    rxdfetap15ovrden_in : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    rxdfetap2ovrden_in : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    rxdfetap3ovrden_in : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    rxdfetap4ovrden_in : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    rxdfetap5ovrden_in : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    rxdfetap6ovrden_in : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    rxdfetap7ovrden_in : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    rxdfetap8ovrden_in : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    rxdfetap9ovrden_in : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    rxdfeutovrden_in : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    rxlpmgcovrden_in : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    rxlpmhfovrden_in : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    rxlpmlfklovrden_in : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    rxlpmosovrden_in : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    rxosovrden_in : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    rxpllclksel_in : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
    txpllclksel_in : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
    txpmareset_in : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    cplllock_out : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    cpllrefclklost_out : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    drpdo_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    drprdy_out : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    gthtxn_out : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    gthtxp_out : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    gtpowergood_out : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    rxpmaresetdone_out : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    txbufstatus_out : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    txpmaresetdone_out : OUT STD_LOGIC_VECTOR(0 DOWNTO 0)
  );
END COMPONENT;
-- COMP_TAG_END ------ End COMPONENT Declaration ------------

-- The following code must appear in the VHDL architecture
-- body. Substitute your own instance name and net names.

------------- Begin Cut here for INSTANTIATION Template ----- INST_TAG
your_instance_name : v_smpte_uhdsdi_gtwiz
  PORT MAP (
    gtwiz_userclk_tx_reset_in => gtwiz_userclk_tx_reset_in,
    gtwiz_userclk_tx_srcclk_out => gtwiz_userclk_tx_srcclk_out,
    gtwiz_userclk_tx_usrclk_out => gtwiz_userclk_tx_usrclk_out,
    gtwiz_userclk_tx_usrclk2_out => gtwiz_userclk_tx_usrclk2_out,
    gtwiz_userclk_tx_active_out => gtwiz_userclk_tx_active_out,
    gtwiz_userclk_rx_reset_in => gtwiz_userclk_rx_reset_in,
    gtwiz_userclk_rx_srcclk_out => gtwiz_userclk_rx_srcclk_out,
    gtwiz_userclk_rx_usrclk_out => gtwiz_userclk_rx_usrclk_out,
    gtwiz_userclk_rx_usrclk2_out => gtwiz_userclk_rx_usrclk2_out,
    gtwiz_userclk_rx_active_out => gtwiz_userclk_rx_active_out,
    gtwiz_reset_clk_freerun_in => gtwiz_reset_clk_freerun_in,
    gtwiz_reset_all_in => gtwiz_reset_all_in,
    gtwiz_reset_tx_pll_and_datapath_in => gtwiz_reset_tx_pll_and_datapath_in,
    gtwiz_reset_tx_datapath_in => gtwiz_reset_tx_datapath_in,
    gtwiz_reset_rx_pll_and_datapath_in => gtwiz_reset_rx_pll_and_datapath_in,
    gtwiz_reset_rx_datapath_in => gtwiz_reset_rx_datapath_in,
    gtwiz_reset_rx_cdr_stable_out => gtwiz_reset_rx_cdr_stable_out,
    gtwiz_reset_tx_done_out => gtwiz_reset_tx_done_out,
    gtwiz_reset_rx_done_out => gtwiz_reset_rx_done_out,
    gtwiz_userdata_tx_in => gtwiz_userdata_tx_in,
    gtwiz_userdata_rx_out => gtwiz_userdata_rx_out,
    drpaddr_in => drpaddr_in,
    drpclk_in => drpclk_in,
    drpdi_in => drpdi_in,
    drpen_in => drpen_in,
    drpwe_in => drpwe_in,
    gthrxn_in => gthrxn_in,
    gthrxp_in => gthrxp_in,
    gtrefclk0_in => gtrefclk0_in,
    rxcdrhold_in => rxcdrhold_in,
    rxdfeagcovrden_in => rxdfeagcovrden_in,
    rxdfelfovrden_in => rxdfelfovrden_in,
    rxdfetap10ovrden_in => rxdfetap10ovrden_in,
    rxdfetap11ovrden_in => rxdfetap11ovrden_in,
    rxdfetap12ovrden_in => rxdfetap12ovrden_in,
    rxdfetap13ovrden_in => rxdfetap13ovrden_in,
    rxdfetap14ovrden_in => rxdfetap14ovrden_in,
    rxdfetap15ovrden_in => rxdfetap15ovrden_in,
    rxdfetap2ovrden_in => rxdfetap2ovrden_in,
    rxdfetap3ovrden_in => rxdfetap3ovrden_in,
    rxdfetap4ovrden_in => rxdfetap4ovrden_in,
    rxdfetap5ovrden_in => rxdfetap5ovrden_in,
    rxdfetap6ovrden_in => rxdfetap6ovrden_in,
    rxdfetap7ovrden_in => rxdfetap7ovrden_in,
    rxdfetap8ovrden_in => rxdfetap8ovrden_in,
    rxdfetap9ovrden_in => rxdfetap9ovrden_in,
    rxdfeutovrden_in => rxdfeutovrden_in,
    rxlpmgcovrden_in => rxlpmgcovrden_in,
    rxlpmhfovrden_in => rxlpmhfovrden_in,
    rxlpmlfklovrden_in => rxlpmlfklovrden_in,
    rxlpmosovrden_in => rxlpmosovrden_in,
    rxosovrden_in => rxosovrden_in,
    rxpllclksel_in => rxpllclksel_in,
    txpllclksel_in => txpllclksel_in,
    txpmareset_in => txpmareset_in,
    cplllock_out => cplllock_out,
    cpllrefclklost_out => cpllrefclklost_out,
    drpdo_out => drpdo_out,
    drprdy_out => drprdy_out,
    gthtxn_out => gthtxn_out,
    gthtxp_out => gthtxp_out,
    gtpowergood_out => gtpowergood_out,
    rxpmaresetdone_out => rxpmaresetdone_out,
    txbufstatus_out => txbufstatus_out,
    txpmaresetdone_out => txpmaresetdone_out
  );
-- INST_TAG_END ------ End INSTANTIATION Template ---------

-- You must compile the wrapper file v_smpte_uhdsdi_gtwiz.vhd when simulating
-- the core, v_smpte_uhdsdi_gtwiz. When compiling the wrapper file, be sure to
-- reference the VHDL simulation library.

