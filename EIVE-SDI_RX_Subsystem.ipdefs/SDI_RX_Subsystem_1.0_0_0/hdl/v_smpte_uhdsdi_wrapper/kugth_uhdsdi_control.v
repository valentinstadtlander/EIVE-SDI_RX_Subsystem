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
// /___/  \  /    Vendor: Xilinx
// \   \   \/     Version: $Revision: #1 $
//  \   \         
//  /   /         Filename: $File: uhdsdi_control.v $
// /___/   /\     Timestamp: $DateTime: 2013/10/22 10:29:23 $
// \   \  /  \
//  \___\/\___\
//
// Description:
//  This module implements the GTH specific logic to be used when implementing
//  SDI interfaces with Ultrascale GTH transceiver. The functions implemented by
//  this control module are:
//      GTH PLL reset logic
//      GTH RX reset logic, including holding RXRATE at 000 until GTH is initialized
//      GTH TX reset logic
//      GTH TXPLLCLKSEL and TXRATE dynamic change sequence logic
//      GTH RXCDR_CFG and RXOUT_DIV attribute dynamic change through DRP to 
//        match SDI mode
//      NI-DRU for recovering SD-SDI data at 270 Mb/s
//      RX bit rate detection
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

`timescale 1 ns / 1 ns

module kugth_uhdsdi_control #( 
    parameter TX_INPUT_SETTLE_BITWIDTH  = 7,        // TX Settle Time MSB	
    parameter TX_GT_RESET_TIMEOUT_MSB   = 10,       // MSB of GT TX DRP timeout counter
    parameter TX_RETRY_CNTR_MSB         = 8,        // MSB of TX retry counter
    parameter TXPLLCLKSEL_TX_M_0        = 2'b00,    // Value to output on TXPLLCLKSEL when tx_m is 0
    parameter TXPLLCLKSEL_TX_M_1        = 2'b10,    // Value to output on TXPLLCLKSEL when tx_m is 1
    parameter TX_M_0_QPLL               = 1'b0,     // PLL clock source for tx_m=0 QPLL (1) or CPLL (0) -- Default to CPLL
    parameter TX_M_1_QPLL               = 1'b1,     // PLL clock source for tx_m=1 QPLL (1) or CPLL (0) -- Default to QPLL
    parameter RX_FXDCLK_FREQ            = 27000000, // Frequency, in hertz, of fxdclk
    parameter RX_INPUT_SETTLE_BITWIDTH  = 5,        // RX Settle Time MSB
    parameter RX_GT_RESET_TIMEOUT_MSB   = 10,       // MSB of GTRX DRP timeout counter
    parameter RX_RETRY_CNTR_MSB         = 8,        // MSB of RX retry counter
    parameter RXPLLCLKSEL_RX_M_0        = 2'b10,    // Value to output on RXPLLCLKSEL when rx_m is 0
    parameter RXPLLCLKSEL_RX_M_1        = 2'b10,    // Value to output on RXPLLCLKSEL when rx_m is 1
    parameter RX_M_0_QPLL               = 1'b1,     // PLL clock source for tx_m=0 QPLL (1) or CPLL (0) -- Default to QPLL
    parameter RX_M_1_QPLL               = 1'b1,     // PLL clock source for tx_m=1 QPLL (1) or CPLL (0) -- Default to QPLL
    parameter DRP_WR_VERIFY_BYPASS      = 1,        // Bypass DRP write data verificaftion
    parameter DRP_TIMEOUT_MSB           = 10 ,      // MSB of DRP timeout counter
    parameter DRP_RETRY_CNTR_MAX        = 8,        // If serial clock is from QPLL, set this parameter to 1, from CPLL, set to 0
    parameter integer INCLUDE_NIDRU     = 1,        // include nidru or not
    parameter EN_HOT_PLUG_LOGIC         = 0         // Enable hot-plug logic
)
(
  input wire qpll0reset_in, 
  input wire qpll0lock_in, 
  input wire qpll1reset_in, 
  input wire qpll1lock_in, 
  input wire cpllreset_in, 
  input wire cplllock_in, 
// TX related signals                                                                                               (clock domain)
    input   wire        tx_rst_in,                  // sync reset for SDI TX data path
    input   wire        txclk_ready,
    input   wire        tx_usrclk_in,               // Connect to same clock as drives GTH TXUSRCLK2
    input   wire [2:0]  tx_mode_in,                 // 000 = HD, 001 = SD, 010 = 3G, 100 = 6G, 101 = 12G/1000, 110 = 12G/1001 (txusrclk)
    input   wire        tx_m_in,                    // TX bit rate select (0=1000/1000, 1=1000/1001)                (async)
    output  wire        tx_fabric_rst_out,          // SDI TX fabric reset                                          (txusrclk)
    input   wire        tx_resetdone_in,            // Connect to the TXRESETDONE port of the GTH                   (async)
    output  wire [1:0]  tx_pllclksel_out,           // Connect to TXPLLCLKSEL input of GTH                          (drpclk)
    output  reg         tx_slew_out = 1'b0,         // Slew rate control signal for SDI cable driver                (txusrclk)
    output  wire        tx_change_done_out,         // 1 when txrate or txpllclksel changes are complete            (drpclk)
    output  wire        tx_change_fail_out,         // 1 when txrate or txpllclksel changes fail                    (drpclk)
    output  wire [2:0]  tx_change_fail_code_out,    // TX change failure code
    output  wire        gttxreset_out,              // Connect to GTTXRESET input of GTH                            (drpclk)

// RX related signals
    input   wire        rx_rst_in,                  // sync reset for SDI RX data path
    input   wire        rxclk_ready,
    input   wire        rx_usrclk_in,               // Connect to same clock as drives GTH RXUSRCLK2
    input   wire        rx_fxdclk_in,               // Used for RX bit rate detection (usually same as drpclk)
    input   wire        rx_mode_locked_in,          // rx_mode locked indication (rxusrclk)
    input   wire        rx_trs_in,                  // RX TRS (rxusrclk)
    input   wire [2:0]  rx_mode_in,                 // 000 = HD, 001 = SD, 010 = 3G, 100 = 6G, 101 = 12G/1000, 110 = 12G/1001 (rxusrclk)
	output  wire        rx_m_out,                   // Indicates received bit rate: 1=/1.001 rate, 0 = /1 rate      (rxusrclk)
    output  wire        rx_fabric_rst_out,          // SDI RX fabric reset                                          (rxusrclk)
    input   wire        rx_resetdone_in,            // Connect to RXRESETDONE port of the GTH                       (async)
    output  wire [1:0]  rx_pllclksel_out,           // Connect to RXPLLCLKSEL input of GTH                          (drpclk)
    output  wire        rx_cdrhold_out,             // Connect to RXCDRHOLD port of GTH                             (drpclk)
    output  wire        rx_change_done_out,         // 1 when rx_mode change has completed successfully             (drpclk)
    output  wire        rx_change_fail_out,         // 1 when rx_mode change failed                                 (drpclk)
    output  wire [2:0]  rx_change_fail_code_out,    // RX change failure code
    output  wire        gtrxreset_out,              // Connect to GTRXRESET input of GTH                            (drpclk)

// SD-SDI DRU signals
    input   wire [19:0] dru_data_in,                // 11X oversampled data input vector
    output  reg  [9:0]  sd_data_out = 0,            // Recovered SD-SDI data
    output  wire        sd_data_strobe_out,         // Asserted high when an output data word is ready
    output  wire [19:0] recclk_txdata_out,          // Optional output data for recovering a clock using transmitter

// DRP signals -- Used for updatating GT attributes
    input   wire        drpclk_in,                  // Connect to GTH DRP clock
    input   wire        drprdy_in,                  // Connect to GTH DRPRDY port
    output  wire [9:0]  drpaddr_out,                // Connect to GTH DRPADDR port
    output  wire [15:0] drpdi_out,                  // Connect to GTH DRPDI port
    input   wire [15:0] drpdo_in,	            // Connect to GTH DRPDO port
    output  wire        drpen_out,                  // Connect to GTH DRPEN port
    output  wire        drpwe_out,                  // Connect to GTH DRPWE port
    output  wire [4:0]  tx_state,
    output  wire [4:0]  rx_state,
    output  wire        drp_fail_out,               // DRP Fail Indicator
    output  wire [7:0]  drp_fail_cnt_out            // DRP Fail Count
);

//UHD-SDI MODES 
localparam MODE_SD	  = 3'b001;
localparam MODE_HD	  = 3'b000;
localparam MODE_3G	  = 3'b010;
localparam MODE_6G	  = 3'b100;
localparam MODE_12G_0	  = 3'b101;
localparam MODE_12G_1	  = 3'b110;

//
// Internal signal definitions
//
(* ASYNC_REG = "true" *) (* shift_extract = "{no}" *) reg rx_resetdone_d1_cdc_to = 1'b0;
(* ASYNC_REG = "true" *) (* shift_extract = "{no}" *) reg rx_resetdone_d2 = 1'b0;
(* ASYNC_REG = "true" *) (* shift_extract = "{no}" *) reg rx_resetdone_d3 = 1'b0;
    
reg  [2:0]    rxmode_reg = 3'b000;
reg           tx_resetdone_r;
reg           rx_resetdone_r;
wire [9:0]    dru_dout;
wire          dru_drdy;
reg           dru_enable = 1'b0;
wire [8:0]    drpaddr_int;
//
// DRP controller Signals
//
wire [8:0]    drp_tx_addr;	
wire [15:0]   drp_tx_wr_data;	
wire [15:0]   drp_tx_wr_data_mask;
wire          drp_tx_change_req;
wire          drp_tx_change_req_done;
wire          drp_tx_change_grant;
wire [8:0]    drp_rx_addr;	
wire [15:0]   drp_rx_wr_data;	
wire [15:0]   drp_rx_wr_data_mask;
wire          drp_rx_change_req;
wire          drp_rx_change_req_done;
wire          drp_rx_change_grant;
wire          drp_done;
wire          rx_m_out_int;

assign drpaddr_out[9] = 1'b0;
assign drpaddr_out[8:0] = drpaddr_int;

// This bit is sent in com_gt_sts bus which will be sampled in AXI-4 Lite
// Clock. FF will avoid CDC-10 warning (combo logic before synchronizer)
always @ (posedge rx_usrclk_in)
  rx_resetdone_r    <=  rx_resetdone_in;

always @ (posedge tx_usrclk_in)
  tx_resetdone_r    <=  tx_resetdone_in;

//-------------------------------------------------------------------
// Synchronization logic for rx_resetdone_in input
always @ (posedge drpclk_in)
begin
  rx_resetdone_d1_cdc_to    <=  rx_resetdone_r;
  rx_resetdone_d2           <=  rx_resetdone_d1_cdc_to; 
  rx_resetdone_d3           <=  rx_resetdone_d2; 
end

//------------------------------------------------------------------------------
// tx_slew rate output register
//
always @ (posedge tx_usrclk_in)
    tx_slew_out <= tx_mode_in == MODE_SD;

//------------------------------------------------------------------------------
// rxmode input register
//
always @ (posedge rx_usrclk_in)
    rxmode_reg <= rx_mode_in;

//------------------------------------------------------------------------------
// RX bit rate detection
//
// This logic distinguishes between the 1000/1000 and the 1000/1001 bit rates
// of the incoming SDI signal by timing the RXUSRCLK relative to a fixed
// frequency clk, fxdclk.
//
uhdsdi_rate_detect #(
    .REFCLK_FREQ     (RX_FXDCLK_FREQ))
RATE0 (
    .refclk                 (rx_fxdclk_in), //DRP clk
    .recvclk                (rx_usrclk_in),
    .rx_mode                (rxmode_reg),
    .enable                 (rx_resetdone_r),
    .enable_drpclk_sync     (rx_resetdone_d3),
    .rate                   (rx_m_out_int));

//------------------------------------------------------------------------------
// 11X oversampling data recovery unit for SD-SDI
//

//
// Only enable the DRU when in SD-SDI mode by generating a dru_enable clock
// enable. This saves power by disabling the DRU when it is not being used.
//
always @ (posedge rx_usrclk_in)
    if (rxmode_reg == MODE_SD)
        dru_enable <= 1'b1;
    else
        dru_enable <= 1'b0;

generate
    if (INCLUDE_NIDRU == 1)
    begin : GEN_NIDRU
       nidru_20_wrapper #(
           .S_MAX      (2))
       NIDRU (
           .DT_IN      (dru_data_in),
           .CENTER_F   (37'b0000111010001101011111110100101111011),
           .EN         (dru_enable),
           .G1         (5'b00110),
           .G1_P       (5'b10000),
           .G2         (5'b00111),
           .CLK        (rx_usrclk_in),
           .PH_OUT     (),
           .INTEG      (),
           .DIRECT     (),
           .CTRL       (),
           .AL_PPM     (),
           .RST        (rx_rst_in),
           .RST_FREQ   (1'b0),
           .EN_INTEG   (1'b1),
           .PH_EST_DIS (1'b0),
           .VER        (),
           .RECCLK     (recclk_txdata_out),
           .SAMV       (),
           .SAM        (),
           .EN_OUT     (dru_drdy),
           .DOUT       (dru_dout));
        
       always @ (posedge rx_usrclk_in)
           if (dru_drdy)
               sd_data_out <= dru_dout;
       assign sd_data_strobe_out = dru_drdy;
	 end  else begin : NO_NIDRU  
       always @ (posedge rx_usrclk_in)
           if (dru_drdy)
               sd_data_out <= 0;
       assign sd_data_strobe_out = 0; 
       assign recclk_txdata_out = 0; 
	 end
endgenerate

//
// sdi_drp_control
//
// This module controls DRP write cycles to change the RXCDR_CFG and RXOUT_DIV 
// attributes of the GTH whenever the rxmode input changes. It also controls 
// RXRATE and RXCDRHOLD appropriately for rxmode changes.
//
kugth_uhdsdi_drp_control #(
	.DRP_WR_VERIFY_BYPASS   (DRP_WR_VERIFY_BYPASS),
	.DRP_TIMEOUT_MSB		(DRP_TIMEOUT_MSB),
	.DRP_RETRY_CNTR_MAX		(DRP_RETRY_CNTR_MAX)
	)
DRPCTRL (
    //.rst                         (tx_fabric_rst_out & rx_fabric_rst_out),
    .rst                         (1'b0),
    
    .drpclk_in                   (drpclk_in),
    .drpaddr_out                 (drpaddr_int),
    .drpadi_out                  (drpdi_out),
    .drpen_out                   (drpen_out),
    .drpwe_out                   (drpwe_out),
    .drpado_in                   (drpdo_in),
    .drprdy_in                   (drprdy_in),

    .drp_rd_data_out             (),
    .drp_done_out                (drp_done),
    .drp_wr_fail_out             (drp_fail_out),
    .drp_wr_fail_cnt_out         (drp_fail_cnt_out),

    .drp_tx_addr_in              (drp_tx_addr),
    .drp_tx_wr_data_in           (drp_tx_wr_data),
    .drp_tx_wr_data_mask_in      (drp_tx_wr_data_mask),
    .drp_tx_change_req_in        (drp_tx_change_req),
    .drp_tx_change_req_done_in   (drp_tx_change_req_done),
    .drp_tx_change_grant_out     (drp_tx_change_grant),

    .drp_rx_addr_in              (drp_rx_addr),
    .drp_rx_wr_data_in           (drp_rx_wr_data),
    .drp_rx_wr_data_mask_in      (drp_rx_wr_data_mask),
    .drp_rx_change_req_in        (drp_rx_change_req),
    .drp_rx_change_req_done_in   (drp_rx_change_req_done),
    .drp_rx_change_grant_out     (drp_rx_change_grant)
	);



//------------------------------------------------------------------------------
// TX control logic
//
// This module controls the TXOUT_DIV, TXPLLCLKSEL, GTTXRESET, and PLLRESET signals
// in order to initialize the GTH TX and to change the SDI mode and the clock
// source of the GTH TX.
//

kugth_uhdsdi_tx_control #(
    .TX_INPUT_SETTLE_BITWIDTH (TX_INPUT_SETTLE_BITWIDTH),
	.TX_GT_RESET_TIMEOUT_MSB  (TX_GT_RESET_TIMEOUT_MSB),
    .TX_RETRY_CNTR_MSB        (TX_RETRY_CNTR_MSB),
	.TXPLLCLKSEL_TX_M_0       (TXPLLCLKSEL_TX_M_0),
	.TXPLLCLKSEL_TX_M_1       (TXPLLCLKSEL_TX_M_1),
	.TX_M_0_QPLL		      (TX_M_0_QPLL),
	.TX_M_1_QPLL		      (TX_M_1_QPLL)
	)
TXCTRL (
    .qpll0reset_in (qpll0reset_in),
    .qpll0lock_in (qpll0lock_in),
    .qpll1reset_in (qpll1reset_in),
    .qpll1lock_in (qpll1lock_in),
    .cpllreset_in (cpllreset_in), 
    .cplllock_in (cplllock_in), 
    .rst_in                   (~txclk_ready), 
    .drpclk_in                (drpclk_in),

	.txusrclk_in              (tx_usrclk_in),
    .txmode_in                (tx_mode_in),
    .tx_m_in                  (tx_m_in),
    .tx_fabric_rst_out        (tx_fabric_rst_out),

	.drp_done_in              (drp_done),
    .drp_addr_out             (drp_tx_addr),
    .drp_wr_data_out          (drp_tx_wr_data),
    .drp_wr_data_mask_out     (drp_tx_wr_data_mask),
    .drp_wr_fail_in           (drp_fail_out),
    .drp_change_req_out       (drp_tx_change_req),
    .drp_change_grant_in      (drp_tx_change_grant),
    .drp_change_req_done_out  (drp_tx_change_req_done),

	.gt_tx_pllclksel_out      (tx_pllclksel_out),
    .gt_tx_datapath_reset_out (gttxreset_out),
    .gt_tx_reset_done_in      (tx_resetdone_r),

    .done_out              	  (tx_change_done_out),
    .tx_state (tx_state),
    .fail_out              	  (tx_change_fail_out),
    .fail_code_out         	  (tx_change_fail_code_out)

	);

//------------------------------------------------------------------------------
// RX control logic
//
// This logic controls the GTH GTRXRESET signal, the DRP of the GTH 
// to correctly reset the GTH RX and its associated PLL and 
// change the bit rate of the GTH in response to changes on the rxmode input. 
// These functions are all carefully sequenced so as to not cause conflicts on 
// the DRP which is also used by the state machines internal to the GTH wrapper.
//

//
// sdi_rx_reset_control
//
// This module controls resets of the GTH RX and the PLL in response to the
// assertion of the full_reset or gtrxreset_in signals.
//
    
kugth_uhdsdi_rx_control #(
    .RX_INPUT_SETTLE_BITWIDTH (RX_INPUT_SETTLE_BITWIDTH),
    .RX_GT_RESET_TIMEOUT_MSB  (RX_GT_RESET_TIMEOUT_MSB),
    .RX_RETRY_CNTR_MSB        (RX_RETRY_CNTR_MSB),
    .RXPLLCLKSEL_RX_M_0       (RXPLLCLKSEL_RX_M_0),
    .RXPLLCLKSEL_RX_M_1       (RXPLLCLKSEL_RX_M_1),
    .RX_M_0_QPLL              (RX_M_0_QPLL),
    .RX_M_1_QPLL              (RX_M_1_QPLL),
    .EN_HOT_PLUG_LOGIC        (EN_HOT_PLUG_LOGIC)
)
RXCTRL (
    .qpll0reset_in (qpll0reset_in),
    .qpll0lock_in (qpll0lock_in),
    .qpll1reset_in (qpll1reset_in),
    .qpll1lock_in (qpll1lock_in),
    .cpllreset_in (cpllreset_in), 
    .cplllock_in (cplllock_in), 
    .rst_in                   (~rxclk_ready),
    .drpclk_in                (drpclk_in),

	.rxusrclk_in              (rx_usrclk_in),
    .rx_mode_locked_in        (rx_mode_locked_in),
    .rx_trs_in                (rx_trs_in),
    .rx_mode_in               (rx_mode_in),
    .rx_m_in                  (rx_m_out),
    .rx_fabric_rst_out        (rx_fabric_rst_out),

	.drp_done_in              (drp_done),
    .drp_addr_out             (drp_rx_addr),
    .drp_wr_data_out          (drp_rx_wr_data),
    .drp_wr_data_mask_out     (drp_rx_wr_data_mask),
    .drp_wr_fail_in           (drp_fail_out),
    .drp_change_req_out       (drp_rx_change_req),
    .drp_change_grant_in      (drp_rx_change_grant),
    .drp_change_req_done_out  (drp_rx_change_req_done),

	.gt_rx_pllclksel_out      (rx_pllclksel_out),
	.gt_rx_cdrhold_out        (rx_cdrhold_out),
    .gt_rx_datapath_reset_out (gtrxreset_out),
    .gt_rx_reset_done_in      (rx_resetdone_d3),

    .done_out              	  (rx_change_done_out),
    .rx_state (rx_state),
    .fail_out                 (rx_change_fail_out),
    .fail_code_out            (rx_change_fail_code_out)

    );

sync_block SYNC_RX_BIT_RATE (
	.clk	(rx_usrclk_in),
	.din	(rx_m_out_int),
	.dout	(rx_m_out));
	
endmodule
