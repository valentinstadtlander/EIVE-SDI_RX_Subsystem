// (c) Copyright 2013 Xilinx, Inc. All rights reserved.
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
// \   \   \/     
//  \   \         
//  /   /         
// /___/   /\     
// \   \  /  \
//  \___\/\___\
//
// Description:
//  This module modifies attributes in the GTH transceiver in response to 
//  changes in the TX SDI mode and bit rate. This module is specifically designed 
//  to support SDI interfaces implemented in the GTH. It changes the TXPLLCLKSEL, 
//  TXOUT_DIV, TXDATA_WIDTH, TXINT_DATAWIDTH attributes when the 
//  tx_mode and tx_m input changes.
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

module kugth_uhdsdi_tx_control #( 
	parameter TX_INPUT_SETTLE_BITWIDTH  = 5,           // TX Settle Time MSB
	parameter TX_GT_RESET_TIMEOUT_MSB   = 10,          // MSB of GT TX DRP timeout counter
    parameter TX_RETRY_CNTR_MSB         = 8,           // MSB of TX retry counter
    parameter TXPLLCLKSEL_TX_M_0        = 2'b00,       // Value to output on TXPLLCLKSEL when tx_m is 0
    parameter TXPLLCLKSEL_TX_M_1        = 2'b10,       // Value to output on TXPLLCLKSEL when tx_m is 1
    parameter TX_M_0_QPLL               = 1'b0,        // PLL clock source for tx_m=0 QPLL (1) or CPLL (0) -- Default to CPLL
    parameter TX_M_1_QPLL               = 1'b1         // PLL clock source for tx_m=1 QPLL (1) or CPLL (0) -- Default to QPLL
) 
(
    input   wire        rst_in,                        // module reset                                             (async)
    input   wire        drpclk_in,                     // Fixed frequency clock                                    (drpclk)

   input wire qpll0reset_in, 
   input wire qpll0lock_in, 
   input wire qpll1reset_in, 
   input wire qpll1lock_in, 
   input wire cpllreset_in, 
   input wire cplllock_in, 

    //SDI Interface
	input   wire        txusrclk_in,                   // TXUSRCLK                                                 (txusrclk)
    input    wire [2:0]  txmode_in,                     // TX SDI mode                                              (txusrclk)
    input    wire        tx_m_in,                       // TX bit rate select (0=1000/1000, 1=1000/1001)            (async)
    output  wire        tx_fabric_rst_out,             // SDI TX fabric reset                                      (txusrclk)

    //GT DRP Control Interface
     input    wire        drp_done_in,                   // DRP CTRL done                                            (drpclk)
     output   reg   [8:0] drp_addr_out,                  // DRP address to access                                    (drpclk)
      output  reg  [15:0] drp_wr_data_out,               // Write data                                               (drpclk)
      output  reg  [15:0] drp_wr_data_mask_out,          // Mask to indicate bits to be written                      (drpclk)
     input   wire        drp_wr_fail_in,                // DRP write fail                                           (drpclk)
     output   reg         drp_change_req_out,            // DRP change request                                       (drpclk)
     input  wire        drp_change_grant_in,           // DRP change grant                                         (drpclk)
    output   reg         drp_change_req_done_out,       // DRP change done                                          (drpclk)

	//GT Interface
  	output  reg  [1:0]	gt_tx_pllclksel_out,           // TXPLLCLKSEL output
    output   reg         gt_tx_datapath_reset_out,      // GT TX datapath reset output                              (drpclk)
    input    wire        gt_tx_reset_done_in,           // GT TX reset done input                                   (txusrclk)
	
    output   reg         done_out,              		   // Sequence done output                                     (drpclk)
    output  reg         fail_out,             		   // Sequence failure output                                  (drpclk)
    output    reg [4:0]  tx_state, 
    output  reg  [2:0]  fail_code_out          		   // Sequence failure code                                    (drpclk)
);

//UHD-SDI MODES 
localparam MODE_SD		  = 3'b001;
localparam MODE_HD		  = 3'b000;
localparam MODE_3G		  = 3'b010;
localparam MODE_6G		  = 3'b100;
localparam MODE_12G		  = 3'b101;

