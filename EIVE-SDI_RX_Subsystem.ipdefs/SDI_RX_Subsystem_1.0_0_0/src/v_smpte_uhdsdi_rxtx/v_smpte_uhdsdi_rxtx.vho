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

-- IP VLNV: xilinx.com:ip:v_smpte_uhdsdi:1.0
-- IP Revision: 5

-- The following code must appear in the VHDL architecture header.

------------- Begin Cut here for COMPONENT Declaration ------ COMP_TAG
COMPONENT v_smpte_uhdsdi_rxtx
  PORT (
    rx_clk : IN STD_LOGIC;
    rx_rst : IN STD_LOGIC;
    rx_mode_detect_rst : IN STD_LOGIC;
    rx_data_in : IN STD_LOGIC_VECTOR(19 DOWNTO 0);
    rx_sd_data_strobe : IN STD_LOGIC;
    rx_frame_en : IN STD_LOGIC;
    rx_bit_rate : IN STD_LOGIC;
    rx_mode_enable : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
    rx_mode_detect_en : IN STD_LOGIC;
    rx_forced_mode : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    rx_ready : IN STD_LOGIC;
    rx_mode : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    rx_mode_hd : OUT STD_LOGIC;
    rx_mode_sd : OUT STD_LOGIC;
    rx_mode_3g : OUT STD_LOGIC;
    rx_mode_locked : OUT STD_LOGIC;
    rx_t_locked : OUT STD_LOGIC;
    rx_t_family : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    rx_t_rate : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    rx_t_scan : OUT STD_LOGIC;
    rx_level_b_3g : OUT STD_LOGIC;
    rx_ce_out : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    rx_active_streams : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    rx_ln_ds1 : OUT STD_LOGIC_VECTOR(10 DOWNTO 0);
    rx_ln_ds2 : OUT STD_LOGIC_VECTOR(10 DOWNTO 0);
    rx_ln_ds3 : OUT STD_LOGIC_VECTOR(10 DOWNTO 0);
    rx_ln_ds4 : OUT STD_LOGIC_VECTOR(10 DOWNTO 0);
    rx_st352_0 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    rx_st352_0_valid : OUT STD_LOGIC;
    rx_st352_1 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    rx_st352_1_valid : OUT STD_LOGIC;
    rx_crc_err_ds1 : OUT STD_LOGIC;
    rx_crc_err_ds2 : OUT STD_LOGIC;
    rx_crc_err_ds3 : OUT STD_LOGIC;
    rx_crc_err_ds4 : OUT STD_LOGIC;
    rx_ds1 : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
    rx_ds2 : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
    rx_ds3 : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
    rx_ds4 : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
    rx_eav : OUT STD_LOGIC;
    rx_sav : OUT STD_LOGIC;
    rx_trs : OUT STD_LOGIC;
    rx_edh_errcnt_en : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    rx_edh_clr_errcnt : IN STD_LOGIC;
    rx_edh_ap : OUT STD_LOGIC;
    rx_edh_ff : OUT STD_LOGIC;
    rx_edh_anc : OUT STD_LOGIC;
    rx_edh_ap_flags : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
    rx_edh_ff_flags : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
    rx_edh_anc_flags : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
    rx_edh_packet_flags : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    rx_edh_errcnt : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    tx_clk : IN STD_LOGIC;
    tx_ce : IN STD_LOGIC;
    tx_sd_ce : IN STD_LOGIC;
    tx_edh_ce : IN STD_LOGIC;
    tx_rst : IN STD_LOGIC;
    tx_mode : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    tx_insert_crc : IN STD_LOGIC;
    tx_insert_ln : IN STD_LOGIC;
    tx_insert_st352 : IN STD_LOGIC;
    tx_overwrite_st352 : IN STD_LOGIC;
    tx_insert_edh : IN STD_LOGIC;
    tx_mux_pattern : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    tx_insert_sync_bit : IN STD_LOGIC;
    tx_sd_bitrep_bypass : IN STD_LOGIC;
    tx_line_ch0 : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
    tx_line_ch1 : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
    tx_st352_line_f1 : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
    tx_st352_line_f2 : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
    tx_st352_f2_en : IN STD_LOGIC;
    tx_st352_data_ch0 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    tx_st352_data_ch1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    tx_ds1_in : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
    tx_ds2_in : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
    tx_ds3_in : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
    tx_ds4_in : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
    tx_ds1_st352_out : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
    tx_ds2_st352_out : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
    tx_ds3_st352_out : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
    tx_ds4_st352_out : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
    tx_ds1_anc_in : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
    tx_ds2_anc_in : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
    tx_ds3_anc_in : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
    tx_ds4_anc_in : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
    tx_use_anc_in : IN STD_LOGIC;
    tx_txdata : OUT STD_LOGIC_VECTOR(19 DOWNTO 0);
    tx_ce_align_err : OUT STD_LOGIC
  );
END COMPONENT;
-- COMP_TAG_END ------ End COMPONENT Declaration ------------

-- The following code must appear in the VHDL architecture
-- body. Substitute your own instance name and net names.

