// (c) Copyright 2011 - 2013 Xilinx, Inc. All rights reserved.
//
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
//
//------------------------------------------------------------------------------
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor:  Xilinx
// \   \   \/     
//  \   \         
//  /   /         
// /___/   /\     
// \   \  /  \
//  \___\/\___\
//
// Description:
//  This wrapper file includes a MGT Common logic, SMPTE SDI core and the GTH and
//  corresponding control module.
//  It implements a single SDI RX and a single SDI TX.
//------------------------------------------------------------------------------
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

`timescale 1ns / 1ps

module kugth_uhdsdi_3g_wrapper_support #(
    parameter TXPLLCLKSEL_TX_M_0              = 2'b11,         // Value to output on TXPLLCLKSEL when tx_m is 0; //CPLL=00, QPLL0=11, QPLL1=10 
    parameter TXPLLCLKSEL_TX_M_1              = 2'b10,         // Value to output on TXPLLCLKSEL when tx_m is 1; //CPLL=00, QPLL0=11, QPLL1=10 
    parameter RX_FXDCLK_FREQ                  = 27000000,      // Frequency, in hertz, of fxdclk
    parameter RXPLLCLKSEL_RX_M_0              = 2'b11,         // Value to output on RXPLLCLKSEL when rx_m is 0; //CPLL=00, QPLL0=11, QPLL1=10 
    parameter RXPLLCLKSEL_RX_M_1              = 2'b10,         // Value to output on RXPLLCLKSEL when rx_m is 1; //CPLL=00, QPLL0=11, QPLL1=10 
    parameter XY_SITE                         = "x1y4",       // GTH Location
	parameter EN_HOT_PLUG_LOGIC               = 0              // Enable Hot-Plug logic    
	)
(

// RX ports
    input   wire                        rx_fxdclk_in,           // fixed frequency clock SDI RX bit rate detection
    input   wire                        rx_rst_in,              // sync reset for SDI RX data path
    output  wire                        rx_fabric_rst_out,      // RX fabric reset
    output  wire                        rx_usrclk_out,          // rxusrclk input
    input   wire                        rx_mode_detect_rst_in,  // synchronous reset for SDI mode detection function 
    input   wire [ 2:0]                 rx_mode_en_in,          // unary enable bits for SDI mode search {3G, SD, HD} 1=enable, 0=disable
    input   wire                        rx_mode_detect_en_in,   // 1 enables SDI mode detection      
    input   wire [ 1:0]                 rx_forced_mode_in,      // if mode_detect_en=0, this port specifies the SDI mode of the RX
    output  wire [ 1:0]                 rx_mode_out,            // 00=HD, 01=SD, 10=3G
    output  wire                        rx_mode_hd_out,         // 1 = HD mode      
    output  wire                        rx_mode_sd_out,         // 1 = SD mode
    output  wire                        rx_mode_3g_out,         // 1 = 3G mode
    output  wire                        rx_mode_locked_out,     // auto mode detection locked
    output  wire                        rx_bit_rate_out,        // 0 = 1000/1000, 1 = 1000/1001
    output  wire                        rx_t_locked_out,        // transport format detection locked
    output  wire [ 3:0]                 rx_t_family_out,        // transport format family
    output  wire [ 3:0]                 rx_t_rate_out,          // transport frame rate
    output  wire                        rx_t_scan_out,          // transport scan: 0=interlaced, 1=progressive
    output  wire                        rx_level_b_3g_out,      // 0 = level A, 1 = level B
    output  wire                        rx_ce_out,              // clock enable 
  	output  wire [2:0]                  rx_active_streams_out,  // 2^active_streams = number of active streams
    output  wire [10:0]                 rx_line_0_out,          // line number for data stream 1
    output  wire [10:0]                 rx_line_1_out,          // line number for data stream 3
    output  wire [31:0]                 rx_st352_0_out,         // video payload ID packet ds1 (for 3G-SDI level A, Y VPID)
    output  wire                        rx_st352_0_valid_out,   // 1 = st352_0 is valid
    output  wire [31:0]                 rx_st352_1_out,         // video payload ID packet ds3 (ds2 for 3G-SDI level A, C VPID) 
    output  wire                        rx_st352_1_valid_out,   // 1 = st352_1 is valid
	output  wire [ 3:0]                 rx_crc_err_out,         // CRC error signals for all 4 data streams [ds4:ds1]
    output  wire [ 9:0]                 rx_ds1_out,             // SD=Y/C, HD=Y, 3GA=ds1, 3GB=Y link A, 6G/12G=ds1
    output  wire [ 9:0]                 rx_ds2_out,             // HD=C, 3GA=ds2, 3GB=C link A, 6G/12G=ds2
    output  wire [ 9:0]                 rx_ds3_out,             // 3GB=Y link B, 6G/12G=ds3
    output  wire [ 9:0]                 rx_ds4_out,             // 3GB=C link B, 6G/12G=ds4
    output  wire                        rx_eav_out,             // 1 during XYZ word of EAV
    output  wire                        rx_sav_out,             // 1 during XYZ word of SAV
    output  wire                        rx_trs_out,             // 1 during all 4 words of EAV and SAV
    input   wire [15:0]                 rx_edh_errcnt_en_in,    // enables various errors to increment rx_edh_errcnt
    input   wire                        rx_edh_clr_errcnt_in,   // clears rx_edh_errcnt
    output  wire                        rx_edh_ap_out,          // 1 = AP CRC error detected previous field
    output  wire                        rx_edh_ff_out,          // 1 = FF CRC error detected previous field
    output  wire                        rx_edh_anc_out,         // 1 = ANC checksum error detected
    output  wire [ 4:0]                 rx_edh_ap_flags_out,    // EDH AP flags received in last EDH packet
    output  wire [ 4:0]                 rx_edh_ff_flags_out,    // EDH FF flags received in last EDH packet
    output  wire [ 4:0]                 rx_edh_anc_flags_out,   // EDH ANC flags received in last EDH packet
    output  wire [ 3:0]                 rx_edh_packet_flags_out,// EDH packet error condition flags
    output  wire [15:0]                 rx_edh_errcnt_out,      // EDH error counter
    output  wire                        rx_change_done_out,     // 1 when rx_mode change has completed successfully                         (drpclk)
    output  wire                        rx_change_fail_out,     // 1 when rx_mode change failed                                             (drpclk)
    output  wire [ 2:0]                 rx_change_fail_code_out,// failure code when rx_change_fail = 1                                     (drpclk)

// TX ports                                                (clock domain)
    input   wire                        tx_rst_in,              // sync reset for SDI TX data path
    output  wire                        tx_fabric_rst_out,      // TX fabric reset
    output  wire                        tx_usrclk_out,          // clock input
    input   wire                        tx_ce_in,               // clock enable 
    input   wire                        tx_sd_ce_in,            // SD-SDI clock enable, must be High in all other modes
    input   wire                        tx_edh_ce_in,           // EDH clock enable, recommended Low in all modes except SD-SDI
    input   wire [ 1:0]                 tx_mode_in,             // 00=HD, 01=SD, 10=3G
    input   wire                        tx_m_in,                // 0 = select 148.35 MHz refclk, 1 = select 148.5 MHz refclk                (async)
    input   wire                        tx_insert_crc_in,       // 1 = insert CRC for HD and 3G
    input   wire                        tx_insert_ln_in,        // 1 = insert LN for HD and 3G
    input   wire                        tx_insert_st352_in,     // 1 = enable ST352 PID packet insert
    input   wire                        tx_overwrite_st352_in,  // 1 = overwrite existing ST352 packets
    input   wire                        tx_insert_edh_in,       // 1 = generate & insert EDH for SD 
    input   wire [ 2:0]                 tx_mux_pattern_in,      // specifies the multiplex interleave pattern of data streams 
    input   wire                        tx_insert_sync_bit_in,  // 1 enables sync bit insertion
    input   wire [10:0]                 tx_line_0_in,           // current line number for ds1 & ds2
    input   wire [10:0]                 tx_line_1_in,           // current line number for ds3 & ds4
    input   wire [10:0]                 tx_st352_line_f1_in,    // insert ST352 packet on this line in field 1
    input   wire [10:0]                 tx_st352_line_f2_in,    // insert ST352 packet on this line in field 2
    input   wire                        tx_st352_f2_en_in,      // enable ST352 packet insertion in field 2
    input   wire [31:0]                 tx_st352_data_0_in,     // ST352 data bytes for ds1 {byte4, byte3, byte2, byte1} 
    input   wire [31:0]                 tx_st352_data_1_in,     // ST352 data bytes for ds3 (and ds2 in 3GA mode) {byte4, byte3, byte2, byte1} 
    input   wire [ 9:0]                 tx_ds1_in,              // data stream 1 (Y) in -- only active ds in SD, Y for HD & 3GA, AY for 3GB
    input   wire [ 9:0]                 tx_ds2_in,              // data stream 2 (C) in -- C for HD & 3GA, AC for 3GB
    input   wire [ 9:0]                 tx_ds3_in,              // data stream 3 (Y) in -- BY for 3GB
    input   wire [ 9:0]                 tx_ds4_in,              // data stream 4 (C) in -- BC for 3GB
    output  wire [ 9:0]                 tx_ds1_st352_out,       // data stream 1 after ST352 insertion
    output  wire [ 9:0]                 tx_ds2_st352_out,       // data stream 2 after ST352 insertion
    output  wire [ 9:0]                 tx_ds3_st352_out,       // data stream 3 after ST352 insertion
    output  wire [ 9:0]                 tx_ds4_st352_out,       // data stream 4 after ST352 insertion
    input   wire [ 9:0]                 tx_ds1_anc_in,          // data stream 1 after ANC insertion input
    input   wire [ 9:0]                 tx_ds2_anc_in,          // data stream 2 after ANC insertion input
    input   wire [ 9:0]                 tx_ds3_anc_in,          // data stream 3 after ANC insertion input
    input   wire [ 9:0]                 tx_ds4_anc_in,          // data stream 4 after ANC insertion input
    input   wire                        tx_use_anc_in,          // use the dsX_anc_in ports
    output  wire                        tx_ce_align_err_out,    // 1 if ce 5/6/5/6 cadence is broken in SD-SDI mode
    output  wire                        tx_slew_out,            // slew rate control signal for SDI cable driver
    output  wire                        tx_change_done_out,     // 1 when txrate or txsysclksel changes complete successfully               (drpclk)
    output  wire                        tx_change_fail_out,     // 1 when txrate or txsysclksel changes fail                                (drpclk)
    output  wire [ 2:0]                 tx_change_fail_code_out,// failure code when tx_change_fail = 1                                     (drpclk)

// DRP Controller Ports
    output  wire                        drp_fail_out,           // DRP Controller Fail Indicator
    output  wire [ 7:0]                 drp_fail_cnt_out,       // DRP Controller Fail Count
	                     
// GTH Ports      
    input   wire                        gth_wiz_reset_all_in,                   // GTH RX and TX full reset	
    input   wire                        gth_wiz_reset_tx_pll_and_datapath_in,   // GTH TX datapath and PLL reset	
    input   wire                        gth_wiz_reset_rx_pll_and_datapath_in,   // GTH RX datapath and PLL reset    
    output  wire                        gth_wiz_txresetdone_out,                // GTH TXP Output
    output  wire                        gth_wiz_rxresetdone_out,                // GTH TXP Output
    input   wire                        gth_drpclk_in,                          // GTH DRP Ref Clock Input
    input   wire                        gth_qpll0_refclk_p_in,                  // GTH QPLL0 Ref Clock P Input
    input   wire                        gth_qpll0_refclk_n_in,                  // GTH QPLL0 Ref Clock N Input
    input   wire                        gth_qpll0_reset_in,                     // GTH QPLL0 Ref Clock Reset Input
    output  wire                        gth_qpll0_clk_out,                      // GTH CHANNEL QPLL0 Clock Output
    output  wire                        gth_qpll0_refclk_out,                   // GTH CHANNEL QPLL0 Ref Clock Output
    output  wire                        gth_qpll0_lock_out,                     // GTH CHANNEL QPLL0 Lock Output
    input   wire                        gth_qpll1_refclk_p_in,                  // GTH QPLL1 Ref Clock P Input
    input   wire                        gth_qpll1_refclk_n_in,                  // GTH QPLL1 Ref Clock N Input
    input   wire                        gth_qpll1_reset_in,                     // GTH QPLL1 Ref Clock Reset Input
    output  wire                        gth_qpll1_clk_out,                      // GTH CHANNEL QPLL1 Clock Output
    output  wire                        gth_qpll1_refclk_out,                   // GTH CHANNEL QPLL1 Ref Clock Output
    output  wire                        gth_qpll1_lock_out,                     // GTH CHANNEL QPLL1 Lock Output
    input   wire                        gth_cpll_refclk_p_in,                   // GTH CPLL Ref Clock P Input
    input   wire                        gth_cpll_refclk_n_in,                   // GTH CPLL Ref Clock N Input
    output  wire                        gth_cpll_refclk_out,                    // GTH CPLL Ref Clock Output
    output  wire                        gth_cpll_lock_out,                      // GTH CPLL Lock Output
    input   wire                        gth_rxn_in,                             // GTH RXN Input
    input   wire                        gth_rxp_in,                             // GTH RXP Input
    output  wire                        gth_txn_out,                            // GTH TXN Output
    output  wire                        gth_txp_out                             // GTH TXP Output
);

//UHD-SDI MODES 
localparam MODE_SD		  = 3'b001;
localparam MODE_HD		  = 3'b000;
localparam MODE_3G		  = 3'b010;
localparam MODE_6G		  = 3'b100;
localparam MODE_12G_0	  = 3'b101;
localparam MODE_12G_1	  = 3'b110;

wire gtrefclk00;
wire gtrefclk10;

kugth_uhdsdi_3g_wrapper #(
    .TXPLLCLKSEL_TX_M_0              (TXPLLCLKSEL_TX_M_0),             
    .TXPLLCLKSEL_TX_M_1              (TXPLLCLKSEL_TX_M_1),             
    .RX_FXDCLK_FREQ                  (RX_FXDCLK_FREQ),                 
    .RXPLLCLKSEL_RX_M_0              (RXPLLCLKSEL_RX_M_0),             
    .RXPLLCLKSEL_RX_M_1              (RXPLLCLKSEL_RX_M_1),             
    .XY_SITE                         (XY_SITE),
    .EN_HOT_PLUG_LOGIC               (EN_HOT_PLUG_LOGIC)                   
	)
sdi_wrapper (
    .rx_fxdclk_in                    (rx_fxdclk_in),           
    .rx_rst_in                       (rx_rst_in),              
    .rx_fabric_rst_out               (rx_fabric_rst_out),              
    .rx_usrclk_out                   (rx_usrclk_out),          
    .rx_mode_detect_rst_in           (rx_mode_detect_rst_in),  
    .rx_mode_en_in                   (rx_mode_en_in),          
    .rx_mode_detect_en_in            (rx_mode_detect_en_in),   
    .rx_forced_mode_in               (rx_forced_mode_in),      
    .rx_mode_out                     (rx_mode_out),            
    .rx_mode_hd_out                  (rx_mode_hd_out),         
    .rx_mode_sd_out                  (rx_mode_sd_out),         
    .rx_mode_3g_out                  (rx_mode_3g_out),         
    .rx_mode_locked_out              (rx_mode_locked_out),     
    .rx_bit_rate_out                 (rx_bit_rate_out),               
    .rx_t_locked_out                 (rx_t_locked_out),        
    .rx_t_family_out                 (rx_t_family_out),        
    .rx_t_rate_out                   (rx_t_rate_out),          
    .rx_t_scan_out                   (rx_t_scan_out),          
    .rx_level_b_3g_out               (rx_level_b_3g_out),      
    .rx_ce_out                       (rx_ce_out),              
    .rx_active_streams_out           (rx_active_streams_out),            
    .rx_line_0_out                   (rx_line_0_out),          
    .rx_line_1_out                   (rx_line_1_out),          
    .rx_st352_0_out                  (rx_st352_0_out),         
    .rx_st352_0_valid_out            (rx_st352_0_valid_out),   
    .rx_st352_1_out                  (rx_st352_1_out),         
    .rx_st352_1_valid_out            (rx_st352_1_valid_out),   
    .rx_crc_err_out                  (rx_crc_err_out),     
    .rx_ds1_out                      (rx_ds1_out),             
    .rx_ds2_out                      (rx_ds2_out),             
    .rx_ds3_out                      (rx_ds3_out),             
    .rx_ds4_out                      (rx_ds4_out),             
    .rx_eav_out                      (rx_eav_out),             
    .rx_sav_out                      (rx_sav_out),             
    .rx_trs_out                      (rx_trs_out),             
    .rx_edh_errcnt_en_in             (rx_edh_errcnt_en_in),    
    .rx_edh_clr_errcnt_in            (rx_edh_clr_errcnt_in),   
    .rx_edh_ap_out                   (rx_edh_ap_out),          
    .rx_edh_ff_out                   (rx_edh_ff_out),          
    .rx_edh_anc_out                  (rx_edh_anc_out),         
    .rx_edh_ap_flags_out             (rx_edh_ap_flags_out),    
    .rx_edh_ff_flags_out             (rx_edh_ff_flags_out),    
    .rx_edh_anc_flags_out            (rx_edh_anc_flags_out),   
    .rx_edh_packet_flags_out         (rx_edh_packet_flags_out),
    .rx_edh_errcnt_out               (rx_edh_errcnt_out),      
    .rx_change_done_out              (rx_change_done_out),     
    .rx_change_fail_out              (rx_change_fail_out),     
    .rx_change_fail_code_out         (rx_change_fail_code_out),

    .tx_rst_in                       (tx_rst_in),              
    .tx_fabric_rst_out               (tx_fabric_rst_out),          
    .tx_usrclk_out                   (tx_usrclk_out),          
    .tx_ce_in                        (tx_ce_in),               
    .tx_sd_ce_in                     (tx_sd_ce_in),            
    .tx_edh_ce_in                    (tx_edh_ce_in),           
    .tx_mode_in                      (tx_mode_in),             
    .tx_m_in                         (tx_m_in),                
    .tx_insert_crc_in                (tx_insert_crc_in),       
    .tx_insert_ln_in                 (tx_insert_ln_in),        
    .tx_insert_st352_in              (tx_insert_st352_in),     
    .tx_overwrite_st352_in           (tx_overwrite_st352_in),  
    .tx_insert_edh_in                (tx_insert_edh_in),       
    .tx_mux_pattern_in               (tx_mux_pattern_in),      
    .tx_insert_sync_bit_in           (tx_insert_sync_bit_in),  
    .tx_line_0_in                    (tx_line_0_in),         
    .tx_line_1_in                    (tx_line_1_in),         
    .tx_st352_line_f1_in             (tx_st352_line_f1_in),    
    .tx_st352_line_f2_in             (tx_st352_line_f2_in),    
    .tx_st352_f2_en_in               (tx_st352_f2_en_in), 
    .tx_st352_data_0_in              (tx_st352_data_0_in),   
    .tx_st352_data_1_in              (tx_st352_data_1_in),   
    .tx_ds1_in                       (tx_ds1_in),              
    .tx_ds2_in                       (tx_ds2_in),              
    .tx_ds3_in                       (tx_ds3_in),              
    .tx_ds4_in                       (tx_ds4_in),              
    .tx_ds1_st352_out                (tx_ds1_st352_out),       
    .tx_ds2_st352_out                (tx_ds2_st352_out),       
    .tx_ds3_st352_out                (tx_ds3_st352_out),       
    .tx_ds4_st352_out                (tx_ds4_st352_out),       
    .tx_ds1_anc_in                   (tx_ds1_anc_in),          
    .tx_ds2_anc_in                   (tx_ds2_anc_in),          
    .tx_ds3_anc_in                   (tx_ds3_anc_in),          
    .tx_ds4_anc_in                   (tx_ds4_anc_in),          
    .tx_use_anc_in                   (tx_use_anc_in),          
    .tx_ce_align_err_out             (tx_ce_align_err_out),    
    .tx_slew_out                     (tx_slew_out),            
    .tx_change_done_out              (tx_change_done_out),     
    .tx_change_fail_out              (tx_change_fail_out),     
    .tx_change_fail_code_out         (tx_change_fail_code_out),

    .drp_fail_out                    (drp_fail_out),           
    .drp_fail_cnt_out                (drp_fail_cnt_out),       

    .gth_wiz_reset_all_in                 (gth_wiz_reset_all_in),   
    .gth_wiz_reset_tx_pll_and_datapath_in (gth_wiz_reset_tx_pll_and_datapath_in),
    .gth_wiz_reset_rx_pll_and_datapath_in (gth_wiz_reset_rx_pll_and_datapath_in),
    .gth_wiz_txresetdone_out              (gth_wiz_txresetdone_out),
    .gth_wiz_rxresetdone_out              (gth_wiz_rxresetdone_out),
    .gth_drpclk_in                        (gth_drpclk_in),          
    .gth_qpll0_clk_in                     (gth_qpll0_clk_out),       
    .gth_qpll0_refclk_in                  (gth_qpll0_refclk_out),    
    .gth_qpll0_lock_in                    (gth_qpll0_lock_out),      
    .gth_qpll1_clk_in                     (gth_qpll1_clk_out),       
    .gth_qpll1_refclk_in                  (gth_qpll1_refclk_out),    
    .gth_qpll1_lock_in                    (gth_qpll1_lock_out),      
    .gth_cpll_refclk_in                   (gth_cpll_refclk_out),     
    .gth_cpll_lock_out                    (gth_cpll_lock_out),      
    .gth_rxn_in                           (gth_rxn_in),             
    .gth_rxp_in                           (gth_rxp_in),             
    .gth_txn_out                          (gth_txn_out),            
    .gth_txp_out                          (gth_txp_out)            
);

generate
    if(TXPLLCLKSEL_TX_M_0 == 2'b00 || TXPLLCLKSEL_TX_M_1 == 2'b00 || RXPLLCLKSEL_RX_M_0 == 2'b00 || RXPLLCLKSEL_RX_M_1 == 2'b00)
        begin
            IBUFDS_GTE4 CPLL_CLK (
                .I          (gth_cpll_refclk_p_in),
                .IB         (gth_cpll_refclk_n_in),
                .CEB        (1'b0),
                .O          (gth_cpll_refclk_out),
                .ODIV2      ());
                
            assign gtrefclk00 = 1'b0;
        end                
    else
        begin
//            IBUFDS_GTE4 QPLL0_CLK (
//                .I          (gth_qpll0_refclk_p_in),
//                .IB         (gth_qpll0_refclk_n_in),
//                .CEB        (1'b0),
//                .O          (gtrefclk00),
//                .ODIV2      ());
                
//            assign gth_cpll_refclk_out = 1'b0;
        end                
endgenerate

//IBUFDS_GTE4 QPLL1_CLK (
//    .I          (gth_qpll1_refclk_p_in),
//    .IB         (gth_qpll1_refclk_n_in),
//    .CEB        (1'b0),
//    .O          (gtrefclk01),
//    .ODIV2      ());

	
//GTHE4_COMMON #(
//  .BIAS_CFG0           (16'b0000000000000000),
//  .BIAS_CFG1           (16'b0000000000000000),
//  .BIAS_CFG2           (16'b0000000000000000),
//  .BIAS_CFG3           (16'b0000000001000000),
//  .BIAS_CFG4           (16'b0000000000000000),
//  .BIAS_CFG_RSVD       (10'b0000000000),
//  .COMMON_CFG0         (16'b0000000000000000),
//  .COMMON_CFG1         (16'b0000000000000000),
//  .POR_CFG             (16'b0000000000000100),
//  .QPLL0_CFG0          (16'b0011000000011100),
//  .QPLL0_CFG1          (16'b0000000000011000),
//  .QPLL0_CFG1_G3       (16'b0000000000011000),
//  .QPLL0_CFG2          (16'b0000000001001000),
//  .QPLL0_CFG2_G3       (16'b0000000001001000),
//  .QPLL0_CFG3          (16'b0000000100100000),
//  .QPLL0_CFG4          (16'b0000000000001001),
//  .QPLL0_CP            (10'b0000011111),
//  .QPLL0_CP_G3         (10'b1111111111),
//  .QPLL0_FBDIV         (80),
//  .QPLL0_FBDIV_G3      (80),
//  .QPLL0_INIT_CFG0     (16'b0000000000000000),
//  .QPLL0_INIT_CFG1     (8'b00000000),
//  .QPLL0_LOCK_CFG      (16'b0010010111101000),
//  .QPLL0_LOCK_CFG_G3   (16'b0010010111101000),
//  .QPLL0_LPF           (10'b1111111111),
//  .QPLL0_LPF_G3        (10'b0000010101),
//  .QPLL0_REFCLK_DIV    (1),
//  .QPLL0_SDM_CFG0      (16'b0000000000000000),
//  .QPLL0_SDM_CFG1      (16'b0000000000000000),
//  .QPLL0_SDM_CFG2      (16'b0000000000000000),
//  .QPLL1_CFG0          (16'b0011000000011100),
//  .QPLL1_CFG1          (16'b0000000000011000),
//  .QPLL1_CFG1_G3       (16'b0000000000011000),
//  .QPLL1_CFG2          (16'b0000000001000000),
//  .QPLL1_CFG2_G3       (16'b0000000001000000),
//  .QPLL1_CFG3          (16'b0000000100100000),
//  .QPLL1_CFG4          (16'b0000000000001001),
//  .QPLL1_CP            (10'b0000011111),
//  .QPLL1_CP_G3         (10'b1111111111),
//  .QPLL1_FBDIV         (80),
//  .QPLL1_FBDIV_G3      (80),
//  .QPLL1_INIT_CFG0     (16'b0000000000000000),
//  .QPLL1_INIT_CFG1     (8'b00000000),
//  .QPLL1_LOCK_CFG      (16'b0010010111101000),
//  .QPLL1_LOCK_CFG_G3   (16'b0010010111101000),
//  .QPLL1_LPF           (10'b1111111111),
//  .QPLL1_LPF_G3        (10'b0000010101),
//  .QPLL1_REFCLK_DIV    (1),
//  .QPLL1_SDM_CFG0      (16'b0000000000000000),
//  .QPLL1_SDM_CFG1      (16'b0000000000000000),
//  .QPLL1_SDM_CFG2      (16'b0000000000000000),
//  .RSVD_ATTR0          (16'b0000000000000000),
//  .RSVD_ATTR1          (16'b0000000000000000),
//  .RSVD_ATTR2          (16'b0000000000000000),
//  .RSVD_ATTR3          (16'b0000000000000000),
//  .RXRECCLKOUT0_SEL    (2'b00),
//  .RXRECCLKOUT1_SEL    (2'b00),
//  .SARC_EN             (1'b1),
//  .SARC_SEL            (1'b0),
//  .SDM0DATA1_0         (16'b0000000000000000),
//  .SDM0DATA1_1         (9'b000000000),
//  .SDM0INITSEED0_0     (16'b0000000000000000),
//  .SDM0INITSEED0_1     (9'b000000000),
//  .SDM0_DATA_PIN_SEL   (1'b0),
//  .SDM0_WIDTH_PIN_SEL  (1'b0),
//  .SDM1DATA1_0         (16'b0000000000000000),
//  .SDM1DATA1_1         (9'b000000000),
//  .SDM1INITSEED0_0     (16'b0000000000000000),
//  .SDM1INITSEED0_1     (9'b000000000),
//  .SDM1_DATA_PIN_SEL   (1'b0),
//  .SDM1_WIDTH_PIN_SEL  (1'b0),
//  .SIM_RESET_SPEEDUP   ("TRUE"),
//  .SIM_VERSION         (1)
//) GTHE4_COMMON_PRIM_INST (
//  .BGBYPASSB         (1'b1),
//  .BGMONITORENB      (1'b1),
//  .BGPDB             (1'b1),
//  .BGRCALOVRD        (5'b11111),
//  .BGRCALOVRDENB     (1'b1),
//  .DRPADDR           (9'b000000000),
//  .DRPCLK            (1'b0),
//  .DRPDI             (16'b0000000000000000),
//  .DRPEN             (1'b0),
//  .DRPWE             (1'b0),
//  .GTGREFCLK0        (1'b0),
//  .GTGREFCLK1        (1'b0),
//  .GTNORTHREFCLK00   (1'b0),
//  .GTNORTHREFCLK01   (1'b0),
//  .GTNORTHREFCLK10   (1'b0),
//  .GTNORTHREFCLK11   (1'b0),
//  .GTREFCLK00        (gtrefclk00),
//  .GTREFCLK01        (gtrefclk00),
//  .GTREFCLK10        (gtrefclk01),
//  .GTREFCLK11        (gtrefclk01),
//  .GTSOUTHREFCLK00   (1'b0),
//  .GTSOUTHREFCLK01   (1'b0),
//  .GTSOUTHREFCLK10   (1'b0),
//  .GTSOUTHREFCLK11   (1'b0),
//  .PMARSVD0          (8'b00000000),
//  .PMARSVD1          (8'b00000000),
//  .QPLL0CLKRSVD0     (1'b0),
//  .QPLL0CLKRSVD1     (1'b0),
//  .QPLL0LOCKDETCLK   (1'b0),
//  .QPLL0LOCKEN       (1'b1),
//  .QPLL0PD           (1'b0),
//  .QPLL0REFCLKSEL    (3'b001),
//  .QPLL0RESET        (gth_qpll0_reset_in),
//  .QPLL1CLKRSVD0     (1'b0),
//  .QPLL1CLKRSVD1     (1'b0),
//  .QPLL1LOCKDETCLK   (1'b0),
//  .QPLL1LOCKEN       (1'b1),
//  .QPLL1PD           (1'b0),
//  .QPLL1REFCLKSEL    (3'b010),
//  .QPLL1RESET        (gth_qpll1_reset_in),
//  .QPLLRSVD1         (8'b00000000),
//  .QPLLRSVD2         (5'b00000),
//  .QPLLRSVD3         (5'b00000),
//  .QPLLRSVD4         (8'b00000000),
//  .RCALENB           (1'b1),

//  .DRPDO             (),
//  .DRPRDY            (),
//  .PMARSVDOUT0       (),
//  .PMARSVDOUT1       (),
//  .QPLL0FBCLKLOST    (),
//  .QPLL0LOCK         (gth_qpll0_lock_out),   
//  .QPLL0OUTCLK       (gth_qpll0_clk_out),
//  .QPLL0OUTREFCLK    (gth_qpll0_refclk_out),  
//  .QPLL0REFCLKLOST   (),
//  .QPLL1FBCLKLOST    (),
//  .QPLL1LOCK         (gth_qpll1_lock_out),  
//  .QPLL1OUTCLK       (gth_qpll1_clk_out),
//  .QPLL1OUTREFCLK    (gth_qpll1_refclk_out),
//  .QPLL1REFCLKLOST   (),
//  .QPLLDMONITOR0     (),
//  .QPLLDMONITOR1     (),
//  .REFCLKOUTMONITOR0 (),
//  .REFCLKOUTMONITOR1 (),
//  .RXRECCLK0_SEL     (),
//  .RXRECCLK1_SEL     ()

//);	
	
endmodule

    