//GT DRP Settings Params
localparam TXOUT_DIV_DRP_ADDR          =  9'h07C;     // GT TXOUT_DIV DRP Address
localparam TXOUT_DIV_DRP_WR_MASK       = 16'h0700;    // GT TXOUT_DIV write mask --> 1:write bit 0:no change
localparam TXOUT_DIV1                  = 16'h0000;    // GT TXOUT_DIV DRP register value for divide by 1
localparam TXOUT_DIV2                  = 16'h0100;    // GT TXOUT_DIV DRP register value for divide by 2
localparam TXOUT_DIV4                  = 16'h0200;    // GT TXOUT_DIV DRP register value for divide by 4
localparam TXOUT_DIV8                  = 16'h0300;    // GT TXOUT_DIV DRP register value for divide by 8

localparam TXDATA_WIDTH_DRP_ADDR       =  9'h07A;     // GT TX_DATA_WIDTH DRP Address
localparam TXDATA_WIDTH_DRP_WR_MASK    = 16'h000F;    // GT TX_DATA_WIDTH write mask --> 1:write bit 0:no change
localparam TXDATA_WIDTH20              = 16'h0003;    // GT TX_DATA_WIDTH DRP register value for 20 bits
localparam TXDATA_WIDTH40              = 16'h0005;    // GT TX_DATA_WIDTH DRP register value for 40 bits
localparam TXDATA_WIDTH80              = 16'h0007;    // GT TX_DATA_WIDTH DRP register value for 80 bits
localparam TXDATA_WIDTH_DUMMY          = 16'hFFF3;    // Dummy datawidth value to force change during init

localparam TXINT_DATAWIDTH_DRP_ADDR    =  9'h085;     // GT TXINT_DATAWIDTH DRP Address
localparam TXINT_DATAWIDTH_DRP_WR_MASK = 16'h0C00;    // GT TXINT_DATAWIDTH write mask --> 1:write bit 0:no change
localparam TXINT_DATAWIDTH_2_BYTES     = 16'h0000;    // GT TXINT_DATAWIDTH DRP register value for 2 bytes
localparam TXINT_DATAWIDTH_4_BYTES     = 16'h0400;    // GT TXINT_DATAWIDTH DRP register value for 4 bytes
localparam TXINT_DATAWIDTH_DUMMY       = 16'hFFFF;    // Dummy datawidth value to force change during init

//
// These parameters define the encoding of the FSM states
//
localparam MSTR_STATE_WIDTH   = 5;
localparam MSTR_STATE_MSB     = MSTR_STATE_WIDTH - 1;

localparam [MSTR_STATE_MSB:0]
    READY_STATE                 = 5'h00,
    SETTLE_STATE			    = 5'h01,
    FREEZE_STATE			    = 5'h02,
    TXDATA_WIDTH1_STATE		    = 5'h03,
    TXDATA_WIDTH2_STATE		    = 5'h04,
    TXDATA_WIDTH_ERR_STATE	    = 5'h05,
    TXINT_DATAWIDTH1_STATE      = 5'h06,
    TXINT_DATAWIDTH2_STATE      = 5'h07,
    TXINT_DATAWIDTH_ERR_STATE   = 5'h08,
    TXOUT_DIV1_STATE		    = 5'h09,
    TXOUT_DIV2_STATE		    = 5'h0A,
    TXOUT_DIV_ERR_STATE	        = 5'h0B,
    TXPLLCLKSEL1_STATE	        = 5'h0C,
    TXPLLCLKSEL2_STATE	        = 5'h0D,
    GT_RESET_STATE      	    = 5'h0E,
    GT_RESET_WAIT_STATE    	    = 5'h0F,
    GT_RESET_DONE_STATE    	    = 5'h10,
    GT_RESET_TO_STATE    	    = 5'h11,
    PLL_WAIT_LOCK1_STATE         = 5'h12,
    PLL_WAIT_LOCK2_STATE         = 5'h13,
    FAIL_STATE            	    = 5'h14;

