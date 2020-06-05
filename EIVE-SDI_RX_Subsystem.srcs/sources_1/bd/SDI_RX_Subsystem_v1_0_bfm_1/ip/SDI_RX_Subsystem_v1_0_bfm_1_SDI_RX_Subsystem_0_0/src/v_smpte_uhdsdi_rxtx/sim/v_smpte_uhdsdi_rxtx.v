// (c) Copyright 1995-2020 Xilinx, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
// 
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
// 
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
// 
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
// 
// DO NOT MODIFY THIS FILE.


// IP VLNV: xilinx.com:ip:v_smpte_uhdsdi:1.0
// IP Revision: 5

`timescale 1ns/1ps

(* DowngradeIPIdentifiedWarnings = "yes" *)
module v_smpte_uhdsdi_rxtx (
  rx_clk,
  rx_rst,
  rx_mode_detect_rst,
  rx_data_in,
  rx_sd_data_strobe,
  rx_frame_en,
  rx_bit_rate,
  rx_mode_enable,
  rx_mode_detect_en,
  rx_forced_mode,
  rx_ready,
  rx_mode,
  rx_mode_hd,
  rx_mode_sd,
  rx_mode_3g,
  rx_mode_locked,
  rx_t_locked,
  rx_t_family,
  rx_t_rate,
  rx_t_scan,
  rx_level_b_3g,
  rx_ce_out,
  rx_active_streams,
  rx_ln_ds1,
  rx_ln_ds2,
  rx_ln_ds3,
  rx_ln_ds4,
  rx_st352_0,
  rx_st352_0_valid,
  rx_st352_1,
  rx_st352_1_valid,
  rx_crc_err_ds1,
  rx_crc_err_ds2,
  rx_crc_err_ds3,
  rx_crc_err_ds4,
  rx_ds1,
  rx_ds2,
  rx_ds3,
  rx_ds4,
  rx_eav,
  rx_sav,
  rx_trs,
  rx_edh_errcnt_en,
  rx_edh_clr_errcnt,
  rx_edh_ap,
  rx_edh_ff,
  rx_edh_anc,
  rx_edh_ap_flags,
  rx_edh_ff_flags,
  rx_edh_anc_flags,
  rx_edh_packet_flags,
  rx_edh_errcnt,
  tx_clk,
  tx_ce,
  tx_sd_ce,
  tx_edh_ce,
  tx_rst,
  tx_mode,
  tx_insert_crc,
  tx_insert_ln,
  tx_insert_st352,
  tx_overwrite_st352,
  tx_insert_edh,
  tx_mux_pattern,
  tx_insert_sync_bit,
  tx_sd_bitrep_bypass,
  tx_line_ch0,
  tx_line_ch1,
  tx_st352_line_f1,
  tx_st352_line_f2,
  tx_st352_f2_en,
  tx_st352_data_ch0,
  tx_st352_data_ch1,
  tx_ds1_in,
  tx_ds2_in,
  tx_ds3_in,
  tx_ds4_in,
  tx_ds1_st352_out,
  tx_ds2_st352_out,
  tx_ds3_st352_out,
  tx_ds4_st352_out,
  tx_ds1_anc_in,
  tx_ds2_anc_in,
  tx_ds3_anc_in,
  tx_ds4_anc_in,
  tx_use_anc_in,
  tx_txdata,
  tx_ce_align_err
);

input wire rx_clk;
input wire rx_rst;
input wire rx_mode_detect_rst;
input wire [19 : 0] rx_data_in;
input wire rx_sd_data_strobe;
input wire rx_frame_en;
input wire rx_bit_rate;
input wire [5 : 0] rx_mode_enable;
input wire rx_mode_detect_en;
input wire [2 : 0] rx_forced_mode;
input wire rx_ready;
output wire [2 : 0] rx_mode;
output wire rx_mode_hd;
output wire rx_mode_sd;
output wire rx_mode_3g;
output wire rx_mode_locked;
output wire rx_t_locked;
output wire [3 : 0] rx_t_family;
output wire [3 : 0] rx_t_rate;
output wire rx_t_scan;
output wire rx_level_b_3g;
output wire [0 : 0] rx_ce_out;
output wire [2 : 0] rx_active_streams;
output wire [10 : 0] rx_ln_ds1;
output wire [10 : 0] rx_ln_ds2;
output wire [10 : 0] rx_ln_ds3;
output wire [10 : 0] rx_ln_ds4;
output wire [31 : 0] rx_st352_0;
output wire rx_st352_0_valid;
output wire [31 : 0] rx_st352_1;
output wire rx_st352_1_valid;
output wire rx_crc_err_ds1;
output wire rx_crc_err_ds2;
output wire rx_crc_err_ds3;
output wire rx_crc_err_ds4;
output wire [9 : 0] rx_ds1;
output wire [9 : 0] rx_ds2;
output wire [9 : 0] rx_ds3;
output wire [9 : 0] rx_ds4;
output wire rx_eav;
output wire rx_sav;
output wire rx_trs;
input wire [15 : 0] rx_edh_errcnt_en;
input wire rx_edh_clr_errcnt;
output wire rx_edh_ap;
output wire rx_edh_ff;
output wire rx_edh_anc;
output wire [4 : 0] rx_edh_ap_flags;
output wire [4 : 0] rx_edh_ff_flags;
output wire [4 : 0] rx_edh_anc_flags;
output wire [3 : 0] rx_edh_packet_flags;
output wire [15 : 0] rx_edh_errcnt;
input wire tx_clk;
input wire tx_ce;
input wire tx_sd_ce;
input wire tx_edh_ce;
input wire tx_rst;
input wire [2 : 0] tx_mode;
input wire tx_insert_crc;
input wire tx_insert_ln;
input wire tx_insert_st352;
input wire tx_overwrite_st352;
input wire tx_insert_edh;
input wire [2 : 0] tx_mux_pattern;
input wire tx_insert_sync_bit;
input wire tx_sd_bitrep_bypass;
input wire [10 : 0] tx_line_ch0;
input wire [10 : 0] tx_line_ch1;
input wire [10 : 0] tx_st352_line_f1;
input wire [10 : 0] tx_st352_line_f2;
input wire tx_st352_f2_en;
input wire [31 : 0] tx_st352_data_ch0;
input wire [31 : 0] tx_st352_data_ch1;
input wire [9 : 0] tx_ds1_in;
input wire [9 : 0] tx_ds2_in;
input wire [9 : 0] tx_ds3_in;
input wire [9 : 0] tx_ds4_in;
output wire [9 : 0] tx_ds1_st352_out;
output wire [9 : 0] tx_ds2_st352_out;
output wire [9 : 0] tx_ds3_st352_out;
output wire [9 : 0] tx_ds4_st352_out;
input wire [9 : 0] tx_ds1_anc_in;
input wire [9 : 0] tx_ds2_anc_in;
input wire [9 : 0] tx_ds3_anc_in;
input wire [9 : 0] tx_ds4_anc_in;
input wire tx_use_anc_in;
output wire [19 : 0] tx_txdata;
output wire tx_ce_align_err;

  v_smpte_uhdsdi_v1_0_5 #(
    .INCLUDE_RX_EDH_PROCESSOR("TRUE"),
    .NUM_RX_CE(1),
    .DATA_WIDTH(20),
    .EDH_ERR_WIDTH(16)
  ) inst (
    .rx_clk(rx_clk),
    .rx_rst(rx_rst),
    .rx_mode_detect_rst(rx_mode_detect_rst),
    .rx_data_in(rx_data_in),
    .rx_sd_data_strobe(rx_sd_data_strobe),
    .rx_frame_en(rx_frame_en),
    .rx_bit_rate(rx_bit_rate),
    .rx_mode_enable(rx_mode_enable),
    .rx_mode_detect_en(rx_mode_detect_en),
    .rx_forced_mode(rx_forced_mode),
    .rx_ready(rx_ready),
    .rx_mode(rx_mode),
    .rx_mode_hd(rx_mode_hd),
    .rx_mode_sd(rx_mode_sd),
    .rx_mode_3g(rx_mode_3g),
    .rx_mode_6g(),
    .rx_mode_12g(),
    .rx_mode_locked(rx_mode_locked),
    .rx_t_locked(rx_t_locked),
    .rx_t_family(rx_t_family),
    .rx_t_rate(rx_t_rate),
    .rx_t_scan(rx_t_scan),
    .rx_level_b_3g(rx_level_b_3g),
    .rx_ce_out(rx_ce_out),
    .rx_active_streams(rx_active_streams),
    .rx_ln_ds1(rx_ln_ds1),
    .rx_ln_ds2(rx_ln_ds2),
    .rx_ln_ds3(rx_ln_ds3),
    .rx_ln_ds4(rx_ln_ds4),
    .rx_ln_ds5(),
    .rx_ln_ds6(),
    .rx_ln_ds7(),
    .rx_ln_ds8(),
    .rx_ln_ds9(),
    .rx_ln_ds10(),
    .rx_ln_ds11(),
    .rx_ln_ds12(),
    .rx_ln_ds13(),
    .rx_ln_ds14(),
    .rx_ln_ds15(),
    .rx_ln_ds16(),
    .rx_st352_0(rx_st352_0),
    .rx_st352_0_valid(rx_st352_0_valid),
    .rx_st352_1(rx_st352_1),
    .rx_st352_1_valid(rx_st352_1_valid),
    .rx_st352_2(),
    .rx_st352_2_valid(),
    .rx_st352_3(),
    .rx_st352_3_valid(),
    .rx_st352_4(),
    .rx_st352_4_valid(),
    .rx_st352_5(),
    .rx_st352_5_valid(),
    .rx_st352_6(),
    .rx_st352_6_valid(),
    .rx_st352_7(),
    .rx_st352_7_valid(),
    .rx_crc_err_ds1(rx_crc_err_ds1),
    .rx_crc_err_ds2(rx_crc_err_ds2),
    .rx_crc_err_ds3(rx_crc_err_ds3),
    .rx_crc_err_ds4(rx_crc_err_ds4),
    .rx_crc_err_ds5(),
    .rx_crc_err_ds6(),
    .rx_crc_err_ds7(),
    .rx_crc_err_ds8(),
    .rx_crc_err_ds9(),
    .rx_crc_err_ds10(),
    .rx_crc_err_ds11(),
    .rx_crc_err_ds12(),
    .rx_crc_err_ds13(),
    .rx_crc_err_ds14(),
    .rx_crc_err_ds15(),
    .rx_crc_err_ds16(),
    .rx_ds1(rx_ds1),
    .rx_ds2(rx_ds2),
    .rx_ds3(rx_ds3),
    .rx_ds4(rx_ds4),
    .rx_ds5(),
    .rx_ds6(),
    .rx_ds7(),
    .rx_ds8(),
    .rx_ds9(),
    .rx_ds10(),
    .rx_ds11(),
    .rx_ds12(),
    .rx_ds13(),
    .rx_ds14(),
    .rx_ds15(),
    .rx_ds16(),
    .rx_eav(rx_eav),
    .rx_sav(rx_sav),
    .rx_trs(rx_trs),
    .rx_edh_errcnt_en(rx_edh_errcnt_en),
    .rx_edh_clr_errcnt(rx_edh_clr_errcnt),
    .rx_edh_ap(rx_edh_ap),
    .rx_edh_ff(rx_edh_ff),
    .rx_edh_anc(rx_edh_anc),
    .rx_edh_ap_flags(rx_edh_ap_flags),
    .rx_edh_ff_flags(rx_edh_ff_flags),
    .rx_edh_anc_flags(rx_edh_anc_flags),
    .rx_edh_packet_flags(rx_edh_packet_flags),
    .rx_edh_errcnt(rx_edh_errcnt),
    .tx_clk(tx_clk),
    .tx_ce(tx_ce),
    .tx_sd_ce(tx_sd_ce),
    .tx_edh_ce(tx_edh_ce),
    .tx_rst(tx_rst),
    .tx_mode(tx_mode),
    .tx_insert_crc(tx_insert_crc),
    .tx_insert_ln(tx_insert_ln),
    .tx_insert_st352(tx_insert_st352),
    .tx_overwrite_st352(tx_overwrite_st352),
    .tx_insert_edh(tx_insert_edh),
    .tx_mux_pattern(tx_mux_pattern),
    .tx_insert_sync_bit(tx_insert_sync_bit),
    .tx_sd_bitrep_bypass(tx_sd_bitrep_bypass),
    .tx_line_ch0(tx_line_ch0),
    .tx_line_ch1(tx_line_ch1),
    .tx_line_ch2(11'B0),
    .tx_line_ch3(11'B0),
    .tx_line_ch4(11'B0),
    .tx_line_ch5(11'B0),
    .tx_line_ch6(11'B0),
    .tx_line_ch7(11'B0),
    .tx_st352_line_f1(tx_st352_line_f1),
    .tx_st352_line_f2(tx_st352_line_f2),
    .tx_st352_f2_en(tx_st352_f2_en),
    .tx_st352_data_ch0(tx_st352_data_ch0),
    .tx_st352_data_ch1(tx_st352_data_ch1),
    .tx_st352_data_ch2(32'B0),
    .tx_st352_data_ch3(32'B0),
    .tx_st352_data_ch4(32'B0),
    .tx_st352_data_ch5(32'B0),
    .tx_st352_data_ch6(32'B0),
    .tx_st352_data_ch7(32'B0),
    .tx_ds1_in(tx_ds1_in),
    .tx_ds2_in(tx_ds2_in),
    .tx_ds3_in(tx_ds3_in),
    .tx_ds4_in(tx_ds4_in),
    .tx_ds5_in(10'B0),
    .tx_ds6_in(10'B0),
    .tx_ds7_in(10'B0),
    .tx_ds8_in(10'B0),
    .tx_ds9_in(10'B0),
    .tx_ds10_in(10'B0),
    .tx_ds11_in(10'B0),
    .tx_ds12_in(10'B0),
    .tx_ds13_in(10'B0),
    .tx_ds14_in(10'B0),
    .tx_ds15_in(10'B0),
    .tx_ds16_in(10'B0),
    .tx_ds1_st352_out(tx_ds1_st352_out),
    .tx_ds2_st352_out(tx_ds2_st352_out),
    .tx_ds3_st352_out(tx_ds3_st352_out),
    .tx_ds4_st352_out(tx_ds4_st352_out),
    .tx_ds5_st352_out(),
    .tx_ds6_st352_out(),
    .tx_ds7_st352_out(),
    .tx_ds8_st352_out(),
    .tx_ds9_st352_out(),
    .tx_ds10_st352_out(),
    .tx_ds11_st352_out(),
    .tx_ds12_st352_out(),
    .tx_ds13_st352_out(),
    .tx_ds14_st352_out(),
    .tx_ds15_st352_out(),
    .tx_ds16_st352_out(),
    .tx_ds1_anc_in(tx_ds1_anc_in),
    .tx_ds2_anc_in(tx_ds2_anc_in),
    .tx_ds3_anc_in(tx_ds3_anc_in),
    .tx_ds4_anc_in(tx_ds4_anc_in),
    .tx_ds5_anc_in(10'B0),
    .tx_ds6_anc_in(10'B0),
    .tx_ds7_anc_in(10'B0),
    .tx_ds8_anc_in(10'B0),
    .tx_ds9_anc_in(10'B0),
    .tx_ds10_anc_in(10'B0),
    .tx_ds11_anc_in(10'B0),
    .tx_ds12_anc_in(10'B0),
    .tx_ds13_anc_in(10'B0),
    .tx_ds14_anc_in(10'B0),
    .tx_ds15_anc_in(10'B0),
    .tx_ds16_anc_in(10'B0),
    .tx_use_anc_in(tx_use_anc_in),
    .tx_txdata(tx_txdata),
    .tx_ce_align_err(tx_ce_align_err)
  );
endmodule
