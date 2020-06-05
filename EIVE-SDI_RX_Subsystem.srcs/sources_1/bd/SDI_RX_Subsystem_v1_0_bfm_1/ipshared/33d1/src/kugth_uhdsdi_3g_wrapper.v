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
//  This wrapper file includes a SMPTE SDI core and the GTH and corresponding control module.
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

module kugth_uhdsdi_3g_wrapper #(
    parameter TXPLLCLKSEL_TX_M_0              = 2'b11,         // Value to output on TXPLLCLKSEL when tx_m is 0; //CPLL=00, QPLL0=11, QPLL1=10 
    parameter TXPLLCLKSEL_TX_M_1              = 2'b10,         // Value to output on TXPLLCLKSEL when tx_m is 1; //CPLL=00, QPLL0=11, QPLL1=10 
    parameter RX_FXDCLK_FREQ                  = 27000000,      // Frequency, in hertz, of fxdclk
    parameter RXPLLCLKSEL_RX_M_0              = 2'b11,         // Value to output on RXPLLCLKSEL when rx_m is 0; //CPLL=00, QPLL0=11, QPLL1=10 
    parameter RXPLLCLKSEL_RX_M_1              = 2'b10,         // Value to output on RXPLLCLKSEL when rx_m is 1; //CPLL=00, QPLL0=11, QPLL1=10 
    parameter XY_SITE                         = "x1y4",       // GTH Location
    parameter EN_HOT_PLUG_LOGIC               = 0              // Enable hot-plug logic
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
    input   wire                        gth_qpll0_clk_in,                       // GTH CHANNEL QPLL0 Clock Input
    input   wire                        gth_qpll0_refclk_in,                    // GTH CHANNEL QPLL0 Ref Clock Input
    input   wire                        gth_qpll0_lock_in,                      // GTH CHANNEL QPLL0 Lock Input
    input   wire                        gth_qpll1_clk_in,                       // GTH CHANNEL QPLL1 Clock Input
    input   wire                        gth_qpll1_refclk_in,                    // GTH CHANNEL QPLL1 Ref Clock Input
    input   wire                        gth_qpll1_lock_in,                      // GTH CHANNEL QPLL1 Lock Input
    input   wire                        gth_cpll_refclk_in,                     // GTH CPLL Ref Clock Input
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
localparam DATA_WIDTH     = 20;
//
// Internal Signals
//
wire                    tx_rst_in_sync;
wire                    rx_rst_in_sync;
wire                    rx_edh_clr_errcnt_in_sync;
wire [ 9:0]            rx_sd_rxdata_int;
wire                   rx_sd_data_strobe_int;
wire                   rx_bit_rate;
wire [2:0]             rx_mode_int;

// GTH DRP Signals                                         
wire                   gth_drprdy_int;  
wire [ 8:0]            gth_drpaddr_int; 
wire [15:0]            gth_drpdi_int;   
wire [15:0]            gth_drpdo_int;   
wire                   gth_drpen_int;   
wire                   gth_drpwe_int;   

// RX GTH Signals                                          
reg  [DATA_WIDTH-1:0]  gth_rxdata_int;       
wire [DATA_WIDTH-1:0]  gth_rxdata_gt;       
wire                   gth_gtrxreset_int;    
wire [ 1:0]            gth_rxpllclksel_int;   
wire                   gth_rxcdrhold_int;    

// TX GTH Signals                                          
wire [DATA_WIDTH-1:0]  gth_txdata_int;        
wire                   gth_gttxreset_int;     
wire [ 1:0]            gth_txpllclksel_int;   
wire [ 1:0]            txbufstatus_int;   

wire                   qpll0reset_in;
wire                   qpll1reset_in;
//Sync reset_in to rx_usrclk
//always @ (posedge rx_usrclk_out)
//    rx_rst_in_sync <= {rx_rst_in_sync[1:0], rx_rst_in};
//
////Sync rx_edh_clr_errcnt_in to rx_usrclk
//always @ (posedge rx_usrclk_out)
//    rx_edh_clr_errcnt_in_sync <= {rx_edh_clr_errcnt_in_sync[1:0], rx_edh_clr_errcnt_in};
//
////Sync reset_in to tx_usrclk
//always @ (posedge tx_usrclk_out)
//    tx_rst_in_sync <= {tx_rst_in_sync[1:0], tx_rst_in};