reg     [MSTR_STATE_MSB:0]				current_state = READY_STATE;
reg     [MSTR_STATE_MSB:0]   			next_state;
reg     [TX_INPUT_SETTLE_BITWIDTH-1:0]	settle_cntr = 0;
reg                         			clr_settle_cntr;
reg										freeze_inputs = 1'b0;	
wire									freeze_inputs_ds;	
reg										set_freeze;
reg										clr_freeze;	
wire									settle_tc;

reg  [15:0]	pllcnt;
reg clr_pllcnt;
wire pllcnt_tc;

reg  [2:0]                   tx_mode_in_reg              = 3'b000;
(* ASYNC_REG = "true" *) (* shift_extract = "{no}" *) reg  [2:0]                   tx_mode_sync1_cdc_to_reg    = 3'b000;
(* ASYNC_REG = "true" *) (* shift_extract = "{no}" *) reg  [2:0]                   tx_mode_sync2_reg           = 3'b000;
(* ASYNC_REG = "true" *) (* shift_extract = "{no}" *) reg  [2:0]                   tx_mode_last_reg            = 3'b000;
reg                          tx_m_in_reg                 = 1'b0;
(* ASYNC_REG = "true" *) (* shift_extract = "{no}" *) reg                          tx_m_sync1_cdc_to_reg       = 1'b0;
(* ASYNC_REG = "true" *) (* shift_extract = "{no}" *) reg                          tx_m_sync2_reg              = 1'b0;
(* ASYNC_REG = "true" *) (* shift_extract = "{no}" *) reg                          tx_m_last_reg               = 1'b0;
reg                          tx_change_req               = 1'b1;
reg                          clr_tx_change_req;

wire 				                    txresetdone_ds;

reg		    txdata_width_cycle;
reg		[15:0]		                    txdata_width_reg = TXDATA_WIDTH_DUMMY;

reg		    txint_datawidth_cycle;
reg		[15:0]		                    txint_datawidth_reg = TXINT_DATAWIDTH_DUMMY;

reg		                                txout_div_cycle;
reg		[15:0]		                    txout_div_reg = TXOUT_DIV2;
(* dont_touch = "true" *) reg			   txpllclksel_cycle;
(* dont_touch = "true" *) reg		[1:0]  txpllclksel_reg = TXPLLCLKSEL_TX_M_1;

reg 				                    gt_tx_datapath_reset_reg;
reg 				                    drp_change_req_reg;
reg 				                    drp_change_req_done_reg;
reg   [8:0]                             drp_addr_reg;
reg  [15:0]                             drp_wr_data_reg;
reg  [15:0]                             drp_wr_data_mask_reg;
reg 				                    done_reg;
reg 				                    fail_reg;
reg  [2:0]  		                    fail_code_reg;

reg                                     clr_fail;
reg                                     assert_fail;
reg [TX_GT_RESET_TIMEOUT_MSB:0]         to_counter = 0;
reg                                     m_clr_to;
wire                                    timeout;
reg                                     clr_retries;
reg                                     inc_retries;
reg  [TX_RETRY_CNTR_MSB:0]              retry_counter;

wire                                    max_retries;
wire                                    start_retries;
reg						                clr_fabric_reset;
reg						                assert_fabric_reset;
reg                                     tx_fabric_rst_int = 1'b1;
reg                                     set_fail_code_1;
reg                                     set_fail_code_2;
reg                                     set_fail_code_3;
reg                                     set_fail_code_4;
reg                                     tx_ctrl_reset ;

reg                                     assert_fabric_reset_ff;
reg                                     clr_fabric_reset_ff;

wire pllreset_m0;
wire plllock_m0;
wire pllreset_m1;
wire plllock_m1;
reg pll_change;
reg pll_change_done;

    (* ASYNC_REG = "true" *) (* shift_extract = "{no}" *) reg tx_fabric_rst_out_d1_cdc_to = 1'b1;
    (* ASYNC_REG = "true" *) (* shift_extract = "{no}" *) reg tx_fabric_rst_out_d2 = 1'b1;
    (* ASYNC_REG = "true" *) (* shift_extract = "{no}" *) reg tx_fabric_rst_out_d3 = 1'b1;
    