------------- Begin Cut here for INSTANTIATION Template ----- INST_TAG
your_instance_name : v_smpte_uhdsdi_rxtx
  PORT MAP (
    rx_clk => rx_clk,
    rx_rst => rx_rst,
    rx_mode_detect_rst => rx_mode_detect_rst,
    rx_data_in => rx_data_in,
    rx_sd_data_strobe => rx_sd_data_strobe,
    rx_frame_en => rx_frame_en,
    rx_bit_rate => rx_bit_rate,
    rx_mode_enable => rx_mode_enable,
    rx_mode_detect_en => rx_mode_detect_en,
    rx_forced_mode => rx_forced_mode,
    rx_ready => rx_ready,
    rx_mode => rx_mode,
    rx_mode_hd => rx_mode_hd,
    rx_mode_sd => rx_mode_sd,
    rx_mode_3g => rx_mode_3g,
    rx_mode_locked => rx_mode_locked,
    rx_t_locked => rx_t_locked,
    rx_t_family => rx_t_family,
    rx_t_rate => rx_t_rate,
    rx_t_scan => rx_t_scan,
    rx_level_b_3g => rx_level_b_3g,
    rx_ce_out => rx_ce_out,
    rx_active_streams => rx_active_streams,
    rx_ln_ds1 => rx_ln_ds1,
    rx_ln_ds2 => rx_ln_ds2,
    rx_ln_ds3 => rx_ln_ds3,
    rx_ln_ds4 => rx_ln_ds4,
    rx_st352_0 => rx_st352_0,
    rx_st352_0_valid => rx_st352_0_valid,
    rx_st352_1 => rx_st352_1,
    rx_st352_1_valid => rx_st352_1_valid,
    rx_crc_err_ds1 => rx_crc_err_ds1,
    rx_crc_err_ds2 => rx_crc_err_ds2,
    rx_crc_err_ds3 => rx_crc_err_ds3,
    rx_crc_err_ds4 => rx_crc_err_ds4,
    rx_ds1 => rx_ds1,
    rx_ds2 => rx_ds2,
    rx_ds3 => rx_ds3,
    rx_ds4 => rx_ds4,
    rx_eav => rx_eav,
    rx_sav => rx_sav,
    rx_trs => rx_trs,
    rx_edh_errcnt_en => rx_edh_errcnt_en,
    rx_edh_clr_errcnt => rx_edh_clr_errcnt,
    rx_edh_ap => rx_edh_ap,
    rx_edh_ff => rx_edh_ff,
    rx_edh_anc => rx_edh_anc,
    rx_edh_ap_flags => rx_edh_ap_flags,
    rx_edh_ff_flags => rx_edh_ff_flags,
    rx_edh_anc_flags => rx_edh_anc_flags,
    rx_edh_packet_flags => rx_edh_packet_flags,
    rx_edh_errcnt => rx_edh_errcnt,
    tx_clk => tx_clk,
    tx_ce => tx_ce,
    tx_sd_ce => tx_sd_ce,
    tx_edh_ce => tx_edh_ce,
    tx_rst => tx_rst,
    tx_mode => tx_mode,
    tx_insert_crc => tx_insert_crc,
    tx_insert_ln => tx_insert_ln,
    tx_insert_st352 => tx_insert_st352,
    tx_overwrite_st352 => tx_overwrite_st352,
    tx_insert_edh => tx_insert_edh,
    tx_mux_pattern => tx_mux_pattern,
    tx_insert_sync_bit => tx_insert_sync_bit,
    tx_sd_bitrep_bypass => tx_sd_bitrep_bypass,
    tx_line_ch0 => tx_line_ch0,
    tx_line_ch1 => tx_line_ch1,
    tx_st352_line_f1 => tx_st352_line_f1,
    tx_st352_line_f2 => tx_st352_line_f2,
    tx_st352_f2_en => tx_st352_f2_en,
    tx_st352_data_ch0 => tx_st352_data_ch0,
    tx_st352_data_ch1 => tx_st352_data_ch1,
    tx_ds1_in => tx_ds1_in,
    tx_ds2_in => tx_ds2_in,
    tx_ds3_in => tx_ds3_in,
    tx_ds4_in => tx_ds4_in,
    tx_ds1_st352_out => tx_ds1_st352_out,
    tx_ds2_st352_out => tx_ds2_st352_out,
    tx_ds3_st352_out => tx_ds3_st352_out,
    tx_ds4_st352_out => tx_ds4_st352_out,
    tx_ds1_anc_in => tx_ds1_anc_in,
    tx_ds2_anc_in => tx_ds2_anc_in,
    tx_ds3_anc_in => tx_ds3_anc_in,
    tx_ds4_anc_in => tx_ds4_anc_in,
    tx_use_anc_in => tx_use_anc_in,
    tx_txdata => tx_txdata,
    tx_ce_align_err => tx_ce_align_err
  );
-- INST_TAG_END ------ End INSTANTIATION Template ---------

-- You must compile the wrapper file v_smpte_uhdsdi_rxtx.vhd when simulating
-- the core, v_smpte_uhdsdi_rxtx. When compiling the wrapper file, be sure to
-- reference the VHDL simulation library.