sync_block #(
    .INITIALIZE(3'b111)
)
RX_RST_IN_SYNC_BLOCK_3G (
	.clk	(rx_usrclk_out),
	.din	(rx_rst_in),
	.dout	(rx_rst_in_sync));
sync_block #(
    .INITIALIZE(3'b111)
)RX_EDH_CLR_SYNC_BLOCK_3G (
	.clk	(rx_usrclk_out),
	.din	(rx_edh_clr_errcnt_in),
	.dout	(rx_edh_clr_errcnt_in_sync));
sync_block #(
    .INITIALIZE(3'b111)
)TX_RST_IN_SYNC_BLOCK_3G (
	.clk	(tx_usrclk_out),
	.din	(tx_rst_in),
	.dout	(tx_rst_in_sync));
//
// In 12G-SDI mode, the LSB of rx_mode_out indicates the bit rate. Otherwise use
// the rx_bit_rate input.
//
assign rx_bit_rate_out = rx_bit_rate;

//------------------------------------------------------------------------------
// SMPTE SDI core
//
v_smpte_uhdsdi_rxtx uhdsdirxtx (     
	.rx_clk          	(rx_usrclk_out),
	.rx_rst             (rx_rst_in_sync | rx_fabric_rst_out),
	.rx_mode_detect_rst (rx_mode_detect_rst_in),
	.rx_data_in         (gth_rxdata_int),
	.rx_sd_data_strobe  (rx_sd_data_strobe_int),
	.rx_frame_en        (1'b1),
	.rx_bit_rate        (rx_bit_rate_out),
	.rx_mode_enable     (rx_mode_en_in),
	.rx_mode_detect_en  (rx_mode_detect_en_in),
	.rx_forced_mode     (rx_forced_mode_in),
	.rx_ready           (rx_change_done_out),
	.rx_mode            (rx_mode_int),
	.rx_mode_hd         (rx_mode_hd_out),
	.rx_mode_sd         (rx_mode_sd_out),
	.rx_mode_3g         (rx_mode_3g_out),
	.rx_mode_locked     (rx_mode_locked_out),
	.rx_t_locked        (rx_t_locked_out),
	.rx_t_family        (rx_t_family_out),
	.rx_t_rate          (rx_t_rate_out),
	.rx_t_scan          (rx_t_scan_out),
	.rx_level_b_3g      (rx_level_b_3g_out),
	.rx_ce_out          (rx_ce_out),
	.rx_active_streams  (rx_active_streams_out),
	.rx_ln_ds1          (rx_line_0_out),
	.rx_ln_ds2          (),
	.rx_ln_ds3          (rx_line_1_out),
	.rx_ln_ds4          (),
	.rx_st352_0         (rx_st352_0_out),
	.rx_st352_0_valid   (rx_st352_0_valid_out),
	.rx_st352_1         (rx_st352_1_out),
	.rx_st352_1_valid   (rx_st352_1_valid_out),
	.rx_crc_err_ds1     (rx_crc_err_out[0]),
	.rx_crc_err_ds2     (rx_crc_err_out[1]),
	.rx_crc_err_ds3     (rx_crc_err_out[2]),
	.rx_crc_err_ds4     (rx_crc_err_out[3]),
	.rx_ds1             (rx_ds1_out),
	.rx_ds2             (rx_ds2_out),
	.rx_ds3             (rx_ds3_out),
	.rx_ds4             (rx_ds4_out),
	.rx_eav             (rx_eav_out),
	.rx_sav             (rx_sav_out),
	.rx_trs             (rx_trs_out),
	.rx_edh_errcnt_en   (rx_edh_errcnt_en_in),
	.rx_edh_clr_errcnt  (rx_edh_clr_errcnt_in_sync),
	.rx_edh_ap          (rx_edh_ap_out),
	.rx_edh_ff          (rx_edh_ff_out),
	.rx_edh_anc         (rx_edh_anc_out),
	.rx_edh_ap_flags    (rx_edh_ap_flags_out),
	.rx_edh_ff_flags    (rx_edh_ff_flags_out),
	.rx_edh_anc_flags   (rx_edh_anc_flags_out),
	.rx_edh_packet_flags(rx_edh_packet_flags_out),
	.rx_edh_errcnt      (rx_edh_errcnt_out),

	.tx_clk             (tx_usrclk_out),
	.tx_rst             (tx_rst_in_sync | tx_fabric_rst_out),
	.tx_ce              (tx_ce_in),
	.tx_sd_ce           (tx_sd_ce_in),
	.tx_edh_ce          (tx_edh_ce_in),
	.tx_mode            (tx_mode_in),
	.tx_insert_crc      (tx_insert_crc_in),
	.tx_insert_ln       (tx_insert_ln_in),
	.tx_insert_st352    (tx_insert_st352_in),
	.tx_overwrite_st352 (tx_overwrite_st352_in),
	.tx_insert_edh      (tx_insert_edh_in),
	.tx_mux_pattern     (tx_mux_pattern_in),
	.tx_insert_sync_bit (tx_insert_sync_bit_in),
	.tx_sd_bitrep_bypass(1'b0),
	.tx_line_ch0        (tx_line_0_in),
	.tx_line_ch1        (tx_line_1_in),
	.tx_st352_line_f1   (tx_st352_line_f1_in),
	.tx_st352_line_f2   (tx_st352_line_f2_in),
	.tx_st352_f2_en     (tx_st352_f2_en_in),
	.tx_st352_data_ch0  (tx_st352_data_0_in),
	.tx_st352_data_ch1  (tx_st352_data_1_in),
	.tx_ds1_in          (tx_ds1_in),
	.tx_ds2_in          (tx_ds2_in),
	.tx_ds3_in          (tx_ds3_in),
	.tx_ds4_in          (tx_ds4_in),
	.tx_ds1_st352_out   (tx_ds1_st352_out),
	.tx_ds2_st352_out   (tx_ds2_st352_out),
	.tx_ds3_st352_out   (tx_ds3_st352_out),
	.tx_ds4_st352_out   (tx_ds4_st352_out),
	.tx_ds1_anc_in      (tx_ds1_anc_in),
	.tx_ds2_anc_in      (tx_ds2_anc_in),
	.tx_ds3_anc_in      (tx_ds3_anc_in),
	.tx_ds4_anc_in      (tx_ds4_anc_in),
	.tx_use_anc_in      (tx_use_anc_in),
	.tx_txdata          (gth_txdata_int),
	.tx_ce_align_err    (tx_ce_align_err_out)
	);
	
assign rx_mode_out = rx_mode_int[1:0];

//------------------------------------------------------------------------------
// This module generates the GTTXRESET and GTRXRESET signals to the GTH. It
// also controls the RXCDRHOLD to place the CDR into lock to reference mode
// during SD-SDI mode. It also generates the RXRATE and TXRATE signals appropriately
// based on which SDI mode the RX and TX are in. Finally, it has a RX bit rate
// detection module that determines which bit rate is being received by the RX.
//
kugth_uhdsdi_control #(  //kugth_uhdsdi_control
	.TX_INPUT_SETTLE_BITWIDTH  (7), 
	.TX_GT_RESET_TIMEOUT_MSB   (10), 
	.TX_RETRY_CNTR_MSB         (8),        
	.TXPLLCLKSEL_TX_M_0        (TXPLLCLKSEL_TX_M_0),       
	.TXPLLCLKSEL_TX_M_1        (TXPLLCLKSEL_TX_M_1),       
	.TX_M_0_QPLL               (TXPLLCLKSEL_TX_M_0 == 2'b00 ? 1'b0 : 1'b1),              
	.TX_M_1_QPLL               (TXPLLCLKSEL_TX_M_1 == 2'b00 ? 1'b0 : 1'b1),            
	.RX_FXDCLK_FREQ            (RX_FXDCLK_FREQ),           
	.RX_INPUT_SETTLE_BITWIDTH  (5),
	.RX_GT_RESET_TIMEOUT_MSB   (10),
	.RX_RETRY_CNTR_MSB         (8),
	.RXPLLCLKSEL_RX_M_0        (RXPLLCLKSEL_RX_M_0),
	.RXPLLCLKSEL_RX_M_1        (RXPLLCLKSEL_RX_M_1),
	.RX_M_0_QPLL               (RXPLLCLKSEL_RX_M_0 == 2'b00 ? 1'b0 : 1'b1),
	.RX_M_1_QPLL               (RXPLLCLKSEL_RX_M_1 == 2'b00 ? 1'b0 : 1'b1),
	.DRP_WR_VERIFY_BYPASS      (1),
	.DRP_TIMEOUT_MSB           (10),
	.DRP_RETRY_CNTR_MAX        (8),
        .EN_HOT_PLUG_LOGIC         (EN_HOT_PLUG_LOGIC)
	)	
uhdsdi_kugth_ctrl (
	.tx_rst_in                 (tx_rst_in_sync),
	.tx_usrclk_in              (tx_usrclk_out),
	.tx_mode_in                ({1'b0, tx_mode_in}),
	.tx_m_in                   (tx_m_in),
	.tx_fabric_rst_out         (tx_fabric_rst_out),
	.tx_resetdone_in           (gth_wiz_txresetdone_out),
	.tx_pllclksel_out          (gth_txpllclksel_int),
	.tx_slew_out               (tx_slew_out),
	.tx_change_done_out        (tx_change_done_out),
	.tx_change_fail_out        (tx_change_fail_out),
	.tx_change_fail_code_out   (tx_change_fail_code_out),
	.gttxreset_out             (gth_gttxreset_int),

	.rx_rst_in                 (rx_rst_in_sync),
	.rx_usrclk_in              (rx_usrclk_out),
	.rx_fxdclk_in              (rx_fxdclk_in),
	.rx_mode_locked_in         (rx_mode_locked_out),
	.rx_trs_in                 (rx_trs_out),
	.rx_mode_in                (rx_mode_int),
	.rx_m_out                  (rx_bit_rate),
	.rx_fabric_rst_out         (rx_fabric_rst_out),
	.rx_resetdone_in           (gth_wiz_rxresetdone_out),
	.rx_pllclksel_out          (gth_rxpllclksel_int),
	.rx_cdrhold_out            (gth_rxcdrhold_int),
	.rx_change_done_out        (rx_change_done_out),
	.rx_change_fail_out        (rx_change_fail_out),
	.rx_change_fail_code_out   (rx_change_fail_code_out),
	.gtrxreset_out             (gth_gtrxreset_int),

	.dru_data_in               (gth_rxdata_gt[19:0]),
	.sd_data_out               (rx_sd_rxdata_int),
	.sd_data_strobe_out        (rx_sd_data_strobe_int),
	.recclk_txdata_out         (),

	.drpclk_in                 (gth_drpclk_in),
	.drprdy_in                 (gth_drprdy_int),
	.drpaddr_out               (gth_drpaddr_int),
	.drpdi_out                 (gth_drpdi_int),
	.drpdo_in                  (gth_drpdo_int),
	.drpen_out                 (gth_drpen_int),
	.drpwe_out                 (gth_drpwe_int),
	.drp_fail_out              (drp_fail_out),
	.drp_fail_cnt_out          (drp_fail_cnt_out),
    .qpll0reset_in            (qpll0reset_in), 
    .qpll0lock_in             (gth_qpll0_lock_in), 
    .qpll1reset_in            (qpll1reset_in), 
    .qpll1lock_in             (gth_qpll1_lock_in), 
    .cpllreset_in             (1'b0), 
    .cplllock_in              (gth_cpll_lock_out),
    .tx_state                 (),
    .rx_state                 (),
    .txclk_ready              (1'b1),
    .rxclk_ready              (1'b1)
);


always @ (posedge rx_usrclk_out)
	if (rx_mode_int == MODE_SD)
		gth_rxdata_int <= {{DATA_WIDTH-10 {1'b0}}, rx_sd_rxdata_int[9:0]};
	else
		gth_rxdata_int <= gth_rxdata_gt;

		
generate
    if (XY_SITE == "x1y4")
        v_smpte_uhdsdi_gtwiz uhdsdi_gtwiz_i (
        	.gthrxn_in                               (gth_rxn_in),
        	.gthrxp_in                               (gth_rxp_in),
        	.gthtxn_out                              (gth_txn_out),
        	.gthtxp_out                              (gth_txp_out),
        	.gtwiz_userclk_tx_reset_in               (1'b0),
        	.gtwiz_userclk_tx_srcclk_out             (),
        	.gtwiz_userclk_tx_usrclk_out             (tx_usrclk_out),
        	.gtwiz_userclk_tx_usrclk2_out            (),
        	.gtwiz_userclk_tx_active_out             (),
        	.gtwiz_userclk_rx_reset_in               (1'b0),
        	.gtwiz_userclk_rx_srcclk_out             (),
        	.gtwiz_userclk_rx_usrclk_out             (rx_usrclk_out),
        	.gtwiz_userclk_rx_usrclk2_out            (),
        	.gtwiz_userclk_rx_active_out             (),
        	.gtwiz_reset_clk_freerun_in              (gth_drpclk_in),
        	.gtwiz_reset_all_in                      (gth_wiz_reset_all_in),
        	.gtwiz_reset_tx_pll_and_datapath_in      (gth_wiz_reset_tx_pll_and_datapath_in),
        	.gtwiz_reset_tx_datapath_in              (gth_gttxreset_int),
        	.gtwiz_reset_rx_pll_and_datapath_in      (gth_wiz_reset_rx_pll_and_datapath_in),
        	.gtwiz_reset_rx_datapath_in              (gth_gtrxreset_int),
//        	.gtwiz_reset_qpll0lock_in                (gth_qpll0_lock_in), //remove of CPLL is used
//        	.gtwiz_reset_qpll1lock_in                (gth_qpll1_lock_in),
        	.gtwiz_reset_rx_cdr_stable_out           (),
        	.gtwiz_reset_tx_done_out                 (gth_wiz_txresetdone_out),
        	.gtwiz_reset_rx_done_out                 (gth_wiz_rxresetdone_out),
//        	.gtwiz_reset_qpll0reset_out              (qpll0reset_in),
//        	.gtwiz_reset_qpll1reset_out              (qpll1reset_in),
        	.gtwiz_userdata_tx_in                    (gth_txdata_int),
        	.gtwiz_userdata_rx_out                   (gth_rxdata_gt),
        
        	.drpaddr_in                              (gth_drpaddr_int[8:0]),
        	.drpclk_in                               (gth_drpclk_in),
        	.drpdi_in                                (gth_drpdi_int),
        	.drpen_in                                (gth_drpen_int),
        	.drpwe_in                                (gth_drpwe_int),
        	.drpdo_out                               (gth_drpdo_int),
        	.drprdy_out                              (gth_drprdy_int),
        	
        	.gtrefclk0_in                            (gth_cpll_refclk_in),
        	.cplllock_out                            (gth_cpll_lock_out),
//        	.qpll0clk_in                             (gth_qpll0_clk_in),
//        	.qpll0refclk_in                          (gth_qpll0_refclk_in),
//        	.qpll1clk_in                             (gth_qpll1_clk_in),
//        	.qpll1refclk_in                          (gth_qpll1_refclk_in),
        	.rxpllclksel_in                          (gth_rxpllclksel_int),
        	.txpllclksel_in                          (gth_txpllclksel_int),
        	.rxpmaresetdone_out                      (),
        	.txpmaresetdone_out                      (),
        	.txbufstatus_out                         (txbufstatus_int),
            .txpmareset_in                           (txbufstatus_int[1]),
        
        	.rxcdrhold_in                            (gth_rxcdrhold_int),
        	.rxdfeagcovrden_in                       (gth_rxcdrhold_int),
        	.rxdfelfovrden_in                        (gth_rxcdrhold_int),
        	.rxdfetap10ovrden_in                     (gth_rxcdrhold_int),
        	.rxdfetap11ovrden_in                     (gth_rxcdrhold_int),
        	.rxdfetap12ovrden_in                     (gth_rxcdrhold_int),
        	.rxdfetap13ovrden_in                     (gth_rxcdrhold_int),
        	.rxdfetap14ovrden_in                     (gth_rxcdrhold_int),
        	.rxdfetap15ovrden_in                     (gth_rxcdrhold_int),
        	.rxdfetap2ovrden_in                      (gth_rxcdrhold_int),
        	.rxdfetap3ovrden_in                      (gth_rxcdrhold_int),
        	.rxdfetap4ovrden_in                      (gth_rxcdrhold_int),
        	.rxdfetap5ovrden_in                      (gth_rxcdrhold_int),
        	.rxdfetap6ovrden_in                      (gth_rxcdrhold_int),
        	.rxdfetap7ovrden_in                      (gth_rxcdrhold_int),
        	.rxdfetap8ovrden_in                      (gth_rxcdrhold_int),
        	.rxdfetap9ovrden_in                      (gth_rxcdrhold_int),
        	.rxdfeutovrden_in                        (gth_rxcdrhold_int),
        
        	.rxlpmgcovrden_in                        (gth_rxcdrhold_int),
        	.rxlpmhfovrden_in                        (gth_rxcdrhold_int),
        	.rxlpmlfklovrden_in                      (gth_rxcdrhold_int),
        	.rxlpmosovrden_in                        (gth_rxcdrhold_int),
        	.rxosovrden_in                           (gth_rxcdrhold_int),
            .gtpowergood_out                         ()
        	
        );

	//Add more else if statements according to number if SDI channels needed
	
endgenerate	

endmodule

    