assign pllreset_m0 = (TXPLLCLKSEL_TX_M_0 == 2'b00) ? cpllreset_in : ((TXPLLCLKSEL_TX_M_0 == 2'b11) ? qpll0reset_in : qpll1reset_in);
assign plllock_m0 = (TXPLLCLKSEL_TX_M_0 == 2'b00) ? cplllock_in : ((TXPLLCLKSEL_TX_M_0 == 2'b11) ? qpll0lock_in : qpll1lock_in);
assign pllreset_m1 = (TXPLLCLKSEL_TX_M_1 == 2'b00) ? cpllreset_in : ((TXPLLCLKSEL_TX_M_1 == 2'b11) ? qpll0reset_in : qpll1reset_in);
assign plllock_m1 = (TXPLLCLKSEL_TX_M_1 == 2'b00) ? cplllock_in : ((TXPLLCLKSEL_TX_M_1 == 2'b11) ? qpll0lock_in : qpll1lock_in);

always @ (posedge drpclk_in) begin
   if(tx_ctrl_reset) begin
      pll_change <= 1'b0;
   end else begin
      if(pllreset_m0 | pllreset_m1) begin
         pll_change <= 1'b1;
      end
      if(pll_change_done) begin
         pll_change <= 1'b0;
      end
   end
end


//------------------------------------------------------------------------------
// TX Control Module Reset
//
//
always @ (posedge drpclk_in)
    if (rst_in)
	    tx_ctrl_reset = 1'b1;
	else
	    tx_ctrl_reset = 1'b0;

//
// Input register & unary bit encoding for txmode
//
always @ (posedge txusrclk_in) 
	if (~freeze_inputs_ds) begin
		tx_mode_in_reg         <= txmode_in;
		tx_m_in_reg           <= tx_m_in;
	end
	
//
// Sync signals to the txusrclk domain
//
sync_block SYNC_FRZ_INPUT (
	.clk	(txusrclk_in),
	.din	(freeze_inputs),
	.dout	(freeze_inputs_ds));

//------------------------------------------------------------------------------
// tx_mode change detectors
//
// Synchronize the tx_mode signal to the clock
always @ (posedge drpclk_in)
begin
    tx_mode_sync1_cdc_to_reg <= tx_mode_in_reg;
    tx_mode_sync2_reg        <= tx_mode_sync1_cdc_to_reg;
    tx_mode_last_reg         <= tx_mode_sync2_reg;
end

//------------------------------------------------------------------------------
// tx_m change detectors
//
// Synchronize the tx_m signal to the clock
always @ (posedge drpclk_in)
begin
    tx_m_sync1_cdc_to_reg <= tx_m_in_reg;
    tx_m_sync2_reg        <= tx_m_sync1_cdc_to_reg;
    tx_m_last_reg         <= tx_m_sync2_reg;
end

always @ (posedge drpclk_in)
    if (tx_ctrl_reset | clr_tx_change_req)
        tx_change_req <= 1'b0;
    else if ((tx_mode_sync2_reg != tx_mode_last_reg) || (tx_m_sync2_reg != tx_m_last_reg))
        tx_change_req <= 1'b1;

//
// Sync signals to the drpclk domain
//
sync_block SYNC_TXRESETDONE_SYNC (
	.clk	(drpclk_in),
	.din	(gt_tx_reset_done_in),
	.dout	(txresetdone_ds));

//
// Determine the tXPLLCLKSEL Value
//
always @ (posedge drpclk_in)
    if (txpllclksel_cycle)
	begin
        if (tx_m_last_reg == 1'b1) 
		    txpllclksel_reg <= TXPLLCLKSEL_TX_M_1;
		else
		    txpllclksel_reg <= TXPLLCLKSEL_TX_M_0;
	end


//
always @ (posedge drpclk_in) begin
	if ((tx_mode_last_reg == MODE_6G) || (tx_mode_last_reg == MODE_12G))
		    begin                                                                              
				txdata_width_reg    <= TXDATA_WIDTH40;
				txint_datawidth_reg <= TXINT_DATAWIDTH_4_BYTES;
		    end                                                                                
	else  //SD, HD, 3G                                                                         
		    begin                                                                              
				txdata_width_reg    <= TXDATA_WIDTH20;
				txint_datawidth_reg <= TXINT_DATAWIDTH_2_BYTES; 
		    end
    
end
//
// New TXOUT_DIV calculation
//
always @ (posedge drpclk_in)
	if (((tx_m_last_reg == 1'b0) && (TX_M_0_QPLL == 1'b1)) || ((tx_m_last_reg == 1'b1) && (TX_M_1_QPLL == 1'b1)))	// QPLL selected
	begin
		if (tx_mode_last_reg == MODE_HD)
			txout_div_reg <= TXOUT_DIV8;
		else if (tx_mode_last_reg == MODE_6G)
			txout_div_reg <= TXOUT_DIV2;
		else if (tx_mode_last_reg == MODE_12G)
			txout_div_reg <= TXOUT_DIV1;
		else //SD and 3G
			txout_div_reg <= TXOUT_DIV4;
	end
	else	// CPLL selected
	begin
		if (tx_mode_last_reg == MODE_HD)
			txout_div_reg <= TXOUT_DIV4;
		else if (tx_mode_last_reg == MODE_6G)
			txout_div_reg <= TXOUT_DIV1;
		else //SD and 3G
			txout_div_reg <= TXOUT_DIV2;
		//NOTE: CPLL can't be used for 12G line rate
	end

//
// This logic creates the correct DRP address and data values.
//
always @ (*)
    if (txout_div_cycle)
		begin
			drp_addr_reg         = TXOUT_DIV_DRP_ADDR;
			drp_wr_data_mask_reg = TXOUT_DIV_DRP_WR_MASK;
			drp_wr_data_reg      = txout_div_reg;
		end 
	else if (txdata_width_cycle)
		begin
			drp_addr_reg         = TXDATA_WIDTH_DRP_ADDR;
			drp_wr_data_mask_reg = TXDATA_WIDTH_DRP_WR_MASK;
			drp_wr_data_reg      = txdata_width_reg;
		end
	else //txint_datawidth_cycle
		begin
			drp_addr_reg         = TXINT_DATAWIDTH_DRP_ADDR;
			drp_wr_data_mask_reg = TXINT_DATAWIDTH_DRP_WR_MASK;
			drp_wr_data_reg      = txint_datawidth_reg;
		end

  always @ (posedge txusrclk_in) 
  begin
    tx_fabric_rst_out_d1_cdc_to  <=  tx_fabric_rst_int;
    tx_fabric_rst_out_d2         <=  tx_fabric_rst_out_d1_cdc_to;
    tx_fabric_rst_out_d3         <=  tx_fabric_rst_out_d2;
  end
  	
//
// Output registers
//
assign tx_fabric_rst_out         = tx_fabric_rst_out_d3;

always @ (posedge drpclk_in)
begin
    done_out                  <= done_reg;
    drp_addr_out              <= drp_addr_reg;
    drp_wr_data_out           <= drp_wr_data_reg;
    drp_wr_data_mask_out      <= drp_wr_data_mask_reg;
    drp_change_req_out        <= drp_change_req_reg;
    drp_change_req_done_out   <= drp_change_req_done_reg;
    gt_tx_pllclksel_out       <= txpllclksel_reg;
    gt_tx_datapath_reset_out  <= gt_tx_datapath_reset_reg;
    fail_out                  <= fail_reg;
    fail_code_out             <= fail_code_reg;
end

//
// Input register freeze control FF
//
always @ (posedge drpclk_in)
	if (set_freeze)
		freeze_inputs <= 1'b1;
	else if (clr_freeze)
		freeze_inputs <= 1'b0;

//
// Settle counter
//
always @ (posedge drpclk_in)
begin
	if (clr_settle_cntr)
		settle_cntr <= 0;
	else
		settle_cntr <= settle_cntr + 1;
end

assign settle_tc = &settle_cntr;
//
// pll counter
//
always @ (posedge drpclk_in)
begin
	if (clr_pllcnt)
		pllcnt <= 0;
	else
		pllcnt <= pllcnt + 1;
end
assign pllcnt_tc = &(pllcnt);

//
// FSM current state register
// 
always @ (posedge drpclk_in)
    if (tx_ctrl_reset)
		current_state <= READY_STATE;
	else
		current_state <= next_state;

always @ (posedge drpclk_in)
  tx_state <= current_state;

//
// FSM next state logic
//
always @ (*)
begin
    case(current_state)
        READY_STATE:
            //if pll change detected 
            if (pll_change)
                next_state = PLL_WAIT_LOCK1_STATE;
            else if (plllock_m0 & plllock_m1 & txresetdone_ds & tx_change_req)
                next_state = SETTLE_STATE;
            else
                next_state = READY_STATE;

        SETTLE_STATE:
            if (~settle_tc)
                next_state = SETTLE_STATE;
			else
				next_state = FREEZE_STATE;

		FREEZE_STATE:
			next_state = TXDATA_WIDTH1_STATE;

		TXDATA_WIDTH1_STATE:
			if (drp_change_grant_in)
				next_state = TXDATA_WIDTH2_STATE;
			else 
				next_state = TXDATA_WIDTH1_STATE;

		TXDATA_WIDTH2_STATE:
			if (drp_done_in)
			    next_state = TXINT_DATAWIDTH1_STATE;
            else if (drp_wr_fail_in)
                next_state = TXDATA_WIDTH_ERR_STATE;
			else
				next_state = TXDATA_WIDTH2_STATE;
		
		TXDATA_WIDTH_ERR_STATE:
            if (max_retries)
                next_state = FAIL_STATE;
            else
                next_state = TXDATA_WIDTH1_STATE;

		TXINT_DATAWIDTH1_STATE:
			if (drp_change_grant_in)
				next_state = TXINT_DATAWIDTH2_STATE;
			else 
				next_state = TXINT_DATAWIDTH1_STATE;

		TXINT_DATAWIDTH2_STATE:
			if (drp_done_in)
			    next_state = TXOUT_DIV1_STATE;
            else if (drp_wr_fail_in)
                next_state = TXINT_DATAWIDTH_ERR_STATE;
			else
				next_state = TXINT_DATAWIDTH2_STATE;
		
		TXINT_DATAWIDTH_ERR_STATE:
            if (max_retries)
                next_state = FAIL_STATE;
            else
                next_state = TXINT_DATAWIDTH1_STATE;

		TXOUT_DIV1_STATE:
			if (drp_change_grant_in)
				next_state = TXOUT_DIV2_STATE;
			else 
				next_state = TXOUT_DIV1_STATE;

		TXOUT_DIV2_STATE:
			if (drp_done_in)
				next_state = TXPLLCLKSEL1_STATE;
            else if (drp_wr_fail_in)
                next_state = TXOUT_DIV_ERR_STATE;
			else
				next_state = TXOUT_DIV2_STATE;
		
		TXOUT_DIV_ERR_STATE:
            if (max_retries)
                next_state = FAIL_STATE;
            else
                next_state = TXOUT_DIV1_STATE;

		TXPLLCLKSEL1_STATE:
			   next_state = TXPLLCLKSEL2_STATE;

		TXPLLCLKSEL2_STATE:
		    if (settle_tc) 
                next_state = GT_RESET_STATE;
			else
				next_state = TXPLLCLKSEL2_STATE;

		GT_RESET_STATE:
			next_state = GT_RESET_WAIT_STATE;
			
		GT_RESET_WAIT_STATE:			
			if (~txresetdone_ds)
				next_state = GT_RESET_DONE_STATE;
			else
				next_state = GT_RESET_WAIT_STATE;		

		GT_RESET_DONE_STATE:			
			//if (timeout)
                //next_state = GT_RESET_TO_STATE;
            if (txresetdone_ds)
			    next_state = READY_STATE;
			else
				next_state = GT_RESET_DONE_STATE;		
				
		GT_RESET_TO_STATE:
            if (max_retries)
                next_state = FAIL_STATE;
            else
                next_state = GT_RESET_STATE;
        PLL_WAIT_LOCK1_STATE:
            if (plllock_m0 & plllock_m1)
                next_state = PLL_WAIT_LOCK2_STATE; 
            else 
                next_state = PLL_WAIT_LOCK1_STATE; 
        PLL_WAIT_LOCK2_STATE:
            //issue gt reset when both pll are locked
            if (plllock_m0 & plllock_m1) begin
                if (pllcnt_tc) begin
                    next_state = SETTLE_STATE;
                end else begin
                    next_state = PLL_WAIT_LOCK2_STATE; 
                end
            end else begin
                next_state = PLL_WAIT_LOCK1_STATE; 
            end
        FAIL_STATE:
            //if (~txresetdone_ds)
                //next_state = FAIL_STATE;
            //else
                next_state = READY_STATE;
        
		default:
            next_state = READY_STATE;
    endcase
end

//
// FSM output logic
//
always @ (*)
begin
    pll_change_done = 1'b0;
    clr_pllcnt = 1'b0;
    clr_settle_cntr      	  = 1'b0;
	txout_div_cycle           = 1'b0;
	txdata_width_cycle        = 1'b0;
	txint_datawidth_cycle     = 1'b0;
    txpllclksel_cycle        = 1'b0; 
	set_freeze				  = 1'b0;
	clr_freeze				  = 1'b0;
	done_reg				  = 1'b0;
    clr_fail                  = 1'b0;
    assert_fail               = 1'b0;
	drp_change_req_reg		  = 1'b0;
	drp_change_req_done_reg	  = 1'b0;
	gt_tx_datapath_reset_reg  = 1'b0;
    clr_tx_change_req        = 1'b0;
    m_clr_to                  = 1'b0;
    inc_retries               = 1'b0;
    clr_retries               = 1'b0;
    set_fail_code_1           = 1'b0;
    set_fail_code_2           = 1'b0;
    set_fail_code_3           = 1'b0;
    set_fail_code_4           = 1'b0;
	clr_fabric_reset          = 1'b0;
	assert_fabric_reset       = 1'b0;

    case(current_state)
        READY_STATE:
			begin
                clr_pllcnt = 1'b1;
				clr_settle_cntr    = 1'b1;
				clr_freeze         = 1'b1;
				done_reg           = 1'b1;
				clr_fail           = txresetdone_ds; //clear fail code only when resetdone issued.;
				m_clr_to           = 1'b1;
				clr_retries        = 1'b1;
				clr_fabric_reset   = 1'b1;
			end

		FREEZE_STATE:
			set_freeze = 1'b1;

		TXDATA_WIDTH1_STATE:		
			begin
				drp_change_req_reg = 1'b1;
				txdata_width_cycle = 1'b1;
			end

		TXDATA_WIDTH2_STATE:		
            begin
			    txdata_width_cycle = 1'b1;
                if (drp_done_in)
				   clr_retries        = 1'b1;
            end

		TXDATA_WIDTH_ERR_STATE:	
			begin
				txdata_width_cycle = 1'b1;
				inc_retries        = 1'b1;
				m_clr_to           = 1'b1;
				if (max_retries)
					set_fail_code_1 = 1'b1;
			end

		TXINT_DATAWIDTH1_STATE:		
			begin
				drp_change_req_reg    = 1'b1;
				txint_datawidth_cycle = 1'b1;
			end

		TXINT_DATAWIDTH2_STATE:		
            begin
			    txint_datawidth_cycle = 1'b1;
                if (drp_done_in)
				   clr_retries        = 1'b1;
            end

		TXINT_DATAWIDTH_ERR_STATE:	
			begin
				txint_datawidth_cycle = 1'b1;
				inc_retries        = 1'b1;
				m_clr_to           = 1'b1;
				if (max_retries)
					set_fail_code_2 = 1'b1;
			end

		TXOUT_DIV1_STATE:
			begin
				drp_change_req_reg = 1'b1;
				txout_div_cycle    = 1'b1;
			end

		TXOUT_DIV2_STATE:	
            begin
				txout_div_cycle    = 1'b1;
                if (drp_done_in)
				   clr_retries        = 1'b1;
            end

        TXOUT_DIV_ERR_STATE:   
			begin
				txout_div_cycle    = 1'b1;
				inc_retries        = 1'b1;
				m_clr_to           = 1'b1;
				if (max_retries)
					set_fail_code_3 = 1'b1;
			end

		TXPLLCLKSEL1_STATE:
			begin
                txpllclksel_cycle = 1'b1;
				clr_settle_cntr     = 1'b1;
			end
		
		GT_RESET_STATE:
			begin
                clr_pllcnt = 1'b1;
				drp_change_req_done_reg = 1'b1;	
				gt_tx_datapath_reset_reg = 1'b1;
                m_clr_to            = 1'b1; //reset timeout counter
			end

        GT_RESET_DONE_STATE:
        begin
            if(pll_change == 1'b1) begin
               pll_change_done = ~start_retries;
            end else begin
               clr_tx_change_req   = ~start_retries;
            end
            assert_fabric_reset = txresetdone_ds;
        end

        GT_RESET_TO_STATE:
        begin
            inc_retries = 1'b1;
            m_clr_to    = 1'b1;
            if (max_retries)
                set_fail_code_4 = 1'b1;
        end

        PLL_WAIT_LOCK1_STATE:
        begin
           clr_pllcnt = 1'b1;
           m_clr_to    = 1'b1;
           clr_retries         = 1'b1;
        end

        PLL_WAIT_LOCK2_STATE:
        begin
			clr_settle_cntr    = 1'b1;
            m_clr_to    = 1'b1;
            clr_retries         = 1'b1;
        end

        FAIL_STATE:
			begin
                pll_change_done = 1'b1;
                clr_tx_change_req   = 1'b1;
                clr_retries         = 1'b1;
				assert_fail              = 1'b1;	
				drp_change_req_done_reg  = 1'b1;	
				//gt_tx_datapath_reset_reg = 1'b1;
				assert_fabric_reset      = 1'b1;
			end

        default:;
    endcase
end		
	
//FAIL out
always @ (posedge drpclk_in)
    if (tx_ctrl_reset | clr_fail)
        fail_reg <= 1'b0;
    else if (assert_fail)
        fail_reg <= 1'b1;
//Retry Counter
always @ (posedge drpclk_in)
    if (tx_ctrl_reset | clr_retries)
        retry_counter <= 0;
    else if (inc_retries)
        retry_counter <= retry_counter + 1;

assign max_retries = &retry_counter;
assign start_retries = |retry_counter;

//
// A timeout counter for GT reset. If the timeout counter reaches its
// terminal count, the state machine aborts/restarts the transfer.
//
always @ (posedge drpclk_in)
    if (m_clr_to)
        to_counter <= 0;
    else if (~timeout)
        to_counter <= to_counter + 1;

assign timeout = to_counter[TX_GT_RESET_TIMEOUT_MSB];

//
// tx_fabric_rst output
//
// This output is asserted as the FPGA comes out of config and after assertion
// of tx_ctrl_reset. It is intended to be used to keep the SDI core TX section in reset
// at initialization time.  This signal goes low only after the first txresetdone.
//

// Flop the reset control logic to remove glitches.
always @ (posedge drpclk_in)
begin
   assert_fabric_reset_ff <= assert_fabric_reset;
   clr_fabric_reset_ff    <= clr_fabric_reset;
end

always @ (posedge drpclk_in)
begin
    if (tx_ctrl_reset | assert_fabric_reset_ff)
        tx_fabric_rst_int <= 1'b1;
    else if (clr_fabric_reset_ff)
        tx_fabric_rst_int <= 1'b0;
end

//
// Fail code register
//
always @ (posedge drpclk_in)
    if (tx_ctrl_reset | clr_fail)
		fail_code_reg <= 3'b000;
	else if (set_fail_code_1)
		fail_code_reg <= 3'b001;
	else if (set_fail_code_2)
		fail_code_reg <= 3'b010;
	else if (set_fail_code_3)
		fail_code_reg <= 3'b011;
	else if (set_fail_code_4)
		fail_code_reg <= 3'b100;

	
endmodule
